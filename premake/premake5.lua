-- premake5.lua
--[[
Usage examples:
    for windows: premake5.exe --os=windows vs2015
    fot linux:   premake5.exe --os=linux gmake
]]

workspace "LuaPbIntf"
	location (_ACTION)  -- subdir vs2015 (or gmake, ...)
	configurations { "Release", "Debug" }
	platforms { "x64", "x32" }

project "LuaPbIntf"
    kind "StaticLib"
    targetname "luapbintf"
    targetprefix ""  -- linux: luapbintf.so
    targetextension ".a"
    language "C++"
    cppdialect "C++11"
    flags {
        --"C++11",
        --"StaticRuntime",  -- for protobuf
    }
    files {
        "../src/**.h",
        "../src/**.cpp",
        "../test/test.lua",
        "../test/*.proto",
    }
    includedirs {
        "../src",
        "../../protobuf/include",
        "../../tolua_runtime/luajit-2.1/src",
        --"../third_party/lua/src",
        --"/mingw64/include/lua5.1",
        "../third_party/lua-intf",
        --"../third_party/protobuf/src",
    }
    libdirs {
        "../third_party/lib",
    }

    --[[
    From: https://github.com/SteveKChiu/lua-intf
    By default LuaIntf expect the Lua library to build under C++.
    If you really want to use Lua library compiled under C,
    you can define LUAINTF_LINK_LUA_COMPILED_IN_CXX to 0:
    --]]
    --defines { "LUAINTF_LINK_LUA_COMPILED_IN_CXX=0" }

    filter "configurations:Debug"
        symbols "On"
        --flags { "Symbols" }
        libdirs {
            "../third_party/lib/Debug",
            "/mingw64/lib",
        }
    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"
        libdirs {
            "../third_party/lib/Release",
            "/mingw64/lib", 
        }
    filter { "system:windows" }
        links { "liblua" }
    filter { "system:windows", "Debug" }
        links { "libprotobufd" }
    filter { "system:windows", "Release" }
        links { "libprotobuf" }
    filter { "system:linux" }
        links { "protobuf" }

-- End of project "LuaPbIntf"
