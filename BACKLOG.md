# Backlog

Findings from the audit of 2026-08-22, kept so the audit does not have to be run again. Each item
says what it is, why it matters, roughly what it costs, and the evidence. Update or delete an item
when it is done or turns out to be wrong — do not start a fresh audit.

Evidence marked **(verified)** was reproduced directly; **(reported)** came out of the audit and was
not independently re-checked.

## Before releasing 1.7.0

**Do not promote an existing TestFlight build.** Builds 3, 4 and 5 of 1.7.0 were uploaded on
2026-08-22 and all three predate `847509a`, so they carry the migration crash described below —
build 5 was distributed to internal testers. The decision was to leave them in place rather than
ship a replacement, because the release is far off. Cut a fresh build from `development` when the
time comes.

The crash: the migration stages read rows through `container.viewContext`, a main-queue context,
while Core Data runs the stage handlers on its own thread. The deferred `_forgetObject:` cleanup was
scheduled on the main queue and ran after the migration released the model, dereferencing a freed
entity — `SIGSEGV` in `_PFObjectIDFastHash64`, on app launch, for anyone upgrading from a v1/v2/v3
store. It reproduced as roughly one crashed test in three, each time a different test, because the
crash lands nowhere near its cause. Fixed in `847509a`; 0 failures in 40 runs afterwards, against 3
in 10 before. See the gotcha in `CLAUDE.md`.

## Audit of 2026-08-22, second pass

A fourteen-agent review of everything between `eb5e2b7` (the 1.6.1 merge) and HEAD: seven reviewers by
area, each followed by an adversarial critic that re-ran the citations and hunted for what the
reviewer skipped. 64 findings; the critics overturned seven verdicts, in both directions. What
follows is the surviving set. Items marked **(verified here)** were reproduced independently
afterwards, not taken on the agents' word.

### XcodeGen does not do what `CLAUDE.md` said it does · FIXED

**(verified here)** Every claim in the old "an xcconfig can lose to an XcodeGen preset" rule was
false. XcodeGen 2.46.0 *reads* the attached xcconfig, follows its `#include` chain, and **omits any
preset the file already defines** — at target level and at project level alike. Measured with the
repository's own pinned `.bin/xcodegen`:

| experiment | result |
|---|---|
| `TARGETED_DEVICE_FAMILY = 1` in a target xcconfig | nothing written to the pbxproj, effective value `1` |
| reverse control, key removed | `1,2` written twice, effective value `1,2` |
| xcconfig attached at **project** level | zero `SWIFT_VERSION` lines written, effective `6.0` |
| no `options.deploymentTarget`, value only in the project xcconfig | nothing written, effective `17.0` |

So the four-level `#include` chain and the split source of truth between `project.yml` and `Configs/`
solve a problem the tool does not have. The rule was also stated backwards, which is worse than
having no rule: it told the next editor that settings which *do* work from an xcconfig would be
silently overridden.

The documentation is corrected and `TARGETED_DEVICE_FAMILY` now lives in `Configs/`. Collapsing the
`#include` chain onto a single project-level attachment is still open, and is now a simplification
rather than a correctness fix.

### The scheme guard in `verify_release` could not fail · FIXED

**(verified here)** `xcodebuild -list` prints `Information about project "Wake On LAN"` in its header
and lists both `Wake On LAN` and `Intent` under `Targets:`, so the substring test passed whether or
not the `Schemes:` section still held them. A guard added the same day it was called a working check,
and the one guard of that batch for which no negative control was run.

### A failed migration falls through to the lossy migration it exists to prevent · FIXED

**(verified here)** `PersistenceCore` builds its store description as a bare
`NSPersistentStoreDescription(url:)`, so `shouldMigrateStoreAutomatically` and
`shouldInferMappingModelAutomatically` are both left at `true`. When `HostStoreMigrator` throws and
`CoreDataService+Init` logs and carries on, the app's own container then performs exactly the
single-hop inferred migration that `HostMigrationStages` was written to replace — the one that drops
the host address and the list order.

