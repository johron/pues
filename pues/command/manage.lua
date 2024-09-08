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

require("pues.util.misc")

---Convert a project to a pues managed project
---@param arg table
return function(arg)
    local subc = arg[2]
    if not subc then
        print("pues: 'manage' requires a secondary argument [blueprint | --help|-h]")
        os.exit(1)
    end

    if subc == "--help" or subc == "-h" then
        require("pues.command.help").manage()
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

    local blueprint_name

    if subc then
        blueprint_name = subc
    end

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
    local build = blueprint_table["build"]
    local run = blueprint_table["run"]
    local dependencies = blueprint_table["dependencies"]

    check_version(version)

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

    if dependencies then
        local_config.dependencies = dependencies
    end

    io.write_file("pues.json", json.encode(local_config))
end