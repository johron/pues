--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local lfs = require("lfs")
local json = require("pues.util.json")

require("pues.util.misc")

---Write a point
---@param name string
---@param lua_table table
local function write_point(name, lua_table)
    local json_string = json.encode(lua_table)
    io.write_file(PuesPath .. "points/" .. name .. ".json", json_string)
end

local points = {
    ["blank"] = {
        version = Version,
    },
    ["python"] = {
        version = Version,
        source = "python",
        readme = true,
        run = {
            "python3 src/main.py"
        },
    },
    ["nodejs"] = {
        version = Version,
        source = "nodejs",
        readme = true,
        run = {
            "node src/main.js"
        },
    },
    ["lua"] = {
        version = Version,
        source = "lua",
        readme = true,
        run = {
            "lua src/main.lua"
        },
    },
    ["gcc"] = {
        version = Version,
        source = "gcc",
        readme = true,
        build = {
            "gcc src/main.c -o out/main"
        },
        run = {
            "./out/main"
        }
    },
    ["arduino_uno"] = {
        version = Version,
        source = "arduino_uno",
        build = {
            "pio run"
        },
        run = {
            "pio run --target upload"
        }
    },
}

---Write premade points
local function write_points()
    if not io.exists(PuesPath) then
        lfs.mkdir(PuesPath)
    end

    if not io.exists(PuesPath .. "points/") then
        lfs.mkdir(PuesPath .. "points/")
    end

    if not io.exists(PuesPath .. "archives/") then
        lfs.mkdir(PuesPath .. "archives/")
    end

    for i, v in pairs(points) do
        write_point(i, v)
    end
end

local function has_name_of_point(name)
    for key, _ in pairs(points) do
      if key == name then
        return true
      end
    end
    return false
end

local function move_archives()
    local archives_path = nil

    local archive_paths = {
        "/usr/local/lib/luarocks/rocks-{lua_ver}/pues/{pues_ver}/archives/",
        "/usr/lib/luarocks/rocks-{lua_ver}/pues/{pues_ver}/archives/",
        "/lib/luarocks/rocks-{lua_ver}/pues/{pues_ver}/archives/",
        "{home}/.luarocks/lib/luarocks/rocks-{lua_ver}/pues/{pues_ver}/archives/"
    }

    for i, v in pairs(archive_paths) do
        local path = v:gsub("{lua_ver}", _VERSION:gsub("Lua ", "")):gsub("{pues_ver}", Version)
        path = path:gsub("{user}", string(os.getenv("HOME")))
        if io.exists(path) and not io.is_dir_empty(path) then
            archives_path = path
            break
        end
    end

    if Version == "scm-1" then
        local is_luarocks = false

        for path in string.gmatch(package.path, "([^;]+)") do
            if path:find("luarocks") then
                is_luarocks = true
                break
            end
        end

        if not is_luarocks then
            archives_path = "archives/"
        end
    end

    if archives_path == nil then
        print("pues: couldn't find the path for 'archives/', please download this folder from github")
        os.exit(1)
    end

    os.execute("cp -r " .. archives_path .. " " .. PuesPath)
end

local function reload_custom_points()
    for v in lfs.dir(PuesPath .. "points/") do
        local v = v:gsub(".json$", "")
        if not (v == "." or v == "..") then
            if not has_name_of_point(v) then
                local old_point_str = io.read_file(PuesPath .. "points/" .. v .. ".json")
                if old_point_str == nil then print("pues: error reading current point") os.exit(1) end
                local old_point = json.decode(old_point_str)

                local point = {
                    version = Version,
                    source = old_point["source"],
                    readme = old_point["readme"],
                    managed = old_point["managed"],
                    build = old_point["build"],
                    run = old_point["run"],
                }

                write_point(v, point)
            end
        end
    end
end

---Generates configs
---@param arg table Argument table
return function(arg)
    local subc = arg[2]
    if not subc then
        print("pues: specify configuration operation, see 'pues config --help'")
        os.exit(1)
    end

    if subc == "--help" or subc == "-h" then
        require("pues.command.help").config()
    elseif subc == "reload" then
        local terc = arg[3]
        if not terc then
            print("pues: missing argument for what that should be reloaded, see 'pues config --help'")
            os.exit(1)
        end

        if terc == "premade" then
            local agreed = assure("Are you sure? This will override your current premade points.")
            if not agreed then
                print("pues: operation aborted")
                os.exit(0)
            end

            move_archives()
            write_points()
        elseif terc == "custom" then
            local agreed = assure("Are you sure? This will update all custom points, which could break them.")
            if not agreed then
                print("pues: operation aborted")
                os.exit(0)
            end

            reload_custom_points()
        elseif terc == "all" then
            if arg[1] == "install" then
                print("Setting up for first run..")
            else
                local agreed = assure("Are you sure? This will rewrite and update all your configurations, which could break them.")
                if not agreed then
                    print("pues: operation aborted")
                end
            end

            write_points()
            move_archives()
            reload_custom_points()
        end
    elseif subc == "path" then
        printf("Pues path: '%s'", PuesPath)
    else
        printf("pues: '%s' is not a recognized subcommand of config", subc)
        os.exit(1)
    end
end