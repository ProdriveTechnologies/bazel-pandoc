def _pandoc_impl(ctx):
    toolchain = ctx.toolchains["@bazel_pandoc//:pandoc_toolchain_type"]
    ctx.actions.run(
        executable = toolchain.pandoc.files.to_list()[0].path,
        arguments = ctx.attr.options + [
            "--from",
            ctx.attr.from_format,
            "--to",
            ctx.attr.to_format,
            "-o",
            ctx.outputs.out.path,
            ctx.files.src[0].path,
        ],
        inputs = toolchain.pandoc.files + ctx.files.src,
        outputs = [ctx.outputs.out],
    )

_pandoc = rule(
    attrs = {
        "extension": attr.string(),
        "from_format": attr.string(),
        "options": attr.string_list(),
        "src": attr.label(allow_files = True),
        "to_format": attr.string(),
    },
    outputs = {"out": "%{name}.%{extension}"},
    toolchains = ["@bazel_pandoc//:pandoc_toolchain_type"],
    implementation = _pandoc_impl,
)

def pandoc(**kwargs):
    # Derive extension of the output file based on the desired format.
    # Use the generic .xml syntax for XML-based formats and .txt for
    # ones with no commonly used extension.
    extensions = {
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
    to_format = kwargs["to_format"]
    if to_format not in extensions:
        fail("Unknown output format: " + to_format)

    _pandoc(extension = extensions[to_format], **kwargs)
