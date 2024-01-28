load("@rules_python//python:defs.bzl", "py_binary", "py_library")
load("//third_party:python_image_utils.bzl", "py_oci_image")
load("@rules_oci//oci:defs.bzl", "oci_tarball")
load("@aspect_bazel_lib//lib:transitions.bzl", "platform_transition_filegroup")

package(default_visibility = ["//visibility:public"])

py_library(
    name = "manage_lib",
    srcs = [
        "__init__.py",
        "manage.py",
    ],
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

py_binary(
    name = "neptune_web_app_main",
    srcs = ["__main__.py"],
    imports = [".."],
    main = "__main__.py",
    deps = [":manage_lib"],
)

py_oci_image(
    name = "neptune_image",
    base = "@python_base",
    binary = ":neptune_web_app_main",
    entrypoint = ["/neptune/neptune_web_app_main"],
    # cmd = [
    #     "bash",
    #     "apt",
    #     "install",
    #     "python3",
    # ],
    # env = {"PATH": "/neptune:$PATH"},
)

platform(
    name = "x86_64_linux",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
)

platform_transition_filegroup(
    name = "platform_image",
    srcs = [":neptune_image"],
    target_platform = "x86_64_linux",
)

# $ bazel run //neptune:neptune_tarball
# $ docker run --rm gcr.io/oci_python_hello_world:latest
oci_tarball(
    name = "neptune_tarball",
    image = ":platform_image",
    repo_tags = ["gcr.io/oci_python_neptune:latest"],
)
