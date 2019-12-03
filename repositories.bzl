load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

PANDOC_VERSION = "2.3.1"

def pandoc_repositories():
    http_archive(
        name = "pandoc_bin_linux",
        build_file_content = """
filegroup(
    name = "pandoc",
    srcs = ["bin/pandoc"],
    visibility = ["//visibility:public"],
)""",
        sha256 = "859609cdba5af61aefd7c93d174e412d6a38f5c1be90dfc357158638ff5e7059",
        strip_prefix = "pandoc-{v}".format(v=PANDOC_VERSION),
        url = "https://github.com/jgm/pandoc/releases/download/{v}/pandoc-{v}-linux.tar.gz".format(v=PANDOC_VERSION),
    )

    http_archive(
        name = "pandoc_bin_macOS",
        build_file_content = """
filegroup(
    name = "pandoc",
    srcs = ["bin/pandoc"],
    visibility = ["//visibility:public"],
)""",
        sha256 = "bc9ba6f1f4f447deff811554603edcdb13344b07b969151569b6e46e1c8c81b7",
        strip_prefix = "pandoc-{v}".format(v=PANDOC_VERSION),
        url = "https://github.com/jgm/pandoc/releases/download/{v}/pandoc-{v}-macOS.zip".format(v=PANDOC_VERSION),
    )

    http_archive(
        name = "pandoc_bin_windows-i386",
        build_file_content = """
filegroup(
    name = "pandoc",
    srcs = ["pandoc.exe"],
    visibility = ["//visibility:public"],
)""",
        sha256 = "4b878dfc094af245621581cf30afbe2eb401dc886f59edbe67356e691a4c72cc",
        strip_prefix = "pandoc-{v}-windows-i386".format(v=PANDOC_VERSION),
        url = "https://github.com/jgm/pandoc/releases/download/{v}/pandoc-{v}-windows-i386.zip".format(v=PANDOC_VERSION),
    )

    http_archive(
        name = "pandoc_bin_windows-x86_64",
        build_file_content = """
filegroup(
    name = "pandoc",
    srcs = ["pandoc.exe"],
    visibility = ["//visibility:public"],
)""",
        sha256 = "c84377a6ddb45b149c297af3e37aacaa8f82535c929aa74723f7a75d7d7b15ab",
        strip_prefix = "pandoc-{v}-windows-x86_64".format(v=PANDOC_VERSION),
        url = "https://github.com/jgm/pandoc/releases/download/{v}/pandoc-{v}-windows-x86_64.zip".format(v=PANDOC_VERSION),
    )

    native.register_toolchains(
        "@bazel_pandoc//:pandoc_toolchain_linux",
        "@bazel_pandoc//:pandoc_toolchain_macOS",
        "@bazel_pandoc//:pandoc_toolchain_windows-i386",
        "@bazel_pandoc//:pandoc_toolchain_windows-x86_64",
    )
