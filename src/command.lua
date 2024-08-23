--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local command = {}

---Create new project
---@param arg table Argument table
function command.create(arg)
    require("src.command.create")(arg)
end

---Generates global config
---@param arg table|nil Argument table
function command.config(arg)
    require("src.command.config")(arg)
end

---Shows help pages
---@param arg table|nil Argument table
function command.help(arg)
    require("src.command.help")(arg)
end

return command