# hellmoo utils for mudlet
This is a collection of **Mudlet** modules that are intended to be used in **HellMOO** but might be useful more generally for other MUD/MOO style games as well. 

Most of the modules are heavily inspired by similar functionality available in **TinTin++** (as wel as other) clients. Note that all of this functionality already has equivalent ways to accomplish the same in Mudlet. The only thing this package does is to expose that functionality in a different, more ad-hoc and (hopefully) *wrist-friendly* way.

## overview
The whole package consists of a variety of modules that can be used together independently of eachother. There's no dependencies to worry about. To make loading and unloading modules easier, a loader module `hum` is provided as well/

* `hum` the top level loader (root) module (documented below)
* `delay` executes a piece of code in the future
* `swatch` helps you to keep track of durations (it's a stopwatch)
* `ticker` executes code on regular intervals
* `action` triggers code on patterns of output
* `mapper` is a mapper API tailored to HellMOO
* `gag` removes lines from output completely

## quick start
The recommended way to load modules is using the `hum` system module. First, we need to load (or *source*) this module into our client session. 
```
> lua dofile([[/scripts/hellmoo/hum.lua]])
```

This will load the loader and a setup some aliases that we can use to load additional modules. We can inspect the loader and see the raw object:
```
> lua hum
```

And this will display a literal Lua table with all the stuff that's hanging from the `hum` object. Another thing we can do is get the `hum` module's help by executing `hum help` (or just the name of the module, in this case `hum`).
```
> hum help
```

This will show you some general info and all aliases provided by the `hum` module. Other modules might have examples and remarks in their help.

If we execute `hum list` we should get a list of modules that are available:
```
> hum list
module                           loaded
action                           false 
delay                            false 
swatch                           false 
ticker                           false 
gag                              false
```

If you just loaded the `hum` module then none of the other modules should be loaded. We can load an individual module using the `hum load` alias:
```
> hum load {ticker}
```

This will load the `ticker` module, initialize it and make sure it's ready to be used. We can check this by just executing `ticker` which should display this module's help file:
```
> ticker
```

We can verify that it's loaded using the `hum list` alias as well:
```
> hum list
module                           loaded
action                           false 
delay                            false 
swatch                           false 
ticker                           true 
gag                              false
```

Also you should be able to see the module on attached to the `hum` object and available as the global `ticker` object as well. You can inspect these by using the `lua` alias.

## hum (loader) module
This module is responsible for loading additional modules and offering a convenient discovery point.

* `hum load {<module>}` load an individual module
* `hum load all` load all available modules
* `hum list` list module info
* `hum help` show the helpfile for this module

To read more about the `hum` module you can always execute `hum` (or `hum help`) after loading it.