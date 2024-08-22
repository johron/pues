# Pues
- project initializer and maybe other things
- only linux, will only support linux

## Configuration documentation for prebuilt configs (configs are converted to json)
```lua
local table = {
    default = -- default point ran with `pues create` without any specifier
    version = -- latest version see `pues --version`. Pues will run older version configs, but will come with a confirmation that the user wants to run an older config
    premade = -- only for premade configs shipped by pues do not include this or the config will be replaced when pues updates
    points = {
        example = {
            source = -- nil (empty), direct link to archive internet, archive name without extention (will find it from the .pues/points folder) **must be tar.gz** archive
            readme = -- true or false (includes readme or not)
            built = -- true or false (is the language built, gives access to build and run parameters)
            build = -- shell command, only availbale with `interpreted = true`
            interpreted = -- true or false (is the language interpreted, gives access to run parameter)
            run = -- shell command, only available with `interpreted = true` or `built = true`
        } -- if these (^^^) parameters are missing they will be treated as false or nil
    }
}
```

- A point or start point is the project start point being used.

## Plan
- Hvis programmet ikke er i den rette mappen (~/.pues) så skal programmet flytte seg selv til denne plassen i tilegg til å lage mappen hvis den ikke er der.
- Kanskje det og skal genereres en blank konfigurasjon eller så skal brukeren gjøre det selv. (sist ser best ut)
- Programmet skal kunne installere seg selv ^^ de øvre punktene
- Fullfør write_config() og write_file() osv lag program!!

## License
- This source code is subject to the terms of the GNU General Public License, version 3. [License](./LICENSE.md)