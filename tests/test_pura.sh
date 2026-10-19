#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PURA="$ROOT/src/pura"

assert_contains() {
    haystack=$1
    needle=$2
    printf '%s\n' "$haystack" | grep -F "$needle" >/dev/null || {
        printf 'FAIL: expected %s\n' "$needle" >&2
        exit 1
    }
}

printf '%s\n' '1/8 help and product name'
out=$($PURA --help)
assert_contains "$out" 'pura - Linux'
assert_contains "$out" 'pura [seçenekler] clean /dev/sdX'

printf '%s\n' '2/8 version'
out=$($PURA --version)
assert_contains "$out" 'pura 0.1.0'

printf '%s\n' '3/8 explanation'
out=$($PURA explain)
assert_contains "$out" 'wipefs'
assert_contains "$out" 'ham diske'

printf '%s\n' '4/8 read-only scan'
out=$($PURA scan /tmp)
assert_contains "$out" 'Filesystem görünümü: /tmp'

printf '%s\n' '5/8 dry-run'
out=$($PURA clean all --dry-run)
assert_contains "$out" 'dry-run'

printf '%s\n' '6/8 non-block device refusal'
if $PURA clean /dev/null >/tmp/pura-test-out 2>&1; then
    printf '%s\n' 'FAIL: character device was accepted as a disk' >&2
    exit 1
fi
assert_contains "$(cat /tmp/pura-test-out)" 'Blok aygıtı değil'
rm -f /tmp/pura-test-out

printf '%s\n' '7/8 reject cache path outside HOME'
tmp_root=$(mktemp -d)
mkdir -p "$tmp_root/home" "$tmp_root/victim/thumbnails"
printf 'preserve\n' > "$tmp_root/victim/thumbnails/keep"
HOME="$tmp_root/home" XDG_CACHE_HOME="$tmp_root/victim" "$PURA" clean caches --yes >/dev/null 2>&1
[ -f "$tmp_root/victim/thumbnails/keep" ] || {
    printf '%s\n' 'FAIL: cache outside HOME was modified' >&2
    rm -rf "$tmp_root"
    exit 1
}
rm -rf "$tmp_root"

printf '%s\n' '8/8 safety implementation guard'
if grep -F 'rm -rf -- {} +' "$PURA" >/dev/null; then
    printf '%s\n' 'FAIL: recursive rm on find results could cross nested mounts' >&2
    exit 1
fi
sh -n "$PURA"
printf '%s\n' 'PASS: pura smoke/security tests'
