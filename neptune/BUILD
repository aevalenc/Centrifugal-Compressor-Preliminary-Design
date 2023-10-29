load("@rules_python//python:defs.bzl", "py_binary")

package(default_visibility = ["//visibility:public"])

py_binary(
    name = "manage",
    srcs = ["manage.py"],
    deps = [
        "@python_deps_colorama//:pkg",
        "@python_deps_django//:pkg",
    ],
)
