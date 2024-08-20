--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

--- Get user input.
-- @param msg Message before input.
-- @param type io.read input type: "n", "a", "l", "L"
function _G.input(msg, type)
	type = type or "l"
    printb(msg)
    return io.read(type)
end

-- printb -> bare print
function _G.printb(...)
	io.write(...)
end

-- printf -> print formatted
function _G.printf(msg, ...)
	print(string.format(msg, ...))
end