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
    local terc = arg[3]

    if not subc then
        print("pues: 'create' requires a secondary argument [name | point | --help|-h]")
        os.exit(1)
    end

    if subc == "--help" or subc == "-h" then
        require("src.command.help").create()
        os.exit(0)
    end

    local project_name = subc
    local point_name = nil

    local config = get_config()
    local global_version = config["version"]

    if not global_version or #global_version == 0 then
        print("pues: no version passed in global configuration")
        os.exit(1)
    end

    check_version(global_version, true)

    if terc then
        point_name = terc
    else
        local default_point = config["default"]
        if not default_point or #default_point == 0 then
            print("pues: default start point set in global configuration is not set")
            os.exit(0)
        end

        point_name = default_point
    end

    print(project_name, point_name)

    local point_path = PuesPath .. "points/" ..point_name .. ".json"

    if not io.exists(point_path) then
        print("pues: point supplied does not exist in ~/.pues/points/")
    end

    local point_json = io.read_file(point_path)
    if not point_json then
        print("pues: supplied point is empty")
        os.exit(1)
    end

    print(point_json)

    local point_table = json.decode(point_json)
    local version = point_table["version"]
    local source = point_table["source"]
    local readme = point_table["readme"]
    local build = point_table["build"]
    local run = point_table["run"]

    check_version(version, false)

    if io.dir_name(lfs.currentdir()) ~= project_name then
        if not io.exists(project_name) then
            lfs.mkdir(project_name)
            lfs.chdir(project_name)
        else
            if not io.is_dir_empty(project_name) then
                print("pues: folder already exists and is not empty")
                os.exit(1)
            end
            lfs.chdir(project_name)
        end
    else
        if not io.is_dir_empty(lfs.currentdir()) then
            print("pues: current folder is not empty")
            os.exit(1)
        end
    end

    local readme_str = string.format("# %s", project_name, point_name)
    -- if run then add # Running \n ```bash pues run```
    -- if build then --||--



    if readme == true then
        io.write_file("README.md", readme_str)
    end

    print(lfs.currentdir())
end