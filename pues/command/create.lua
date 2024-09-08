--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("pues.util.json")
local lfs = require("lfs")

require("pues.util.io")
require("pues.util.misc")

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
        require("pues.command.help").create()
        os.exit(0)
    end

    local project_name = subc

    if not terc then
        print("pues: requires tertiary argument for blueprint, see 'pues create --help'")
        os.exit(1)
    end

    local blueprint_name = terc

    local blueprint_path = PuesPath .. "blueprints/" .. blueprint_name .. ".json"

    if not io.exists(blueprint_path) then
        printf("pues: supplied blueprint '%s' does not exist", blueprint_name)
        os.exit(1)
    end

    local blueprint_json = io.read_file(blueprint_path)
    if not blueprint_json then
        print("pues: supplied blueprint is empty")
        os.exit(1)
    end

    local blueprint_table = json.decode(blueprint_json)
    local version = blueprint_table["version"]
    local source = blueprint_table["source"]
    local readme = blueprint_table["readme"]
    local managed = blueprint_table["managed"]
    local build = blueprint_table["build"]
    local run = blueprint_table["run"]
    local marked = blueprint_table["marked"]
    local dependencies = blueprint_table["dependencies"]

    check_version(version)

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

        if dependencies then
            local_config.dependencies = dependencies
        end

        io.write_file("pues.json", json.encode(local_config))
    end

    if readme == true then
        local readme_str = string.format("# %s", project_name, blueprint_name)

        if build then readme_str = readme_str .. "\n\n## Build\n- 'pues build'" end
        if run then readme_str = readme_str .. "\n\n## Run\n- 'pues run'" end

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