#!/usr/bin/env bash
# validate.sh — Validate zed-extension-shuttle-syntax without opening Zed.
#
# Usage:  ./validate.sh [-v|--verbose]
#
# Exits 0 on success, 1 on failure. Each check prints PASS or FAIL.
# Requires: tree-sitter (>=0.25), emscripten (for wasm rebuild).

set -uo pipefail

EXT_DIR="$(cd "$(dirname "$0")" && pwd)"
SHUTTLE_DIR="/home/estrandv/programming/tree-sitter-shuttle-notation"
BILLBOARD_DIR="/home/estrandv/programming/tree-sitter-jdw-billboarding"

SHUTTLE_SHORT="shuttle"
BILLBOARD_SHORT="billboard"
PASS=0
FAIL=0

usage() {
  echo "Usage: $(basename "$0") [-v|--verbose]"
  echo "Validate zed-extension-shuttle-syntax without opening Zed."
  exit 1
}

# Parse args
VERBOSE=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--verbose) VERBOSE=true; shift ;;
    *) usage ;;
  esac
done

result() {
  local label="$1"
  shift
  if "$@"; then
    echo "  PASS  $label"
    ((PASS++))
  else
    echo "  FAIL  $label"
    ((FAIL++))
  fi
}

run() {
  if $VERBOSE; then
    "$@"
  else
    "$@" > /dev/null 2>&1
  fi
}

echo "=== validate.sh — zed-extension-shuttle-syntax ==="
echo

# 1. Grammar corpus tests
echo "--- Grammar tests ---"
result "$SHUTTLE_SHORT   corpus"   run sh -c "cd '$SHUTTLE_DIR'   && tree-sitter test > /dev/null 2>&1"
result "$BILLBOARD_SHORT corpus"   run sh -c "cd '$BILLBOARD_DIR' && tree-sitter test > /dev/null 2>&1"

# 2. Example files parse (natively)
echo "--- Parse example files ---"
result "$SHUTTLE_SHORT   parses"   run sh -c "cd '$SHUTTLE_DIR'   && tree-sitter parse -q '$EXT_DIR/example.shuttle'"
result "$BILLBOARD_SHORT parses"   run sh -c "cd '$BILLBOARD_DIR' && tree-sitter parse -q '$EXT_DIR/example.bbd'"

# 3. Highlight queries validate (captures match real node types)
echo "--- Highlight query validation ---"
result "$SHUTTLE_SHORT   highlights"   run sh -c "cd '$SHUTTLE_DIR'   && tree-sitter highlight --check \
  --query-paths '$EXT_DIR/languages/shuttle/highlights.scm' '$EXT_DIR/example.shuttle'"
result "$BILLBOARD_SHORT highlights"   run sh -c "cd '$BILLBOARD_DIR' && tree-sitter highlight --check \
  --query-paths '$EXT_DIR/languages/billboard/highlights.scm' '$EXT_DIR/example.bbd'"
result "injections"                   run sh -c "cd '$BILLBOARD_DIR' && tree-sitter highlight --check \
  --query-paths '$EXT_DIR/languages/billboard/injections.scm' '$EXT_DIR/example.bbd'"

# 4. WASM files rebuild
echo "--- WASM builds ---"
result "$SHUTTLE_SHORT   wasm"   run tree-sitter build --wasm \
  -o "$EXT_DIR/grammars/shuttle.wasm" "$EXT_DIR/grammars/shuttle"
result "$BILLBOARD_SHORT wasm"   run tree-sitter build --wasm \
  -o "$EXT_DIR/grammars/jdw_billboarding.wasm" "$EXT_DIR/grammars/jdw_billboarding"

# 5. Extension.toml has GitHub URLs (not file://)
echo "--- Extension metadata ---"
result "github URLs (no file://)" sh -c \
  "grep -q 'github\.com' '$EXT_DIR/extension.toml' && ! grep -q 'file://' '$EXT_DIR/extension.toml'"

echo
echo "=== Results: $PASS passed, $FAIL failed ==="
exit "$(( FAIL > 0 ))"