The comment claiming "the container below opens exactly what was there before" was false and has been
corrected. The behaviour too: a failed migration now discards the store through
`HostStoreMigrator.discardStore(at:)`, journal files included, so the container opens an empty store
at the current version. The user sees an empty list — obvious, and fixed by re-adding hosts — rather
than entries that still look right and wake nothing. Two tests cover the discard, including that a
missing store is not an error.

### The release runner keeps the GPG private key · FIXED

`build-ios-beta.yml` imported the git-secret signing key into the runner's keyring and never removed
it, on a **self-hosted** runner that also serves `Checks` on `pull_request` — that is, on code from
forks. Now imported into a throwaway `GNUPGHOME` that is deleted in an `if: always()` step.

Still open, and not addressed here: `Checks` runs on `pull_request` on that same self-hosted runner,
so a pull request from a fork executes its own `Makefile` and build scripts on the machine. GitHub's
default `pull_request` trigger withholds secrets, which limits the damage but does not remove code
execution.

### Smaller findings, not yet acted on

- ~~**Decorative `nonisolated`**~~ — DONE. Sixteen keywords removed from `SharedCode/`, whose targets
  never had main-actor default isolation; `SWIFT_DEFAULT_ACTOR_ISOLATION` is set by no target at all.
  The comments that explained the opt-out are gone with them, and the two that carried a real warning
  now say what they mean: do not give this type an actor later.
- ~~**Redundant hops to the main actor**~~ — DONE. Both interactors are `@MainActor`, so the `Task`
  closures already inherit it.
- ~~**`@preconcurrency` on `AboutScreenViewRepresentable`**~~ — DONE. The protocol was referenced only
  by its own declaration and conformance; both are gone and `configure(with:)` is a plain method.
- ~~**`INFOPLIST_FILE` in `App.xcconfig` and `Intent.xcconfig` is inert**~~ — DONE. Confirmed by
  pointing the xcconfig at `Bogus/Nope.plist` and watching the effective value stay put: XcodeGen
  auto-detects the plist and writes the setting into the target's own settings, which *do* outrank
  the xcconfig. The lines are gone and a comment says why the key is absent.
- ~~**Five settings carried into `Configs/` that do nothing**~~ — DONE, see "Dead build settings and
  unused entitlements" below.
- ~~**Version checksums are hardcoded**~~ — DONE. Read from
  `HostsDataModel.momd/VersionInfo.plist` at run time, and the silent fallbacks around them replaced
  by thrown errors: a checksum that no longer matches its model does not fail loudly, it makes
  `NSStagedMigrationManager` skip the stage.
- ~~**`Scratch` carries `createdAt` across two schema steps**~~ — investigated, **keeping it**, do not
  reopen. The finding rested on "nothing shows it to a user", which is true and beside the point:
  `HostListCellViewModel` is the diffable snapshot's item identifier and `createdAt` is one of only
  four fields in its hash. The other three — `title`, `iconName`, `macAddress` — may legitimately
  repeat, since the same machine can be added twice. Dropping the carry would stamp every migrated
  host with a `Date()` from one loop, leaving microseconds as the only thing standing between the
  snapshot and a duplicate-identifier crash.
- ~~**`swift-templates` still carries tag 1.1.0**~~ — DONE. `master` rolled back to `1593714` and the
  tag deleted, locally and on origin. Checked first that nothing else depends on the dropped commits:
  the only other consumer, `hydrate-ios`, pins `9cfb381`, an ancestor. Recovery, should it ever be
  wanted: `master` was `2ffe83f`, tag `1.1.0` was `bf4f6f1`.

  The submodule pointer here stays where it always was, at `443bf54` (tag `0.0.2`). Only the commit
  that reached for the forked stencil ever moved it, and that commit is gone. `master` in
  `swift-templates` sits ahead of it at `1593714`; a submodule pinning an ancestor is normal, and
  nothing in this project reads the templates on the build path.
- ~~**`CFBundleDisplayName` and `CFBundleName` leaked into `InfoPlist.xcstrings`**~~ — DONE. Both were
  English-only and identical to what `DISPLAY_NAME` / `PRODUCT_NAME` already expand to, and the
  Russian bundle never carried them, so removing them changes nothing. Verified against a rebuilt
  bundle: `CFBundleDisplayName` is still `Awake`.
