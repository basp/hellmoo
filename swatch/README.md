### SUMMARY
Swatches are simple tool that can be used to time events such as repop and 
shop restock. Once you find out how long something takes you can setup a 
delay in order to be notified while you're off to do something else. However,
swatches are generally useful in lots of ways.

### ALIASES
```
swatch {<name>}                         create a new swatch
swatch reset {<name>}                   reset an existing swatch
unswatch {<name>}                       destroy an existing swatch
swatches                                list all existing swatches
swatch help                             show this help
```

### REMARKS
Swatches are extremely light-weight so you can have as many as you want. They
are implemented as a simple table of start times and there are no resources 
such as temporary timers or anything involved. Use them liberally.