ticker = ticker or {}

ticker.tickers = ticker.tickers or {}

local function notify(color, msg)
    cecho("<"..color..">[ TICKER ] <reset>"..msg.."\n")
end

function ticker:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function ticker:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

function ticker:create(name, command, seconds)
    if self.tickers[name] then
        self:debug(string.format("There's alreay a ticker named '%s'", name))
        return
    end

    self:_c(name, command, seconds)
    self:info(string.format("%s now executes '%s' every %d seconds", name, command, seconds))
end

function ticker:list()
    cecho(string.format("%5s %-16s %-32s %5s\n", "id", "name", "command", "sec"))
    for name, t in pairs(self.tickers) do
        cecho(string.format("%5d %-16s %-32s %5d\n", t.id, name, t.command, t.seconds))
    end
end

function ticker:destroy(name)
    if not self.tickers[name] then return end
    local id = self.tickers[name].id
    killTimer(id)
    self.tickers[name] = nil
    self:info(string.format("%s is no longer a ticker", name))
end

function ticker:_c(name, command, seconds)
    local f = function()
        send(command)
        if self.tickers[name] then self:_c(name, command, seconds) end
    end
    self.tickers[name] = {
        command = command,
        seconds = seconds,
        id = tempTimer(seconds, f),
    } 
end