local json = require("lib.json")
local input = require("lib.input")

if #arg == 0 then
    print("usage: pues [-v | --verison]...")
    print("print usage and help")
elseif #arg == 1 then
    if arg[1] == "create" then
        print("pues create: requires second argument for thing")
    else
        print(string.format("pues: '%s' is not a pues command. See 'pues --help'", arg[1]))
    end
end