--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

local json = require("lib.json")
local lfs = require("lfs")

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

---Check if directory has contents
---@param path string
---@return boolean empty
function io.is_dir_empty(path)
	for entry in lfs.dir(path) do
        if entry ~= "." and entry ~= ".." then
            return false
        end
    end
    return true
end

---Get dir name
---@param path string
---@return string|nil
function io.dir_name(path)
	local name = ""
	for part in path:gmatch("([^/]+)") do
		name = part
	end

	return name
end

---Read global configuration
---@return table luatable
function _G.get_config()
	local config = io.read_file(PuesPath .. "config.json")
	if config == nil then print("pues: global configuration not found: please see 'pues config --help'") os.exit(1) end

	return json.decode(config)
end

---Read point configuration
---@param point string
---@return table luatable
function _G.get_point(point)
	local config = io.read_file(PuesPath .. "points/" .. point .. ".json")
	if config == nil then printf("pues: point '%s' not found: please make sure this point exists", point) os.exit(1) end

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

---Highest of two arguments
---@param x string
---@param y string
---@return number result x = 1, y = 2, same = 3
function _G.highest(x, y)
	local nx = x:gsub("%.", "")
	local ny = y:gsub("%.", "")

	if nx == ny then
		return 3
	elseif nx > ny then
		return 1
	else
		return 2
	end
end

---Check if version is outdated
---@param version string
---@param global boolean
function _G.check_version(version, global)
    local result = highest(Version, version)
    if result == 1 then
        local agreed
        if global then
            agreed = assure(string.format("Are you sure? Global config has an older version (%s) than current program version (%s). Using this config can have consequences.", version, Version))
        else
            agreed = assure(string.format("Are you sure? Point config has an older version (%s) than current program version (%s). Using this config can have consequences.", version, Version))
        end
        if not agreed then
            print("pues: operation aborted")
            os.exit(0)
        end
    elseif result == 2 then
        if global then
            printf("pues: global config version (%s) is higher than program version (%s)", version, Version)
        else
            printf("pues: point config version (%s) is higher than program version (%s)", version, Version)
        end
        os.exit(1)
    end
end