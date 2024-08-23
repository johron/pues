--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
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

local function write_point(name, lua_table)
    print(name, json.encode(lua_table))

    local json_string = json.encode(lua_table)
    io.write_file(PuesPath .. "points/" .. name .. ".json", json_string)
end

local points = {
    ["generic"] = {
        version = Version,
        premade = true,
    },
    ["python"] = {
        version = Version,
        premade = true,
        source = "python",
        readme = true,
        interpreted = true,
        run = "python3 %file",
    }
}

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

return function(arg)
    local subc = arg[2]
    if subc == nil then
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
    end
end