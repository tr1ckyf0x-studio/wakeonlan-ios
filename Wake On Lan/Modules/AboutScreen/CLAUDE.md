# AboutScreen module

Static "About" screen: app logo, name, version, and four menu rows. Reached from the Host list
via `HostListPresenter.viewDidPressAboutButton`.

## Files

| File | Role |
|------|------|
| `AboutScreenContract.swift` | The four VIPER protocols, all `@MainActor`. View input is `configure(with:)` + `displayShareApp(with:)` |
| `AboutScreenFactory.swift` | Composition root. `Context = Void?` (ignored). Header comment still says `AboutScreenConfigurator.swift` |
| `AboutScreenRoutes.swift` | `backOrDismiss(animated:)`, `openDonate()` |
| `AboutScreenInteractor.swift` | Wraps `ProvidesBundleInfo`; `fetchBundleInfo()` is fully synchronous and calls back inline |
| `AboutScreenPresenter.swift` | Builds the whole view model, owns the two hard-coded URLs, performs review request / URL open / navigation |
| `AboutScreenViewController.swift` | Installs `AboutScreenView`, presents the share sheet, installs the back bar button |
| `AboutScreenView.swift` | Scroll view → content view → header + vertical stack of menu rows. Declares `AboutScreenViewDelegate` |
| `AboutScreenHeaderView.swift` | Logo + app name + version label |
| `AboutScreenMenuButtonView.swift` | One menu row: `SoftUIView` with symbol + title; stores the tap closure |
| `AboutScreenViewViewModel.swift` | `headerViewModel` + `buttonListViewModel` |
| `AboutScreenHeaderViewViewModel.swift` | `name`, `version` |
| `AboutScreenMenuButtonViewViewModel.swift` | `title`, `symbol: SFSymbol`, `action: (() -> Void)?` |

## Wiring

`AboutScreenFactory.build(with:)` creates the view controller, presenter, and interactor and
cross-links them; the `context` is ignored.

Dependencies come from **default arguments**, not from the factory:

- `AboutScreenInteractor(bundleInfoProvider: ProvidesBundleInfo = BundleInfoProvider())`
- `AboutScreenPresenter(reviewRequester: RequestsReview.Type = SKStoreReviewController.self, urlOpener: OpensURL = UIApplication.shared)`

Both `RequestsReview` and `OpensURL` come from the `SharedProtocolsAndModels` package, so the
presenter is testable even though the factory does not inject anything.

`WOLRouter` conforms to `AboutScreenRoutes` with an empty extension in `Routes/Routes.swift` —
`backOrDismiss` comes from `WOLRouter+CommonRoutes.swift` and `openDonate` from `Routes+Donate.swift`.

## View-model composition

Three plain structs, all built in `AboutScreenPresenter.makeViewModel(from:)`. Each menu row's
`action` closure captures the presenter weakly.

Rendering is one-shot: `viewDidLoad → presenter.viewDidLoad → interactor.fetchBundleInfo()`
(synchronous) → `presenter.interactor(_:didFetchBundleInfo:)` → `view.configure(with:)`. The view
allocates one `AboutScreenMenuButtonView` per view model, pins its height to 48, and appends it to
the stack view.

## Menu items

| # | Title key | Icon | Action |
|---|-----------|------|--------|
| 1 | `L10n.AboutScreen.Item.rateApp` | `.starFill` | `SKStoreReviewController.requestReview()` (static, sceneless) |
| 2 | `L10n.AboutScreen.Item.github` | `.tag` | Opens `https://github.com/tr1ckyf0x-studio/wakeonlan-ios` via `UIApplication.open` |
| 3 | `L10n.AboutScreen.Item.shareApp` | `.squareAndArrowUp` | `view.displayShareApp(with:)` → `UIActivityViewController` |
| 4 | `L10n.AboutScreen.Item.donate` | `.dollarsignCircleFill` | `router.openDonate()` |

Both URLs are literals in the presenter's private `Configuration` enum. There is no mail item and no
in-app browser — GitHub leaves the app.

## Gotchas

- **`configure(with:)` is append-only.** It never clears the stack view, so a second call duplicates
  all four rows. The invariant that it runs exactly once holds only because `fetchBundleInfo()` is
  called once from `viewDidLoad`.
- **The share sheet receives a `String`, not a `URL`.** `activityItems` is `[appURL]` where `appURL`
  is the raw App Store URL string.
- **`BundleInfoProvider` traps.** `fetchBundleInfo()` calls `fatalError` if `Info.plist` cannot be
  read or decoded, and `BundleInfo.displayName` (`CFBundleDisplayName`) is non-optional — a missing
  key crashes the app when this screen opens.
- **The header view re-parents its logo.** `addSubviews()` adds `logoImageView` to `self` and then
  adds `headerStackView`, whose lazy initializer moves the image view into the stack. The first
  `addSubview` has no lasting effect.
- The literal "Version" is not in the view model — `AboutScreenHeaderView.configure` composes
  `"\(L10n.AboutScreen.Item.version) \(viewModel.version)"`.
- `presenter?.viewDidLoad(self)` runs **before** `setupNavigationBar()` here, the opposite order from
  `DonateScreenViewController`.
- The protocol methods take the view as a parameter, but the presenter always uses its own `weak var view`.

## Concurrency

The contracts, the presenter, the interactor and the factory are all `@MainActor`; the view, the
header and the menu rows inherit it from `UIView`. `AboutScreenPresenter` needs the annotation for a
concrete reason beyond tidiness — its `urlOpener` default argument is `UIApplication.shared`, which
is main-actor isolated and cannot be evaluated in a nonisolated initializer.
