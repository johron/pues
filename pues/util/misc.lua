--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("pues.util.json")

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
    if y == "scm-1" then
        return 3 -- if it's a developer version, don't care
    end

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
            agreed = assure(string.format("Are you sure? Blueprint config has an older version (%s) than current program version (%s). Using this config can have consequences.", version, Version))
        else
            agreed = assure(string.format("Are you sure? Project config has an older version (%s) than current program version (%s). Using this config can have consequences.", version, Version))
        end
        if not agreed then
            print("pues: operation aborted")
            os.exit(0)
        end
    elseif result == 2 then
        if project == false then
            printf("pues: blueprint config version (%s) is higher than program version (%s)", version, Version)
        else
            printf("pues: project config version (%s) is higher than program version (%s)", version, Version)
        end
        os.exit(1)
    end
end

local function execute_command(command)
    local handle = io.popen(command)
    if handle == nil then
        print("pues: error executing command for getting current user")
        os.exit(1)
    end

    local result = handle:read("*a")
    handle:close()
    return result:gsub("\n", "")
end

function _G.get_user()
    local wh_user = execute_command("whoami")
    if wh_user ~= "" and wh_user ~= "root" then
        return wh_user
    end

    local user = os.getenv("USER")
    if not user then
        user = execute_command("logname")
        if user == "" then
            user = os.getenv("LOGNAME")
        end
    end

    if user == "root" or wh_user == "root" then
        local sudo_user = os.getenv("SUDO_USER")
        if sudo_user then
            return sudo_user
        end

        local pkexec_uid = os.getenv("PKEXEC_UID")
        if pkexec_uid then
            local ent_user = execute_command("getent passwd " .. pkexec_uid .. " | cut -d: -f1")
            if ent_user ~= "" then
                return ent_user
            end
        end
    end

    print("pues: couldn't get current user")
    os.exit(1)
end