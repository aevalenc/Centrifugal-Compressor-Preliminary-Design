load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_python",
    sha256 = "b593d13bb43c94ce94b483c2858e53a9b811f6f10e1e0eedc61073bd90e58d9c",
    strip_prefix = "rules_python-0.12.0",
    url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.12.0.tar.gz",
)

load("@rules_python//python:repositories.bzl", "python_register_toolchains")

python_register_toolchains(
    name = "python39",
    # Available versions are listed in @rules_python//python:versions.bzl.
    # We recommend using the same version your team is already standardized on.
    python_version = "3.9",
)

load("@python39//:defs.bzl", "interpreter")
load("@rules_python//python:pip.bzl", "pip_parse")

pip_parse(
    name = "python_deps",
    python_interpreter_target = interpreter,
    requirements_lock = "//third_party:requirements_lock.txt",
)

# Load the starlark macro which will define your dependencies.
load("@python_deps//:requirements.bzl", "install_deps")

# Call it to define repos for your requirements.
install_deps()
