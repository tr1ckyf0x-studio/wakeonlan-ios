# Host Status Indicator Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Land the v2 design-system colour palette as a namespaced asset group and build the six-state host status dot (card 4b) as the first SwiftUI component.

**Architecture:** Colours live only in `Colors.xcassets/DesignSystem/`, a namespaced group, so the new palette and the legacy neumorphic one cannot collide and the legacy set can later be deleted as a folder. `HostStatus` is a flat six-case enum carrying meaning alone. `HostStatusIndicator` maps that enum to one `Appearance` value describing four independent axes — fill, ring, glow, pulse — and renders through a single path.

**Tech Stack:** SwiftUI (iOS 17 deployment target), Swift 6 language mode with warnings-as-errors, XcodeGen 2.46.0, SwiftLint 0.65.0 `--strict` as a pre-build phase, Xcode asset symbol generation.

**Spec:** `docs/superpowers/specs/2026-08-25-host-status-indicator-design.md`

**Deviation from the spec:** the spec placed `HostStatus.swift` under `SwiftUI/DesignSystem/`. That folder would then hold exactly one file that is not a design-system artefact — the colours live in the asset catalogue, not in Swift. Both files go to `SwiftUI/Components/HostStatusIndicator/` instead.

**No unit tests.** The deliverable is an asset catalogue and a view whose only logic is a `switch`. Verification is a clean build under warnings-as-errors and `--strict` lint, the generated asset symbols read from `DerivedSources`, and the preview catalogue rendered in both themes.

---

### Task 1: Design-system colour palette

**Files:**
- Create: `Wake On Lan/Resources/Assets/Colors.xcassets/DesignSystem/Contents.json`
- Create: `Wake On Lan/Resources/Assets/Colors.xcassets/DesignSystem/<Name>.colorset/Contents.json` × 17

- [x] **Step 1: Generate the group and all 17 colorsets**

Run this from the repository root. Dark value first in the spec table, but the asset catalogue lists the light (`any`) appearance first, which is why the table below is `name|lightHex|lightAlpha|darkHex|darkAlpha`.

```bash
bash -euo pipefail -c '
ROOT="Wake On Lan/Resources/Assets/Colors.xcassets/DesignSystem"
mkdir -p "$ROOT"
cat > "$ROOT/Contents.json" <<JSON
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  },
  "properties" : {
    "provides-namespace" : true
  }
}
JSON
while IFS="|" read -r name lhex lalpha dhex dalpha; do
  [ -z "$name" ] && continue
  dir="$ROOT/$name.colorset"
  mkdir -p "$dir"
  cat > "$dir/Contents.json" <<JSON
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "$lalpha",
          "blue" : "0x${lhex:4:2}",
          "green" : "0x${lhex:2:2}",
          "red" : "0x${lhex:0:2}"
        }
      },
      "idiom" : "universal"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "$dalpha",
          "blue" : "0x${dhex:4:2}",
          "green" : "0x${dhex:2:2}",
          "red" : "0x${dhex:0:2}"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
JSON
done <<TABLE
Accent|ADE04C|1.000|ADE04C|1.000
AccentText|5E7A29|1.000|ADE04C|1.000
OnAccent|1D2A08|1.000|1D2A08|1.000
Warning|D84547|1.000|D84547|1.000
WarningText|C2373A|1.000|FF8A8B|1.000
TextPrimary|17181B|1.000|F3F3F5|1.000
TextSecondary|636469|1.000|A8AAAF|1.000
TextTertiary|93959A|1.000|6E7075|1.000
Background|F4F4F5|1.000|0B0C0D|1.000
Surface|FFFFFF|1.000|17181B|1.000
Chip|000000|0.055|FFFFFF|0.090
Keyboard|D2D4D9|1.000|2A2B2F|1.000
KeyboardKey|FCFCFD|1.000|4B4C50|1.000
Stroke|000000|0.100|FFFFFF|0.110
Hairline|000000|0.060|FFFFFF|0.080
ShadowAccent|ADE04C|0.750|ADE04C|0.750
ShadowSheet|16181E|0.300|000000|0.720
TABLE
'
```

- [x] **Step 2: Verify the group is complete and well-formed**

