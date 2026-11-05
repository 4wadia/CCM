# Copy to tool/env.sh and adjust for your machine, then: source tool/env.sh
# This workspace installs SDKs under ~/development (see README).

export JAVA_HOME="${JAVA_HOME:-$HOME/development/jdk-17}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/development/sdk}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export FLUTTER_ROOT="${FLUTTER_ROOT:-$HOME/development/flutter}"

# Keep build caches off small tmpfs mounts.
export GRADLE_USER_HOME="${GRADLE_USER_HOME:-$HOME/.gradle}"
export PUB_CACHE="${PUB_CACHE:-$HOME/.pub-cache}"
export TMPDIR="$HOME/development/tmp"
mkdir -p "$TMPDIR"

export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$FLUTTER_ROOT/bin:$PATH"

export FLUTTER_SUPPRESS_ANALYTICS=true
