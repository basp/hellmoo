## mudlet mapper
This mapper is inspired by the **TinTin++** mapper which works really well for HellMOO. I wanted something similar for **Mudlet** so I started to translate the API to Lua.

### notes
* This mapper has been tailored to work with **HellMOO** although some parts of it might be usable for more generic mappers.
* Every room in **HellMOO** belongs to an *area* and the **Mudlet** mapper operates on areas as well. I decided to keep this mapping *one-to-one* as far as the *dynamic mapping* capabilities are concerned as it seems to work well.
* The room coordinates you will get from the GPS in game will **NOT** correspond to the coordinates of rooms in the map. It's practically impossible to try and keep a reasonable mapping and for all the use-cases I have it's simply not required.
* Mapping still involves a lot of manual attention. It's not simply a matter of blazing around and have the script do its thing, you'll have to pay attention and issue commands and tweak the map as you go.

### introduction
**HellMOO** already includes fabulous maps so why would you need this is the first place? There's multiple reasons. The client map is a lot faster than using `lmap` for instance. You can easily annotate the client map with meta-data that is customized to your playstyle. You can share maps and tweak their layout and also you can correlate various aspects such as paths to named rooms and for example associating commands with rooms upon entry and/or exit. 

There's a lot of things you can do with a client map that you can't do with a server side map. And the goal of this mapping script is to be a bridge between **HellMOO** and the **Mudlet** mapper API.

### quick start
This is a pretty basic quick start to getting up and running with this mapping script.

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

### reference
Below is a reference of the raw Lua mapper API. Usually, you'll make use of *aliases* to interact with the mapper.