```bash
ls "Wake On Lan/Resources/Assets/Colors.xcassets/DesignSystem" | wc -l
find "Wake On Lan/Resources/Assets/Colors.xcassets/DesignSystem" -name Contents.json -exec python3 -c 'import json,sys;json.load(open(sys.argv[1]))' {} \;
```

Expected: `18` (17 colorsets plus the group's own `Contents.json`), and no output from the second command — every file parses as JSON.

- [x] **Step 3: Spot-check one plain colour and one translucent colour**

```bash
cat "Wake On Lan/Resources/Assets/Colors.xcassets/DesignSystem/Accent.colorset/Contents.json"
cat "Wake On Lan/Resources/Assets/Colors.xcassets/DesignSystem/Stroke.colorset/Contents.json"
```

Expected: `Accent` is `0xAD`/`0xE0`/`0x4C` at alpha `1.000` in both appearances. `Stroke` is `0x00`×3 at alpha `0.100` for the light appearance and `0xFF`×3 at alpha `0.110` for the dark one.

- [x] **Step 4: Commit**

```bash
git add "Wake On Lan/Resources/Assets/Colors.xcassets/DesignSystem"
git commit --no-gpg-sign -m "Added the v2 design-system colour palette to the asset catalogue"
```

---

### Task 2: Confirm the generated asset symbols

The exact spelling of the symbol for a namespaced asset group decides how every component from here on refers to colour. It is read from the build, never assumed.

**Files:** none — this task only builds and reads.

- [x] **Step 1: Build the app target**

```bash
xcodebuild -project "Wake On LAN.xcodeproj" -scheme "Wake On LAN" -configuration Debug -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Expected: `** BUILD SUCCEEDED **`. The asset catalogue changed but no Swift file did, so nothing can fail to compile yet.

- [x] **Step 2: Read the generated symbols**

```bash
find ~/Library/Developer/Xcode/DerivedData -name GeneratedAssetSymbols.swift -newermt '-30 minutes' \
  -exec grep -n -A2 -i 'designsystem\|accent\|textTertiary' {} +
```

Expected: a nested namespace type generated from the group, with `accent`, `textTertiary` and `warning` inside it — the anticipated call site is `Color(.DesignSystem.accent)`.

- [x] **Step 3: Record the real spelling**

Confirmed against Xcode 26.6 / iOS 26.5 SDK. The generator emits:

```swift
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    static let darkShadow = DeveloperToolsSupport.ColorResource(name: "DarkShadow", bundle: resourceBundle)

    /// The "DesignSystem" asset catalog resource namespace.
    enum DesignSystem {
        static let accent = DeveloperToolsSupport.ColorResource(name: "DesignSystem/Accent", bundle: resourceBundle)
        static let warning = DeveloperToolsSupport.ColorResource(name: "DesignSystem/Warning", bundle: resourceBundle)
        // …fifteen more
    }
}
```

So the call site is **`Color(.DesignSystem.accent)`**, exactly as Task 4 assumes. The legacy root
`Warning.colorset` still resolves as `.warning` while the namespaced one is `.DesignSystem.warning`
— the two coexist, which is what the namespace was for.

---

### Task 3: `HostStatus`

**Files:**
- Create: `Wake On Lan/SwiftUI/Components/HostStatusIndicator/HostStatus.swift`

- [x] **Step 1: Write the enum**

```swift
//
//  HostStatus.swift
//  Wake on LAN
//

import Foundation

/// The six states a host can be in, as documented by card 4b of the design system.
///
/// The type carries meaning only. Response time, the wake countdown and the attempt counter are
/// row data rather than indicator input — the dot never draws them — so they belong to the host
/// row's view model. Keeping them out also keeps equality meaningful: a `waking` host is the same
/// state whether 47 or 46 seconds remain.
enum HostStatus: Hashable, CaseIterable, Sendable {

    /// Ping returned.
    case online

    /// Ping did not return while the network is reachable — an ordinary sleeping machine.
    case offline

    /// The first poll after the list appeared or after pull-to-refresh. Lives one to two seconds.
    case probing

    /// The magic packet was sent and the one-minute wait is running.
    case waking

