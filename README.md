# Pues
- Project initializer and runner

## Install
```bash
luarocks install pues
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

## License
- This source code is subject to the terms of the GNU General Public License, version 3. [License](./LICENSE.md)
