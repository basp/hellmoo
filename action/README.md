## action module
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