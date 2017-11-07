## mudlet mapper
This mapper is inspired by the **TinTin++** mapper which works really well for HellMOO. I wanted something similar for **Mudlet** so I started to translate the API to Lua.

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
4. Try out `lua mapper.log:info("Testing")` to see if it gives some output
5. Initialize the mapper by calling `lua mapper:init()` (this will hook up some client events)
6. Make sure the map is visible from **Mudlet** by enabling it
7. Create a map with `lua mapper:create()` (this should create a single room in your **Mudlet** map display)
8. Give the room a name
9. Enable dynamic mapping by executing `lua mapper:on()` (you should get a message)

### firing the `onRoomData` event
This mapper is trying to be reasonably generic (although still written for **HellMOO**) and so it uses an event to update some essential parts of the mapper's internal state: the room and area name. These two pieces are not only important but we can capture them automatically as well with a **Mudlet** *regex* trigger that looks like this:

