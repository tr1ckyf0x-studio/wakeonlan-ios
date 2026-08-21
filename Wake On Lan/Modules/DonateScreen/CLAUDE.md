# DonateScreen module

Donation screen backed by non-consumable in-app purchases. Reached from the Host list
(`viewDidPressDonateButton`) and from the About screen's Donate row.

The StoreKit layer it drives lives outside this directory, in
`Wake On Lan/Frameworks/IAPManager/`, and is documented here because nothing else uses it.

## Files

### `Modules/DonateScreen/`

| File | Role |
|------|------|
| `DonateScreenContract.swift` | The four VIPER protocols, all `@MainActor`. Note that `DonateScreenViewOutput` and `DonateScreenInteractorInput` are **not** `AnyObject`-constrained |
| `DonateScreenFactory.swift` | Composition root. `Context = Void?` (ignored) |
| `DonateScreenRoutes.swift` | `backOrDismiss(animated:)` only |
| `DonateScreenInteractor.swift` | Bridges the synchronous VIPER contract to `async` `ManagesIAP`; owns the `Task`s and the `MainActor` hops |
| `DonateScreenPresenter.swift` | State machine + view-model construction |
| `DonateScreenState.swift` | `enum { paymentsUnavailable, loading, loaded, loadingFailed }` |
| `DonateScreenTableSection.swift` | `DonateScreenTableSectionItem.purchase(ProductViewModel)` and `DonateScreenTableSectionModel.donateSection(content:footer:)` |
| `DonateScreenTableManager.swift` | `UITableViewDataSource` + `UITableViewDelegate` over the sections |
| `DonateScreenView.swift` | Grouped table view + two `EmptyView`s + `SpinnerView` + back button; exposes `stateViews` |
| `DonateScreenViewController.swift` | Installs the view, lazily creates the table manager, implements `setSections` / `showState` |
| `DonateItemCell.swift` | `SoftUIView` row with title on the left and price on the right |
| `ProductViewModel.swift` | `title`, `price`, `onClick`; `Equatable`/`Hashable` over title + price only |

### `Frameworks/IAPManager/`

| File | Role |
|------|------|
| `Core/IAPManager.swift` | `ManagesIAP` protocol + `IAPManager`: fetches, sorts, and formats products; delegates payment |
| `Core/PaymentManager.swift` | `SKPaymentTransactionObserver`; maps `SKPayment` → `CheckedContinuation`, guarded by an `NSLock` |
| `Core/ProductsRequest.swift` | One-shot async wrapper over `SKProductsRequest`, guarded by an `NSLock` |
| `Core/ProductIdentifier.swift` | The 8 App Store product identifiers |
| `Models/Product.swift` | `title`, `price`, `identifier` DTO |

### Elsewhere

`Wake On Lan/AppDelegatePlugins/IAPAppDelegatePlugin.swift` holds a strong `IAPManager` for the whole
process — see the first gotcha.

## Wiring

`DonateScreenFactory.build(with:)` creates the view controller, `DonateScreenPresenter()`, and
`DonateScreenInteractor(iAPManager: IAPManager.shared)`. The singleton is hard-coded in the factory
rather than injected.

Ownership: `ViewController → Presenter → Interactor → IAPManager → PaymentManager`, with
`presenter.view` and `interactor.presenter` weak.

## State machine

| Trigger | Resulting state |
|---------|-----------------|
| `viewDidLoad` and `canMakePayments != true` | `.paymentsUnavailable` — **terminal**, products are never fetched |
| `viewDidLoad` and payments allowed | `.loading`, then `fetchPurchases()` |
| `interactor(_:didLoad:)` | `setSections([...])` then `.loaded` |
| `interactorDidFailToLoad(_:error:)` | `.loadingFailed` — an `EmptyView` with a message, no retry |
| `interactorDidStartPurchasing` | `.loading` |
| `interactorDidFinishPurchasing` | `.loaded` — fires for **both** success and failure |

`showState` hides everything in `rootView.stateViews`, stops the spinner, and un-hides exactly one
view.

Table composition is fixed: exactly one section, `.donateSection(content: productItems, footer:
L10n.DonateScreen.Screen.footer)`, rendered by a plain (non-diffable) data source.

## Purchase flow

**StoreKit 1 throughout** — `SKProduct`, `SKProductsRequest`, `SKPayment`, `SKPaymentQueue`,
`SKPaymentTransactionObserver`. There is no StoreKit 2 anywhere.

