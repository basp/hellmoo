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

function delay:list()
    display(self.delays)
end

function delay:create(seconds, code)
    self.delays[code] = {
        seconds = seconds,
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
    self.log:info(string.format("Ok, delay %d is no more", id))
end