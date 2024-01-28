load("@rules_python//python:defs.bzl", "py_library")

py_library(
    name = "asgi",
    srcs = ["asgi.py"],
    visibility = ["//:__subpackages__"],
)

py_library(
    name = "settings",
    srcs = ["settings.py"],
    visibility = ["//:__subpackages__"],
    deps = ["//neptune/ccpd_ui:apps"],
)

py_library(
    name = "urls",
    srcs = ["urls.py"],
    visibility = ["//:__subpackages__"],
    deps = ["//neptune/ccpd_ui:urls"],
)

py_library(
    name = "wsgi",
    srcs = ["wsgi.py"],
    visibility = ["//:__subpackages__"],
)
