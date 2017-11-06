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
1. Get the `mapper.lua` script and save it somewhere where you can find it
2. Start **Mudlet** and execute `lua dofile("/where/you/saved/it/mapper.lua")`
3. Make sure that it loaded by executing `lua mapper` (this will show you the `mapper` object)
4. Initialize the mapper by calling `lua mapper:init()` (this should show some debug messages)

### reference
Below is a reference of the raw Lua mapper API. Usually, you'll make use of *aliases* to interact with the mapper.
