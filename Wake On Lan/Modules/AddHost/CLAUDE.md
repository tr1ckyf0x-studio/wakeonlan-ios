# AddHost module

Two submodules:

- **AddHostForm** — the "Add host" screen (also used for editing), pushed on the navigation stack.
- **ChooseIcon** — the device-icon picker, presented as a custom bottom sheet from AddHostForm.

## Files

### `AddHostForm/`

| File | Role |
|------|------|
| `AddHostContract.swift` | The four VIPER protocols, all `@MainActor` |
| `AddHostFactory.swift` | Composition root. `Context = Host?` |
| `AddHostPresenter.swift` | Owns the `AddHostForm` model and the table manager; implements `AddHostViewOutput`, `AddHostInteractorOutput`, `AddHostTableManagerDelegate`, `ChooseIconModuleOutput` |
| `AddHostInteractor.swift` | Turns the form into `HostFormValues` and creates/updates `Host` on a child context via `HostCRUDWorker` |
| `AddHostRoutes.swift` | `openChooseIcon(with:)`, `backOrDismiss(animated:)` |
| `AddHostViewController.swift` | Installs `AddHostView`, wires the table to `presenter.tableManager` |
| `AddHostView.swift` | Grouped table view, save/back bar buttons, keyboard inset handling |
| `AddHostTableManager.swift` | `UITableViewDataSource`/`Delegate` over `form.sections`; appends the italic " - Optional" suffix to non-mandatory headers |
| `AddHostTableManagerDelegate.swift` | Single callback: `tableManagerDidTapDeviceIconCell` |
| `TextInputCell.swift` | Text field cell: live validation and formatting, expanding error row, next-responder handling, `maxLength`, number-pad toolbar |

### `AddHostForm/Models/` — the form engine

| File | Role |
|------|------|
| `AddHostForm.swift` | The form model: `iconModel`, `sections`, `host`, the four scalar outputs, `isValid` |
| `FormSection.swift` | `enum FormSection` with one case; nested `Kind`, `Header`, `Footer` |
| `FormItem.swift` | `enum FormItem { case text(TextFormItem), case icon(IconModel) }` |
| `TextFormItem.swift` | Per-field state: value, placeholder, defaultValue, validator, formatter, maxLength, failureReason, indexPath, `onValueChanged` |
| `FormConfigurable.swift` | `configure(with formItem: FormItem)` — only `TextInputCell` conforms |
| `Validator.swift` / `TextValidator.swift` | Regex validation |
| `Formatter.swift` / `TextFormatter.swift` | Mask-based formatting (shadows `Foundation.Formatter` inside the app module) |
| `AddHostValidationStrategy.swift` | Regexes for title / MAC / port |
| `AddHostFormatterStrategy.swift` | Mask for MAC (`XX:XX:XX:XX:XX:XX`, separator `:`) |
| `RegExPatternRepresentable.swift`, `FormatPatternRepresentable.swift` | Strategy protocols |

### `AddHostForm/DeviceIconCell/`

`DeviceIconCell.swift` (cell + "Tap to change icon" label, `didTapChangeIconBlock`) and
`DeviceIconView.swift` (the tappable symbol image view).

### `ChooseIcon/`

| File | Role |
|------|------|
| `ChooseIconConfigurator.swift` | `ChooseIconFactory`. `Context = ChooseIconModuleOutput` — the context *is* the delegate |
| `ChooseIconContract.swift` | View input/output plus the public `ChooseIconModuleOutput` |
| `ChooseIconPresenter.swift` | Builds the single section from `HostIcon.allCases`; no interactor |
| `ChooseIconRoutes.swift` | `backOrDismiss(animated:)` |
| `ChooseIconViewController.swift` | Sheet content + Cancel button; drives layout invalidation from `viewDidLayoutSubviews` |
| `ChooseIconView.swift`, `ChooseIconCell.swift`, `ChooseIconCollectionLayout.swift`, `ChooseIconTableManager.swift`, `ChooseIconSection.swift` | Grid rendering (4 columns of squares) |

## Wiring

