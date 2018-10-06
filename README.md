# Bazel rules for Pandoc

This repository provides a function for
[the Bazel build system](https://bazel.build/) called `pandoc()` that
invokes [the Pandoc document converter](https://pandoc.org/). Example
use cases include converting documentation written in Markdown to HTML
files, or embedding them as chapters into LaTeX documents. These rules
depend on the official release binaries provided by the Pandoc project.

# Using these rules

Add the following to your `WORKSPACE` file:

```python
http_archive(
    name = "bazel_pandoc",
    sha256 = "<checksum>",
    strip_prefix = "bazel-pandoc-<release>",
    url = "https://github.com/ProdriveTechnologies/bazel-pandoc/archive/v<release>.tar.gz",
)

load("@bazel_pandoc//:repositories.bzl", "pandoc_repositories")

pandoc_repositories()
```

You can then add directives along these lines to your `BUILD.bazel` files:

```python
load("@bazel_pandoc//:pandoc.bzl", "pandoc")

pandoc(
    name = "foo",
    src = "foo.md",
    from_format = "markdown",
    to_format = "latex",
)
```

In the example above, an output file called `foo.tex` will be created in
the `bazel-bin` directory. The `to_format` field is used to
automatically derive a file extension of the output file.

# Platform support

These rules have been tested to work on:

- macOS Mojave 10.14, building locally.
- Ubuntu 18.04, building locally.
- Ubuntu 18.04, building on a Debian 9 based
  [Buildbarn](https://github.com/EdSchouten/bazel-buildbarn) setup.
- Windows 10 1803, building locally.
- Windows 10 1803, building on a Debian 9 based
  [Buildbarn](https://github.com/EdSchouten/bazel-buildbarn) setup.
