--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

--- Get user input.
---@param msg string Message
---@param type string {"n", "a", "l", "L"}
function _G.input(msg, type)
	type = type or "l"
    printb(msg)
    return io.read(type)
end

---Barebones print.
---Wrapper for 'io.write'.
---@param ... any Message(s)
function _G.printb(...)
	io.write(...)
end

---Formatted print.
---@param msg string Message
---@param ... any To be concatinated
function _G.printf(msg, ...)
	print(string.format(msg, ...))
end

---Check if file exists
---@param path string
---@return boolean exists
function io.exists(path)
	print("path")
	local f=io.open(path, "r")
	if f~=nil then io.close(f) return true else return false end
end

---Read system pues configuration
---@return table lua_table
function _G.config()
	
end