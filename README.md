# Pues
- Project initializer and runner

## Install
```bash
luarocks install pues
```

## Todo
- [ ] Adding a way to install project dependencies from package managers point syntax like this?:
```json
{
    "dependencies": {
        "npm install": [ // the command to install the dependency
            "typescript" // the dependency (npm install typescript)
        ],
        "luarocks install": [
            "luafilesystem"
        ]
    }
}
```

## Point documentation
- `version`: The version this point was made for
- `source`?: Name of zip archive located in '~/.pues/archives/' without extention
- `readme`?: If a readme should be included
    - default = false
- `managed`?: If the project should be managed by pues
    - default = true
- `build`?: Table of shell commands
- `run`?: Table of shell commands
- `marked`?: Files where '%{name}' should be replaced with project name

## Example Point
```json
{
    "version": "0.0.1",
    "source": "example",
    "readme": true,
    "managed": true,
    "build": [
        "tsc src/main.ts"
    ],
    "run": [
        "ts-node src/main.ts"
    ],
    "marked": [
        "package.json"
    ]
}
```

## Building
- Make sure necessary dependencies are installed, see latest rockspec
```bash
luarocks make rockspecs/pues-(version).rockspec
```


## Testing / Running local project
- Make sure pues is installed as the scm-1 version if you have built by luarocks to test or **remove** pues.
    - This is because lua tries running the installed modules instead of the local modules from source control.
- Make sure necessary dependencies are installed, see latest rockspec

### From source control
```bash
lua pues/main.lua
```

### From luarocks built scm-1 version
```bash
pues
```
## License
- This source code is subject to the terms of the GNU General Public License, version 3. [License](./LICENSE.md)
