### SUMMARY
Tickers are used to execute a chunk of code on regular interval. They are
useful if you need to execute the same command many times on a regular basis 
for a prolonged period of time.

### ALIASES
```
ticker {<name>} {<code>} {<seconds>}    create a new ticker
unticker {<name>}                       destroy an existing ticker
tickers                                 list all running tickers
ticker help                             show this help
```

### EXAMPLES
The example below creates a new ticker that uses the tickers built-in logging
system to output a message every 30 seconds:
```
ticker {hello} {ticker.log:info("Hello from ticker!")} {30}
```

We can destroy this ticker with the follow command:
```
unticker {hello}
```

Because tickers run Lua code client-side we need to use the send function to
send commands to the game:
```
ticker {hello} {send("say Hello!")} {10}
```

The above would send the command "say hello" every 10 seconds.

### REMARKS
Tickers do consume resources, they are implemented as a chain of one-shot
timers using Mudlet's tempTimer API. This is also why you will see a ticker's
id update every time it fires.

Note that just like a delay, tickers also include a tte (time-to-execute) 
field in the listing.