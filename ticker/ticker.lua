ticker = ticker or {}
ticker.tickers = ticker.tickers or {}
ticker.aliases = ticker.aliases or {}
ticker.log = hum.Logger:new{name = "TICKER"}

local function eval(code)
    local f, e = loadstring("return "..code)
    if not f then
        f, e = assert(loadstring(code))
    end
    
    local r = f()
    if r ~= nil then display(r) end
end

local help = [=[
<magenta>--------------------------------------------------------------------------------<reset>
<yellow>SUMMARY<reset>
Tickers are used to execute a chunk of code on regular interval. They are
useful if you need to execute the same command many times on a regular basis 
for a prolonged period of time.

<yellow>ALIASES<reset>
ticker {<name>} {<code>} {<seconds>}    create a new ticker
unticker {<name>}                       destroy an existing ticker
tickers                                 list all running tickers
ticker help                             show this help

<yellow>EXAMPLES<reset>
The example below creates a new ticker that uses the tickers built-in logging
system to output a message every 30 seconds:

    <cyan>ticker {hello} {ticker.log:info("Hello from ticker!")} {30}<reset>

We can destroy this ticker with the follow command:

    <cyan>unticker {hello}<reset>

Because tickers run Lua code client-side we need to use the send function to
send commands to the game:

    <cyan>ticker {hello} {send("say Hello!")} {10}

The above would send the command "say hello" every 10 seconds.

<yellow>REMARKS<reset>
Tickers do consume resources, they are implemented as a chain of one-shot
timers using Mudlet's tempTimer API. This is also why you will see a ticker's
id update every time it fires.

Note that just like a delay, tickers also include a tte (time-to-execute) 
field in the listing.
<magenta>--------------------------------------------------------------------------------<reset>
]=]

function ticker:help()
    cecho(help)
end

local aliases = {
    ["^ticker \\{(.+)\\} \\{(.+)\\} \\{(.+)\\}$"] = [[ticker:create(matches[2], matches[3], tonumber(matches[4]))]],
    ["^unticker \\{(.+)\\}$"] = [[ticker:destroy(matches[2])]],
    ["^tickers$"] = [[ticker:list()]],
    ["^ticker help$"] = [[ticker:help()]],
    ["^ticker$"] = [[ticker:help()]],
}

function ticker:init()
    for pat, code in pairs(aliases) do
        if self.aliases[pat] then
            killAlias(self.aliases[pat].id)
        end
        self.aliases[pat] = {
            id = tempAlias(pat, code),
            code = code,
        }
    end
    if hum then hum.ticker = ticker end
    self.log:debug("Initialized module")
end

function ticker:unload()
    for pat, alias in pairs(self.aliases) do
        killAlias(alias.id)
    end
    for name, t in pairs(self.tickers) do
        killTimer(t.id)
    end
    if hum then hum.ticker = nil end
    self.log:debug("Unloaded module")
end

function ticker:create(name, code, seconds)
    if self.tickers[name] then
        self.log:debug("Killing existing ticker %s", name)
        killTimer(self.tickers[name].id)
    end
    self:_c(name, code, seconds)
    self.log:info("Ok, %s now executes '%s' every %d seconds", name, code, seconds)
end

function ticker:list()
    if self:count() <= 0 then
        self.log:info("There are no active tickers")
        return
    end

    cecho(string.format("<yellow>%5s %-24s %-39s %5s %5s<reset>\n", "id", "name", "code", "sec", "tte"))
    local now = os.time()
    for name, t in pairs(self.tickers) do
        local tte = t.seconds - (now - t.start)
        cecho(string.format("%5d %-24s %-39s %5d %5d\n", t.id, name:cut(24), t.code:cut(39), t.seconds, tte))
    end
end

function ticker:destroy(name)
    if not self.tickers[name] then return end
    local id = self.tickers[name].id
    killTimer(id)
    self.tickers[name] = nil
    self.log:info("Ok, %s is no longer a ticker", name)
end

function ticker:count()
    local c = 0
    for name, start in pairs(self.tickers) do
        c = c + 1
    end
    return c    
end

function ticker:_c(name, code, seconds)
    local f = function()
        eval(code)
        if self.tickers[name] then 
            self:_c(name, code, seconds) 
        end
    end
    self.tickers[name] = {
        code = code,
        seconds = seconds,
        start = os.time(),
        id = tempTimer(seconds, f),
    } 
end

ticker:init()