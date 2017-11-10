swatch = swatch or {}

swatch.swatches = swatch.swatches or {}
swatch.log = swatch.log or {}

local function notify(color, msg)
    cecho("<"..color..">[ SWATCH ] <reset>"..msg.."\n")
end

function swatch.log:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function swatch.log:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

function swatch.log:warn(msg)
    local color = "yellow"
    notify(color, msg)
end

local help = [=[
<yellow>SUMMARY<reset>
Swatches are simple tool that can be used to time events such as repop and 
shop restock. Once you find out how long something takes you can setup a 
delay in order to be notified while you're off to do something else. However,
swatches are generally useful in lots of ways.

<yellow>ALIASES<reset>
swatch create <name>                    create a new swatch
swatch reset <name>                     reset an existing swatch
unswatch <name>                         destroy an existing swatch
swatches                                list all existing swatches
swatch help                             shows this help

<yellow>REMARKS<reset>
Swatches are extremely light-weight so you can have as many as you want. They
are implemented as a simple table of start times and there are no resources 
such as temporary timers or anything involved. Use them liberally.
]=]

function swatch:help()
    cecho(help)
end

function swatch:list()
    if table.getn(self.swatches) <= 0 then
        self.log:info("There's no active swatches")
        return
    end

    cecho(string.format("<yellow>%5s %-64s %5s<reset>\n", "id", "name", "sec"))
    local t = os.time()
    for name, start in pairs(self.swatches) do
        local dur = t - start
        cecho(string.format("%5d %-64s %5d\n", 0, name, dur))
    end
end

function swatch:create(name)
    if self.swatches[name] then return end
    self.swatches[name] = os.time();
    self.log:info(string.format("Ok, created new swatch '%s'", name))
end

function swatch:reset(name)
    if not self.swatches[name] then return end
    self.swatches[name] = os.time();
    self.log:info(string.format("Ok, swatch '%s' is reset", name))
end

function swatch:duration(name)
    local t = os.time()
    return t - self.swatches[name]
end

function swatch:destroy(name)
    self.swatches[name] = nil
    self.log:info(string.format("Ok, swatch '%s' is no more", name))
end 