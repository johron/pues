--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("src.util")
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

    if io.exists("pues.json") then
        print("pues: current folder is already managed by pues")
        os.exit(1)
    end

    local name = io.dir_name(lfs.currentdir())

    local terc = arg[3]
    if terc then
        name = terc
    end

    local point_name

    if subc then
        point_name = subc
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
    local build = point_table["build"]
    local run = point_table["run"]

    check_version(version, false)

    local local_config = {
        name = name,
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