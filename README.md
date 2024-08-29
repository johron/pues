# Pues
- project initializer and maybe other things
- only linux, will only support linux

## Configuration documentation for prebuilt configs (configs are converted to json)
```lua
local point = {
    version = -- latest version see `pues --version`. Pues will run older version configs, but will come with a confirmation that the user wants to run an older config
    source = -- nil (empty), direct link to archive internet, archive name without extention (will find it from the .pues/points folder) **must be tar.gz** archive
    readme = -- true or false
    managed = -- if does not exist then it is true, true|false|nothing
    default = -- "run" or "build" -- if run and build in config then build will be default if none is set or build if only build and so on
    build = {} -- shell command for building
    run = {} -- shell command for running
} -- if these (^^^) parameters are missing they will be treated as false or nil
```

- A point or start point is the project start point being used.

## Plan
- Hvis programmet ikke er i den rette mappen (~/.pues) så skal programmet flytte seg selv til denne plassen i tilegg til å lage mappen hvis den ikke er der.
- Kanskje det og skal genereres en blank konfigurasjon eller så skal brukeren gjøre det selv. (sist ser best ut)
- Programmet skal kunne installere seg selv ^^ de øvre punktene
- license adder, command som `pues license mit 'author' 'year'`, this would mean I have to add all popular licenses 'n stuff, I do not really want to do this
- where do the archives come from, the builtin ones. how can i have them without downloading them with the idea i have

## License
- This source code is subject to the terms of the GNU General Public License, version 3. [License](./LICENSE.md)
