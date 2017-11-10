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
    cecho(string.format("<yellow>%-16s %8s<reset>\n", "name", "sec"))
    local t = os.time()
    for name, start in pairs(self.swatches) do
        local dur = t - start
        cecho(string.format("%-16s %8d\n", name, dur))
    end
end

function swatch:create(name)
    if self.swatches[name] then return end
    self.swatches[name] = os.time();
    self.log:info(string.format("Created new swatch '%s'", name))
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
end 