- ~~**`CODE_SIGN_IDENTITY` hardcodes full certificate common names**~~ — DONE for the Debug
  configurations. The Distribution ones keep their full name, which is keyed on the team and survives
  renewal.

## Correctness

### ~~Core Data migration loses data for old installs~~ — DONE

Automatic lightweight migration is single-hop, so a store at v1 got an inferred v1→v4 mapping that
matched attributes by name: `ipAddressData` (v1, Binary) has no counterpart in v4, so every host lost
its address and fell back to the 255.255.255.255 broadcast, and `order` did not exist before v3 so the
list collapsed onto one position. Reproduced on a seeded store.

Exposure from history: v1 shipped May 2020 – Aug 2023, v2 until Dec 2023, v3 until Jan 2024. A v1
store therefore means an install untouched for over two years; a v2 store lost only its ordering.

Fixed by raising the deployment target to iOS 17 and adopting `NSStagedMigrationManager`
(`HostMigrationStages`), which walks v1→v2→v3→v4 with three custom stages. The three
`.xcmappingmodel` files and the three `NSEntityMigrationPolicy` subclasses were deleted with it —
staged migration takes no mapping models, and one of the three had been unusable for years anyway
because a mapping model embeds a *copy* of its source and destination models and v3 was edited after
it was authored.

Covered by `SharedCodeTests/HostStoreMigratorTests.swift` (v1, v2, v3, current, empty store, creation
dates preserved, missing icon backfilled) and verified end to end by seeding a v1 store into the
simulator's App Group container and launching the app.

### ~~The icon picker's transition delegate is owned by nobody~~ — investigated, not doing

The audit reported that `Routes+AddHost.swift` creates `SelfSizingBottomSheetModalTransitionDelegate()`
as a local held only weakly — by RouteComposer's `PresentModallyAction.transitioningDelegate` and by
`UIViewController.transitioningDelegate` — and claimed the picker therefore fails in Release builds.

**It does not.** A Release build on the simulator presents the sheet and dismisses it correctly,
animation included. UIKit asks the delegate for its presentation controller *synchronously* inside
`present(_:animated:)`, while the local is still in scope, and retains the presentation controller
itself from then on.

A fix was written (the view controller owning its own delegate) and reverted: it changed nothing
observable, and no defect was ever demonstrated. Do not re-open this without a reproduction — the
ownership reads wrong, but the behaviour is correct and the presentation path does not depend on the
local outliving the call.

### ~~`MagicPacketBuilder` accepts malformed MAC addresses~~ — DONE

`compactMap` dropped the groups it could not parse and the length check counted only the survivors,
so anything with six *parseable* groups among however many was accepted. The builder now counts the
separated groups before parsing any of them, requires exactly six, and requires each to be exactly
two hexadecimal digits — the same shape the AddHost form's regex enforces, so the codebase holds one
definition of a valid MAC rather than two that can drift apart.

All three per-group conditions earn their place, measured rather than assumed:

| input | `UInt8(_:radix: 16)` | `count == 2` | `allSatisfy(\.isHexDigit)` |
|---|---|---|---|
| `"AA"` | 170 | yes | yes |
| `"+A"` | **10** | yes | no |
| `"１２"` | nil | yes | **yes** |
| `"A"` | 10 | no | yes |

A length check alone admits `"+A"`, because `UInt8(_:radix:)` accepts a leading sign; `isHexDigit`
alone admits full-width digits, which `UInt8` then rejects.

Covered by `SharedCodeTests/MagicPacketBuilderTests.swift`, which also brings `WakeOnLanService`
under test for the first time. The suite was checked against the old implementation: five of its ten
malformed inputs failed there — `AA:BB:CC:DD:EE:FF:GG`, `AA:BB:CC:DD:EE:FF:`, `::AA:BB:CC:DD:EE:FF`,
`A:B:C:D:E:F` and `+A:BB:CC:DD:EE:FF` — so it proves the fix rather than itself.

Still true, and the reason this stayed low priority: no path reaches the builder with unvalidated
input. The form gates on the regex, and the Siri extension resolves a saved host rather than taking a
MAC of its own.

### Failures are reported to the user as success · ~1 day

