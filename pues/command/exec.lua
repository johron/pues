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

local function loop_over_and_exec(conf, arg)
    local curr_arg = 2

    for _, v in pairs(conf) do
        local words = {}
        for word in v:gmatch("%S+") do
            if word == "%{arg}" then
                if not arg[curr_arg] then
                    printf("pues: configuration expects (an) argument(s): '%s'", v)
                    os.exit(1)
                end
                table.insert(words, arg[curr_arg])
                curr_arg = curr_arg + 1
            else
                table.insert(words, word)
            end
        end
        v = table.concat(words, " ")

        local error_code = os.execute(v .. " 2>&1")
        if error_code ~= 0 then
            os.exit(1)
        end
    end
end

---Execute either build or run
---@param arg table
---@param mode string|nil build|run|nil
return function(arg, mode)
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

    check_version(version)

    local conf

    if mode == "build" then
        conf = config["build"]
    elseif mode == "run" then
        conf = config["run"]
    end

    if mode == "build" then
        if not conf or #conf == 0 and conf == nil then
            print("pues: build table is empty or not defined")
            os.exit(1)
        end

        loop_over_and_exec(conf, arg)
    elseif mode == "run" then
        if not conf or #conf == 0 and conf == nil then
            print("pues: run table is empty or not defined")
            os.exit(1)
        end

        loop_over_and_exec(conf, arg)
    else
        print("pues: mode is wrong?")
        os.exit(1)
    end
end