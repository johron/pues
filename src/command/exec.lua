--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("lib.json")

require("src.util")

local function loop_over_and_exec(conf, isrun, arg)
    local isrun = isrun or false
    local arg = arg or nil

    for i, v in ipairs(conf) do
        local add = ""

        if i == 1 and isrun then
            local newarg = {}

            if isrun then
                for i, v in ipairs(arg) do
                    if i ~= 1 then
                        table.insert(newarg, v)
                    end
                end
            end

            add = " " .. table.concat(newarg, " ")
        end

        local handle = io.popen(v .. add .. " 2>&1")
        if handle == nil then
            printf("pues: error executing '%s'", v)
            os.exit(1)
        end

        local result = handle:read("*a")
        handle:close()

        if result and result ~= "" then
            local cleaned = result:gsub("^sh: line %d+: ", ""):gsub("\n$", "")
            if cleaned ~= nil then
                print(cleaned)
            end
        end
    end
end

---Execute either build or run
---@param arg table
---@param mode string|nil build|run|nil
return function(arg, mode)
    local subc = arg[2]
    if subc == "--help" or subc == "-h" then
        require("src.command.help").short()
        os.exit(0)
    end

    local config_file = io.read_file("pues.json")
    if not config_file then
        print("pues: pues.json does not exist")
        os.exit(1)
    end

    local config = json.decode(config_file)
    local default = config["default"]
    local version = config["version"]

    check_version(version, 3)

    local conf

    if mode == "build" then
        conf = config["build"]
    elseif mode == "run" then
        conf = config["run"]
    else
        if default == "run" or default == "build" then
            mode = default
            conf = config[default]
        end
    end

    if mode == "build" then
        if not conf or #conf == 0 and conf == nil then
            print("pues: build table is empty or not defined")
            os.exit(1)
        end

        loop_over_and_exec(conf)
    elseif mode == "run" then
        if not conf or #conf == 0 and conf == nil then
            print("pues: run table is empty or not defined")
            os.exit(1)
        end

        loop_over_and_exec(conf, true, arg)
    else
        print("pues: missing 'default' property in pues.json")
        os.exit(1)
    end
end