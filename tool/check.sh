#!/usr/bin/env bash
# Local verification gate. Mirrors the per-milestone checks in the specification.
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Format check"
dart format --output=none --set-exit-if-changed .

echo "==> Static analysis"
flutter analyze

echo "==> Tests"
flutter test

if [[ "${SKIP_BUILD:-0}" != "1" ]]; then
  echo "==> Android debug build"
  flutter build apk --debug
fi

echo "==> OK"
