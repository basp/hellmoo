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

Or you can use the master loader which will load all modules that are suitable for public consumption:
```
lua dofile("/where/you/cloned/hum.lua")
```

This will load all the modules and additionally it will create a `hum` object so you can inspect the whole system by executing `lua hum`.

In order to make use of any *aliases* you will need to either import the Mudlet package (in the `_package` directory) or define them yourself using the reference in the `REF.md` (incomplete) specification.

## usage
Most of the modules have a very similar API (at least some `create`, `list` and `destroy` variant). After you loaded one of the modules you can always ask for help using the Lua API:
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

Another good way to inspect the modules is to just output the module object using the Lua API:
```
lua module
```

Which will show you a Lua definition of the specified module object. Remember to substitute `module` with one of the module names from the **overview** above.

Each module has its own more detailed documentation and reference, look at the `README` in their respective folders for more info on how to use them or use the built-in help.