--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local lfs = require("lfs")
local json = require("lib.json")

local configs = {
    ["generic"] = function()
        return {
            default = "blank",
            version = Version,
            premade = true,
            points = {
                blank = {}
            }
        }
    end,
    ["python"] = function()
        return {
            default = "python",
            version = Version,
            premade = true,
            points = {
                python = {
                    source = "python",
                    readme = true,
                    interpreted = true,
                    run = "python3"
                }
            }
        }
    end,
}

---Writes a global config
---@param lua_table table
local function write_config(lua_table)
    local json_string = json.encode(lua_table)

    if not io.exists(PuesPath) then
        lfs.mkdir(PuesPath)
    end

    if io.exists(PuesPath .. "config.json") then
        local agreed = assure("Are you sure? This will override your current configuration.")
        if not agreed then
            print("pues: operation aborted")
            os.exit(0)
        end
    end

    io.write_file(PuesPath .. "config.json", json_string)
end

return function(arg)
    if #arg <= 1 then -- no extra argument: pues generate
        local lua_table = configs["generic"]()
        write_config(lua_table)
    else
        local subc = arg[2]
        if not configs[subc] then printf("pues: '%s' is not a predefined global configuration, see 'pues --help generate'", subc) os.exit(1) end

        local lua_table = configs[subc]()
        write_config(lua_table)
    end
end