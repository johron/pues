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

---Write a blueprint
---@param name string
---@param lua_table table
local function write_blueprint(name, lua_table)
    local json_string = json.encode(lua_table)
    io.write_file(PuesPath .. "blueprints/" .. name .. ".json", json_string)
end

local blueprints = {
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
        dependencies = {
            luarocks = {
                command = "luarocks install",
                packages = {
                    "lua-cjson"
                }
            }
        }
    },
    ["gcc"] = {
        version = Version,
        source = "gcc",
        readme = true,
        build = {
            "gcc src/main.c -o out/main"
        },
        run = {
            "gcc src/main.c -o out/main && ./out/main"
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

---Write premade blueprints
local function write_blueprints()
    local p = PuesPath:gsub("/pues", "")
    if not io.exists(p) then
        lfs.mkdir(p)
    end

    if not io.exists(PuesPath) then
        lfs.mkdir(PuesPath)
    end

    if not io.exists(PuesPath .. "blueprints/") then
        lfs.mkdir(PuesPath .. "blueprints/")
    end

    if not io.exists(PuesPath .. "archives/") then
        lfs.mkdir(PuesPath .. "archives/")
    end

    for i, v in pairs(blueprints) do
        write_blueprint(i, v)
    end
end

local function has_name_of_blueprint(name)
    for key, _ in pairs(blueprints) do
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

    if archives_path:match("{home}") then
        local home = os.getenv("HOME")

        if not home then
            print("pues: couldn't get the user's home directory")
            os.exit(1)
        end

        archives_path = archives_path:gsub("{home}", home)
    end

    os.execute("cp -r " .. archives_path .. " " .. PuesPath)
end

local function reload_custom_blueprints()
    for v in lfs.dir(PuesPath .. "blueprints/") do
        local v = v:gsub(".json$", "")
        if not (v == "." or v == "..") then
            if not has_name_of_blueprint(v) then
                local old_blueprint_str = io.read_file(PuesPath .. "blueprints/" .. v .. ".json")
                if old_blueprint_str == nil then
                    print("pues: error reading current blueprint, blueprint does not exist or is empty")
                    os.exit(1)
                end

                local old_blueprint = json.decode(old_blueprint_str)
                local blueprint = {
                    version = Version,
                    source = old_blueprint["source"],
                    readme = old_blueprint["readme"],
                    managed = old_blueprint["managed"],
                    build = old_blueprint["build"],
                    run = old_blueprint["run"],
                    dependencies = old_blueprint["dependencies"],
                }

                write_blueprint(v, blueprint)
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
            assure("Are you sure? This will override your current premade blueprints.")

            move_archives()
            write_blueprints()
        elseif terc == "custom" then
            assure("Are you sure? This will update all custom blueprints, which could break them.")

            reload_custom_blueprints()
        elseif terc == "all" then
            if arg[1] == "setup" then
                print("Setting up for first run..")
            else
                assure("Are you sure? This will rewrite and update all your configurations, which could break them.")
            end

            write_blueprints()
            move_archives()
            reload_custom_blueprints()
        end
    elseif subc == "path" then
        printf("Pues path: '%s'", PuesPath)
    else
        printf("pues: '%s' is not a recognized subcommand of config", subc)
        os.exit(1)
    end
end