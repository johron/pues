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

---Convert a project to a pues managed project
---@param arg table
return function(arg)
    local subc = arg[2]
    if not subc then
        print("pues: 'manage' requires a secondary argument [point | --help|-h]")
        os.exit(1)
    end

    if subc == "--help" or subc == "-h" then
        require("src.command.help").manage()
        os.exit(0)
    end

    local name = io.dir_name(lfs.currentdir())

    local terc = arg[3]
    if terc then
        name = terc
    end

    local config = get_config()

    local point_name

    if subc then
        point_name = subc
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
    local default = point_table["default"]
    local build = point_table["build"]
    local run = point_table["run"]

    check_version(version, 2)

    local local_config = {
        name = name,
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