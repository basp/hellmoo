# hellmoo utils for mudlet
This is a collection of **Mudlet** modules that are intended to be used in **HellMOO** but might be useful more generally for other MUD/MOO style games as well.

# setup
The easiest way to load the scripts is to make use of the `lua` alias (that just executes Lua code) and the `dofile` function. There are no dependencies, you can use/load them both together or individually.
```
lua dofile("/where/you/cloned/mapper.lua")
lua dofile("/where/you/cloned/ticker.lua")
lua dofile("/where/you/cloned/action.lua")
```

To check if they loaded correctly you can execute `lua mapper` and `lua ticker`. This will just display the definitions of the `mapper` and `ticker` objects respectively or nothing (and an error in the **Mudlet** error and debug windows) in case things went wrong.

## actions
Setting up *triggers* or *actions* in **Mudlet** is not that easy. The Lua API is not bad but especially with *temp triggers* it's easy to lose track of them. It often happens that you're doing things in game and you suddenly think of a cool trigger to setup. This is not that easy in **Mudlet** as it involves going into the script UI or use the somewhat cumbersome `lua` command to execute bare Lua code and interface with the API from your command line.

The `action` module tries to remedy this by offering you a convenient way to setup ad-hoc triggers, keep track of them and destroy them once they are no longer needed. This module is inspired by **TinTin++** as well.

### reference
* `:create(pattern, code)` creates a new *action* to execude `code` on the `pattern` regexp.
* `:destroy(pattern)` destroys the *action* associated with `pattern`
* `:list()` lists all action definitions

Note that (in contrast to *tickers*) the code is raw Lua code to be executed. So if you wanna send commands to the game you'll have to use the `send` function as demonstrated below:
```
action:create([[^The thing dies!$]], [[send("cut skin from thing")]])
```

### todo
It should be possible to create actions that *capture* groups of characters and re-use them in the code like this:
```
action:create([[^the %1 treeman dies!$]], [[send("cut bark from %1")]])
```

## tickers
The ticker module is a small utility package that makes it a lot easier to create ad-hoc repeating timers. Usually, when you want to have a persistent timer in **Mudlet** you need to go into the timer UI and click around to create one. Not only is this annoying but also it tends to draw your focus away from what is happening in game.

In the **TinTin++** client you can create so-called *tickers* that are the equivalent of persistent timers in **Mudlet**. However, you can create and kill them with basic commands. This module implements the basic *ticker* functionality as found in **TinTin++** for **Mudlet**.

Note that (in contrast to *actions*) you *CANNOT* send arbirtrary Lua code. The `command` parameter will be send to the game using the `send` function so of the game cannot interpret your command your *ticker* will be useless.

### reference
* `:create(name, command, seconds)` creates a new ticker that executes with an interval of `seconds`
* `:destroy(name)` destroys the ticker named `name`
* `:list()` lists all active tickers

### quick start
1. Create a new ticker by executing `lua ticker:create("foo", "look", 30)` (you should get a message that a new ticker has been created)
2. Inspect the currently running tickers by executing `lua ticker:list()` (this should show you the ticker you created in the previous step)
3. Try to create a ticker with the same name `lua ticker:create("foo", "inv", 16)` and you should get a message saying there's already a ticker with that name.
4. Destroy the ticker with `lua ticker:destroy("foo")` and you'll get a message saying that the ticker is no more.

### aliases
Although you can interact with the low level `ticker` API using the `lua` alias it's much more convenient to use the ticker aliases for this.

* `ticker <name> <command> <interval>` creates a new ticker
* `unticker <name>` destroys an existing ticker
* `tickers` lists all the running tickers

## mapper
This mapper is inspired by the **TinTin++** mapper which works really well for HellMOO. I wanted something similar for **Mudlet** so I started to translate the API to Lua.

**HellMOO** already includes fabulous maps so why would you need this is the first place? There's multiple reasons. The client map is a lot faster than using `lmap` for instance. You can easily annotate the client map with meta-data that is customized to your playstyle. You can share maps and tweak their layout and also you can correlate various aspects such as paths to named rooms and for example associating commands with rooms upon entry and/or exit. 

There's a lot of things you can do with a client map that you can't do with a server side map. And the goal of this mapping script is to be a bridge between **HellMOO** and the **Mudlet** mapper API.

### notes
* This mapper has been tailored to work with **HellMOO** although some parts of it might be usable for more generic mappers.
* Every room in **HellMOO** belongs to an *area* and the **Mudlet** mapper operates on areas as well. I decided to keep this mapping *one-to-one* as far as the *dynamic mapping* capabilities are concerned as it seems to work well.
* The room coordinates you will get from the GPS in game will **NOT** correspond to the coordinates of rooms in the map. It's practically impossible to try and keep a reasonable mapping and for all the use-cases I have it's simply not required.
* Mapping still involves a lot of manual attention. It's not simply a matter of blazing around and have the script do its thing, you'll have to pay attention and issue commands and tweak the map as you go.