**AddHostForm.** `AddHostFactory.build(with context: Host?)` funnels the context straight into
`AddHostForm(host:)` — the presenter never stores it separately. Then the usual cross-linking:
`presenter.router`, `presenter.interactor` (strong) / `interactor.presenter` (weak),
`viewController.presenter` (strong) / `presenter.view` (weak). Services: `CoreDataService.shared`
plus a `HostCRUDWorker` over the same instance.

**ChooseIcon.** `ChooseIconFactory.build(with context: ChooseIconModuleOutput)` assigns
`presenter.moduleDelegate = context` (weak). The route in `Routes+AddHost.swift` presents it modally
with `SelfSizingBottomSheetModalTransitionDelegate` from `WOLUIComponents`. The `ClassFinder` in that
step means an already-presented picker is reused rather than presented twice.

Icon tap chain:
`DeviceIconView → DeviceIconViewDelegate → DeviceIconCell.didTapChangeIconBlock → AddHostTableManager → AddHostPresenter → router.openChooseIcon(with: self)`.

## The form engine

`AddHostForm.sections` is built once in `makeSections()` and is `private(set)`. `FormItem` forwards
`isValid` to the wrapped `TextFormItem` and returns `true` for `.icon`, so the icon row never blocks
saving. `TextFormItem` is a **class** — reference semantics are load-bearing, since the form keeps
references to the same items the cells mutate.

### Validation

`TextValidator.validate` is `value.range(of: pattern, options: .regularExpression) != nil`, i.e. a
**substring** match — patterns that must anchor use `^…$`.

| Field | Mandatory | Validator | defaultValue | Effective behavior |
|-------|-----------|-----------|--------------|--------------------|
| title | yes | non-whitespace required | — | empty blocks save |
| macAddress | yes | `^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$` | — | blocks save until the regex matches |
| destination | no | **none** | `255.255.255.255` | always valid, any text passes |
| port | no | 0…65535 | `9` | empty passes (validates the default); out-of-range blocks save |

`AddHostForm.isValid` is `sections.lazy.flatMap(\.items).allSatisfy(\.isValid)`.
`viewDidPressSaveButton` **silently returns** when invalid — there is an explicit
`// TODO: Обработка ошибок формы`; the only feedback is the per-cell error row that live validation
already produced.

### Live formatting (MAC address)

`TextInputCell.textFieldValueChanged` runs on `.editingChanged` and writes the formatted value back
into the item as well as into the field:

```swift
item.value = textValue
if item.needsUppercased, let formatted = item.formatted?.uppercased() {
    item.value = formatted
    textField.text = formatted
}
isExpanded = !(item.isValid || textValue.isEmpty)
```

The second assignment is not redundant. Setting `textField.text` programmatically does **not** re-fire
`.editingChanged`, so without it the item keeps the raw text while the field shows the formatted one —
a pasted MAC address renders correctly, never validates, and saving silently does nothing.

`String.formatted(by:_:)` strips **every** non-alphanumeric character before applying the mask, not
just the mask's own separator, so `AA-BB-CC-DD-EE-FF` and `AA.BB.CC.DD.EE.FF` are re-formatted rather
than interleaved with the pasted separator.

What reaches Core Data is not stored verbatim either: `CoreDataHostFormatter.compress` splits on `:`
and parses each component with `UInt8(_, radix: 16)`, so the MAC is persisted as six raw bytes and
`Host.macAddress` renders it back with `%02X`. Note that `compress` uses `compactMap`, so any
component that fails to parse is **silently dropped** and the stored MAC comes out shorter than six
bytes.

Length is capped separately in `textField(_:shouldChangeCharactersIn:replacementString:)` against
`maxLength` (17 for the formatted MAC, 5 for port, `nil` elsewhere).

## Create vs. edit

One code path; the mode is the optional `Host` context.

`AddHostForm.init(host:)` stores the host, calls `makeSections()`, then calls `applyValues(from:)`
explicitly. That last call used to be `defer { self.host = host }` with the hydration living in a
`didSet` — a trick that relied on a property observer firing for an assignment made inside an
initializer. It worked in Swift 5 and **silently stopped working in Swift 6**, leaving every edit form
blank. Do not reintroduce it.

