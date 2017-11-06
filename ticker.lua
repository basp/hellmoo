ticker = ticker or {}

ticker.group_name = "tickers"

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

function ticker:init()
    ticker.tickers = ticker.tickers or {}
end

function ticker:_rep(name, seconds, func)
    if not self.tickers[name] then return end
    func()
    local id = tempTimer(seconds, function () 
        self:_rep(name, seconds, func) 
    end)
    self.tickers[name] = id
    return id
end

function ticker:create(name, command, seconds)
    self:_rep(name, seconds, function () send(command) end)
    self:info("Created ticker '"..name.."' with command '"..command.."'")
end

function ticker:destroy(name)
    local id = self.tickers[name]
    killTrigger(id)
    self.tickers[name] = nil
    self:info("Destroyed ticker '"..name.."' ("..id..")")
end