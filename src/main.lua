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
PuesPath = string.format("%s/.pues/", os.getenv("HOME"))

local function showhelp()
    print("usage: pues [-v | --version] [-h | --help]")
    print()
    print("commands")
    print("  config|conf   Generate configuraitons")
    print("  create|c      Create a new project")
    print("  run|r         Run project configured by config file")
end

if #arg == 0 then
    showhelp()
elseif #arg >= 1 then
    local subc = arg[1]
    if subc == "--help" or subc == "-h" then
        showhelp()
        if arg[2] then print("pues: command specific help pages not implemented") end
    elseif subc == "--version" or subc == "-v" then
        printf("Pues %s. Copyright (C) 2024 Johron", Version)
    elseif subc == "create" or subc == "c" then
        command.create(arg)
    elseif subc == "config" or subc == "conf" then
        command.config(arg)
    else
        printf("pues: '%s' is not a pues command. See 'pues --help'", arg[1])
    end
    -- there is no next here since this will be handled by the respective command
end