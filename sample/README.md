# Sample usage of the pandoc rule

Once you have set up your workspace,
you can generate the [README](../README.md) in a multitude of formats.


## Target defined with `to_format`

For instance:

```sh
bazel build @bazel_pandoc//sample:readme_plain
bazel build @bazel_pandoc//sample:readme_html
bazel build @bazel_pandoc//sample:readme_epub
```

These targets are defined (actually with a _for loop_) with

```python
pandoc(
    name = "readme_plain",
    src = "//:README.md",
    from_format = "markdown",
    to_format = "plain",
)
pandoc(
    name = "readme_html",
    src = "//:README.md",
    from_format = "markdown",
    to_format = "html",
)
pandoc(
    name = "readme_epub",
    src = "//:README.md",
    from_format = "markdown",
    to_format = "epub",
)
```

You notice that the output file is derived from the rule name:
- bazel-bin/sample/readme_plain.txt
- bazel-bin/sample/readme_html.html
- bazel-bin/sample/readme_epub.epub

NB: `from_format` is optional and inferred from the file extension by default.


## Target defined with `output`

It's also possible to specify the output

```python
pandoc(
    name = "gen_html_page",
    src = "//:README.md",
    output = "index.html",
)

```
As a result,
```sh
bazel build //sample:gen_html_page
```
produces an HTML document in:
- bazel-bin/sample/index.html

Finally can also produce the README in all formats know to the rule:

```sh
bazel build @bazel_pandoc//sample/...
```
