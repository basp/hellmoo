ticker = ticker or {}

ticker.tickers = ticker.tickers or {}

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

function ticker:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function ticker:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

local help = [=[
SUMMARY
Tickers are used to execute a chunk of code on regular interval. They are
useful if you need to execute the same command many times on a regular basis 
for a prolonged period of time.

ALIASES
TODO

EXAMPLES
TODO

REMARKS
Note that the curly braces in the examples above are required for the aliases
to fire properly. Without them, it would be hard to seperate the name and code
arguments.
]=]

function ticker:help()
    cecho(help)
end

function ticker:create(name, code, seconds)
    if self.tickers[name] then
        self:debug(string.format("Killing existing ticker %s", name))
        killTimer(self.tickers[name].id)
    end
    self:_c(name, code, seconds)
    self:info(string.format("Ok, %s now executes '%s' every %d seconds", name, code, seconds))
end

function ticker:list()
    cecho(string.format("%5s %-16s %-32s %5s\n", "id", "name", "code", "sec"))
    for name, t in pairs(self.tickers) do
        cecho(string.format("%5d %-16s %-32s %5d\n", t.id, name, t.code, t.seconds))
    end
end

function ticker:destroy(name)
    if not self.tickers[name] then return end
    local id = self.tickers[name].id
    killTimer(id)
    self.tickers[name] = nil
    self:info(string.format("Ok, %s is no longer a ticker", name))
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
        id = tempTimer(seconds, f),
    } 
end