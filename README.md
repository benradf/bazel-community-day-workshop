# Debugging Cache Misses in Bazel

A toy repository with a few deliberate issues that introduce nondeterminism and
break caching.

## Required Tools

- [Nix: the package manager](https://nixos.org/download)
- C++ compiler
- `docker`
- `ffmpeg`

## Getting Started

```
git clone https://github.com/benradf/bazel-community-day-workshop.git
cd bazel-community-day-workshop
./run.sh
```

This will build the `//docker:tarball` target and run it as a docker container, which serves
an animated gif using [darkhttpd](https://github.com/emikulic/darkhttpd).

Unfortunately `//docker:tarball` fails to build on MacOS because the repository is not set up
for cross-compilation, but you can build `//docker:overlay` instead. This target still has a
number of issues that need resolving.

## Target Dependency Graph

The following graph shows how `//docker:tarball`, `//docker:overlay`, and the other targets
in the repository depend on each other:

![target-graph](target-graph.png)

## Remote Cache Debugger
If you're familiar with [this](https://bazel.build/remote/cache-remote) article you know
how painful it can be if you have to compare execution logs of a heavy project as a single
execution log (even in binary format) might be gigabytes big. To simplify and automate the process
[remote-cache-debugger](https://github.com/JSGette/remote-cache-debugger) can be used.

This tool automatically compares two execution logs and identifies differences in
inputs and environment variables as those two attributes are the main culprits in most
of caching issues. However, even if inputs and envvars don't differ and an action is cachable, 
the tool will still reflect executions that occured during both builds.

To simplify usage of the tool [compare_exec_logs.sh](compare_exec_logs.sh) is introduced
which automatically creates a temporary disk cache folder in /tmp, builds this
repository twice and generates the output file.
