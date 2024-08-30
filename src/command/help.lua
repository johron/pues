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
    print("  regen -> rewrites all configurations")
    print("  default <point> -> update global config to have new default point")
    print("  premade -> rewrites all the premade points")
    print("  update -> updates all configurations with new version numbers and")
    print("            fields that new versions may have (may break older configs)")
end

function help.create()
    print_usage()
    print("argument(s):")
    print("  <point> -> the point you want to generate")
end

---Shows short help message
function help.short()
    print_usage()
    print("commands:")
    print("  create <name> [<point>]")
    print("  config (regen | default | premade | update)")
    print("  build")
    print("  run")
    print()
    print("more help for each command with:")
    print("  'pues <command> --help'")
end

return help