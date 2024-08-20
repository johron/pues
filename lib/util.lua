--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

function _G.switch(expr)
	return function(cases)
		setmetatable(cases, cases)
		local f = cases[expr]
		if f then
			f()
		end
	end
end

function _G.input(message, type)
	type = type or "*l"
    print(message)
    return io.read(type)
end

function _G.print(message)
	io.write(message)
end

function _G.println(message)
	io.write(message .. "\n")
end