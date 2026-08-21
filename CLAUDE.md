# Awake — Wake on LAN for iOS

## Overview

iPhone app that wakes computers on the local network by sending a Wake-on-LAN magic packet.
UIKit, Swift, targeting iOS 17.0+. Ships on the App Store as **Awake**.

- Bundle ID: `com.tr1ckyf0x.wake-on-lan` (Siri extension: `com.tr1ckyf0x.wake-on-lan.intent`)
- App Store ID: `1575138731`
- App Group (shared Core Data store): `group.com.tr1ckyf0x.wake-on-lan.shared`
- `TARGETED_DEVICE_FAMILY = 1` — iPhone only, portrait only

## Architecture

**VIPER** modules + **RouteComposer** for navigation, with a plugin-based app lifecycle.

- **Modules** (`Wake On Lan/Modules/`): each screen is a VIPER stack — `Factory`, `ViewController`, `View`, `Presenter`, `Interactor`, `Contract`, `Routes`. Every module directory has its own `CLAUDE.md`.
- **Frameworks** (`Wake On Lan/Frameworks/`): in-target shared code — router wrappers, UI components, resources, IAP.
- **SharedCode** (`SharedCode/`): real framework targets shared with the Siri extension — `CoreDataService`, `WakeOnLanService`, `WOLSharedProtocolsAndModels`.

### Key architectural decisions

- **Composition roots are Factories.** Every module has a `Factory` conforming to `RouteComposer.Factory` that constructs and wires the whole stack. Dependencies are resolved *inside* `build(with:)`, mostly from `.shared` singletons — there is no DI container.
- **Navigation is data.** A `Route` (`Frameworks/SharedRouter/Core/Route.swift`) wraps a closure. Presenters conform to `Navigates` and call `navigate(to: router?.someRoute())`. Concrete routes live in `Wake On Lan/Routes/` as `WOLRouter` extensions, one file per destination module.
- **Modules declare what they need, not where they go.** Each module owns a `<Module>Routes` protocol; `WOLRouter` conforms to all of them (`Routes/Routes.swift`).
- **Delegate-based module output.** A module that must report back takes its caller as `Context` (see `ChooseIconFactory.Context = ChooseIconModuleOutput`).
- **Plugin-based lifecycle.** `AppDelegate` and `SceneDelegate` are thin hosts holding arrays of plugins that conform to `UIApplicationDelegate` / `UIWindowSceneDelegate`. See “App lifecycle” below.
- **Weak shared instances.** `CoreDataService`, `WakeOnLanService`, and `IAPManager` use `ProvidesWeakSharedInstanceTrait` from the `shared-frameworks` package: `.shared` returns the live instance if one exists, otherwise creates a new one held **weakly**. A service therefore lives only as long as something retains it — see “Gotchas”.
- **Programmatic UI only.** No storyboards or xibs except `LaunchScreen.storyboard`. Layout is SnapKit. The visual style is neumorphic (“soft UI”), implemented in `Frameworks/WOLUIComponents/SoftUI`.

## Directory structure

