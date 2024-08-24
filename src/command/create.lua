--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("lib.json")
local lfs = require("lfs")

require("lib.util")

---Create new project
---@param arg table Argument table
return function(arg)
    local subc = arg[2]
    if subc and (subc == "--help" or subc == "-h") then
        require("src.command.help").create()
        os.exit(0)
    end

    local config = get_config()

    local default = config["default"]
    if (default == nil or string.len(default) == 0) and #arg < 2 then
        print("pues: no point specified and default is unspecified in global config")
        os.exit(1)
    end

    local version = config["version"]

    if version == nil then
        print("pues: no version passed in global config")
        os.exit(1)
    end

    if string.len(version) == 0 then
        print("pues: no version passed in global config")
        os.exit(1)
    end

    check_version(version, true)

    local point_name = subc
    if not point_name or string.len(point_name) == 0 then point_name = default end

    if not io.exists(PuesPath .. "points/" .. point_name .. ".json") then print("pues: specified or default point does not exist") os.exit(1) end
    local point_json = io.read_file(PuesPath .. "points/" .. point_name .. ".json")
    if point_json == nil then print("pues: error reading specified or default point") os.exit(1) end

    local point = json.decode(point_json)

    local version = point["version"]
    check_version(version, false)

    print(json.encode(point))
    local source = point["source"]
    local readme = point["readme"]
    local build = point["build"]
    local run = point["run"]
    -- most of theese are probably not necesarry for the project creating, most are for the run and build process, but
    -- they can be usefull for the project.json that will be made for the project, maybe the point config from ~/.pues
    -- should be copied to the project so it uses the correct things from project creation?

    --[[local name = input("name: ")
    if not name or #name == 0 then
        print("pues: operation aborted")
        os.exit(1)
    end

    if not io.is_dir_empty("./") and io.dir_name("./") then
        lfs.mkdir(path)
    end--]]
    -- bruk heller input fra 'subc', eller 'terc' hvis 'subc' er for point

    if source and #source ~= 0 then
        print("yes source")
    else
        print("no source")
    end

    if readme and #source ~= 0 then
        io.write_file(path .. "/README.md", string.format("# %s\n- Project generated with pues", name))
        print(path)
    end
end