--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("lib.json")

require("lib.util")

switch(#arg) { 
    [0] = function()
        println("usage: pues [-v | --verison]...")
        println("print usage and help")
	end,
	[1] = function()
        switch(arg[1]) {
            ["create"] = function() 
                println("pues create: requires second argument for thing")
            end,
            _index = function()
                println(string.format("pues: '%s' is not a pues command. See 'pues --help'", arg[1]))
            end,
        }
	end,
}