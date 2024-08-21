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

---Exits the program and gives print in same function
---@param ... string Exit message
function _G.exit(...)
	print(...)
	os.exit()
end

---Formatted exit print.
---@param msg string Exit message
---@param ... any To be concatinated
function _G.exitf(msg, ...)
	print(string.format(msg, ...))
	os.exit()
end

---Check if file exists
---@param path string
---@return boolean exists
function io.exists(path)
	local f=io.open(path, "r")
	if f~=nil then io.close(f) return true else return false end
end

---Reads a file
---@param path string
---@return nil|string
function io.read_file(path)
	if not io.exists(path) then return nil end

	local lines = {}
	for line in io.lines(path) do
		lines[#lines + 1]  = line
	end

	return table.concat(lines, "\n")
end

---Read system pues configuration
---@return table|nil luatable
function _G.config()
	local config = io.read_file(string.format("%s/.bashrcc", os.getenv("HOME")))
	if config == nil then exit("pues: system pues configuration not found: generating... (not implemented)") end
	print(config)
	return {}
end