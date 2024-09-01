--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("src.util.util")
local lfs = require("lfs")

require("src.util.util")

---Create new project
---@param arg table Argument table
return function(arg)
    local subc = arg[2]
    local terc = arg[3]

    if not subc then
        print("pues: 'create' requires a secondary argument for name | --help|-h]")
        os.exit(1)
    end

    if subc == "--help" or subc == "-h" then
        require("src.command.help").create()
        os.exit(0)
    end

    local project_name = subc

    if not terc then
        print("pues: requires tertiary argument for point, see 'pues create --help'")
        os.exit(1)
    end

    local point_name = terc

    local point_path = PuesPath .. "points/" ..point_name .. ".json"

    if not io.exists(point_path) then
        printf("pues: supplied point '%s' does not exist in ~/.pues/points/", point_name)
        os.exit(1)
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
    local build = point_table["build"]
    local run = point_table["run"]
    local marked = point_table["marked"]

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

    if managed == nil or managed == true then
        local local_config = {
            name = project_name,
            version = Version,
        }

        if build then
            local_config.build = build
        end

        if run then
            local_config.run = run
        end

        io.write_file("pues.json", json.encode(local_config))
    end

    if readme == true then
        local readme_str = string.format("# %s", project_name, point_name)

        if build then readme_str = readme_str .. "\n\n## Build\n- `pues build`" end
        if run then readme_str = readme_str .. "\n\n## Run\n- `pues run`" end

        io.write_file("README.md", readme_str)
    end

    if source or (source and #source ~= 0) or source ~= nil then
        io.extract_zip(PuesPath .. "archives/" .. source .. ".zip", "")

        if marked or (marked and #marked ~= 0) or marked ~= nil then
            for i, v in ipairs(marked) do
                if not io.exists(v) then
                    printf("pues: path marked for replacing does not exist: '%s'", v)
                    os.exit(1)
                end

                local content = io.read_file(v)
                if content == nil then content = "" end
                content = content:gsub("%%{name}", project_name)
                io.write_file(v, content)
            end
        end
    end
end