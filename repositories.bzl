load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

PANDOC_VERSION = "2.8.0.1"

BUILD_CONTENT_UNIX = """
filegroup(
    name = "pandoc",
    srcs = ["bin/pandoc"],
    visibility = ["//visibility:public"],
)"""

BUILD_CONTENT_WINDOWS = """
filegroup(
    name = "pandoc",
    srcs = ["pandoc.exe"],
    visibility = ["//visibility:public"],
)"""

def pandoc_repositories():
    http_archive(
        name = "pandoc_bin_linux-x86_64",
        build_file_content = BUILD_CONTENT_UNIX,
        sha256 = "8ebf1b6c852d77290345afdd565547bdbd5de7888362f5a69fc7f51aeb8696a2",
        strip_prefix = "pandoc-{v}".format(v = PANDOC_VERSION),
        url = "https://github.com/jgm/pandoc/releases/download/{v}/pandoc-{v}-linux-amd64.tar.gz".format(v = PANDOC_VERSION),
    )

    http_archive(
        name = "pandoc_bin_macOS",
        build_file_content = BUILD_CONTENT_UNIX,
        sha256 = "477d2f436170ecccd33e741516e01f053c8d0b141e7a9a4c26c09d07f62a080f",
        strip_prefix = "pandoc-{v}".format(v = PANDOC_VERSION),
        url = "https://github.com/jgm/pandoc/releases/download/{v}/pandoc-{v}-macOS.zip".format(v = PANDOC_VERSION),
    )

    http_archive(
        name = "pandoc_bin_windows-i386",
        build_file_content = BUILD_CONTENT_WINDOWS,
        sha256 = "c1530b141bd98903fa0f3d242076d790ce9d7448e8fc24f5084967c0889238d6",
        strip_prefix = "pandoc-{v}-windows-i386".format(v = PANDOC_VERSION),
        url = "https://github.com/jgm/pandoc/releases/download/{v}/pandoc-{v}-windows-i386.zip".format(v = PANDOC_VERSION),
    )

    http_archive(
        name = "pandoc_bin_windows-x86_64",
        build_file_content = BUILD_CONTENT_WINDOWS,
        sha256 = "ce9f8a68b9bccbec63d35317dfdc40dc3e1722d49b66b9cf39cc1459ae688129",
        strip_prefix = "pandoc-{v}-windows-x86_64".format(v = PANDOC_VERSION),
        url = "https://github.com/jgm/pandoc/releases/download/{v}/pandoc-{v}-windows-x86_64.zip".format(v = PANDOC_VERSION),
    )

    native.register_toolchains(
        "@bazel_pandoc//:pandoc_toolchain_linux-x86_64",
        "@bazel_pandoc//:pandoc_toolchain_macOS",
        "@bazel_pandoc//:pandoc_toolchain_windows-i386",
        "@bazel_pandoc//:pandoc_toolchain_windows-x86_64",
    )
