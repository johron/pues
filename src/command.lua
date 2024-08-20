local json = require("lib.json")

local command = {}

---Create command
---@param arg table Argument table
function command.create(arg)
    print("create command")
    print(json.encode(arg))
end

return command