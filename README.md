# Bazel rules for Pandoc

This repository provides a function for
[the Bazel build system](https://bazel.build/) called `pandoc()` that
invokes [the Pandoc document converter](https://pandoc.org/). Example
use cases include converting documentation written in Markdown to HTML
files, or embedding them as chapters into LaTeX documents. These rules
depend on the official release binaries provided by the Pandoc project.

# Using these rules

Please see the sample folder for an example of how bazel-pandoc could be used.

## Set up your workspace

Add the following to your `WORKSPACE` file:

```python
http_archive(
    name = "bazel_pandoc",
    strip_prefix = "bazel-pandoc-<release>",
    url = "https://github.com/ProdriveTechnologies/bazel-pandoc/archive/v<release>.tar.gz",
)

load("@bazel_pandoc//:repositories.bzl", "pandoc_repositories")

pandoc_repositories()
```

## Use the `pandoc` rule in BUILD files

You can then add directives along these lines to your `BUILD.bazel` files:

```python
load("@bazel_pandoc//:pandoc.bzl", "pandoc")

pandoc(
    name = "foo",                # required
    src = "foo.md",              # required
    from_format = "markdown",    # optional, inferred from src extension by default
    to_format = "latex",         # optional, inferred from output extension by default
    output = "awesome_doc.tex",  # optional, derived from name and to_format by default
)
```

In the example above, an output file called `awesome_doc.tex` will be created
in the `bazel-bin` directory.

At least one of the `to_format` or `output` attributes must be provided.

# Platform support

These rules have been tested to work on:

- macOS Mojave 10.14, building locally.
- Ubuntu 18.04, building locally.
- Ubuntu 18.04, building on a Debian 9 based
  [Buildbarn](https://github.com/EdSchouten/bazel-buildbarn) setup.
- Windows 10 1803, building locally.
- Windows 10 1803, building on a Debian 9 based
  [Buildbarn](https://github.com/EdSchouten/bazel-buildbarn) setup.
