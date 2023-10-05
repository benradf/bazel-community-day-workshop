#!/usr/bin/env bash
set -ex
bazel run //docker:tarball
docker run -it -p 8080:80 bazel-community-day-workshop:latest
