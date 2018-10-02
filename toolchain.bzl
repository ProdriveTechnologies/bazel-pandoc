def _pandoc_toolchain_info_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            pandoc = ctx.attr.pandoc,
        ),
    ]

_pandoc_toolchain_info = rule(
    attrs = {
        "pandoc": attr.label(
            allow_single_file = True,
            cfg = "host",
            executable = True,
        ),
    },
    implementation = _pandoc_toolchain_info_impl,
)

def pandoc_toolchain(platform, exec_compatible_with):
    _pandoc_toolchain_info(
        name = "pandoc_toolchain_info_%s" % platform,
        pandoc = "@pandoc_bin_%s//:pandoc" % platform,
        visibility = ["//visibility:public"],
    )

    native.toolchain(
        name = "pandoc_toolchain_%s" % platform,
        exec_compatible_with = exec_compatible_with,
        toolchain = ":pandoc_toolchain_info_%s" % platform,
        toolchain_type = ":pandoc_toolchain_type",
    )
