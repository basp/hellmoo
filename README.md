# hellmoo utils for mudlet
This is a collection of **Mudlet** modules that are intended to be used in **HellMOO** but might be useful more generally for other MUD/MOO style games as well.

## overview
The whole package consists of a variety of modules that can be used independently of eachother. There's no dependencies to worry about.

* `delay` executes a piece of code in the future
* `swatch` helps you to keep track of durations (it's a stopwatch)
* `ticker` executes code on regular intervals
* `action` triggers code on patterns of output
* `mapper` is a mapper API tailored to HellMOO

## setup
Basically you just clone this repository somewhere and use the `dofile` function to load all or any of the modules.
```
lua dofile("/where/you/cloned/module/module.lua")
```

## usage
Most of the modules have a very similar API. After you loaded one of the modules you can always ask for help using the Lua API:
```
lua module:help()
```

Or using one of the aliases:
```
module help
```

Or you can just type the module name which does the same:
```
module
```

Another good way to inspect the modules is to just output the module object using the lua API:
```
lua module
```

Which will show you a Lua definition of the specified module object.