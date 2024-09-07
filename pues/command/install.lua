--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("pues.util.json")

require("pues.util.io")
require("pues.util.misc")

---Install project dependencies
---@param arg table
return function(arg)
    local subc = arg[2]
    if subc == "--help" or subc == "-h" then
        require("pues.command.help").short()
        os.exit(0)
    end

    local config_file = io.read_file("pues.json")
    if not config_file then
        print("pues: pues.json does not exist")
        os.exit(1)
    end

    local config = json.decode(config_file)
    local version = config["version"]

    check_version(version, true)

    local dependencies = config["dependencies"]

    if not dependencies then
        print("pues: no dependencies mentioned in configuration")
        os.exit(1)
    end

    for i, v in pairs(dependencies) do
        --print(i, json.encode(v))

        local command = v["command"]
        local packages = v["packages"]

        if not command or #command == 0 then
            print("pues: missing command property for the '%s' package manager in dependencies part of point", i)
            os.exit(1)
        end

        if not packages then
            print("pues: missing packages property for the '%s' package manager in dependencies part of point", i)
            os.exit(1)
        end

        print(command)
        print(json.encode(packages))
    end
end