1. `viewDidLoad` → `canMakePayments` → `fetchPurchases()`.
2. The interactor spawns a `Task`, awaits `fetchProducts(withIDs:)` for all 8 `ProductIdentifier`
   cases, then hops to `MainActor` to call the presenter — on success and on failure alike.
3. `IAPManager.fetchProducts` sorts ascending by price and formats each price with a
   `NumberFormatter` in the product's own `priceLocale`. Products whose price fails to format are
   **silently dropped**.
4. Tapping a row calls `ProductViewModel.onClick` → `interactor.makePurchase(product:)`, which calls
   `interactorDidStartPurchasing` synchronously (→ `.loading`) and then spawns a `Task`.
5. `IAPManager.makePurchase` performs a **second** StoreKit round trip to re-fetch the `SKProduct`.
   If it comes back empty the method returns without throwing and without enqueuing anything.
6. `PaymentManager.enqueue` stores a continuation keyed by the `SKPayment` and adds it to the queue.
7. `paymentQueue(_:updatedTransactions:)` handles **every** transaction, not only those with a live
   continuation: `.purchased`/`.restored` finish and resume with success, `.failed` finishes and
   resumes with an error, `.deferred` resumes with `transactionDeferred` but is deliberately left
   unfinished because StoreKit re-delivers it once a parent responds.
8. The interactor catches any error with a bare `print`, then unconditionally calls
   `interactorDidFinishPurchasing` → `.loaded`.

### Products

`ProductIdentifier` — `donateForTea` and `donateForCoffee` still carry the legacy
`…donate.tier1` / `tier2` identifiers; the rest are `…donate.for_lunch`, `.for_dinner`,
`.for_development`, `.for_party`, `.for_equipment`, `.significant`. Display order is ascending
App Store price, **not** declaration order.

## Concurrency

The contracts, the presenter, the interactor and the factory are `@MainActor`; the view layer
inherits it from UIKit. The StoreKit layer deliberately is not.

`PaymentManager` and `ProductsRequest` are plain nonisolated classes because their delegate callbacks
arrive on StoreKit's own queue. Isolating either to the main actor makes Swift insert a dynamic check
that trips (`_dispatch_assert_queue_fail`) the moment StoreKit answers — that is exactly what crashed
the Donate screen on device while the simulator stayed happy. Both use an `NSLock` around the
continuation state instead, and each continuation is resumed exactly once.

## Gotchas

- **The transaction observer is pinned at launch, not by this screen.** `IAPManager.shared` is a
  *weak* singleton (`ProvidesWeakSharedInstanceTrait`), so it would otherwise live only while the
  Donate screen is on screen. `IAPAppDelegatePlugin` holds a strong reference for the whole process,
  which is what keeps `PaymentManager`'s `SKPaymentTransactionObserver` registered. Without it,
  transactions delivered outside that window — promoted App Store purchases, purchases interrupted by
  termination, "Ask to Buy" approvals — are never finished and stay pending in the queue forever.
  `PaymentManager` removes itself from the queue in `deinit`.
- **A failed purchase is indistinguishable from a successful one.** Fetch failures now reach the UI
  as `.loadingFailed`, but purchase errors go to a bare `print` and still end in `.loaded`.
- **There is no "Restore purchases".** No `restoreCompletedTransactions()` call and no restore UI
  exist anywhere in the repository. Restored transactions are finished when StoreKit delivers them,
  but nothing asks for them.
- **The local `Product` struct shadows StoreKit 2's `StoreKit.Product`** inside the app module.
- **`tableManager` is `lazy` with side effects**: its initializer assigns the table view's
  `dataSource` and `delegate`. It is first touched in `setSections`, so on the
  `.paymentsUnavailable` and `.loadingFailed` paths the table view never gets a data source at all.
- `DonateScreenTableManager` indexes rows with `indexPath.item`, not `.row`.
- `DonateItemCell` never calls `baseView.configure(with:)`, so `SoftUIView.contentView` stays `nil`
  and the row shows no pressed state — `.touchUpInside` still fires because `SoftUIView` is a `UIControl`.
- `ProductViewModel`'s `Hashable` conformance is currently unused (the module uses a plain data
  source, not a diffable one); it exists so the section enums can be `Hashable`.
