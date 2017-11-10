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
<yellow>SUMMARY<reset>
Actions execute some piece of code whenever a particular pattern of text is 
received from the game. They are generally useful to automate a variety of
repetative tasks.

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

<yellow>REMARKS<reset>
Test your actions first with client-side output instead of sending commands 
straight back to the game and potentially causing a feedback loop.

While using actions or triggers is really on the wrists, you'll have to be
careful that you operate within the rules of the game you're playing.

Also be very careful with actions, if you create an action that triggers on
the output it causes you'll quickly enter an action loop. This is bad for
the server and might even get you banned so BE CAREFUL! 
]]

function action:help()
    cecho(help)
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

function action:list()
    if table.getn(self.actions) <= 0 then
        self.log:info("There are no active actions")
        return
    end

    cecho(string.format("<yellow>%5s %-32s %s<reset>\n", "id", "pattern", "code"))
    for pat, act in pairs(self.actions) do
        cecho(string.format("%5d %-32s %s\n", act.id, pat, act.code))
    end
end