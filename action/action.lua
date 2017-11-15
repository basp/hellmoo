action = action or {}

action.actions = action.actions or {}
action.log = action.log or {}

local function notify(color, msg)
    cecho("<"..color..">[ ACTION ] <reset>"..msg.."\n")
end

local function eval(code)
    local f, e = loadstring("return "..code)
    if not f then
        f, e = assert(loadstring(code))
    end
    
    local r = f()
    if r ~= nil then display(r) end
end

function action.log:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function action.log:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

function action.log:warn(msg)
    local color = "yellow"
    notify(color, msg)
end

local help = [[
<magenta>--------------------------------------------------------------------------------<reset>
<yellow>SUMMARY<reset>
Actions execute some piece of code whenever a particular pattern of text is 
received from the game. They are generally useful to automate a variety of
repetative tasks.

Actions are equivalent to triggers you define in the Mudlet UI, they are far 
more lightweight and transient though and are meant to be more of an ad-hoc
alternative to using the default Mudlet triggers.

<yellow>ALIASES<reset>
action {<pattern>} {<code>}             create a new action
unaction <pattern>                      destroy an existing action
actions                                 list all existing actions
action help                             show this help

<yellow>EXAMPLES<reset>
This will create an action that executes the "say hi" command every time 
Mr. Wagener is standing in the room:

    <cyan>action {^Mr. Wagener is standing here.$} {send("say Hi!")}<reset>

Using captures is a bit iffy as we're executing Lua code directly. To make the
above trigger more generic we could rewrite it:

    <cyan>action {^(.+) is standing here.$} {send("say Hi "..matches[2].."!")}<reset>

This would trigger on "Foo Bar is standing here." and send the command 
"say Hi Foo Bar!". 

Note that we need to use curly braces in order to remove any ambiguity between
the pattern and code arguments of our alias.

We can destroy an action by using the pattern by which we defined it:

    <cyan>unaction ^(.+) is standing here.$<reset>

In this case, because there's no ambiguity, we don't need the curly braces.

You can overwrite actions by using the same pattern. This will kill the old 
trigger and create a new one with the new code.

Sometimes your action triggers might not easily fit in the truncated action
listing. In order to destroy the action you need the pattern though so in order
to find out all the information about an action you can always use the info
command:

    <cyan>action info <id><reset>

This will show you all the details of the action with specified id and this
includes the full pattern you can use to destroy it.

<yellow>REMARKS<reset>
Test your actions first with client-side output instead of sending commands 
straight back to the game and potentially causing a feedback loop.

While using actions or triggers is really on the wrists, you'll have to be
careful that you operate within the rules of the game you're playing.

Also be very careful with actions, if you create an action that triggers on
the output it causes you'll quickly enter an action loop. This is bad for
the server and might even get you banned so BE CAREFUL!
<magenta>--------------------------------------------------------------------------------<reset>
]]

function action:help()
    cecho(help)
end

local aliases = {

}

function action:init()
    self.log:debug("Initialized action module")
end

function action:create(pattern, code)
    if self.actions[pattern] then
        local existing = self.actions[pattern].id
        killTrigger(existing)
        self.log:debug(string.format("Killing existing trigger with id %d", existing))
        self.log:debug(string.format("Overwriting exiting action for '%s'", pattern))
    end

    self.actions[pattern] = {
        code = code,
        id = tempRegexTrigger(pattern, code),
    }
    local msg = string.format("Ok, will execute `%s` on trigger '%s'", code, pattern)
    self.log:info(msg)
end

function action:destroy(pattern)
    local id = self.actions[pattern].id
    killTrigger(id)
    self.actions[pattern] = nil
    self.log:info(string.format("Ok, Trigger '%s' is no more", pattern))
end

function action:info(id)
    for pat, act in pairs(self.actions) do
        if act.id == id then
            cecho("Id      : "..act.id.."\n")
            cecho("Pattern : "..pat.."\n")
            cecho("Code    : "..act.code.."\n")
            return
        end
    end
    self.log:info(string.format("There's no action with id %d", id))
end

function action:count()
    local c = 0
    for pat, act in pairs(self.actions) do
        c = c + 1
    end
    return c
end

function action:list()
    if self:count() <= 0 then
        self.log:info("There are no active actions")
        return
    end

    cecho(string.format("<yellow>%5s %-24s %s<reset>\n", "id", "pattern", "code"))
    for pat, act in pairs(self.actions) do
        cecho(string.format("%5d %-24s %s\n", act.id, pat:cut(24), act.code:cut(32)))
    end
end

action:init()
if hum then hum.action = action end