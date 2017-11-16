## SUMMARY
Actions execute some piece of code whenever a particular pattern of text is 
received from the game. They are generally useful to automate a variety of
repetative tasks.

Actions are equivalent to triggers you define in the Mudlet UI, they are far 
more lightweight and transient though and are meant to be more of an ad-hoc
alternative to using the default Mudlet triggers.

## ALIASES
```
action {<pattern>} {<code>}             create a new action
unaction {<pattern>}                    destroy an existing action
actions                                 list all existing actions
action help                             show this help
```

## EXAMPLES
This will create an action that executes the "say hi" command every time 
36Tonya is standing in the room:
```
action {^36Tonya is standing here} {send("say Hi!")}
```

Using captures is a bit iffy as we're executing Lua code directly. To make the
above trigger more generic we could rewrite it:
```
action {^(.+) is standing here} {send("say Hi "..matches[2].."!")}
```

This would trigger on "Foo Bar is standing here." and send the command 
"say Hi Foo Bar!". 

We can destroy an action by using the pattern by which we defined it:
```
unaction {^(.+) is standing here}
```

You can overwrite actions by using the same pattern. This will kill the old 
trigger and create a new one with the new code.

Sometimes your action triggers might not easily fit in the truncated action
listing. In order to destroy the action you need the pattern though so in order
to find out all the information about an action you can always use the info
command:
```
action info <id>
```

This will show you all the details of the action with specified id and this
includes the full pattern you can use to destroy it.

## REMARKS
Test your actions first with client-side output instead of sending commands 
straight back to the game and potentially causing a feedback loop.

While using actions or triggers is really on the wrists, you'll have to be
careful that you operate within the rules of the game you're playing.

Also be very careful with actions, if you create an action that triggers on
the output it causes you'll quickly enter an action loop. This is bad for
the server and might even get you banned so BE CAREFUL!