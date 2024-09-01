--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

require("src.util.io")

Version = "1.0-1"
PuesPath = string.format("%s/.pues/", os.getenv("HOME"))

if not io.exists(PuesPath) then
    require("src.command.config")({"install", "all"})
end

if #arg == 0 then
    require("src.command.help").short()
elseif #arg >= 1 then
    local subc = arg[1]
    if subc == "--help" or subc == "-h" then
        require("src.command.help").short()
    elseif subc == "--version" or subc == "-v" then
        printf("Pues %s. Copyright (C) 2024 Johan Rong", Version)
    elseif subc == "create" or subc == "c" then
        require("src.command.create")(arg)
    elseif subc == "config" or subc == "conf" then
        require("src.command.config")(arg)
    elseif subc == "run" or subc == "r" then
        require("src.command.exec")(arg, "run")
    elseif subc == "build" or subc == "b" then
        require("src.command.exec")(arg, "build")
    elseif subc == "license" or subc == "l" then
        require("src.command.license")(arg)
    elseif subc == "manage" or subc == "m" then
        require("src.command.manage")(arg)
    else
        printf("pues: '%s' is not a pues command. See 'pues --help'", arg[1])
    end
    -- there is no next here since this will be handled by the respective command
end