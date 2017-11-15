### SUMMARY
Highlights are used to make certain patterns of output stand out so it's easier
to see at a glance what is happening. Basically, anything output that requires
attention is a valid highlight candidate.

### ALIASES
```
highlight {<pattern>} {fg} {bg}         create a new highlight
unhighlight {<pattern>}                 destroy an existing highlight
highlights                              list all existing highlights
highlight colors                        show the list of supported colors
highlight help                          show this help
```

### EXAMPLES
Create a new highlight for "radiation sickness" with a red background and
yellow foreground:
```
highlight {radiation sickness} {yellow} {red}
```

We can destroy this highlight by using its pattern again:
```
unhighlight {radiation sickness}
```

We can inspect the list of supported colors with the colors alias:
```
highlight colors
```

### REMARKS
The values for the forground (fg) and background (bg) colors are taken from the
list of standard Mudlet colors. You can review this list with the showColors
function that is part of the Mudlet API. Highlights have full regex support.