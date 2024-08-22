--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local command = require("src.command")

require("lib.util")

Version = "0.0.1"

local function showhelp()
    print("usage: pues [-v | --version] [-h | --help]")
    print()
    print("commands")
    print("  create    Create a new project")
    print("  run       Run project configured by config file")
end

if #arg == 0 then
    showhelp()
elseif #arg >= 1 then
    local subc = arg[1]
    if subc == "--help" or subc == "-h" then
        showhelp()
    elseif subc == "--version" or subc == "-v" then
        printf("pues version %s", Version)
    elseif subc == "create" or subc == "c" then
        command.create(arg)
    elseif subc == "generate" or subc == "gen" or subc == "g" then
        command.generate(arg)
    else
        printf("pues: '%s' is not a pues command. See 'pues --help'", arg[1])
    end
    -- there is no next here since this will be handled by the respective command
end