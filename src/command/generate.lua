--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("lib.json")

---@return table lua_table Outputted configuration as table
local function generate_generic()
    local table = {
        default = "blank",
        version = Version,
        points = {
            blank = {}
        }
    }

    return table
end

local configs = {
    ["generic"] = generate_generic,
}

---Writes a global config
---@param lua_table table
local function write_config(lua_table)
    local json_string = json.encode(lua_table)
    io.
end

return function(arg)
    if #arg <= 1 then -- no extra argument: pues generate
        local lua_table = configs["generic"]()
        write_config(lua_table)
    else
        local subc = arg[2]
        if not configs[subc] then printf("pues: '%s' is not a predefined global configuration, see 'pues --help generate'", subc) os.exit() end

        local lua_table = configs[subc]()
        write_config(lua_table)
    end
end