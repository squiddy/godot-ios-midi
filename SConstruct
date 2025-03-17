#!/usr/bin/env python
import subprocess


opts = Variables([], ARGUMENTS)

env = DefaultEnvironment()

opts.Add(
    EnumVariable(
        "target", "Compilation target", "debug", ["debug", "release", "release_debug"]
    )
)

opts.Update(env)

env.Append(CCFLAGS=["-fmodules", "-fcxx-modules"])

sdk_name = "iphoneos"
env.Append(CCFLAGS=["-miphoneos-version-min=12.0"])
env.Append(LINKFLAGS=["-miphoneos-version-min=12.0"])

try:
    sdk_path = (
        subprocess.check_output(["xcrun", "--sdk", "iphoneos", "--show-sdk-path"])
        .strip()
        .decode("utf-8")
    )
except (subprocess.CalledProcessError, OSError):
    raise ValueError(
        "Failed to find SDK path while running xcrun --sdk iphoneos --show-sdk-path."
    )

env.Append(
    CCFLAGS=[
        "-fobjc-arc",
        "-fmessage-length=0",
        "-fno-strict-aliasing",
        "-fdiagnostics-print-source-range-info",
        "-fdiagnostics-show-category=id",
        "-fdiagnostics-parseable-fixits",
        "-fpascal-strings",
        "-fblocks",
        "-fvisibility=hidden",
        "-MMD",
        "-MT",
        "dependencies",
        "-fno-exceptions",
        "-Wno-ambiguous-macro",
        "-Wall",
        "-Werror=return-type",
        "-arch",
        "arm64",
        "-isysroot",
        "$IOS_SDK_PATH",
        "-stdlib=libc++",
        "-isysroot",
        sdk_path,
        "-DPTRCALL_ENABLED",
    ]
)
env.Prepend(
    CXXFLAGS=[
        "-DNEED_LONG_INT",
        "-DLIBYUV_DISABLE_NEON",
        "-DIOS_ENABLED",
        "-DUNIX_ENABLED",
        "-DCOREAUDIO_ENABLED",
    ]
)
env.Append(LINKFLAGS=["-arch", "arm64", "-isysroot", sdk_path, "-F" + sdk_path])

env.Prepend(CFLAGS=["-std=gnu11"])
env.Prepend(CXXFLAGS=["-DVULKAN_ENABLED", "-std=gnu++17"])

if env["target"] == "debug":
    env.Prepend(
        CXXFLAGS=[
            "-gdwarf-2",
            "-O0",
            "-DDEBUG_MEMORY_ALLOC",
            "-DDISABLE_FORCED_INLINE",
            "-D_DEBUG",
            "-DDEBUG=1",
            "-DDEBUG_ENABLED",
        ]
    )
elif env["target"] == "release_debug":
    env.Prepend(
        CXXFLAGS=[
            "-O2",
            "-ftree-vectorize",
            "-DNDEBUG",
            "-DNS_BLOCK_ASSERTIONS=1",
            "-DDEBUG_ENABLED",
        ]
    )
    env.Prepend(CXXFLAGS=["-fomit-frame-pointer"])
else:
    env.Prepend(
        CXXFLAGS=[
            "-O2",
            "-ftree-vectorize",
            "-DNDEBUG",
            "-DNS_BLOCK_ASSERTIONS=1",
        ]
    )
    env.Prepend(CXXFLAGS=["-fomit-frame-pointer"])

env.Append(
    CPPPATH=[
        ".",
        "src/godot",
        "src/godot/platform/ios",
    ]
)

sources = Glob("src/*.cpp")
sources.append(Glob("src/*.mm"))

library_name = "godot_ios_midi.a"
library = env.StaticLibrary(target="bin/" + library_name, source=sources)

Default(library)

Help(opts.GenerateHelpText(env))