    /// The minute elapsed with no answer. Holds until the host is woken again.
    case unreachable

    /// Polling is impossible: the host has no IP address, or Wi-Fi is off.
    case unknown
}
```

- [x] **Step 2: Commit**

```bash
git add "Wake On Lan/SwiftUI/Components/HostStatusIndicator/HostStatus.swift"
git commit --no-gpg-sign -m "Added the host status type behind the v2 status indicator"
```

---

### Task 4: `HostStatusIndicator`

**Files:**
- Create: `Wake On Lan/SwiftUI/Components/HostStatusIndicator/HostStatusIndicator.swift`

Note on the constants, so they are not "corrected" later: the CSS keyframe `awPing` runs `0 % → 50 % → 100 %` over 1.1 s, and a CSS duration covers the whole there-and-back cycle. SwiftUI's `.repeatForever(autoreverses: true)` duration covers one direction, so the value here is `0.55`. The glow `box-shadow: 0 0 10px` becomes `radius: 5` because a CSS blur radius is 2σ while a SwiftUI shadow radius is σ. `strokeBorder` rather than `stroke` reproduces `box-sizing: border-box`: the ring is drawn inside the 9 pt circle, so the outer diameter stays 9.

Reduce Motion is deliberately not handled — the pulse runs regardless, because the design defines exactly one appearance per state.

- [x] **Step 1: Write the view**

Replace `Color(.DesignSystem.accent)` and its siblings with the spelling recorded in Task 2 Step 3 if it differs.

```swift
//
//  HostStatusIndicator.swift
//  Wake on LAN
//

import SwiftUI

/// The host status dot documented by card 4b of the design system.
///
/// The six states resolve to four independent axes — fill, ring, glow and pulse — so the view maps
/// the status to a single `Appearance` value and renders it through one path instead of six
/// drawing branches.
///
/// The dot is decorative. Design-system rule 4 requires the row to repeat the state in words, and
/// VoiceOver reads those words, so the dot itself is hidden from accessibility.
struct HostStatusIndicator: View {

    // MARK: - Properties

    let status: HostStatus

    /// Diameter in points. The design system fixes 9 for every list row; card 4b draws 11 only
    /// because it is a showcase. Ring widths stay absolute and do not scale with this.
    var size: CGFloat = 9

    @State private var isPulseCollapsed = false

    private var appearance: Appearance {
        Appearance(status: status)
    }

    private var pulseAnimation: Animation? {
        guard appearance.isPulsing else { return nil }
        return .easeInOut(duration: Appearance.pulseDuration).repeatForever(autoreverses: true)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            if let fill = appearance.fill {
                Circle()
                    .fill(fill)
            }
            if let stroke = appearance.stroke {
                Circle()
                    .strokeBorder(stroke, lineWidth: appearance.lineWidth)
            }
        }
        .frame(width: size, height: size)
        .opacity(appearance.opacity)
        .shadow(
            color: appearance.isGlowing ? Color(.DesignSystem.accent) : .clear,
            radius: appearance.isGlowing ? Appearance.glowRadius : 0
        )
        .scaleEffect(isPulseCollapsed ? Appearance.pulseScale : 1)
        .opacity(isPulseCollapsed ? Appearance.pulseOpacity : 1)
        .animation(pulseAnimation, value: isPulseCollapsed)
        .onAppear {
            isPulseCollapsed = appearance.isPulsing
        }
        .onChange(of: appearance.isPulsing) { _, isPulsing in
            isPulseCollapsed = isPulsing
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Appearance

extension HostStatusIndicator {

    /// The resolved look of one state. The design system encodes meaning as fill versus ring, ring
    /// weight, glow and motion, and every state is some combination of those four.
    fileprivate struct Appearance {
        var fill: Color?
        var stroke: Color?
        var lineWidth: CGFloat = 0
        var opacity: Double = 1
        var isGlowing = false
        var isPulsing = false
    }
}

extension HostStatusIndicator.Appearance {

    static let pulseDuration: TimeInterval = 0.55
    static let pulseScale: CGFloat = 0.82
    static let pulseOpacity: Double = 0.55
    static let glowRadius: CGFloat = 5

    init(status: HostStatus) {
        switch status {
        case .online:
            self.init(fill: Color(.DesignSystem.accent), isGlowing: true)

        case .offline:
            self.init(fill: Color(.DesignSystem.textTertiary), opacity: 0.6)

        case .probing:
            self.init(stroke: Color(.DesignSystem.textTertiary), lineWidth: 2, isPulsing: true)

        case .waking:
            self.init(stroke: Color(.DesignSystem.accent), lineWidth: 2, isPulsing: true)

        case .unreachable:
            self.init(fill: Color(.DesignSystem.warning))

        case .unknown:
            self.init(stroke: Color(.DesignSystem.textTertiary), lineWidth: 1, opacity: 0.6)
        }
    }
}

// MARK: - Previews

/// Preview-only catalogue of all six states. The labels are the case names rather than
/// string-catalogue keys: the localised status names arrive with the host row, which is what will
/// actually show them to a user.
private struct HostStatusCatalogue: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(HostStatus.allCases, id: \.self) { status in
                HStack(spacing: 14) {
                    HostStatusIndicator(status: status)
                    Text(String(describing: status))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(.DesignSystem.textPrimary))
                }
                .padding(.vertical, 14)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.DesignSystem.surface))
    }
}

