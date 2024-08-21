local json = require("lib.json")

local command = {}

---Create command
---@param arg table Argument table
function command.create(arg)
    print("test")
    print(io.exists("README.md"))
    if #arg >= 2 then
        print("yes")
    else
        print("pues: too few arguments")
    end
end

return command