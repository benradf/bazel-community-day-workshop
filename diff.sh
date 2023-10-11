#!/usr/bin/env bash
set -e

hashes() {
  sha256sum \
    bazel-bin/src/life_/life \
    bazel-bin/gif/animated.gif \
    bazel-bin/httpd/darkhttpd \
    bazel-bin/httpd/closure.tar \
    bazel-bin/docker/overlay.tar \
    bazel-bin/docker/tarball/tarball.tar
}

build() {
  bazel clean
  bazel shutdown
  bazel build //...
}

build; hashes1="$(hashes)"
build; hashes2="$(hashes)"
diff <(echo "$hashes1") <(echo "$hashes2")