```
.
├── Wake On Lan/                     # App target sources (note: folder is "Lan", target is "Wake On LAN")
│   ├── AppDelegate.swift            # @main, process-level plugin host
│   ├── SceneDelegate.swift          # scene-level plugin host
│   ├── RootViewControllerFactory.swift  # builds HostList inside WOLNavigationController
│   ├── AppDelegatePlugins/          # DDLog, Firebase, navigation bar appearance, StoreKit observer
│   ├── SceneDelegatePlugins/        # window configuration
│   ├── Modules/                     # VIPER screens (each has its own CLAUDE.md)
│   │   ├── HostList/                # root screen: list of hosts, tap to wake
│   │   ├── AddHost/                 # AddHostForm + ChooseIcon submodules
│   │   ├── AboutScreen/             # about + menu (rate, GitHub, share, donate)
│   │   └── DonateScreen/            # in-app purchase donations
│   ├── Frameworks/                  # in-target shared code (NOT separate targets)
│   │   ├── SharedRouter/            # Route, Navigates, WOLRouter (RouteComposer wrappers)
│   │   ├── WOLUIComponents/         # SoftUI, EmptyView, SpinnerView, StateableView,
│   │   │                            #   WOLNavigationController, bottom-sheet presentation
│   │   ├── WOLResources/            # HostIcon, BundleInfoProvider
│   │   ├── SharedExtensions/        # Foundation/UIKit/CoreGraphics extensions
│   │   └── IAPManager/              # StoreKit 1 wrapper used by DonateScreen
│   ├── Resources/
│   │   ├── Strings/Localizable.xcstrings   # the ONLY localization source (en + ru)
│   │   └── Assets/                  # Assets.xcassets + Colors.xcassets
│   ├── Info.plist
│   └── Wake on LAN.entitlements     # app group, multicast, Siri, APS
├── SharedCode/                      # framework targets shared with the Intent extension
│   ├── CoreDataService/             # Host model, migrations, CRUD/move workers
│   ├── WakeOnLanService/            # magic packet builder + UDP send
│   └── WOLSharedProtocolsAndModels/ # cross-target protocols and value types
├── Intent/                          # Siri app extension (WOLIntentHandler)
├── IntentSharedSources/             # Intents.intentdefinition + its localization, built into both targets
├── swift-templates/Genesis/         # module scaffolding templates (VIPER, Bundle, YARCH)
├── SharedCodeTests/                 # unit tests over SharedCode/ (Swift Testing, no host app)
├── Configs/                         # xcconfig files — the source of truth for build settings
├── fastlane/                        # Fastfile, Matchfile, Appfile, encrypted api_key.json
├── project.yml                      # XcodeGen spec: targets, sources, dependencies
├── Mintfile                         # pinned CLI tools
└── .swiftlint.yml
```

## App lifecycle

Two plugin hosts, split by what actually happens once per process versus once per UI scene.

| Host | File | Plugins | Runs |
|------|------|---------|------|
| `AppDelegate` | `Wake On Lan/AppDelegate.swift` | `DDLogAppDelegatePlugin`, `FirebaseAppDelegatePlugin`, `NavigationBarAppearanceAppDelegatePlugin`, `IAPAppDelegatePlugin` | once per process |
| `SceneDelegate` | `Wake On Lan/SceneDelegate.swift` | `WindowConfigurationSceneDelegatePlugin` | on every scene connect |

A plugin is just an object conforming to `UIApplicationDelegate` / `UIWindowSceneDelegate`; the host iterates its array and forwards the callback.

**Do not move process-level plugins into `SceneDelegate`.** `scene(_:willConnectTo:)` can run more than once in a single process (the system disconnects a background scene and reconnects it), and `FirebaseApp.configure()` traps on the second call while `DDLog.add` would duplicate every log line.

`IAPAppDelegatePlugin` does no configuration at all — it exists purely to hold `IAPManager.shared`
strongly. The instance is a weak singleton, so without a process-lifetime owner the StoreKit
transaction observer would only be registered while the Donate screen is on screen.

Adding a forwarded callback requires editing the host: it forwards only the methods it explicitly implements.

## Build system

### Prerequisites

```bash
make bootstrap    # Mint tools -> .bin, bundle install, XcodeGen project
```

`Wake On LAN.xcodeproj` is **generated** and must never be edited by hand — change `project.yml` and re-run `mint run xcodegen` (or `.bin/xcodegen`).

### Tools (via Mint, pinned in `Mintfile`)

| Tool | Version | Purpose |
|------|---------|---------|
| XcodeGen | 2.46.0 | Generates `.xcodeproj` from `project.yml` |
| SwiftLint | 0.65.0 | Linting; runs as a pre-build script phase |
| Genesis | 0.9.0 | Template engine behind module scaffolding |
| FoxGen | 0.0.9 | Orchestrates Genesis module scaffolding (`foxgen.yml`) |
| xcbeautify | 3.2.1 | `xcodebuild` output formatter used by fastlane |

### Build settings (`Configs/`)

Every build setting lives in an xcconfig; `project.yml` describes targets, sources and dependencies
and carries almost no settings.

