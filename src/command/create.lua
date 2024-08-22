--[[ 
 - This file is part of Pues (https://github.com/johron/pues/).
 - Copyright (c) 2024 Johron and contributors.
 -
 - This source code is subject to the terms of the GNU General Public
 - License, version 3. If a copy of the GPL was not distributed with this
 - file, You can obtain one at: https://www.gnu.org/licenses/gpl-3.0.txt
 --]]

return function(arg)
    local config = get_config()
    print(require("lib.json").encode(config))
    
    local default = config["default"]
    if (default == nil or string.len(default) == 0) and #arg < 2 then
        print("pues: no point specified and default is unspecified")
        os.exit(1)
    end

    local chosen = arg[2]
    
    local version = config["version"]

    if version == nil then
        print("pues: no version passed in global config")
        os.exit(1)
    end

    if string.len(version) == 0 then
        print("pues: no version passed in global config")
        os.exit(1)
    end

    local result = highest(Version, version)
    print(Version, version)
    if result == 1 then
        local agreed = assure(string.format("Are you sure? Global config has an older version (%s) than current program version (%s). Using this config can have consequences.", version, Version))
        if not agreed then
            print("pues: operation aborted")
            os.exit(0)
        end
    elseif result == 2 then
        printf("pues: global config version (%s) is higher than program version (%s), what?", version, Version)
        os.exit(1)
    end

    local premade = config["premade"]

    local points = config["points"]
    local point
    if chosen == nil or string.len(chosen) == 0 then point = default else point = chosen end
    -- check if chosen is valid

    local source = point["source"]
    local readme = point["readme"]
    local built = point["built"]
    local build = point["build"]
    local interpreted = point["interpreted"]
    local run = point["run"]


    print("here")
end