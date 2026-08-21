# HostList module

The app's root screen: the list of saved hosts. Tap a card to send a magic packet, swipe a card to
reveal Delete, long-press to reorder. Built by `RootViewControllerFactory` inside a
`WOLNavigationController` — see the repository root `CLAUDE.md`.

## Files

| File | Role |
|------|------|
| `HostListContract.swift` | The four VIPER protocols, the `HostListNotification` outcome enum, and the diffable typealiases `HostListSection = String`, `HostListItem = HostListSectionItem`, `HostListSnapshot` |
| `HostListFactory.swift` | Composition root. `Context = Void?` (ignored) |
| `HostListRoutes.swift` | `openAddHost(with: Host?)`, `openAbout()`, `openDonate()` |
| `HostListViewController.swift` | Installs `HostListView`, owns the navigation bar, forwards view events to the presenter |
| `HostListView.swift` | Collection view + flow layout + empty state + the three bar buttons. Declares `HostListViewDelegate` and `DisplaysHostList` |
| `HostListPresenter.swift` | Route dispatch, empty/default state selection, and picking the toast from the wake result — no other logic |
| `HostListInteractor.swift` | Wake / delete / fetch-by-indexPath / reorder; owns the cache tracker and the Core Data workers |
| `HostListCacheTracker.swift` | Wraps `NSFetchedResultsController<Host>` and converts its snapshot |
| `HostListSnapshotMapper.swift` | `NSDiffableDataSourceSnapshotReference` → `HostListSnapshot` |
| `HostListSectionModel.swift` | `enum HostListSectionItem { case host(HostListCellViewModel) }`, `nonisolated` |
| `HostListCellViewModel.swift` | `title`, `iconName`, `macAddress`, `createdAt` — the diffable item payload, `nonisolated` |
| `HostListCollectionManager.swift` | `UICollectionViewDiffableDataSource` subclass; also owns the long-press reorder gesture |
| `HostListCollectionCellProvider.swift` | Dequeues and configures the cell |
| `HostListCollectionViewCell.swift` | Neumorphic card in a paging scroll view that reveals Delete; shows the toast and fires haptics |
| `HostListCollectionViewCellDelegate.swift` | `hostListCellDidTap` / `DidTapInfo` / `DidTapDelete` |
| `HostListNotificationView.swift` | The toast, generic over `NotificationViewStyle`. `NotificationViewType.Default` is "Packet sent", `.Failure` is "You must be connected to network" |

## Wiring

`HostListFactory.build(with:)` constructs everything and cross-links it:

```
cacheTracker.delegate    = interactor      // weak
presenter.interactor     = interactor      // strong
interactor.presenter     = presenter       // weak
viewController.presenter = presenter       // strong
presenter.view           = viewController  // weak
presenter.router         = router          // strong, injected into the factory
```

Injected services: `CoreDataService.shared`, `WakeOnLanService.shared`, `HostCRUDWorker()`,
`MoveHostWorker()`, and a `HostListCacheTracker` built over `Host.sortedFetchRequest` and
`coreDataService.mainContext`.

Ownership runs `ViewController → Presenter → Interactor → CacheTracker → NSFetchedResultsController`
with every back-reference weak, so the module dies with the view controller.

The view layer wires itself separately: `HostListView` creates the `HostListCollectionManager`,
becomes its delegate, and passes a `HostListCollectionCellProvider` holding a **weak** back-reference
to itself as the cell delegate.

Event path for a tap:
`cell → HostListCollectionViewCellDelegate → HostListView` (resolves the `IndexPath`)
`→ HostListViewDelegate → ViewController → HostListViewOutput → Presenter → InteractorInput`.

## Data flow

1. `viewDidLoad` → `presenter.viewDidLoad` → `view.showState(.default)` + `interactor.startCacheTracker()`.
2. `HostListCacheTracker.start()` performs the fetch. A throw here is only logged.
3. Content reaches the UI **only** through `NSFetchedResultsControllerDelegate.controller(_:didChangeContentWith:)`.
4. `HostListSnapshotMapper` resolves each `NSManagedObjectID` back to a `Host` and maps it to a
   `HostListCellViewModel`, wrapped in `HostListSectionItem.host`.
5. The snapshot travels tracker → interactor → presenter → view → `collectionManager.apply(_:)`.
6. The presenter also picks the state: `.default` when the snapshot has items, `.empty` otherwise.

After the mapper runs, **no `Host` or `NSManagedObjectID` survives into the view layer**. Index paths
are the only way back — `interactor.fetchHost(at:)` re-resolves them against the fetched results
controller.

The fetch request has `sectionNameKeyPath: nil`, so there is always exactly one section.

### Waking a host

