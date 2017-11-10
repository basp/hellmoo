# hellmoo utils for mudlet
This is a collection of **Mudlet** modules that are intended to be used in **HellMOO** but might be useful more generally for other MUD/MOO style games as well.

## overview
The whole package consists of a variety of modules that can be used independently of eachother. There's no dependencies to worry about.

* `delay` executes a piece of code in the future
* `swatch` helps you to keep track of durations (it's a stopwatch)
* `ticker` executes code on regular intervals
* `action` triggers code on patterns of output

## setup


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