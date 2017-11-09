## ticker module
The ticker module is a small utility package that makes it a lot easier to create ad-hoc repeating timers. Usually, when you want to have a persistent timer in **Mudlet** you need to go into the timer UI and click around to create one. Not only is this annoying but also it tends to draw your focus away from what is happening in game.

In the **TinTin++** client you can create so-called *tickers* that are the equivalent of persistent timers in **Mudlet**. However, you can create and kill them with basic commands. This module implements the basic *ticker* functionality as found in **TinTin++** for **Mudlet**.

Note that (in contrast to *actions*) you **CANNOT** send arbirtrary Lua code. The `command` parameter will be send to the game using the `send` function so if the game cannot interpret your command your *ticker* will be useless.

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