`Base.xcconfig` is attached **once, at project level** (the top-level `configFiles:` key) and covers
every target — Swift 6, warnings-as-errors, team, versions, iPhone-only. The rest are attached per
target:

```
Base.xcconfig                          # project level, applies to every target
App.xcconfig                           # app target: bundle id, entitlements, string-symbol generation
├── AppDebug.xcconfig                  # development identity + profile
└── AppRelease.xcconfig                # distribution identity + profile, dSYM, dead stripping
Intent.xcconfig                        # Siri extension
├── IntentDebug.xcconfig
└── IntentRelease.xcconfig
Framework.xcconfig                     # shared by the SharedCode/ frameworks
├── CoreDataService.xcconfig           # each one only adds its bundle identifier
├── WakeOnLanService.xcconfig
└── WOLSharedProtocolsAndModels.xcconfig
SharedCodeTests.xcconfig               # the test bundle
```

The chain used to run `Base` → `App`/`Intent`/`Framework` through `#include`, on the belief that a
project-level attachment would lose to XcodeGen's presets. It does not — see below. Collapsing it was
verified by diffing `-showBuildSettings` for all six targets in both configurations before and after:
7345 lines, identical.

**XcodeGen omits every preset the attached xcconfig already declares.** It parses the file, follows
its `#include` chain, and then writes only the presets the file left undefined. This holds at target
level and at project level alike, so a setting kept in `Configs/` wins because the file declares it,
not because of where the file is attached. Measured against the pinned XcodeGen 2.46.0: declaring
`TARGETED_DEVICE_FAMILY` in an xcconfig leaves the key out of `project.pbxproj` entirely and resolves
to the declared value; deleting the line makes XcodeGen write `"1,2"` back. The same holds for
`SWIFT_VERSION` and `IPHONEOS_DEPLOYMENT_TARGET` from a *project*-level file, and the deployment
target does not fall through to the SDK when `options.deploymentTarget` is absent, as long as an
xcconfig supplies it.

The four-file `#include` chain is therefore convention rather than necessity: attaching
`Base.xcconfig` once through a project-level `configFiles:` key would behave identically. Only
`options.deploymentTarget` still lives in `project.yml`, and only because nothing has moved it yet.

The one exception runs the other way. `INFOPLIST_FILE` is **not** a preset — XcodeGen detects the
plist from the target's sources and writes the setting into the target's own build settings, which do
outrank the target's xcconfig. The lines in `App.xcconfig` and `Intent.xcconfig` are inert.

> This paragraph replaces one that claimed the exact opposite: that a project-level xcconfig loses to
> the presets, that `TARGETED_DEVICE_FAMILY` had to stay in `project.yml`, and that the deployment
> target would fall through to the SDK. All three were wrong, and being wrong in that direction is
> the expensive kind — it tells you to avoid something that works. Settle a precedence question by
> regenerating and grepping `project.pbxproj`, never by reading prose, this paragraph included.

### Targets

| Target | Type | Notes |
|--------|------|-------|
| `Wake On LAN` | application | The app. Sources: `Wake On Lan/` + `IntentSharedSources` |
| `Intent` | app-extension | Siri intent handler |
| `CoreDataService` | framework | Host storage, shared with `Intent` |
| `WakeOnLanService` | framework | Magic packet + UDP, shared with `Intent` |
| `WOLSharedProtocolsAndModels` | framework | Cross-target protocols/models |

### Build configurations and schemes

- Configurations: `Debug`, `Release`
- Shared schemes: `Wake On LAN`, `Intent` (generated from the `scheme:` key on those targets).
  The frameworks have no shared scheme; `xcodebuild` autocreates one per target on demand.

