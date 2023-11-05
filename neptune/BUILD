load("@rules_python//python:defs.bzl", "py_binary")

package(default_visibility = ["//visibility:public"])

py_binary(
    name = "manage",
    srcs = ["manage.py"],
    deps = [
        "//ccpd:main",
        "//neptune/ccpd_ui:models",
        "//neptune/neptune_web_ui:settings",
        "//neptune/neptune_web_ui:urls",
        "@python_deps_colorama//:pkg",
        "@python_deps_django//:pkg",
    ],
)
