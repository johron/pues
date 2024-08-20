local json = require("lib.json")

local command = {}

function command.create(arg)
    print("create command")
    print(json.encode(arg))
end

return command