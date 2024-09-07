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
        print("pues: not dependencies mentioned in configuration")
        os.exit(1)
    end

    print(config_file)
end