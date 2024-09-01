local cjson = require("lunajson")

local json = {}

 ---Format table
 ---@param json_str string
 ---@return string formatted_json
 local function format(json_str)
    local indent = "    "
    local formatted_json = ""
    local level = 0

    local i = 1
    while i <= #json_str do
        local char = json_str:sub(i, i)

        if char == '{' or char == '[' then
            formatted_json = formatted_json .. char .. "\n"
            level = level + 1
            formatted_json = formatted_json .. string.rep(indent, level)
        elseif char == '}' or char == ']' then
            level = level - 1
            formatted_json = formatted_json .. "\n" .. string.rep(indent, level) .. char
        elseif char == ',' then
            formatted_json = formatted_json .. char .. "\n" .. string.rep(indent, level)
        elseif char == ":" then
            formatted_json = formatted_json .. char .. " "
        else
            formatted_json = formatted_json .. char
        end

        i = i + 1
    end

    return formatted_json
end

---Encode Lua table as JSON string
---@param lua_table table
---@return string json_str
function json.encode(lua_table)
    return format(cjson.encode(lua_table))
end

---Decode JSON string to Lua table
---@param json_str string
---@return table lua_table
function json.decode(json_str)
    return cjson.decode(json_str)
end

return json