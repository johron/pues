--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

---Ask for assurance from user
---@param msg string
function _G.assure(msg)
    local answer = input(msg .. " [y/N] ")

    if answer:lower() ~= "y" then
        print("pues: operation aborted")
        os.exit(0)
    end
end

---Check if version is outdated
---@param version string
function _G.check_version(version)
    if Version ~= "scm-1" and version ~= "scm-1" then
        local major, minor, _ = version:match("^(%d+)%.(%d+)%-(%d+)$")
        local pmajor, pminor, _ = Version:match("^(%d+)%.(%d+)%-(%d+)$")

        local diff = pmajor - major
        if diff > 0 then -- pues version is higher
            printf("pues: given blueprint is too outdated, see 'pues config --help' for a possible fix, (%s>%s)", Version, version)
            os.exit(1)
        elseif diff < 0 then -- pues version is lower
            printf("pues: given blueprint is too new, update pues to use this blueprint, (%s<%s)", Version, version)
            os.exit(1)
        end

        diff = pminor - minor
        if diff > 0 then
            if diff > 2 then
                printf("pues: given blueprint is too outdated, see 'pues config --help' for a possible fix, (%s>%s)", Version, version)
                os.exit(1)
            else
                assure("Given blueprint is outdated, but it may still function. Do you want to try?")
            end
        elseif diff < 0 then
            printf("pues: given blueprint is too new, update pues to use this blueprint, (%s<%s)", Version, version)
            os.exit(1)
        end
    elseif version == "scm-1" and Version ~= "scm-1" then
        print("pues: cannot use scm-1 versioned blueprint")
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

---Get current user
---@return string user
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

function string.split(input, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in input:gmatch(input, sep) do
        table.insert(t, str)
    end
    return t
end