```bash
xcodebuild -project "Wake On LAN.xcodeproj" -scheme "Wake On LAN" \
  -configuration Debug -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

> Building with `CODE_SIGNING_ALLOWED=NO` produces a binary **without entitlements**, so the App Group
> is unavailable and `CoreDataService.init()` hits `fatalError("Persistent container URL is unavailable")`
> at launch. To actually run the app, build with ad-hoc signing (`CODE_SIGN_IDENTITY="-"`).

## Dependencies (SPM, pinned in `project.yml`)

| Package | Version | Purpose |
|---------|---------|---------|
| CocoaLumberjack | 3.9.1 | Logging (`DDLogInfo` / `DDLogError` / `DDLogWarn`) |
| firebase-ios-sdk | 12.18.0 | `FirebaseCore` + `FirebaseCrashlytics` |
| RouteComposer | 2.22.2 | Navigation engine behind `WOLRouter` |
| SFSafeSymbols | 7.0.0 | Compile-time-checked SF Symbols |
| SnapKit | 6.0.0 | Auto Layout DSL |
| shared-frameworks | 1.0.0 | `PersistenceCore`, `SharedProtocolsAndModels` |

## Code generation

### Resources

**Nothing generates resource accessors into this repository.** The Xcode toolchain emits them into
`DerivedSources` on every build, and they are compiled straight into the app target. There is no
SwiftGen, no checked-in generated file, and no `make` step to remember.

| Source | Emitted by | Use it as |
|--------|-----------|-----------|
| `Resources/Assets/{Assets,Colors}.xcassets` | `actool` (`GeneratedAssetSymbols.swift`) | `UIColor(resource: .primary)`, `UIImage(resource: .owl)` |
| `Resources/Strings/Localizable.xcstrings` | `xcstringstool` (`GeneratedStringSymbols_Localizable.swift`) | `String(localized: .hostListScreenTitle)` |
| `InfoPlist.xcstrings` | the system reads it from the bundle | not referenced from code |
| `IntentSharedSources/Intents.xcstrings` | `xcstringstool` | translations for `Base.lproj/Intents.intentdefinition` |

Asset symbols are on by Xcode's default — nothing configures them. String symbols are **not**: they
need `STRING_CATALOG_GENERATE_SYMBOLS = YES`, which is set in `Configs/App.xcconfig`. Both generators
are gated `@available(iOS 11.0, *)` and `@available(iOS 16, *)` respectively, so the iOS 17.0
deployment target needs no guards, and both emit `Sendable`/`nonisolated` types.

Symbol names are flattened from the key: `AddHost.Form.Field.MacAddress.Failure.InvalidMACAddress`
becomes `.addHostFormFieldMacAddressFailureInvalidMACAddress`. Long, but a missing or renamed key is a
**compile error**, and the symbols are regenerated on every build rather than whenever someone
remembers to run a tool.

Both catalogs hold every language in one file — edit them in Xcode's String Catalog editor, which
tracks per-language translation state. `InfoPlist.xcstrings` carries the permission prompts
(`NSLocalNetworkUsageDescription`); the system reads it straight from the bundle, so nothing in code
refers to it. `STRING_CATALOG_GENERATE_SYMBOLS` still emits a symbol file for it — one unused
`LocalizedStringResource`, stripped from Release by `DEAD_CODE_STRIPPING`.

The intent definition keeps base internationalization: `IntentSharedSources/Base.lproj/Intents.intentdefinition`
holds the English text and the opaque string IDs Xcode's intent editor generates (`rD7LLc`, `lgpdSx`,
…), and `Intents.xcstrings` carries the translations keyed by those IDs. Only the `.strings` half
became a catalog — the definition itself must stay in `Base.lproj`.

**Do not add `.lproj` folders.** The only ones left in the repository are `Wake On Lan/Base.lproj`
(LaunchScreen) and `IntentSharedSources/Base.lproj` (the intent definition). The `en.lproj`/`ru.lproj`
folders that appear *in the built bundle* are produced by `xcstringstool` from the catalogs.

> The project used to run SwiftGen for both. It was dropped because Xcode now does the same job
> better: SwiftGen 6.6.3 is its last release (March 2024) and **cannot read `.xcstrings` at all** — fed
> one, it writes an empty file and exits 0 — so keeping it would have frozen the project on legacy
> `.strings` forever. Its generated `ColorAsset` was also a mutable class whose `static let` constants
> Swift 6 rejects outright.

> `foxgen.yml` still declares a `swiftgen` executable. FoxGen 0.0.9 refuses to decode its config
> without that key, but never invokes it — see the comment there.

### Modules (FoxGen + Genesis)

```bash
mint run foxgen --help
```

Templates live in `swift-templates/Genesis/`. The VIPER template generates `Factory`, `Interactor`,
`Presenter`, `Routes`, `View`, `ViewController` into `Modules/<Module>/<Submodule>/`.

## Signing and CI/CD

### Code signing — fastlane match

Certificates and profiles live in the private `tr1ckyf0x-studio/match-certificates` repo. Profile
names are `Wake On Lan <Type>` and `Wake On Lan Siri Intent <Type>`, referenced from `project.yml`
as `PROVISIONING_PROFILE_SPECIFIER`. `CODE_SIGN_STYLE = Manual`.

```bash
make sync_development_certificates                      # read-only, for local development
bundle exec fastlane ios sync_release_certificates      # read-only, used by CI
bundle exec fastlane ios generate_development_certificates   # creates/renews in the portal
bundle exec fastlane ios generate_release_certificates       # creates/renews in the portal
```

The `generate_*` lanes need the App Store Connect API key, which is stored encrypted with
**git-secret** as `fastlane/api_key.json.secret`; run `git secret reveal` first.

### GitHub Actions

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| `ios-checks.yml` | push to `development`, any pull request | bootstrap → `fastlane ios test` → `fastlane ios verify_release` (no signing, no secrets) |
| `build-ios-beta.yml` | push of a `x.y.z` tag | bootstrap → GPG import + `git secret reveal` → temporary keychain → `sync_release_certificates` → `beta` → TestFlight |

**Only a tag ships to TestFlight.** Pushing to `development` just verifies that the project builds.

Required repository secrets (release workflow only): `GPG_PRIVATE_KEY`, `MATCH_PASSWORD`,
`KEYCHAIN_PASSWORD`.

### Release flow

1. Branch `release/<version>` off `development`.
2. Bump `MARKETING_VERSION` in `Configs/Base.xcconfig` and add a `## <version>` section to `CHANGELOG.md`; commit as `version <x.y.z>`.
3. Signed tag: `git tag -s <x.y.z> -m ""` (tag messages are empty by convention).
4. Push the tag — this is what triggers the TestFlight build.
5. Merge the tag back into `development` (`git merge --cleanup=strip <x.y.z>`), delete the release branch.

