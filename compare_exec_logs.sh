#!/bin/bash

#   This script executes bazel build command twice to produce
#   execution logs, then downloads the tool to compare the logs
#   and calls it.
#   Visit https://github.com/JSGette/remote-cache-debugger to
#   know more about the tool.

echo "Creating temporary disk cache directory..."
mkdir -p /tmp/disk_cache
bazel clean --expunge

echo "Performing first build to generate execution logs..."
bazel build //... --disk_cache=/tmp/disk_cache --execution_log_binary_file=/tmp/exec1.log

echo "Cleaning outputs of the previous build..."
bazel clean --expunge

echo "Performing second build to generate execution logs..."
bazel build //... --disk_cache=/tmp/disk_cache --execution_log_binary_file=/tmp/exec2.log

echo "Builds finished..."
echo "============================================================="

echo "Downloading remote-cache-debugger..."
curl -L https://github.com/JSGette/remote-cache-debugger/releases/download/0.0.1-SNAPSHOT/remote-cache-debugger-0.0.1-SNAPSHOT.jar > /tmp/rcd.jar

echo "Comparing execution logs..."
java -jar /tmp/rcd.jar -first /tmp/exec1.log -second /tmp/exec2.log -o output.txt

echo "Performing clean up..."
rm -rf /tmp/disk_cache

echo "Results are available in output.txt"
