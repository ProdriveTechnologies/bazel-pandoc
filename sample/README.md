# Sample usage of the pandoc rule

Once you have set up your workspace,
you can generate the [README](../README.md) in a multitude of formats.

For instance:

```sh
bazel build @bazel_pandoc//sample:readme_plain
bazel build @bazel_pandoc//sample:readme_html
bazel build @bazel_pandoc//sample:readme_epub
```

You can also produce the README in all formats know to the rule:

```sh
bazel build @bazel_pandoc//sample/...
```
