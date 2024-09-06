--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

require("pues.util.io")

Version = "scm-1"
PuesPath = string.format("%s/.pues/", os.getenv("HOME"))

if not io.exists(PuesPath) or io.is_dir_empty(PuesPath) then
    require("pues.command.config")({"setup", "reload", "all"})
end

if #arg == 0 then
    require("pues.command.help").short()
elseif #arg >= 1 then
    local subc = arg[1]
    if subc == "--help" or subc == "-h" then
        require("pues.command.help").short()
    elseif subc == "--version" or subc == "-v" then
        printf("Pues %s. Copyright (C) 2024 Johan Rong", Version)
    elseif subc == "create" or subc == "c" then
        require("pues.command.create")(arg)
    elseif subc == "config" or subc == "conf" then
        require("pues.command.config")(arg)
    elseif subc == "run" or subc == "r" then
        require("pues.command.exec")(arg, "run")
    elseif subc == "build" or subc == "b" then
        require("pues.command.exec")(arg, "build")
    elseif subc == "license" or subc == "l" then
        require("pues.command.license")(arg)
    elseif subc == "manage" or subc == "m" then
        require("pues.command.manage")(arg)
    elseif subc == "install" or subc == "i" then
        require("pues.command.install")(arg)
    else
        printf("pues: '%s' is not a pues command. See 'pues --help'", arg[1])
    end
    -- there is no next here since this will be handled by the respective command
end