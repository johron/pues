--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johan Rong.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local function print_usage()
    print("usage: pues [-v | --version] [-h | --help]")
    print("            <command> [<args>]")
    print()
end

local help = {}

function help.config()
    print_usage()
    print("argument(s):")
    print("  reload")
    print("    all -> updates all configurations, including project configuration")
    print("           if working directory contains one, with new version numbers and")
    print("           fields that new versions may have (may break older configs)")
    print("    premade -> rewrites all the premade points")
    print("    custom -> rewrites all custom points")
    print("  path -> print out pues configuration path")
end

function help.create()
    print_usage()
    print("argument(s):")
    print("  <name> <point> -> the name of the proejct and the point you want to generate")
end

function help.license()
    print_usage()
    print("argument(s):")
    print("  <license> [<year>] [<author>] -> license a project")
    print("licenses:")
    print("  mit <year> <author> -> MIT License")
    print("  gpl-3.0 -> GNU General Public License version 3")
end

function help.manage()
    print_usage()
    print("argument(s):")
    print("  <point> -> the point you want to use")
end

function help.short()
    print_usage()
    print("commands:")
    print("  create     Create a new projcet")
    print("  config     Update your configurations and points")
    print("  license    Add a license to a project")
    print("  build      Run build commands from project configuration")
    print("  run        Execute run commands from project configuration")
    print()
    print("more help for each command with:")
    print("  'pues <command> --help'")
end

return help