`CURRENT_PROJECT_VERSION` is not maintained by hand — fastlane's `increment_build_number` sets the
build number from the latest TestFlight build.

## Testing

One target: **`SharedCodeTests`** (`SharedCodeTests/`, Swift Testing), covering the `SharedCode/`
frameworks. It has **no host application** — nothing in it touches UIKit, the App Group container or
the keychain, so it needs no signing and no app launch. Its own scheme runs it, and CI runs
`fastlane ios test` before the build.

```bash
xcodebuild test -project "Wake On LAN.xcodeproj" -scheme SharedCodeTests \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

The suite is marked `.serialized`, and that is load-bearing rather than cautious — see the Core Data
gotchas below. Its scheme also passes `-com.apple.CoreData.ConcurrencyDebug 1`, which turns a context
touched from the wrong queue into a trap at the offending call instead of memory corruption that
surfaces later somewhere unrelated. It found two violations the first time it was switched on.

`fastlane ios test` additionally fails when fewer than `MINIMUM_TEST_COUNT` tests actually ran, so a
filter that silently selects nothing cannot pass as green.

`fastlane ios verify_release` builds the app in **Release** without signing and runs
`Scripts/verify_release_bundle.sh` over the result. The script asserts what compiles cleanly but
ships broken: the intent definition and the extension are in the bundle, both languages produced
`.strings` files and the Russian one is not empty, the version keys expanded rather than staying
`$(...)`, and the app and the extension agree on `CFBundleVersion`. Each check stands for a
regression that actually happened. The Crashlytics phase honours `SKIP_CRASHLYTICS_UPLOAD=1`, which
the lane sets so a build that never ships does not push dSYMs; the variable is fail-safe on purpose,
since unset means upload.

Nothing covers the app target yet. Most services are reachable through protocols
(`WakeOnLanServiceProtocol`, `CoreDataServiceProtocol`, `ManagesIAP`, `UDPService`,
`BuildsMagicPacket`), so seams exist; the VIPER `Factory` types are the parts that hard-code
`.shared` singletons, and `HostListInteractor` holds `WakeOnLanService` as a concrete type rather
than the protocol. No mocks are generated — hand-written fakes are enough at this size.

## Code conventions

### General

- **Comments and documentation in English.** Use `///` for public/internal API.
- Programmatic UI, SnapKit for layout, no Interface Builder.
- File header comments are the Xcode default block (`//  <name>.swift` / `//  Wake on LAN` / author / copyright).
- `// MARK: -` sections in a consistent order: `Properties`, `Init`, `Lifecycle`, `Private`, then protocol conformances in extensions.
- Protocol conformance goes in a dedicated `extension`, one per protocol, preceded by `// MARK: - <Protocol>`.