#Preview("Dark") {
    HostStatusCatalogue()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    HostStatusCatalogue()
        .preferredColorScheme(.light)
}
```

- [x] **Step 2: Regenerate the Xcode project**

New Swift files reach a target only through XcodeGen — `Wake On LAN.xcodeproj` is generated and must never be hand-edited.

```bash
mint run xcodegen
```

Expected: `Created project at .../Wake On LAN.xcodeproj`.

- [x] **Step 3: Confirm both files joined the app target**

```bash
grep -c 'HostStatusIndicator.swift\|HostStatus.swift' "Wake On LAN.xcodeproj/project.pbxproj"
```

Expected: a non-zero count. Zero means the glob missed them — check the path spelling against `Wake On Lan` (folder is "Lan", target is "LAN").

- [x] **Step 4: Build under warnings-as-errors and strict lint**

```bash
xcodebuild -project "Wake On LAN.xcodeproj" -scheme "Wake On LAN" -configuration Debug -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Expected: `** BUILD SUCCEEDED **`. SwiftLint runs as a pre-build phase with `--strict`, so any violation in the new files fails here rather than warning. `vertical_whitespace_between_cases` is on, which is why the `switch` above has a blank line between every case; `private_swiftui_state` is why `isPulseCollapsed` is `private`; `prefer_asset_symbols` is why colours are `Color(.DesignSystem.…)` and never `Color("Accent")`.

`vertical_whitespace_opening_braces` is also on, and it is the one this file tripped on first pass:
no blank line may follow an opening brace. A `// MARK:` comment goes on the line directly after
`struct HostStatusIndicator: View {`, with nothing between them.

- [x] **Step 5: Commit**

`Wake On LAN.xcodeproj` is in `.gitignore` — it is generated, so it is never committed. Only the
source goes in.

```bash
git add "Wake On Lan/SwiftUI"
git commit --no-gpg-sign -m "Added the host status indicator from card 4b of the design system"
```

---

### Task 5: Visual verification

**Files:** none.

- [x] **Step 1: Render both previews**

Use the Xcode MCP `RenderPreview` tool against `Wake On Lan/SwiftUI/Components/HostStatusIndicator/HostStatusIndicator.swift`, once for the "Dark" preview and once for "Light". Failing that, open the file in Xcode and use the canvas.

- [x] **Step 2: Check the rendering against card 4b**

Confirm, in the dark rendering:

- `online` — solid green disc with a visible halo around it.
- `offline` — solid grey disc, plainly darker than the background, no halo.
- `probing` — grey ring, clearly thicker than `unknown`, shrinking and fading on a loop.
- `waking` — green ring of the same weight, same loop.
- `unreachable` — solid red disc with no halo.
- `unknown` — thin grey ring, completely still.

And in the light rendering: the background is white, the text is near-black, and the green is the same green — `Accent` does not change between themes, only `AccentText` does.

- [x] **Step 3: Report**

State which of the six states matched and which did not. Do not claim the component is done without having looked at both renderings.
