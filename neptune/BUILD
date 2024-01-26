load("@rules_python//python:defs.bzl", "py_binary")
load("//third_party:python_image_utils.bzl", "py_oci_image")
load("@rules_oci//oci:defs.bzl", "oci_tarball")

package(default_visibility = ["//visibility:public"])

py_binary(
    name = "manage",
    srcs = ["manage.py"],
    imports = [".."],
    deps = [
        "//ccpd:main",
        "//neptune/ccpd_ui:models",
        "//neptune/neptune_web_ui:settings",
        "//neptune/neptune_web_ui:urls",
        "@python_deps_colorama//:pkg",
        "@python_deps_django//:pkg",
    ],
)

py_oci_image(
    name = "neptune_image",
    base = "@ubuntu",
    binary = ":manage",
    # entrypoint = ["/neptune/manage"],
    cmd = ["bash"],
)

# $ bazel run //neptune:neptune_tarball
# $ docker run --rm gcr.io/oci_python_hello_world:latest
oci_tarball(
    name = "neptune_tarball",
    image = ":neptune_image",
    repo_tags = ["gcr.io/oci_python_neptune:latest"],
)