### Naming

| Entity | Convention | Example |
|--------|-----------|---------|
| Capability protocols | Verb phrase | `ProvidesBundleInfo`, `ManagesIAP`, `TracksHostListCache`, `Navigates` |
| VIPER contracts | `<Module>ViewInput/Output`, `<Module>InteractorInput/Output` | `HostListViewOutput` |
| Module entry point | `<Module>Factory` | `AddHostFactory` |
| Module routing contract | `<Module>Routes` | `DonateScreenRoutes` |
| Module output delegate | `<Module>ModuleOutput` | `ChooseIconModuleOutput` |
| Extensions | `Type+Feature.swift` | `UIImage+SFSymbol.swift`, `String+Extensions.swift` |
| Route implementations | `Routes+<Destination>.swift` | `Routes+AddHost.swift` |

### SF Symbols

Use **SFSafeSymbols** directly — raw symbol strings are rejected by a custom SwiftLint rule.

```swift
UIImage(systemSymbol: .plus, withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
```

`UIImage(systemSymbol:withConfiguration:)` takes a `UIImage.Configuration`, so a symbol
configuration has to be spelled out — `.init(weight:)` does not infer.

The one project-specific type is `HostIcon` (`Frameworks/WOLResources/SFSymbol/HostIcon.swift`): the
curated set of device icons a user can pick. It is a domain list, not a wrapper — it drives the icon
picker through `allCases` and guards persistence, since `SFSymbol` has thousands of members and
`SFSymbol(rawValue:)` would accept anything.

> `HostIcon.systemName` (i.e. `symbol.rawValue`) is persisted in `Host.iconName`. Removing a case or
> repointing it at a different symbol orphans the icon of every host already saved with it.
> `HostIcon(systemName:)` is the reverse lookup and returns `nil` for unknown names.

### Concurrency

**Swift 6 language mode with strict concurrency**, configured in `Configs/`:

| Setting | Scope | Effect |
|---------|-------|--------|
| `SWIFT_VERSION = 6.0` | all targets (`Base.xcconfig`) | Swift 6 language mode; data-race safety is enforced |
| `SWIFT_APPROACHABLE_CONCURRENCY = YES` | all targets | `InferIsolatedConformances`, `NonisolatedNonsendingByDefault` |
| `SWIFT_TREAT_WARNINGS_AS_ERRORS = YES` | all targets | the build stays diagnostic-free |

**No target sets `SWIFT_DEFAULT_ACTOR_ISOLATION`.** Isolation is written out at each declaration
instead. The app target used to default to `MainActor`, which read well but collided head-on with
Apple's own code generation: the `Intents.intentdefinition` compiler emits a `WOLIntent.swift` whose
overrides of nonisolated `NSObject` initialisers cannot be main-actor isolated, the file is
regenerated on every build so it cannot be annotated, and `INTENTS_CODEGEN_LANGUAGE` offers no way to
turn generation off. Since the app target has to compile that definition — that is what puts the
action in the Shortcuts app — the default isolation had to go.

What carries `@MainActor` today:

