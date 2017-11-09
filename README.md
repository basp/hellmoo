# hellmoo utils for mudlet
This is a collection of **Mudlet** modules that are intended to be used in **HellMOO** but might be useful more generally for other MUD/MOO style games as well.

# setup
The easiest way to load the scripts is to make use of the `lua` alias (that just executes Lua code) and the `dofile` function. There are no dependencies, you can use/load them together or individually.
```
lua dofile("/where/you/cloned/mapper/mapper.lua")
lua dofile("/where/you/cloned/ticker/ticker.lua")
lua dofile("/where/you/cloned/action/action.lua")
lua dofile("/where/you/cloned/delay/delay.lua")
lua dofile("/where/you/cloned/swatch/swatch.lua")
lua dofile("/where/you/cloned/utils/utils.lua")
...
```

To check if they loaded correctly you can execute `lua mapper` and `lua ticker`. This will just display the definitions of the `mapper` and `ticker` objects respectively or nothing (and an error in the **Mudlet** error and debug windows) in case things went wrong.

## triggers
### highlights
* `orange halo` (substring)
* `From your wristpad:` (begin of line substring)
* `(burned(-out)?)` (perl regex)
* `Your stench recedes a little.` (substring)
* `^You wince and shrug off the radiation sickness.$` (perl regex)

### fishing
#### jerk
`^You feel a tug on your line.$` (perl regex)
```
send("jerk pole")
```

#### reel
`^(.*) The (.*) pulls (.*) out on the line.$` (perl regex)
```
send("reel")
```

### barks
#### dead tree
* `^The (.*) treeman creaks and groans, falling apart into a pile of kindling.$` (perl regex)
* `^The body of (.*) treeman's limbs twitch feebly; it coughs weakly, and moves no more.$` (perl regex)
```
local t = matches[2]
send("cut bark from "..t)
```

#### cut bark
* `^(.*) hacks a mossy bark off the body of (.*) treeman.$`
```
send("put bark in straw")
```

### aliases
TODO