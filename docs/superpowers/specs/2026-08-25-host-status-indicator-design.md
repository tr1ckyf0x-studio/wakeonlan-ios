# Host status indicator (component 4b) — design

Date: 2026-08-25
Source: Claude Design project `c668bd3e-c8f8-4c1b-b73c-4cc78c8c4ea9`
— `Awake Design System.dc.html` section 04 (host status), `Awake Green Combo.dc.html` cards 4a and 4b.
The design document is written in Russian; it is referenced here by section and card number, which is
what those numbers are for.

Revised 2026-08-25 against the second version of the design, which added the `status-on` /
`status-quiet` tokens and removed the 60 % dimming after the light theme measured below the 3 : 1
contrast floor. The state set, the pulse and the ring weights are unchanged.

First piece of the SwiftUI v2 rewrite. It lands the design system's colour palette as asset
catalogue entries and the six-state host indicator as a SwiftUI view.

## Scope

In scope:

- `Colors.xcassets/DesignSystem/` — every colour token of design-system section 01.
- `HostStatus` — the six-case state type documented by card 4b.
- `HostStatusIndicator` — the dot, plus a preview catalogue of all six states in both themes.

Out of scope, deliberately:

- The status **text line** — the state in words, the countdown, the failure message. Design-system rule 4
  requires the dot's colour to be repeated in words, so the rule stays unmet until the host row
  (card 4a) is built. Localised status names arrive with it.
- The state machine behind the states — ping every 3 s, up to 20 attempts, the one-minute wake
  window, early exit on reply. Card 4b documents it, but nothing in the app performs it yet.
- Shadow geometry. Only the colour halves of `shadow-accent` / `shadow-sheet` become assets.

## Colours

New folder `Wake On Lan/Resources/Assets/Colors.xcassets/DesignSystem/`, marked
`"provides-namespace": true`. The namespace keeps the new palette apart from the legacy neumorphic
one (`Primary`, `Secondary`, `SecondaryVariant`, `Shadow/*`): `Warning` can exist in both without a
symbol clash, and deleting the legacy set at the end of v2 is a folder delete.

Values are written as hex components (`"red": "0xAD"`), not the decimal fractions the legacy
colorsets use. A transcription error in `0xAD` is visible against the design document; one in
`0.678` is not.

Dark value first, light second; a single value means the token is identical in both themes.

| Colorset | Dark | Light | Use |
|---|---|---|---|
| `Accent` | `#ADE04C` | `#ADE04C` | button fills |
| `AccentText` | `#ADE04C` | `#5E7A29` | text and icons in accent |
| `OnAccent` | `#1D2A08` | `#1D2A08` | text over green |
| `Warning` | `#D84547` | `#D84547` | errors only |
| `StatusOn` | `#ADE04C` | `#5E7A29` | the online and waking dots |
| `StatusQuiet` | `#6E7075` | `#7C7E83` | the offline, probing and unknown dots |
| `StatusGlow` | `#ADE04C` | `#ADE04C` at alpha 0 | the online dot's halo, off on light |
| `WarningText` | `#FF8A8B` | `#C2373A` | error text |
| `TextPrimary` | `#F3F3F5` | `#17181B` | names, titles |
| `TextSecondary` | `#A8AAAF` | `#636469` | explanations, secondary actions |
| `TextTertiary` | `#6E7075` | `#93959A` | MAC, captions, log |
| `Background` | `#0B0C0D` | `#F4F4F5` | screen background |
| `Surface` | `#17181B` | `#FFFFFF` | cards, groups, sheets |
| `Chip` | white 9 % | black 5.5 % | icon tiles, segments |
| `Keyboard` | `#2A2B2F` | `#D2D4D9` | keyboard bar |
| `KeyboardKey` | `#4B4C50` | `#FCFCFD` | keyboard keys |
| `Stroke` | white 11 % | black 10 % | outer strokes |
| `Hairline` | white 8 % | black 6 % | separators inside groups |
| `ShadowAccent` | `#ADE04C` 75 % | `#ADE04C` 75 % | colour half of `0 12px 30px -12px` |
| `ShadowSheet` | black 72 % | `#16181E` 30 % | colour half of `0 34px 74px -26px` |

The design system spells the light half of `shadow-sheet` as «ink 30 %» without defining «ink».
`#16181E` is taken from the only place the document uses that colour, `rgba(22, 24, 30, .4)` in a
smaller sheet shadow; the 30 % comes from the token table. Confirm before the first sheet ships.

`Warning` duplicates the existing root `Warning.colorset` byte for byte — the design system names
that asset as its own source. The duplicate is intentional: the design-system folder has to be
complete on its own, and the namespace makes the duplication free.

The exact spelling of the generated symbol for a namespaced group is verified by building and
reading `GeneratedAssetSymbols.swift`, not assumed.

## `HostStatus`

```swift
enum HostStatus: Hashable, CaseIterable, Sendable {
    case online, offline, probing, waking, unreachable, unknown
}
```

Flat, with no associated values. Card 4b documents meaning and appearance; the response time
("1 ms"), the countdown ("47 s left") and the attempt counter ("poll 5/20") are row data, not
indicator input — the dot never draws them. Attaching them here would freeze a timing model before
the state machine exists, and would break equality by meaning: `.waking(47) != .waking(46)`
although both are the same state. They belong to the host row's view model.

Mapping to card 4b:

Card 4b lists the six in this order, so its rows line up with the table top to bottom.

| Case | Row on card 4b | Meaning |
|---|---|---|
| `online` | 1st | ping returned |
| `offline` | 2nd | ping did not return, network is fine |
| `probing` | 3rd | first poll, lives 1–2 s |
| `waking` | 4th | packet sent, the one-minute wait is running |
| `unreachable` | 5th | the minute elapsed with no answer |
| `unknown` | 6th | no IP address, or Wi-Fi is off |

## `HostStatusIndicator`

The six states resolve to four independent axes, so the view holds one `switch` producing a value
and one rendering path rather than six drawing branches:

```swift
private struct Appearance {
    var fill: Color = .clear    // filled disc
    var stroke: Color = .clear  // ring
    var lineWidth: CGFloat = 0  // 2 while polling, 1 for the unknown state
    var isGlowing = false       // the online state only
    var isPulsing = false
}
```

The colours are `.clear` rather than optional, and the body has no `if` in it:

```swift
Circle()
    .strokeBorder(appearance.stroke, lineWidth: appearance.lineWidth)
    .background(appearance.fill, in: .circle)
```

An absent fill or ring is a colour the state does not paint, not a view it does not have. Branching
on optionals would put an `if` inside the `@ViewBuilder`, and an `if` there produces
`_ConditionalContent`: when the branch flips, SwiftUI treats it as a *different* view, tears the old
one down and builds a new one. For this component that is not academic — `probing → online` flips
from ring to fill, which would drop the pulse mid-animation and reset the `@State` driving it.

A conditional-modifier helper (`extension View { func \`if\`(_:transform:) }`) does not avoid this;
it is the same `_ConditionalContent` behind a nicer call site. It also cannot express this shape,
because `fill` and `strokeBorder` are two different shapes rather than one shape with an optional
modifier — after `.fill` the type is no longer a `Circle` and `.strokeBorder` is gone.

This is the `private let appearance = Appearance()` idiom already used in twelve view files, made
a function of the status.

| Case | Appearance |
|---|---|
| `online` | fill `StatusOn`, glow |
| `offline` | fill `StatusQuiet` |
| `probing` | stroke `StatusQuiet` 2 pt, pulsing |
| `waking` | stroke `StatusOn` 2 pt, pulsing |
| `unreachable` | fill `Warning`, no glow |
| `unknown` | stroke `StatusQuiet` 1 pt, static |

There is no opacity axis. The design's first version dimmed `offline` and `unknown` to 60 %, which
measured 1.84 : 1 against white and 2.16 : 1 against the dark surface — under the 3 : 1 floor in
**both** themes. The revision dropped the multiplier and gave the dot its own tokens instead;
shape now carries the distinction, a filled disc against a 1 pt ring.

### Size

The caller sizes the view with `.frame`; there is no size parameter and no internal frame.

```swift
HostStatusIndicator(status: host.status)
    .frame(width: 9, height: 9)
```

Nine is the design system's diameter for every list row. Card 4b draws 11 because it is a showcase.

The two arrangements are mutually exclusive, and which one is in force was settled by rendering both
rather than by reasoning:

