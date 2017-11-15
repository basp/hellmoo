gag = gag or {}
gag.gags = gag.gags or {}
gag.log = gag.log or {}
gag.aliases = gag.aliases or {}

local function notify(color, msg)
    cecho("<"..color..">[ GAG ] <reset>"..msg.."\n")
end

function gag.log:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function gag.log:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

function gag.log:warn(msg)
    local color = "yellow"
    notify(color, msg)
end

local help = [=[
<magenta>--------------------------------------------------------------------------------<reset>
<yellow>SUMMARY<reset>
Gags are used to strip whole lines containing a particular pattern from the
output. They are useful to silence spammy objects.

<yellow>ALIASES<reset>
gag {<pattern>}                         create a new gag
ungag {<pattern>}                       destroy an existing gag
gags                                    list all existing gags

<yellow>REMARKS<reset>
Note that triggers and actions will still fire on gagged lines.
<magenta>--------------------------------------------------------------------------------<reset>
]=]

function gag:help()
    cecho(help)
end

local aliases = {
    ["^gag \\{(.+)\\}$"] = [[gag:create(matches[2])]],
    ["^ungag \\{(.+)\\}$"] = [[gag:destroy(matches[2])]],
    ["^gags$"] = [[gag:list()]],
    ["^gag help$"] = [[gag:help()]],
    ["^gag$"] = [[gag:help()]],
}

function gag:init()
    for pat, code in pairs(aliases) do
        if self.aliases[pat] then
            killAlias(self.aliases[pat].id)
        end
        self.aliases[pat] = {
            id = tempAlias(pat, code),
            code = code,
        }
    end
    if hum then hum.gag = gag end
    self.log:debug("Initialized module")
end

function gag:unload()
    for pat, alias in pairs(self.aliases) do
        killAlias(alias.id)
    end
    for pat, gag in pairs(self.gags) do
        killTrigger(gag.id)
    end
    if hum then hum.gag = nil end
    self.log:debug("Unloaded module")
end

function gag:create(pattern)
    if self.gags[pattern] then return end
    self.gags[pattern] = {
        id = tempRegexTrigger(pattern, function ()
            deleteLine()
        end)
    }
    self.log:info(string.format("Ok, all lines containing '%s' will now be gagged", pattern))
end

function gag:destroy(pattern)
    if not self.gags[pattern] then return end
    killTrigger(self.gags[pattern].id)
    self.gags[pattern] = nil
    self.log:info(string.format("Ok, lines containing '%s' will no longer be gagged", pattern))
end

function gag:list()
    if self:count() <= 0 then
        self.log:info("There are active gags")
        return
    end

    cecho(string.format("<yellow>%5s %-64s<reset>\n", "id", "pattern"))
    for pat, gag in pairs(self.gags) do
        cecho(string.format("%5d %-64s\n", gag.id, pat))
    end
end

function gag:count()
    local c = 0
    for pat, gag in pairs(self.gags) do
        c = c + 1
    end
    return c
end

gag:init()