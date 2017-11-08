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

function swatch:list()
    display(self.swatches)
end

function swatch:create(message)
    local id = table.getn(self.swatches) + 1
    self.swatches[id] = {
        start = os.time(),
        message = message,
    }
end

function swatch:duration(id)
    local t = os.time()
    return t - self.swatches[id].start
end

function swatch:destroy(id)
    self.swatches[id] = nil
end 