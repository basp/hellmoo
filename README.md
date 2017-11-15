# hellmoo utils for mudlet
This is a collection of **Mudlet** modules that are intended to be used in **HellMOO** but might be useful more generally for other MUD/MOO style games as well.

## overview
The whole package consists of a variety of modules that can be used independently of eachother. There's no dependencies to worry about.

* `delay` executes a piece of code in the future
* `swatch` helps you to keep track of durations (it's a stopwatch)
* `ticker` executes code on regular intervals
* `action` triggers code on patterns of output
* `mapper` is a mapper API tailored to HellMOO
* `gag` removes lines from output completely

## usage
The recommended way to load modules is using the `hum` system module. First, we need to load (or *source*) this module into our client session. 
```
lua dofile([[/scripts/hellmoo/hum.lua]])
```

Now that we have `hum` loaded we can either load all known modules using the `loadall` function:
```
lua hum:loadall()
```

Or load individual modules by name:
```
lua hum:load("gag")
```

However, the modules can also be used directly without invoking the `hum` loader. Assuming you cloned the repository at `/scripts/hellmoo` then you can load the `ticker` module by executing the code below.
```
lua dofile([[/scripts/hellmoo/ticker/ticker.lua]]);
```

Other modules can be loaded in the same way. By replacing all instances of `ticker` in the above example with the module name you want to load.