- every VIPER contract protocol (`*ViewInput/Output`, `*InteractorInput/Output`, `*ModuleOutput`) and
  the concrete presenters, interactors, factories and table/collection managers behind them
- `StateableView` / `DisplaysStateView`, and `ProvidesCollectionViewCell` / `ProvidesTableViewCell` —
  they are handed live views, so they can only ever run on the main actor
- every `Appearance` descriptor, because its stored properties read asset colours and images
- the generated `Asset` namespaces (see "Code generation")

UIKit subclasses need nothing: `UIView` and `UIViewController` are already main-actor isolated, so
views, cells and view controllers inherit it.

What must **stay** unisolated. No target sets a default, so these are already nonisolated and carry
no keyword; what they carry is a note saying not to give them an actor later:

- error types (`UDPError`, `MagicPacketError`) — `LocalizedError` is nonisolated and errors must be
  readable from any isolation
- the migration stages and `CoreDataHostFormatter` — Core Data drives them on its own queue, and an
  actor here compiles clean and traps in `_dispatch_assert_queue_fail` at runtime
- `PaymentManager` and `ProductsRequest` — StoreKit delivers its callbacks on its own queue, and
  isolating them to the main actor makes Swift insert a check that traps (`_dispatch_assert_queue_fail`)
  on the first answer. `NSLock` is what makes them safe instead.
- diffable data source identifiers (`HostListSectionItem`, `HostListCellViewModel`) — the API
  requires `Sendable` identifiers with a nonisolated `Hashable`
- `OneShotContinuation` in `NWUDPService` — reached from `NWConnection`'s own queue

**Managed objects never cross an isolation boundary.** Anything leaving a Core Data context queue is
a value: `HostSnapshot` for the magic packet, `HostFormValues` for writes, and `NSManagedObjectID`
for identifying a row (`PerformsCRUDOperation.update/delete`). This is not stylistic — passing a
`Host` into an `async` function traps under `-com.apple.CoreData.ConcurrencyDebug 1`.

### Linting

`.swiftlint.yml` follows the same policy as the other tr1ckyf0x-studio projects: default rules stay
on, exceptions are listed in `disabled_rules`, extras in `opt_in_rules`. SwiftLint runs as a
pre-build script, so **error-severity violations break the build**; warnings do not.

`no_extension_access_modifier` is disabled on purpose — this codebase uses `public extension Foo { … }`
throughout, and rewriting it would require adding `public` to every member by hand.

## Gotchas

- **Weak singletons.** `CoreDataService.shared`, `WakeOnLanService.shared`, and `IAPManager.shared`
  are stored in a `static weak var`. When the last strong reference dies the instance is deallocated
  and the next `.shared` builds a fresh one. For `IAPManager` this means its
  `SKPaymentTransactionObserver` registration exists only while the Donate screen is on screen.
- **`fatalError` at launch without entitlements.** `CoreDataService.init()` traps when the App Group
  container URL is unavailable — the usual cause is a build made with `CODE_SIGNING_ALLOWED=NO`.
- **Folder/target name mismatch.** The directory is `Wake On Lan`, the target and project are
  `Wake On LAN`. Paths in `project.yml` must match the directory exactly or Xcode warns about
  case-mismatched paths.
- **Error handling is thin.** Most `catch` blocks log through CocoaLumberjack and stop there; several
  modules have no error state at all. Do not assume a failure surfaces in the UI.
- **Module `CLAUDE.md` files must stay excluded from the app target.** `project.yml` globs the whole
  `Wake On Lan` directory, so without the `**/CLAUDE.md` exclude they are copied into the bundle as
  resources and collide with "Multiple commands produce …/CLAUDE.md".
- **Nothing is main-actor by default.** Every declaration that must run on the main actor says so.
  A new presenter, interactor or `Appearance` struct needs `@MainActor` written on it; a UIKit
  subclass does not, because UIKit already provides it.
