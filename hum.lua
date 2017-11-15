local base = [[d:/dev/hellmoo]]

hum = hum or {}
hum.log = hum.log or {}
hum.base = hum.base or base

local function notify(color, msg)
    cecho("<"..color..">[ HUM ] <reset>"..msg.."\n")
end

function hum.log:info(message)
    local color = "cyan"
    notify(color, message)
end

function hum.log:debug(message)
    local color = "steel_blue"
    notify(color, message)
end

function hum:load(module)
    local file = string.format("%s/%s/%s.lua", self.base, mod, mod)
    hum.log:debug(string.format("Loading %s...", file))
    dofile(file)
    hum.log:debug(string.format("Ok, loaded module %s", file))
end

local modules = {
    "action",
    "delay",
    "swatch",
    "ticker",
    "gag",
}

function hum:loadall()
    for i, mod in ipairs(modules) do
        self:load(mod)
    end
end


hum.action = action or {}
hum.delay = delay or {}
hum.swatch = swatch or {}
hum.ticker = ticker or {}
hum.gag = gag or {}

hum.log:info("Ready.")