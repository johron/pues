--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("lib.json")
local command = require("src.command")

--- Get user input.
---@param msg string Message
---@param type string|nil {"n", "a", "l", "L"}
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
	local f=io.open(path, "r")
	if f~=nil then io.close(f) return true else return false end
end

---Reads a file
---@param path string
---@return string|nil
function io.read_file(path)
	if not io.exists(path) then return nil end

	local lines = {}
	for line in io.lines(path) do
		lines[#lines + 1]  = line
	end

	return table.concat(lines, "\n")
end

---Write content to a file
---@param path string
---@param content string
function io.write_file(path, content)
	local file = io.open(path,"w")
	if file == nil then print("pues: problem writing file") os.exit(1) end
	file:write(content)
	file:close()
end

---Read global configuration
---@return table luatable
function _G.get_config()
	local config = io.read_file(PuesPath .. "config.json")
	if config == nil then print("pues: global configuration not found: generating generic, please rerun") command.generate() os.exit(1) end

	return json.decode(config)
end

---Ask for assurance from user
---@param msg string
---@return boolean agreed
function _G.assure(msg)
	local answer = input(msg .. " [y/N] ")

	if answer:lower() == "y" then
		return true
	else
		return false
	end
end