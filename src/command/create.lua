--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("lib.json")
local lfs = require("lfs")

require("src.util")

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

    check_version(global_version, 1)

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

    local point_path = PuesPath .. "points/" ..point_name .. ".json"

    if not io.exists(point_path) then
        print("pues: point supplied does not exist in ~/.pues/points/")
    end

    local point_json = io.read_file(point_path)
    if not point_json then
        print("pues: supplied point is empty")
        os.exit(1)
    end

    local point_table = json.decode(point_json)
    local version = point_table["version"]
    local source = point_table["source"]
    local readme = point_table["readme"]
    local managed = point_table["managed"]
    local default = point_table["default"]
    local build = point_table["build"]
    local run = point_table["run"]

    check_version(version, 2)

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

    if managed == nil or managed == true then
        local local_config = {
            version = Version,
        }

        if default and (default == "run" or default == "build") then
            local_config.default = default
        end
        
        if build then
            local_config.build = build
            if not default then
                local_config.default = "build"
            end
        end

        if run then
            local_config.run = run
            
            if not default then
                if not build then
                    local_config.default = "run"
                end
            end
        end

        io.write_file("pues.json", json.encode(local_config))
    end

    if readme == true then
        local readme_str = string.format("# %s", project_name, point_name)

        if build then readme_str = readme_str .. "\n\n## Build\n- `pues build`" end
        if run then readme_str = readme_str .. "\n\n## Run\n- `pues run`" end

        io.write_file("README.md", readme_str)
    end

    io.extract_zip(PuesPath .. "archives/" .. source .. ".zip", "")
end