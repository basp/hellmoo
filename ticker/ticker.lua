ticker = ticker or {}

ticker.tickers = ticker.tickers or {}
ticker.log = ticker.log or {}

local function notify(color, msg)
    cecho("<"..color..">[ TICKER ] <reset>"..msg.."\n")
end

local function eval(code)
    local f, e = loadstring("return "..code)
    if not f then
        f, e = assert(loadstring(code))
    end
    
    local r = f()
    if r ~= nil then display(r) end
end

function ticker.log:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function ticker.log:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

local help = [=[
<yellow>SUMMARY<reset>
Tickers are used to execute a chunk of code on regular interval. They are
useful if you need to execute the same command many times on a regular basis 
for a prolonged period of time.

<yellow>ALIASES<reset>
ticker {<name>} {<code>} <seconds>      create a new ticker
unticker <name>                         destroy an existing ticker
tickers                                 lists all running tickers
ticker help                             shows this help

<yellow>EXAMPLES<reset>
The example below creates a new ticker that uses the tickers built-in logging
system to output a message every 30 seconds:

    ticker {hello} {ticker.log:info("Hello from ticker!")} 30

We can destroy this ticker with the follow command:

    unticker hello

Note that ticker names support spaces, that's why we need the curly braces to
sepearte the name and code parts when we use the alias:

    ticker {say hello} {send("say Hello!")} 30

Because there's no ambiguity when we unticker we don't need the braces when
destroying tickers:

    unticker say hello

<yellow>REMARKS<reset>
Tickers do consume resources, they are implemented as a chain of one-shot
timers using Mudlet's tempTimer API. This is also why you will see a ticker's
id update every time it fires.

Note that just like a delay, tickers also include a tte (time-to-execute) 
field in the listing.
]=]

function ticker:help()
    cecho(help)
end

function ticker:create(name, code, seconds)
    if self.tickers[name] then
        self.log:debug(string.format("Killing existing ticker %s", name))
        killTimer(self.tickers[name].id)
    end
    self:_c(name, code, seconds)
    self.log:info(string.format("Ok, %s now executes '%s' every %d seconds", name, code, seconds))
end

function ticker:list()
    cecho(string.format("<yellow>%5s %-16s %-48s %5s %5s<reset>\n", "id", "name", "code", "sec", "tte"))
    local now = os.time()
    for name, t in pairs(self.tickers) do
        local tte = t.seconds - (now - t.start)
        cecho(string.format("%5d %-16s %-48s %5d %5d\n", t.id, name:cut(24), t.code:cut(48), t.seconds, tte))
    end
end

function ticker:destroy(name)
    if not self.tickers[name] then return end
    local id = self.tickers[name].id
    killTimer(id)
    self.tickers[name] = nil
    self.log:info(string.format("Ok, %s is no longer a ticker", name))
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