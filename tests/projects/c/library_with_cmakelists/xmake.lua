add_rules("mode.debug", "mode.release")

local cachedir = path.join(os.scriptdir(), "build", "cache")
local packagesdir = path.join(os.scriptdir(), "build", "packages")
package("foo")
    add_deps("cmake")
    set_sourcedir("foo")
    set_cachedir(cachedir)
    set_installdir(packagesdir)
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs, {buildir = "build"})
    end)
    on_test(function (package)
        assert(package:has_cincludes("foo.h"))
    end)
package_end()

add_requires("foo")

target("demo")
    set_kind("binary")
    add_files("src/main.c")
    add_packages("foo")