- **The store is migrated by `NSStagedMigrationManager`, not by Core Data's automatic pass.**
  Automatic lightweight migration is single-hop: a store at v1 got an inferred v1→v4 mapping that
  matched attributes by name, so every host lost its address (`ipAddressData` at v1 versus
  `destination` from v2 on) and the list lost its ordering. `HostMigrationStages` walks v1→v2→v3→v4
  with three custom stages and runs before the app's container opens the file. Adding a model version
  means adding a stage and a test, and taking its `versionChecksum` from
  `HostsDataModel.momd/VersionInfo.plist` — **not** the entity version hash, which is a different
  value.
- **A migration stage must never bind `Host`.** Core Data binds a subclass's `@NSManaged` accessors
  to whichever loaded model claims it first, process-wide. The migration holds four versions open at
  once, all naming `CoreDataService.Host`; leaving them bound left `Host.entity()` pointing at a model
  that no longer existed and the app died in `Managed.entityName` on the *next* launch, long after the
  migration itself had succeeded. Every model the migration touches is therefore a *copy* with its
  entities re-pointed at plain `NSManagedObject` — a copy because a compiled model is immutable, and
  detaching does not change the checksum. The same hazard is why `SharedCodeTests` is `.serialized`.
- **One model reference per version, shared by both stages that touch it.** Handing Core Data two
  distinct model objects for the same version — one as a stage's `nextModel`, another as the next
  stage's `currentModel` — corrupts its migrator's heap and traps inside `saveMetadata:`.
- **A failed migration is not a safe no-op.** `HostStoreMigrator` leaves the store at its original
  version, but `PersistenceCore` builds a bare `NSPersistentStoreDescription`, so the container that
  opens next still has `shouldMigrateStoreAutomatically` and `shouldInferMappingModelAutomatically`
  at `true` and performs the lossy inferred migration anyway. Swallowing the error therefore trades a
  visible failure for silent data loss. Recorded in `BACKLOG.md`; the fix is a product decision, not
  a code cleanup.
- **A migration stage must never touch `container.viewContext`.** Core Data runs the stage handlers
  on its own migration thread, so a main-queue context is the wrong one — and it fails silently, far
  from the cause. Rows read through it are registered in a context whose queue is the main queue, so
  their `_forgetObject:` cleanup is scheduled there; the migration then finishes and releases the
  model, and the main queue drains afterwards into a freed entity — `SIGSEGV` in
  `_PFObjectIDFastHash64`, attributed to whatever ran next. It reproduced as roughly one crashed
  test in three, each time a *different* test. `eachHost` therefore uses its own
  `newBackgroundContext()` inside `performAndWait`, and resets it in a `defer` so the registry is
  emptied while the model is still alive. Anything else the stages reach for must follow the same
  rule.
- **An xcconfig beats an XcodeGen preset, but not an auto-detected setting.** XcodeGen skips any
  preset the attached xcconfig declares, at target *and* project level, so `TARGETED_DEVICE_FAMILY`,
  `SDKROOT` and the framework `DYLIB_*`/`SKIP_INSTALL` block are all safe to keep in `Configs/`.
  What is not safe is `INFOPLIST_FILE`: XcodeGen derives it from the target's sources and writes it
  into the target's own settings, which outrank the xcconfig. Verify by regenerating and grepping
  `project.pbxproj` — the prose here was wrong once already. See "Build settings".
- **`Intents.intentdefinition` must stay in *both* targets.** `IntentSharedSources` is a source of
  the app **and** of `Intent`. The extension needs the generated `WOLIntent` class to handle the
  request; the app needs the compiled definition in its own bundle, because that is what the
  Shortcuts app reads to offer the action. Dropping it from the app target still builds, still ships,
  and still handles Siri — the action simply disappears from Shortcuts, which no test catches.
- **`public` on module types is vestigial.** Factories, view controllers, and routes are `public`
  because modules used to be separate targets (removed in `314b733`). They are all in the app target now.

## Git workflow

- Main branch: `development`. Release branches: `release/<version>`. Hotfixes: `hotfix/<version>`.
- Commit subjects: one line, English, past tense, sentences separated by periods
  (`Fixed magic packet send`, `Updated dependencies. Migrated to SPM`).
- Commits and tags are GPG-signed.
- Push to `development` runs the build check; pushing a `x.y.z` tag ships to TestFlight.
