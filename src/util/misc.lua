--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("src.util.json")

---Read point configuration
 ---@param point string
 ---@return table luatable
 function _G.get_point(point)
    local config = io.read_file(PuesPath .. "points/" .. point .. ".json")
    if config == nil then printf("pues: point '%s' not found: please make sure this point exists", point) os.exit(1) end

    return json.decode(config)
end

---Ask for assurance from user
---@param msg string
---@return boolean agreed
function _G.assure(msg)
    local answer = input(msg .. " [y/N] ")

    if answer:lower() == "y" then
        return true
    else
        return false
    end
end

---Highest of two arguments
---@param x string
---@param y string
---@return number result x = 1, y = 2, same = 3
function _G.highest(x, y)
    local nx = x:gsub("%.", ""):gsub("%-", "")
    local ny = y:gsub("%.", ""):gsub("%-", "")

    if nx == ny then
        return 3
    elseif nx > ny then
        return 1
    else
        return 2
    end
end

---Check if version is outdated
---@param version string
---@param project boolean
function _G.check_version(version, project)
    local result = highest(Version, version)
    if result == 1 then
        local agreed
        if project == false then
            agreed = assure(string.format("Are you sure? Point config has an older version (%s) than current program version (%s). Using this config can have consequences.", version, Version))
        else
            agreed = assure(string.format("Are you sure? Project config has an older version (%s) than current program version (%s). Using this config can have consequences.", version, Version))
        end
        if not agreed then
            print("pues: operation aborted")
            os.exit(0)
        end
    elseif result == 2 then
        if project == false then
            printf("pues: point config version (%s) is higher than program version (%s)", version, Version)
        else
            printf("pues: project config version (%s) is higher than program version (%s)", version, Version)
        end
        os.exit(1)
    end
end