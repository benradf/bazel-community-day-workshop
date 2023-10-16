# Debugging Cache Misses in Bazel

A toy repository with a few deliberate issues that introduce nondeterminism and
break caching. To get started:

```
git clone https://github.com/benradf/bazel-community-day-workshop.git
cd bazel-community-day-workshop
./run.sh
```

This will build and run a docker container, which serves an animated gif using
[darkhttpd](https://github.com/emikulic/darkhttpd). You might need to install a
few tools if you don't already have them:

- C++ compiler
- `docker`
- `ffmpeg`
- [Nix Package Manager](https://nixos.org/download)

## Target Dependency Graph

The following graph shows how the various targets in the repository depend on
each other:

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