# Debugging Cache Misses in Bazel

A toy repository with a few deliberate issues that introduce nondeterminism and
break caching. To get started:

```
git clone https://github.com/benradf/bazel-community-day-workshop.git
cd bazel-community-day-workshop
./run.sh
```

## Target Dependency Graph

![target-graph](target-graph.png)
