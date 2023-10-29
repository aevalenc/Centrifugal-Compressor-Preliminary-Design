load("@rules_python//python:defs.bzl", "py_library", "py_test")

package(default_visibility = ["//visibility:public"])

py_library(
    name = "admin",
    srcs = ["admin.py"],
    deps = [
        "@python_deps_colorama//:pkg",
        "@python_deps_django//:pkg",
    ],
)

py_library(
    name = "apps",
    srcs = ["apps.py"],
    deps = [
        "@python_deps_colorama//:pkg",
        "@python_deps_django//:pkg",
    ],
)

py_library(
    name = "views",
    srcs = ["views.py"],
    deps = [
        "@python_deps_colorama//:pkg",
        "@python_deps_django//:pkg",
    ],
)

py_library(
    name = "urls",
    srcs = ["urls.py"],
    deps = [
        ":views",
        "@python_deps_django//:pkg",
    ],
)

py_library(
    name = "models",
    srcs = ["models.py"],
    deps = [
        "@python_deps_colorama//:pkg",
        "@python_deps_django//:pkg",
    ],
)

py_test(
    name = "tests",
    srcs = ["tests.py"],
    deps = [
        "@python_deps_colorama//:pkg",
        "@python_deps_django//:pkg",
    ],
)
