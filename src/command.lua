--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("lib.json")

local command = {}

---Create command
---@param arg table Argument table
function command.create(arg)
    if #arg >= 2 then
        config()
    else
        print("pues: too few arguments")
    end
end

return command