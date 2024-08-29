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

---Execute either build or run
---@param mode string|nil build|run|nil
return function(mode)
    -- TODO: legg til hjelp melding

    --local mode = mode or nil
    local config_file = io.read_file("config.json")
    if not config_file then
        print("pues: config.json does not exist")
        os.exit(1)
    end

    local config = json.decode(config_file)
    local default = config["default"]
    local version = config["version"]

    check_version(version, 3)

    local table

    if mode == "build" then
        table = config["build"]
    elseif mode == "run" then
        table = config["run"]
    else
        if default == "run" or default == "build" then
            mode = default
            table = config[default]
        end
    end

    -- TODO: fix error messages: weird with run and build stuff

    if not table or #table == 0 and table == nil then
        print("pues: run/build table is empty or not defined")
        os.exit(1)
    end

    for i, v in ipairs(table) do
        local handle = io.popen(v .. " 2>&1")
        if handle == nil then
            printf("pues: error executing '%s'", v)
            os.exit(1)
        end
        
        local result = handle:read("*a")
        handle:close()

        if result and result ~= "" then
            local cleaned = result:gsub("sh: line %d+: ", ""):gsub("\n", "")
            if cleaned ~= nil then
                print(cleaned)
            end
        end
    end
end