- `AddHostInteractor.swift:39` and `:58` bind the completion `Result` to `_`. On a Core Data failure
  the presenter still calls `didSaveForm` and dismisses: the user returns to a list without the host
  they just filled in. The AddHost contract has no error state at all.
- `AddHostPresenter.swift:41-42` — `guard addHostForm.isValid else { return }` with an explicit
  `// TODO: Обработка ошибок формы`. Save is never disabled, so on a fresh install the first tap on
  Save does nothing at all, with no feedback.
- A denied Local Network permission is indistinguishable from any other failure: every tap waits out
  the 5 s UDP timeout and then claims the user is not connected to a network. Nothing links to
  `openSettingsURLString`.

## Build, tooling and CI

### How the release build number actually gets set · note, not a defect

```
$ xcrun agvtool what-version
There does not seem to be a CURRENT_PROJECT_VERSION key set for this project.   # rc=6
```

**(verified)** — `7fcea68` moved `CURRENT_PROJECT_VERSION` into `Configs/Base.xcconfig`, and `agvtool`
parses `project.pbxproj` without resolving xcconfigs.

**The release lane is not broken.** Two consecutive `workflow_dispatch` runs on 2026-08-22
([32573210482](https://github.com/tr1ckyf0x-studio/wakeonlan-ios/actions/runs/32573210482),
[32573232995](https://github.com/tr1ckyf0x-studio/wakeonlan-ios/actions/runs/32573232995)) both
succeeded and produced 1.7.0 builds 3 and 4. What actually happens:

- `latest_testflight_build_number` returns the last build, then `increment_build_number` runs
  `agvtool new-version -all <n>`;
- `agvtool` writes **nothing** into `project.pbxproj` — the key stays absent and `what-version` still
  returns rc=6 afterwards. It only rewrites `CFBundleVersion` in the two **tracked** `Info.plist`
  files, replacing `$(CURRENT_PROJECT_VERSION)` with a literal;
- so the shipped build number travels as a plist literal, and `CURRENT_PROJECT_VERSION = 1` in
  `Base.xcconfig` never participates in a release build at all.

What remains is latent rather than broken:

- `xcrun agvtool what-version` is unusable for a developer;
- every release run dirties two tracked files, and committing one by accident freezes the build
  number and kills the xcconfig line for good;
- fastlane survives only because `build_number:` is passed explicitly —
  `raise "Apple Generic Versioning is not enabled." if agv_disabled && params[:build_number].nil?`.

A race was suspected between one run's upload and the next run's `latest_testflight_build_number`
query. It **did not reproduce**: run #2 queried 33 s after run #1's upload and already saw the new
build — do not reopen this without a reproduction.

**Decided: leave it alone.** Rewriting it to `build_app(xcargs: "CURRENT_PROJECT_VERSION=#{n}")`
would stop the plist mutation, but that mutation costs nothing where it happens — CI workspaces are
disposable — and `increment_build_number` is the action a reader recognises, while an `xcargs`
override is a mechanism they have to work out. Changing a mechanism that has shipped correct build
numbers on every run, to buy tidiness, is the same mistake as the icon-picker entry above.

Note `skip_info_plist: true` is not a middle road: it drops agvtool's `-all` flag, so the write lands
only in `project.pbxproj`, where the key does not exist, and `Info.plist` keeps `$(...)` and resolves
to `1`. The plist rewrite is the mechanism, not a side effect.

What is worth keeping in view: the lane survives on the explicit `build_number:` argument, and the
day someone drops it the failure surfaces only when a tag is pushed. A comment above the call says
so.

### ~~CI builds Debug only, and asserts nothing about the bundle~~ — DONE

`build_only` was replaced by `verify_release`: a **Release** build without signing, followed by
`Scripts/verify_release_bundle.sh` over the produced `.app`. Twelve assertions, every one of them
standing for a regression that actually happened or a failure that reaches App Store Connect rather
than CI:

- `Base.lproj/Intents.intentdefinition` present, so the Shortcuts action cannot vanish again;
- `PlugIns/Intent.appex` present;
- `{en,ru}.lproj/{Localizable,Intents,InfoPlist}.strings` present, and the Russian `Localizable`
  non-empty — a String Catalog that fails to export leaves a well-formed but empty file;
- `CFBundleVersion` and `CFBundleShortVersionString` expanded rather than left as `$(...)`;
- app and extension agreeing on `CFBundleVersion`, which `agvtool` writes into the two plists
  independently and App Store Connect rejects at upload.

The script reports every failure in one run and was checked against a deliberately broken bundle
copy, so it is known to fail rather than merely to pass. Dropping the Debug build costs nothing:
there is not a single `#if DEBUG` in the sources.

Alongside it:

- the scheme check for both shared schemes moved into the same lane;
- `swiftlint --strict` — free, the repository reports zero warnings;
- `-com.apple.CoreData.ConcurrencyDebug 1` on the test scheme, which found two violations in the test
  fixture the moment it was switched on and, verified against the reintroduced original bug, traps
  deterministically at the offending `fetch` where the same defect previously crashed one run in
  three somewhere unrelated;
- `fastlane ios test` fails when fewer than `MINIMUM_TEST_COUNT` tests ran;
- the release lane refuses a tag that disagrees with `MARKETING_VERSION`;
- the Crashlytics phase honours `SKIP_CRASHLYTICS_UPLOAD=1` so the verification build does not push
  dSYMs for a binary that never ships.

### ~~Crashlytics uploads only the app's dSYM~~ — DONE

Firebase's `run` wrapper passes `--build-phase`, which makes `upload-symbols` look at
`$DWARF_DSYM_FILE_NAME` and nothing else — so `Intent.appex.dSYM` and the framework dSYMs were never
uploaded, and a crash in the Siri extension or in `CoreDataService.init()` arrived as hex addresses.
The phase now calls `upload-symbols` directly and hands it `$DWARF_DSYM_FOLDER_PATH`, which the tool
walks recursively; that folder holds all nine dSYMs the build produces.

Two more things changed with it:

- **The upload runs in the foreground.** `run` backgrounds it and redirects output to `/dev/null`, so
  a failed upload looked exactly like a successful one until a crash came back unreadable. It now
  fails the build instead. The trade is real — a network blip during a release turns the run red —
  but a silently unsymbolicated release build is worse.
- **Debug builds skip it.** Guarded on `DEBUG_INFORMATION_FORMAT`, which is `dwarf` in Debug and
  `dwarf-with-dsym` in Release. Verified by building Debug with uploading enabled: it printed
  "produces no dSYM, nothing to upload" and never reached the uploader.

Not verified end to end: that all nine dSYMs actually land in Crashlytics. Uploading symbols for a
throwaway build to prove it was not worth it — `upload-symbols --validate` accepts the directory, and
the first real release run will print the result now that the upload is in the foreground.

### ~~Dead build settings and unused entitlements~~ — DONE

All five removed, each confirmed inert first rather than taken on the audit's word:

- `SWIFT_UPCOMING_FEATURE_ISOLATED_DEFAULT_VALUES` never reached `swiftc`. The build passes seven
  upcoming features — `ExistentialAny`, `ImmutableWeakCaptures`, `InferIsolatedConformances`,
  `InternalImportsByDefault`, `MemberImportVisibility`, `NonescapableTypes`,
  `NonisolatedNonsendingByDefault` — and `IsolatedDefaultValues` is not among them. Xcode does not
  recognise the setting, and SE-0411 is unconditional under Swift 6 anyway.
- `ENABLE_BITCODE` — bitcode left Xcode in 14; the variable is only exported into the build
  environment.
- `aps-environment` in both entitlements files, and `UIBackgroundModes: remote-notification`. There is
  no push code at all: no `registerForRemoteNotifications`, no `UNUserNotificationCenter`, no
  `deviceToken`, and Firebase is wired for `FirebaseCore` + `FirebaseCrashlytics` only. The value was
  wrong on top of being unused — `development` would have shipped in Release builds.
- `UIRequiredDeviceCapabilities: armv7`, on a binary `lipo` reports as `arm64` alone, for a minimum of
  iOS 17 — no armv7 device has run anything past iOS 10. Removing the hand-written key lets Xcode
  inject its own, and the built bundle now declares `arm64`.

**Regenerating provisioning profiles was not needed**, contrary to the first guess: a profile may
carry more capabilities than the app requests, only the reverse fails. Proved by building signed for
a device against the existing profiles — `codesign` succeeded and the signed binary carries only
app-groups, Siri and multicast.

## Tests

`SharedCodeTests` now exists — a unit-test target over `SharedCode/` with no host app, so it needs no
signing, no entitlements and no simulator launch. 14 tests across three suites, run by
`fastlane ios test` before every CI build, with `-com.apple.CoreData.ConcurrencyDebug 1` on the scheme
and a minimum-count guard so a run that silently executes nothing cannot pass as green.

The list below was ordered by which shipped bug each test would retroactively have caught. Two are
done:

1. ~~Core Data migration from a v1 store fixture~~ — DONE, and it is what proved the migration fix.
2. `AddHostForm` fills every field from an existing host (`a70f5b0`, the Swift 6 `didSet` regression
   the compiler stayed silent about; and `73c485a`, destination/port overwritten with `nil`).
3. `HostListCollectionManager` keeps its snapshot and the collection view in step (`f802788`).
4. `MoveHostWorker` reindexes `order` contiguously.
5. `HostCRUDWorker.create` prepends and shifts every existing `order`.
6. ~~`MagicPacketBuilder` rejects malformed MAC addresses~~ — DONE.

Items 2 through 5 all live in the app target, which has no test target at all — that is the next step
here, and a larger one than adding a file.

~~`HostListInteractor.swift:25` holds `WakeOnLanService` as a concrete type~~ — DONE. It takes
`WakeOnLanServiceProtocol` now, the way `WOLIntentHandler` already did, so the wake-failure path can
be driven by a fake. No test came with the change: items 2 through 5 above all need an app-target
test target that does not exist yet, and this only removes the obstacle rather than clearing the way.
No service is held by concrete type anywhere in the app or the extension now.

## Release

`MARKETING_VERSION` is already 1.7.0 while the newest tag is 1.6.1, and the `Next Version` section of
`CHANGELOG.md` is empty after 97 commits **(verified)**. Deliberately deferred — 1.7.0 is not being cut
yet. When it is, the three lines users will actually care about are: no longer waking or deleting the
wrong machine after reordering the list (`f802788`), the Wake action returning to the Shortcuts app
(`25cd7bf`), and the app finally saying so when a packet could not be sent (`98a7bbf`).

The release lane now refuses a tag that disagrees with `MARKETING_VERSION`, so the mismatch has to be
resolved before 1.7.0 can be tagged.

## Product ideas

Recorded, not scheduled:

- **App Intents.** The app still uses a SiriKit custom intent (iOS 12 era) with its own extension
  target. Apple's current framework is App Intents: no extension, phrases registered at install.
  Vladislav asked to be walked through the difference before any decision. Whether it would fix the
  Russian action name not appearing in the Shortcuts app is unproven.
- **Host status.** The app never tells the user whether the machine actually woke. A reachability
  probe is the most valuable feature idea, but it needs a model v5 — do not add one until the
  migration chain above is fixed and covered by a test.
- **An explanation screen** for why a machine did not wake (WOL disabled in BIOS, "Wake for network
  access" on a Mac, wrong subnet, Wi-Fi versus Ethernet). Most "it doesn't work" reports for
  Wake-on-LAN apps are protocol misunderstandings.
- **UI tests** and a **gradual migration to SwiftUI**, screen by screen.
- Now unblocked by the iOS 17 deployment target: **Control Center controls** and **interactive
  widgets** (both iOS 17/18 era), and the App Intents migration above.
- Check in App Store Connect whether the donation products are non-consumable. If they are, a user
  cannot donate twice, and the missing "Restore Purchases" is an App Review 3.1.1 problem.

## Deliberately not doing

iPad and Apple Silicon support, XCUITest on the self-hosted runner,
snapshot tests, generated mocks, and stripping the vestigial `public` from module types (124
declarations, no effect — clean up in passing when a file is touched anyway).

`UIDesignRequiresCompatibility = true` was added in `314b733` to build under Xcode 26. Apple describes
it as temporary and it stops working in the next major iOS release; the whole `SoftUI` design system
rests on it. Weeks of work, and not something to discover a week before a deadline.