`interactor.wakeHost(_:at:)` copies the managed object into a `HostSnapshot` **on the main queue**,
then awaits `WakeOnLanService.sendMagicPacket(to:)` in a `Task { @MainActor in … }`. The outcome
comes back as `didWakeHostAt:` or `didFailToWakeHostAt:error:`, the presenter turns it into
`.packetSent` / `.failure`, and `HostListView.showNotification(_:at:)` annotates the card — if that
index path still has a live cell.

## Concurrency

Nothing in the app target is main-actor by default, so this module says so explicitly: the four
contract protocols, `TracksHostListCache` and `HostListCacheTrackerDelegate`,
`HostListCollectionManagerDelegate`, and the concrete presenter, interactor and factory all carry
`@MainActor`. The view, cell and collection manager inherit it from their UIKit superclasses.

The identifiers stay outside it. `HostListSectionItem` and `HostListCellViewModel` are plain value
types, because `UICollectionViewDiffableDataSource` requires `Sendable` identifiers with a
nonisolated `Hashable` conformance.

**Never hand a `Host` to anything that awaits.** `sendMagicPacket` is a nonisolated async function,
so awaiting it hops to the cooperative pool; reading a main-queue-confined managed object there traps
under `-com.apple.CoreData.ConcurrencyDebug 1`. `HostSnapshot` exists for exactly this. `@MainActor`
on the `Task` does not help — the hop happens inside the callee.

## Gotchas

- **Item identity is value-based.** `HostListCellViewModel` hashes on all four of its fields, so two
  hosts identical in title, icon, MAC, and `createdAt` would collide as diffable identifiers.
  `createdAt` (set in `Host.awakeFromInsert()`) is what keeps them apart in practice. Editing a host
  produces a *new* identifier, so edits animate as delete + insert rather than an in-place update.
- **Reorder must call `super`.** `collectionView(_:moveItemAt:to:)` calls
  `super.collectionView(_:moveItemAt:to:)` before forwarding to the delegate, and the initializer
  sets `reorderingHandlers.canReorderItem = { _ in true }` — the data source ignores an interactive
  move otherwise. Without both, the snapshot keeps the pre-drag order while the collection view shows
  the post-drag one, the two index spaces never converge, and a tap resolves to the wrong host: the
  packet goes to another machine and Delete removes another host. `MoveHostWorker` then rewrites the
  `order` attribute of **every** host and saves; the persisted result arrives through the
  fetched-results round trip. `dragInteractionEnabled` is `true` but no drag/drop delegates are set —
  the long-press recognizer in `HostListCollectionManager` is the only reorder mechanism.
- **`fetchHost(at:)` returns a non-optional `Host`** and traps on a stale index path. The `guard let`
  at the call sites only covers a nil `interactor`, never a bad index path.
- **The toast reports the actual result.** `HostListCollectionViewCell.showNotification(_:)` is driven
  by the presenter once the send has finished. It used to be chosen at tap time from `Reachability`,
  which meant the card claimed "Packet sent" even when nothing left the device; the cell no longer
  knows about reachability at all.
- **A failed wake shows a toast, nothing more.** `didFailToWakeHostAt:error:` logs through
  `DDLogError` and shows the `.failure` card banner; there is no error screen and `ViewState.error`
  is unused in this module.
- **`ViewState` is effectively binary.** `HostListView.view(for:)` returns a view only for `.empty`;
  the `StateableView` extension resets `currentState` to `.default` inside `clearState()`, so the
  property is never observably anything else. The empty view is an overlay, not a replacement.
- **The delete affordance is a paging `UIScrollView`, not a system swipe action.** `prepareForReuse`
  resets the content offset and tears down any in-flight toast, so a recycled cell is neither
  pre-swiped nor carrying another host's banner. Anything added to the cell's per-host state has to be
  reset there too.
- **Cell size is set imperatively** in `layoutSubviews` via `collectionLayout.itemSize`; there is no
  `UICollectionViewDelegateFlowLayout` conformance.
- `setupNavigationBar()` runs in `viewWillAppear`, so it re-applies on every appearance and mutates
  shared navigation controller state (`view.backgroundColor`, `prefersLargeTitles`).

## Dependencies

`CoreDataService` (`Host`, `HostCRUDWorker`, `MoveHostWorker`), `WakeOnLanService`, `PersistenceCore`,
`RouteComposer` (via `SharedRouter`), `WOLUIComponents` (`SoftUIView`, `EmptyView`, `StateableView`),
`WOLSharedProtocolsAndModels` (`ProvidesCollectionViewCell`, `HostSnapshot`, `HostFormValues`),
`WOLResources` (`HostIcon`), `SFSafeSymbols`, `CocoaLumberjack`, `SnapKit`.

Localized strings are `String(localized: .hostList…)` and colours `UIColor(resource: .primary)` and
friends — both are Xcode-generated symbols, see the root `CLAUDE.md`.
