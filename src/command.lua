local json = require("lib.json")

local command = {}

---Create command
---@param arg table Argument table
function command.create(arg)
    if #arg >= 2 then
        config()
    else
        print("pues: too few arguments")
    end
end

return command