### quick start
Note that if you're gonna try this you'll need a trigger to fire the `onRoomData` event, check below for more info on that. Also, you'll need to `@prefs showmap is off` for this trigger to work. And don't worry, mapping is much more exciting without the automap that is provided by the game. You can always use `lmap` to get your bearings.

1. Get the `mapper.lua` script and save it somewhere where you can find it
2. Start **Mudlet** and execute `lua dofile("/where/you/saved/it/mapper.lua")`
3. Make sure that it loaded by executing `lua mapper` (this will show you the `mapper` object)
4. Initialize the mapper by calling `lua mapper:init()` (this should show some debug messages)

Now the mapper doesn't do anything by default. You can move around and nothing happends before you tell it so. Note that for the *automagic* mapping to work properly you need to turn off the in game map so we can properly capture room and area names.

5. Execute `@prefs showmap is off` (you can use `@prefs showmap is on` to turn it back on). This will hide the in-game quickmap and ensures that the scrip will capture the room and area names. You can make sure this is working by executing `lua mapper` and looking at the `room_name` and `area_name` variables.

In order to start mapping we need to go to the starting point of an area. A good choice is **Helliday Inn** as it's usually pretty quiet in there.

5. Go to the starting point of an area you want to map and execute `mapper:create()` to create a new map for that area.
6. Execute `mapper:on()` to enable dynamic mapping.
7. Move in any *standard* direction and the room will be mapped automatically.

You're bound to run into situations where the mapper is gonna create a room or exits where you don't wan't them. In other situations you might go too fast and the mapper and you will be out of sync.

8. Execute `mapper:off()` to disable the mapper.
9. Move to a known room and check the map for the room *vnum* (or id).
10. Execute `mapper:goto(vnum)` to move the mapper over.
11. Use `mapper:list(area_id)` to see what rooms need to be deleted.
12. Delete rooms using `deleteRoom(room_id)` and areas using `deleteArea(area_id)` if needed.

Note that **Mudlet** has a nasty tendency of crashing when deleting rooms and especially areas. It helps to make sure you and the mapper are not in or near any area that you're gonna delete.

### firing the `onRoomData` event
This mapper is trying to be reasonably generic (although still written for **HellMOO**) and so it uses an event to update some essential parts of the mapper's internal state: the room and area name. These two pieces are not only important but we can capture them automatically as well with a **Mudlet** *regex* trigger that looks like this:
```
^(.*) \((.*)\)   (\d+):(\d+)(am|pm)(.*)$
```

And then we can fire event with the following code:
```
local room_name = matches[2]
local area_name = matches[3]
raiseEvent("onRoomData", room_name, area_name)
```

### reference
Below is a reference of the raw Lua mapper API. Usually, you'll make use of *aliases* to interact with the mapper.

* `:init()` initialize the mapper and setup anonymous event handlers
* `:status()` show the global mapper flags
* `:here()` center the map on the current room
* `:off()` disable dynamic mapping
* `:on()` enable dynamic mapping
* `:set(flag, value)` set the value of a global mapping flag
* `:create()` create a new map for the current area
* `:info()` show known map info about the current room
* `:jump(x, y, z)` center the map on `x`, `y`, `z` position
* `:move(dir)` move the map in standard direction `dir`
* `:goto(id)` center the map on room with id `id`
* `:name(name)` rename the current room to `name`
* `:area(name)` move the room to area `name`
* `:link(dir, to, both)` link the current room to room `to` in direction `dir` (specify `both` if you want to create a reverse link as well)
* `:unlink(dir, both)` unlink the room in direction `dir` (specify `both` if you want to unlink the reverse link as well)
* `:areas()` list all known areas
* `:list(name)` list all rooms in area `name` (uses current area by default)
* `:delete(dir)` delete room in direction `dir`
* `:destroy()` destroys the map for the current area (tends to crash Mudlet)

### aliases
It's much easier to interact with the mapper by using the alias listed below.

* `map on` enables the dynamic mapper
* `map off` disables the dynamic mapper
* `map link <direction> to <id>` creates a new exit from the current room to `id` in direction `direction`
* `map unlink <direct>` removes an exit from the current room
* `map goto <id>` positions the map on room with id `id`
* `map info` shows known mapper information about the current room
* `map name` renames the current room
* `map status` shows the status of the mapper
* `map list [area]` lists all rooms for area (or current area if none specified)
* `map init` initializes the mapper

There's also two utility aliases that manipulate in-game settings to show and hide the map.

* `map show` is a utility to show the in-game map
* `map hide` does the opposite of `map show`