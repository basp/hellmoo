swatch = swatch or {}
swatch.swatches = swatch.swatches or {}
swatch.aliases = swatch.aliases or {}
swatch.log = hum.Logger:new{name = "SWATCH"}

local help = [=[
<magenta>--------------------------------------------------------------------------------<reset>
<yellow>SUMMARY<reset>
Swatches are simple tool that can be used to time events such as repop and 
shop restock. Once you find out how long something takes you can setup a 
delay in order to be notified while you're off to do something else. However,
swatches are generally useful in lots of ways.

<yellow>ALIASES<reset>
swatch {<name>}                         create a new swatch
swatch reset {<name>}                   reset an existing swatch
unswatch {<name>}                       destroy an existing swatch
swatches                                list all existing swatches
swatch help                             show this help

<yellow>REMARKS<reset>
Swatches are extremely light-weight so you can have as many as you want. They
are implemented as a simple table of start times and there are no resources 
such as temporary timers or anything involved. Use them liberally.
<magenta>--------------------------------------------------------------------------------<reset>
]=]

function swatch:help()
    cecho(help)
end

local aliases = {
    ["^swatch \\{(.+)\\}$"] = [[swatch:create(matches[2])]],
    ["^swatch reset \\{(.+)\\}$"] = [[swatch:reset(matches[2])]],
    ["^unswatch \\{(.+)\\}$"] = [[swatch:destroy(matches[2])]],
    ["^swatches$"] = [[swatch:list()]],
    ["^swatch help$"] = [[swatch:help()]],
    ["^swatch$"] = [[swatch:help()]],
}

function swatch:init()
    for pat, code in pairs(aliases) do
        if self.aliases[pat] then 
            killAlias(self.aliases[pat].id) 
        end
        self.aliases[pat] = {
            id = tempAlias(pat, code),
            code = code,
        }
    end
    if hum then hum.swatch = swatch end
    self.log:debug("Initialized module")
end

function swatch:unload()
    for pat, alias in pairs(self.aliases) do
        killAlias(alias.id)
    end
    self.log:debug("Unloaded module")
end

function swatch:list()
    if self:count() <= 0 then
        self.log:info("There are no active swatches")
        return
    end

    cecho(string.format("<yellow>%5s %-64s %5s<reset>\n", "id", "name", "sec"))
    local now = os.time()
    for name, start in pairs(self.swatches) do
        local dur = now - start
        cecho(string.format("%5d %-64s %5d\n", 0, name, dur))
    end
end

function swatch:create(name)
    if self.swatches[name] then return end
    self.swatches[name] = os.time();
    self.log:info("Ok, created new swatch '%s'", name)
end

function swatch:reset(name)
    if not self.swatches[name] then return end
    self.swatches[name] = os.time();
    self.log:info("Ok, swatch '%s' is reset", name)
end

function swatch:duration(name)
    local t = os.time()
    return t - self.swatches[name]
end

function swatch:destroy(name)
    self.swatches[name] = nil
    self.log:info("Ok, swatch '%s' is no more", name)
end 

function swatch:count()
    local c = 0
    for name, start in pairs(self.swatches) do
        c = c + 1
    end
    return c    
end

swatch:init()