`applyValues(from:)` resolves the icon through `HostIcon(systemName:)` and falls back to the default
when that returns `nil`, then assigns each `TextFormItem.value`, which fires `onValueChanged` and
fills the form's scalar outputs. The fallback matters: hosts created before the move to SF Symbols
still store legacy asset names (`desktop`, `other`, `router`) that no Core Data mapping rewrites.
Bailing out on an unknown icon opened such a host as a completely empty form, and saving it then
overwrote the stored destination and port with `nil`.

`viewDidPressSaveButton` branches on `addHostForm.host == nil` → `saveForm` else `updateForm`, guarded
by an `isSaving` flag: the save control stays enabled and nothing visible happens while the write is
in flight, so a second tap used to re-enter the create branch with a fresh child context, inserting
the host twice and colliding the `order` of every existing host.

`HostCRUDWorker.create` bumps `order += 1` on all existing hosts so a new host lands on top. Both
success callbacks do the same thing: navigate back. **Core Data failures are ignored** — the
completion result is discarded and the screen dismisses anyway.

The navigation title is always `.addHostScreenTitle` ("Add host"), even when editing.

## Icon round-trip

`ChooseIconPresenter` calls `moduleDelegate?.chooseIconModuleDidSelectIcon(icon)` **then** dismisses.
`AddHostPresenter` stores the new `iconModel`, finds the section whose `kind == .deviceIcon`, and
asks the view to reload its rows. On re-dequeue the table manager renders the **live**
`form.iconModel`, not the value captured inside `FormItem.icon(…)`.

Cancel and tap-outside both call plain `dismiss(animated:)`, bypassing the router.

## Concurrency

The contracts, the presenter, the interactor, the factory, the table managers and
`AddHostTableManagerDelegate` all carry `@MainActor`; so does `AddHostForm`, because the cells mutate
its items from the main thread. `ChooseIconModuleOutput` is `@MainActor` too — it is the seam back
into AddHostForm.

The `Host` managed object never leaves the main queue: the interactor converts the form into a
`Sendable` `HostFormValues` and passes `host.objectID` for updates, because `HostCRUDWorker` does its
work inside `context.perform` on a private-queue child context.

## Gotchas

- **`FormSection.Kind.rawValue` must equal the section's index in `sections`.**
  `AddHostViewController.reloadTable(with:)` uses `kind?.rawValue` as the table section index, so
  reordering `makeSections()` without renumbering `Kind` silently reloads the wrong rows.
- **`iconSectionItems` captures a stale `IconModel`.** It is a `lazy` property evaluated during
  `makeSections()`, before `applyValues(from:)` runs, so the value inside `FormItem.icon(…)` is always
  the default `HostIcon.desktopcomputer`. Nothing breaks only because every render path reads
  `form.iconModel` instead.
- **`destination` and `port` persist as `nil` when untouched** — their `defaultValue`s exist for
  validation only and are never written to Core Data.
- **`updateForm` fails silently** if `form.host` is nil: it logs `DDLogWarn` and returns without any
  callback, leaving the screen open with no feedback and `isSaving` stuck at `true`.
- **Both table managers trap on an unexpected cell type.** `AddHostTableManager` and
  `ChooseIconTableManager` each end `cellForRowAt` with `fatalError`. Everything else in the module
  uses optionals, so other failures are silent no-ops instead.
- **`TextInputCell.prepareForReuse` is load-bearing.** `isExpanded` drives the cell height and the
  failure label survives recycling, so it resets the item, the expansion, the label, the text and the
  `inputAccessoryView`. `configure(with:)` also configures the failure view unconditionally —
  returning early for items without a `failureReason` (Name, Host) left a recycled cell showing the
  previous field's error text.
- **`ChooseIconViewController` creates its height constraint once**, on the first non-zero
  measurement, and only updates it afterwards. Creating it on every layout pass stacked active height
  constraints on a live view; creating it up front with a height of zero contradicted the collection
  view pinned inside with 8pt insets and produced "Unable to simultaneously satisfy constraints".
- **The next-responder chain uses tags equal to section indices** and looks the field up via
  `superview?.viewWithTag(tag + 1)`, where `superview` is the table view. Off-screen fields are not
  found and the keyboard simply resigns.
- `AddHostView` registers keyboard observers in `init` and never removes them.
- `ChooseIconSectionItem` in `ChooseIconSection.swift` is dead code — `ChooseIconSection.Item` is
  `FormItem`, reused from AddHostForm.
