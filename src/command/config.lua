--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local lfs = require("lfs")
local json = require("lib.json")

---Writes a global config
---@param lua_table table
local function write_config(lua_table)
    local json_string = json.encode(lua_table)

    if not io.exists(PuesPath) then
        lfs.mkdir(PuesPath)
    end

    io.write_file(PuesPath .. "config.json", json_string)
end

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
    }
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

---Generates global config
---@param arg table Argument table
return function(arg)
    local subc = arg[2]
    if not subc then print("pues: specify configuration operation, see 'pues config --help'") os.exit(1) end

    if subc == "--help" or subc == "-h" then
        require("src.command.help").config()
    elseif subc == "regen" then
        write_config({
            default = "blank",
            version = Version,
        })

        write_points()
    elseif subc == "default" then
        local terc = arg[3]
        if not terc then print("pues: specify what the default should be") os.exit(1) end

        write_config({
            default = terc,
            version = Version,
        })
    elseif subc == "premade" then
        local agreed = assure("Are you sure? This will override your current premade points.")
        if not agreed then
            print("pues: operation aborted")
            os.exit(0)
        end

        write_points()
    elseif subc == "update" then
        local default = get_config()["default"]
        if not default then default = nil end

        local agreed = assure("Are you sure? This will rewrite all your configurations, which could break them.")
        if not agreed then
            print("pues: operation aborted")
        end

        write_config({
            default = default,
            version = Version,
        })

        write_points()

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
                        default = old_point["default"],
                        build = old_point["build"],
                        run = old_point["run"],
                    }

                    write_point(v, point)
                end
            end
        end
    elseif subc == "path" then
        printf("Pues path: '%s'", PuesPath)
    else
        printf("pues: '%s' is not a recognized subcommand of config", subc)
        os.exit(1)
    end
end