- **With an internal `.frame`**, the view has an intrinsic size and an outer `.frame(width: 40,
  height: 40)` does nothing to the dot — it draws a 40 × 40 box with a 9 pt dot centred in it. The
  only working knob is then a parameter.
- **Without one**, an outer `.frame` sizes the dot as expected, and a caller who omits it gets a
  circle as tall as the row, because `Circle` accepts whatever size it is offered.

The second is what the component does. The cost is that `.frame` is mandatory at every call site and
that the canonical 9 is repeated there; the benefit is ordinary SwiftUI composition and one input to
the view — `status`.

Ring widths (2 and 1) and the glow radius stay absolute and do not scale with the frame. That
follows the design rather than being an oversight: card 4b's 11 pt dot keeps the same 2 pt ring. So
sizes far from 9 look off-proportion until the design supplies numbers for them, and the doc comment
on the type says so.

### Pulse

CSS `awPing` runs `0 % → 50 % → 100 %` over 1.1 s: scale 1 → 0.82, opacity 1 → 0.55, ease-in-out.
A CSS duration covers the whole there-and-back cycle, while a SwiftUI duration covers **one leg of
it**, so the SwiftUI value is `0.55`, not `1.1`. Getting this backwards is a silent 2× error — the
dot still pulses, just at half speed.

The loop is a `PhaseAnimator` over `[false, true]`, and a state that does not pulse is given
`[false]` — a single phase has nothing to move between, so it stands still. Expressing "no pulse" as
one phase rather than as a disabled animation is what keeps the view free of `@State`: it is a pure
function of `status`, with no `onAppear`/`onChange` pair that has to mirror itself.

The alternative, `@State` toggled in `onAppear`/`onChange` and animated with
`.repeatForever(autoreverses: true)`, was built and measured too. Both render an identical
amplitude; the periods came out at 1.133 s for the state version and 1.192 s against a specified
1.1 s. `PhaseAnimator` is consistently the slower of the two — it starts each phase after the
previous one finishes, which costs a frame or so per transition, twice a cycle. Sixty milliseconds
on a background pulse buys removing mutable state from the view, which is the trade taken here.

Both numbers come from screen recordings of the component on a simulator, measured frame by frame —
a static preview snapshot cannot tell a running animation from one frozen at a phase, because
`RenderPreview` is deterministic and returns the same PNG every time.

The glow `box-shadow: 0 0 10px` becomes `.shadow(radius: 5)`: a CSS blur radius is 2σ, a SwiftUI
shadow radius is σ.

The design turns the glow off on the light theme (`--stGlow: none`). Rather than branch on
`colorScheme` in the view, that lives in the `StatusGlow` colorset as the accent at alpha 1 for dark
and alpha 0 for light. The radius is then constant, the shadow simply paints nothing on light, and
the component keeps its rule of holding no theme knowledge — every per-theme value stays in the
asset catalogue, which is what the design system asks for.

### Reduce Motion

Not handled. The pulse runs regardless of `accessibilityReduceMotion`, because the design defines
exactly one appearance per state and the indicator follows it. Recorded so the omission reads as a
decision rather than an oversight.

### VoiceOver

The dot is `.accessibilityHidden(true)`. Design-system rule 4 makes it decorative: the words in the
row carry the state. Standalone it is therefore silent to VoiceOver, which is correct for a
decorative indicator and is closed out when the host row lands.

## Files

```
Wake On Lan/SwiftUI/
├── DesignSystem/
│   └── HostStatus.swift
└── Components/
    └── HostStatusIndicator.swift
```

No Swift facade over the colours — components reference the asset symbols directly.

`project.yml` globs the whole `Wake On Lan` directory, but the `.xcodeproj` is generated, so new
files require `mint run xcodegen` before they reach a target.

## Verification

- The project builds for the simulator with `SWIFT_TREAT_WARNINGS_AS_ERRORS = YES` and SwiftLint
  `--strict`.
- `GeneratedAssetSymbols.swift` contains the namespaced colour symbols, read from the build's
  `DerivedSources` rather than assumed.
- The `#Preview` catalogue renders all six states in dark and light through Xcode's preview.

No unit tests: the deliverable is a colour palette and a view with no logic beyond a `switch`.
