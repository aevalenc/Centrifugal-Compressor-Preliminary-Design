"""Install script for setuptools."""

import contextlib
import os
import platform
import shutil
import sysconfig
from pathlib import Path
from typing import Generator

import setuptools
from setuptools.command import build_ext
import logging

PROJECT_NAME = "ccpd"
__version__ = "1.0.6"

REQUIRED_PACKAGES = []

IS_WINDOWS = platform.system() == "Windows"
IS_MAC = platform.system() == "Darwin"

PYTHON_INCLUDE_PATH_PLACEHOLDER = "<PYTHON_INCLUDE_PATH>"

logger = logging.getLogger(__name__)
logging.basicConfig(filename="log.log", filemode="w", level=logging.DEBUG)


@contextlib.contextmanager
def temp_fill_include_path(fp: str) -> Generator[None, None, None]:
    """Temporarily set the Python include path in a file."""
    with open(fp, "r+") as f:
        logger.info(f"Opened WORKSPACE file")
        print("Opened WORKSPACE file")
        try:
            content = f.read()
            replaced = content.replace(
                PYTHON_INCLUDE_PATH_PLACEHOLDER, Path(sysconfig.get_paths()["include"]).as_posix()
            )
            f.seek(0)
            f.write(replaced)
            f.truncate()
            yield
        finally:
            # revert to the original content after exit
            f.seek(0)
            f.write(content)
            f.truncate()


class BazelExtension(setuptools.Extension):
    """A C/C++ extension that is defined as a Bazel BUILD target."""

    def __init__(self, name: str, bazel_target: str, is_pybind_library: bool):
        super().__init__(name=name, sources=[])

        self.bazel_target = bazel_target
        stripped_target = bazel_target.split("//")[-1]
        self.relpath, self.target_name = stripped_target.split(":")
        logger.debug(f"Relative path: {self.relpath}")
        logger.debug(f"Target name: {self.target_name}")
        self.is_pybind_library = is_pybind_library


class BazelBuildExtension(build_ext.build_ext):
    """A command that runs Bazel to build a C/C++ extension."""

    def run(self):
        for ext in self.extensions:
            logger.debug(f"Building extension: {ext}")
            self.bazel_build(ext)
        super().run()
        # explicitly call `bazel shutdown` for graceful exit
        self.spawn(["bazel", "shutdown"])

    def copy_extensions_to_source(self):
        """
        Copy generated extensions into the source tree.
        This is done in the ``bazel_build`` method, so it's not necessary to
        do again in the `build_ext` base class.
        """
        pass

    def bazel_build(self, bazel_extension: BazelExtension) -> None:
        """Runs the bazel build to create the package."""
        logger.debug(f"Temporary build directory: {self.build_temp}")
        try:
            with temp_fill_include_path("WORKSPACE"):
                temp_path = Path(self.build_temp)
                logger.info(f"temp_path: {temp_path}")

                bazel_argv = [
                    "bazel",
                    "build",
                    bazel_extension.bazel_target,
                    "--enable_bzlmod=false",
                    f"--symlink_prefix={temp_path / 'bazel-'}",
                    f"--compilation_mode={'dbg' if self.debug else 'opt'}",
                    # C++17 is required by nanobind
                    f"--cxxopt={'/std:c++17' if IS_WINDOWS else '-std=c++17'}",
                ]

                if IS_WINDOWS:
                    # Link with python*.lib.
                    for library_dir in self.library_dirs:
                        bazel_argv.append("--linkopt=/LIBPATH:" + library_dir)
                elif IS_MAC:
                    if platform.machine() == "x86_64":
                        # C++17 needs macOS 10.14 at minimum
                        bazel_argv.append("--macos_minimum_os=10.14")

                        # cross-compilation for Mac ARM64 on GitHub Mac x86 runners.
                        # ARCHFLAGS is set by cibuildwheel before macOS wheel builds.
                        archflags = os.getenv("ARCHFLAGS", "")
                        if "arm64" in archflags:
                            bazel_argv.append("--cpu=darwin_arm64")
                            bazel_argv.append("--macos_cpus=arm64")

                    elif platform.machine() == "arm64":
                        bazel_argv.append("--macos_minimum_os=11.0")

                self.spawn(bazel_argv)

                if not bazel_extension.is_pybind_library:

                    shared_lib_suffix = ".dll" if IS_WINDOWS else ".so"
                    ext_name = bazel_extension.name + shared_lib_suffix
                    ext_bazel_bin_path = temp_path / "bazel-bin" / bazel_extension.relpath / ext_name

                    logger.info(f"extension name: {ext_name}")
                    logger.info(f"ext_bazel_bin_path: {ext_bazel_bin_path}")

                    ext_dest_path = (
                        Path(self.get_ext_fullpath(bazel_extension.name)).parent / bazel_extension.relpath / ext_name
                    )
                    logger.info(f"ext_dest_path: {ext_dest_path}")

                    shutil.copyfile(ext_bazel_bin_path, ext_dest_path)
                    print(f"Copy exited successfully")
                logger.info("Extension built successfully!")
        except:
            print("Failed to load WORKSPACE file")


setuptools.setup(
    name=PROJECT_NAME,
    version=__version__,
    description="Data types from CCPD",
    author="Alejandro Valencia",
    ext_modules=[
        BazelExtension("thermo_point", "//ccpd/data_types:thermo_point", True),
        BazelExtension("_constants", "//ccpd/cc_libraries:py_constants", False),
    ],
    cmdclass=dict(build_ext=BazelBuildExtension),
    packages=["ccpd/data_types", "ccpd/cc_libraries"],
)
