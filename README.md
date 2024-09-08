# Pues
- Initialize and manage projects easily with json blueprints

## Install
- see [dependencies](#dependencies) before installation
```bash
luarocks install pues
pues --version
```

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

## Dependencies
- zzip.h, can be installed with 'apt install zziplib-dev', 'dnf install zziplib-devel'
- for rest see latest rockspec in [rockspecs](./rockspecs/), these are installed automatically when using luarocks

## Building with luarocks
```bash
luarocks make rockspecs/pues-<version>.rockspec
```

## Testing
- Using the docker and the provided [Dockerfile](./Dockerfile) is recommended when testing

### With luarocks (recommended)
```bash
luarocks make rockspecs/pues-<version>.rockspec
pues --version
```

### Without luarocks
```bash
lua pues/main.lua --version
```

## License
- This source code is subject to the terms of the GNU General Public License, version 3. [License](./LICENSE.md)
