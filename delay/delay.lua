delay = delay or {}

delay.delays = delay.delays or {}
delay.log = delay.log or {}

local function notify(color, msg)
    cecho("<"..color..">[ DELAY ] <reset>"..msg.."\n")
end

local function eval(code)
    local f, e = loadstring("return "..code)
    if not f then
        f, e = assert(loadstring(code))
    end
    
    local r = f()
    if r ~= nil then display(r) end
end

function delay.log:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function delay.log:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

function delay.log:warn(msg)
    local color = "yellow"
    notify(color, msg)
end

local help = [[
Delays are used to execute a chunk of code sometime in the future. They are 
especially useful when you want to be notified of some event that happened
somewhere else (like a repop or restock for example).

delay <seconds> <code>          create a new delay
undelay <code>                  destroy an existing delay
delays                          lists all existing delays

Note that when you list delays you will see an id and tte field. The id field
is used internally and the tte field shows the time-to-execute for that delay.
]]

function delay:help()
    cecho(help)
end

function delay:list()
    cecho(string.format("<yellow>%5s %-64s %5s %5s<reset>\n", "id", "code", "sec", "tte"))
    local t = os.time()
    for code, delay in pairs(self.delays) do
        local tte = delay.seconds - (t - delay.start)
        cecho(string.format("%5d %-64s %5d %5d\n", delay.id, code:cut(64), delay.seconds, tte))
    end
end

function delay:create(seconds, code)
    self.delays[code] = {
        seconds = seconds,
        start = os.time(),
        id = tempTimer(seconds, function ()
            eval(code)
            self.delays[code] = nil
        end),
    }
    self.log:info(string.format("Ok, in %d seconds '%s' is executed", seconds, code))
end

function delay:destroy(id)
    if not self.delays[id] then return end
    killTimer(id)
    self.delays[id] = nil
    self.log:info(string.format("Ok, delay '%s' is no more", id))
end