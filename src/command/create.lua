--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("lib.json")

---Check if version is outdated
---@param version string
---@param global boolean
local function checkVersion(version, global)
    local result = highest(Version, version)
    if result == 1 then
        local agreed
        if global then
            agreed = assure(string.format("Are you sure? Global config has an older version (%s) than current program version (%s). Using this config can have consequences.", version, Version))
        else
            agreed = assure(string.format("Are you sure? Point config has an older version (%s) than current program version (%s). Using this config can have consequences.", version, Version))
        end
        if not agreed then
            print("pues: operation aborted")
            os.exit(0)
        end
    elseif result == 2 then
        if global then
            printf("pues: global config version (%s) is higher than program version (%s)", version, Version)
        else
            printf("pues: point config version (%s) is higher than program version (%s)", version, Version)
        end
        os.exit(1)
    end
end

return function(arg)
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

    checkVersion(version, true)

    local point_name = arg[2]
    if not point_name or string.len(point_name) == 0 then point_name = default end

    if not io.exists(PuesPath .. "points/" .. point_name .. ".json") then print("pues: specified or default point does not exist") os.exit(1) end
    local point_json = io.read_file(PuesPath .. "points/" .. point_name .. ".json")
    if point_json == nil then print("pues: error reading specified or default point") os.exit(1) end
    
    local point = json.decode(point_json)

    local version = point["version"]
    checkVersion(version, false)
    
    print(json.encode(point))
    local premade = point["premade"]
    local source = point["source"]
    local readme = point["readme"]
    local built = point["built"]
    local build = point["build"]
    local interpreted = point["interpreted"]
    local run = point["run"]
    -- most of theese are probably not necesarry for the project creating, most are for the run and build process, but
    -- they can be usefull for the project.json that will be made for the project, maybe the point config from ~/.pues
    -- should be copied to the project so it uses the correct things from project creation?

end