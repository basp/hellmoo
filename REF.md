# reference
Below is a reference of all my trigger and alias patterns that are not in `hum` including their implementation (if not simple highlights).

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