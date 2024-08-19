local lunajson = require("lunajson")

local json = {}

local function format(json_str)
    local indent = "  "
    local pretty_str = ""
    local level = 0

    local i = 1
    while i <= #json_str do
        local char = json_str:sub(i, i)

        if char == '{' or char == '[' then
            pretty_str = pretty_str .. char .. "\n"
            level = level + 1
            pretty_str = pretty_str .. string.rep(indent, level)
        elseif char == '}' or char == ']' then
            level = level - 1
            pretty_str = pretty_str .. "\n" .. string.rep(indent, level) .. char
        elseif char == ',' then
            pretty_str = pretty_str .. char .. "\n" .. string.rep(indent, level)
        else
            pretty_str = pretty_str .. char
        end

        i = i + 1
    end

    return pretty_str
end

function json.encode(lua_table)
    return format(lunajson.encode(lua_table))
end

function json.decode(json_str)
    return lunajson.decode(json_str)
end


return json