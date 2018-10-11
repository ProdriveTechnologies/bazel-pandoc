def _pandoc_impl(ctx):
    toolchain = ctx.toolchains["@bazel_pandoc//:pandoc_toolchain_type"]
    cli_args = []
    cli_args.extend(ctx.attr.options)
    if ctx.attr.from_format:
        cli_args.extend(["--from", ctx.attr.from_format])
    if ctx.attr.to_format:
        cli_args.extend(["--to", ctx.attr.to_format])
    cli_args.extend(["-o", ctx.outputs.output.path])
    cli_args.append(ctx.file.src.path)

    print("args=" + str(cli_args))
    ctx.actions.run(
        mnemonic = "Pandoc",
        executable = toolchain.pandoc.files.to_list()[0].path,
        arguments = cli_args,
        inputs = toolchain.pandoc.files + ctx.files.src,
        outputs = [ctx.outputs.output],
    )

_pandoc = rule(
    attrs = {
        "extension": attr.string(),
        "from_format": attr.string(),
        "options": attr.string_list(),
        "src": attr.label(allow_single_file = True, mandatory = True),
        "to_format": attr.string(),
        "output": attr.output(mandatory = True),
    },
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
