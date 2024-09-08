# Pues
- Initialize and manage projects easily with json blueprints

## Install
```bash
luarocks install pues
```
- \*The dependency luazip is dependent on zzip which may not be preinstalled\*

## Todo
- [ ] Make error messages more uniform throughout the application
- [ ] Change version notifying to only happen if the gap is too big, remake the version checking system
- [ ] Add ability for pues run to take input in programs
- [ ] Update this readme to have better help on how to test/run/build and develop
- [ ] Write better comments for functions or give better names

## Blueprint documentation
- `version`: The version this blueprint was made for
- `source`?: Name of zip archive located in '~/.config/pues/archives/' without extention
- `readme`?: If a readme should be included
    - default = false
- `managed`?: If the project should be managed by pues
    - default = true
- `build`?: Table of shell commands
- `run`?: Table of shell commands
- `marked`?: Files where '%{name}' should be replaced with project name
- `dependencies`?: Project dependencies
    - Table with name as the package manager name
        - `command`: The command to install with the package manager
        - `packages`: Table with the packages to be installed

## Example Blueprint
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
    ],
    "dependencies": {
        "npm": {
            "command": "npm install",
            "packages": [
                "example@2.1.5",
                "package"
            ]
        }
    }
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
- Using the Dockerfile is recommended as it keeps everything nice and isolated

### From source control
```bash
lua pues/main.lua
```

### From rockspec built version
```bash
pues
```
## License
- This source code is subject to the terms of the GNU General Public License, version 3. [License](./LICENSE.md)
