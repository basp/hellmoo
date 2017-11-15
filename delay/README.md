### SUMMARY
Delays are used to execute a chunk of code sometime in the future. They are 
especially useful when you want to be notified of some event that happened
somewhere else (like a repop or restock for example).

### ALIASES
```
delay {<seconds>} {<code>}              create a new delay
undelay {<code>}                        destroy an existing delay
delays                                  list all existing delays
delay help                              show this help
```

### EXAMPLES
The example below will execute a notification message 10 minutes (600 seconds)
into the future using the delay's built-in logging system:
```
delay 600 delay.log:info("Hello from the past!")
```

The command below would destroy the delay created in the previous example:
```
undelay delay.log:info("Hello from the past!")
```

If you frequenly need to undelay it might be useful to store the code in a
variable and use the Lua API instead:
```
lua code = [[delay.log:info("Hello from the past!")]]
delay:create(600, code)
```

Later, you can easily undelay this by using the code variable again:
```
lua delay:destroy(code)
```

Because you're executing Lua code, if you want to send commands to the game
you'll have to use the send function. The example below will send a command to
the game in 30 seconds:
```
delay 30 send("say Belated hi!")
```

### REMARKS
When you list delays you will see an id and tte field. The id field is used 
internally and the tte field shows the time-to-execute for that delay.