### SUMMARY
Gags are used to strip whole lines containing a particular pattern from the
output. They are useful to silence spammy objects.

### ALIASES
```
gag {<pattern>}                         create a new gag
ungag {<pattern>}                       destroy an existing gag
gags                                    list all existing gags
```

### REMARKS
Note that triggers and actions will still fire on gagged lines.