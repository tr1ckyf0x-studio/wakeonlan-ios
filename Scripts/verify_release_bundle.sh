#!/bin/bash
#
# Asserts the things about a built app bundle that compile cleanly but ship broken.
#
# Every check here stands for a regression that actually happened and that nothing else caught: the
# Shortcuts action vanishing when Intents.intentdefinition left the app target, a localisation
# disappearing behind the String Catalog migration, and a version key left as an unexpanded
# $(CURRENT_PROJECT_VERSION). All checks run before the script exits, so one CI run reports every
# problem rather than only the first.

set -uo pipefail

APP=${1:-}
if [ -z "$APP" ] || [ ! -d "$APP" ]; then
    echo "usage: $(basename "$0") <path to .app>" >&2
    exit 2
fi

failures=0

pass() { printf '  ok   %s\n' "$1"; }
fail() { printf '  FAIL %s\n' "$1" >&2; failures=$((failures + 1)); }

require_path() {
    if [ -e "$APP/$1" ]; then
        pass "$1"
    else
        fail "$1 is missing — $2"
    fi
}

echo "Verifying $(basename "$APP")"

require_path "Base.lproj/Intents.intentdefinition" \
    "the Shortcuts app reads the compiled definition from the app bundle. Without it the Wake action silently disappears from Shortcuts while the app still builds, still ships, and still answers Siri"
require_path "PlugIns/Intent.appex" \
    "the Siri extension was not embedded"

for language in en ru; do
    for catalog in Localizable Intents InfoPlist; do
        require_path "$language.lproj/$catalog.strings" \
            "the $language translations produced from the String Catalogs did not reach the bundle"
    done
done

# A String Catalog that fails to export still yields a well-formed, empty .strings file, so presence
# alone proves nothing.
entries=$(plutil -p "$APP/ru.lproj/Localizable.strings" 2>/dev/null | grep -c '=>' || true)
if [ "${entries:-0}" -ge 20 ]; then
    pass "ru.lproj/Localizable.strings holds $entries entries"
else
    fail "ru.lproj/Localizable.strings holds ${entries:-0} entries — expected at least 20"
fi

read_key() {
    /usr/libexec/PlistBuddy -c "Print :$2" "$1/Info.plist" 2>/dev/null || true
}

for key in CFBundleVersion CFBundleShortVersionString; do
    value=$(read_key "$APP" "$key")
    case "$value" in
        "")
            fail "$key is absent from Info.plist"
            ;;
        *'$('*)
            fail "$key is literally '$value' — the build setting behind it never expanded"
            ;;
        *)
            pass "$key = $value"
            ;;
    esac
done

# agvtool writes the build number into both Info.plist files independently, so they can disagree.
# App Store Connect rejects that at upload, long after CI has gone green.
app_build=$(read_key "$APP" CFBundleVersion)
extension_build=$(read_key "$APP/PlugIns/Intent.appex" CFBundleVersion)
if [ -n "$app_build" ] && [ "$app_build" = "$extension_build" ]; then
    pass "app and extension agree on CFBundleVersion ($app_build)"
else
    fail "CFBundleVersion disagrees: app '$app_build', extension '$extension_build'"
fi

if [ "$failures" -eq 0 ]; then
    echo "Bundle verification passed."
else
    echo "Bundle verification failed with $failures problem(s)." >&2
fi
exit $(( failures > 0 ? 1 : 0 ))
