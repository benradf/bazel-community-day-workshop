#!/bin/bash

set -eux

#   This script executes bazel build command twice to produce
#   execution logs, then downloads the tool to compare the logs
#   and calls it.
#   Visit https://github.com/JSGette/remote-cache-debugger to
#   know more about the tool.

exec-log-filename() {
    mkdir -p /tmp/execlogs
    printf "/tmp/execlogs/exec-%s-%s.log" "$USER" $(date +%Y%m%d-%H%M%S)
}

extra_build_params=""  # --config=bcd-cluster  # --disk_cache=/tmp/disk_cache

echo "Creating temporary disk cache directory..."
mkdir -p /tmp/disk_cache
bazel clean #--expunge

execlog1=$(exec-log-filename)
echo "Performing first build to generate execution logs..."
bazel build //... $extra_build_params --execution_log_binary_file=$execlog1

echo "Cleaning outputs of the previous build..."
bazel clean #--expunge

execlog2=$(exec-log-filename)
echo "Performing second build to generate execution logs..."
bazel build //... $extra_build_params --execution_log_binary_file=$execlog2

echo "Builds finished..."
echo "============================================================="

echo "Downloading remote-cache-debugger..."
curl -L https://github.com/JSGette/remote-cache-debugger/releases/download/0.0.1-SNAPSHOT/remote-cache-debugger-0.0.1-SNAPSHOT.jar > /tmp/rcd.jar

echo "Comparing execution logs..."
java -jar /tmp/rcd.jar -first $execlog1 -second $execlog2 -o output.txt

echo "Performing clean up..."
rm -rf /tmp/disk_cache

echo "Results are available in output.txt"
