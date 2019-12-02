PANDOC_EXTENSIONS = {
    "asciidoc": "adoc",
    "beamer": "tex",
    "commonmark": "md",
    "context": "tex",
    "docbook": "xml",
    "docbook4": "xml",
    "docbook5": "xml",
    "docx": "docx",
    "dokuwiki": "txt",
    "dzslides": "html",
    "epub": "epub",
    "epub2": "epub",
    "epub3": "epub",
    "fb2": "fb",
    "haddock": "txt",
    "html": "html",
    "html4": "html",
    "html5": "html",
    "icml": "icml",
    "jats": "xml",
    "json": "json",
    "latex": "tex",
    "man": "1",
    "markdown": "md",
    "markdown_github": "md",
    "markdown_mmd": "md",
    "markdown_phpextra": "md",
    "markdown_strict": "md",
    "mediawiki": "txt",
    "ms": "1",
    "muse": "txt",
    "native": "txt",
    "odt": "odt",
    "opendocument": "odt",
    "opml": "openml",
    "org": "txt",
    "plain": "txt",
    "pptx": "pptx",
    "revealjs": "html",
    "rst": "rst",
    "rtf": "rtf",
    "s5": "html",
    "slideous": "html",
    "slidy": "html",
    "tei": "html",
    "texinfo": "texi",
    "textile": "textile",
    "zimwiki": "txt",
}
PANDOC_FORMATS = PANDOC_EXTENSIONS.keys()

def _pandoc_impl(ctx):
    toolchain = ctx.toolchains["@bazel_pandoc//:pandoc_toolchain_type"]
    cli_args = []
    cli_args.extend(ctx.attr.options)
    if ctx.attr.from_format:
        cli_args.extend(["--from", ctx.attr.from_format])
    if ctx.attr.to_format:
        cli_args.extend(["--to", ctx.attr.to_format])
    cli_args.extend(["-o", ctx.outputs.output.path])
    cli_args.extend([ctx.files.src[0].path])
    ctx.actions.run(
        mnemonic = "Pandoc",
        executable = toolchain.pandoc.files.to_list()[0].path,
        arguments = cli_args,
        inputs = depset(
            direct = ctx.files.src,
            transitive = [toolchain.pandoc.files],
        ),
        outputs = [ctx.outputs.output],
    )

_pandoc = rule(
    attrs = {
        "from_format": attr.string(),
        "options": attr.string_list(),
        "src": attr.label(allow_files = True),
        "to_format": attr.string(),
        "output": attr.output(mandatory = True),
    },
    toolchains = ["@bazel_pandoc//:pandoc_toolchain_type"],
    implementation = _pandoc_impl,
)

def _check_format(format, attr_name):
    if format not in PANDOC_EXTENSIONS:
        fail("Unknown `%{attr}` format: %{format}".fmt(attr = attr_name, format = format))
    return format

def _infer_output(name, to_format):
    """Derives output file based on the desired format.

    Use the generic .xml syntax for XML-based formats and .txt for
    ones with no commonly used extension.
    """
    to_format = _check_format(to_format, "to_format")
    ext = PANDOC_EXTENSIONS[to_format]
    return name + "." + ext

def pandoc(**kwargs):
    if "output" not in kwargs:
        if "to_format" not in kwargs:
            fail("One of `output` or `to_format` attributes must be provided")
        to_format = _check_format(kwargs["to_format"], "to_format")
        kwargs["output"] = _infer_output(kwargs["name"], to_format)
    _pandoc(**kwargs)
