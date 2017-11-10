hum = hum or {}

hum.log = hum.log or {}

local function notify(color, msg)
    cecho("<"..color..">[ HUM ] <reset>"..msg.."\n")
end

function hum.log:info(message)
    local color = "yellow"
    notify(color, message)
end

function hum.log:debug(message)
    local color = "yellow"
    notify(color, message)
end

local base = [[d:/dev/hellmoo]]

local modules = {
    "action",
    "delay",
    "swatch",
    "ticker",
}

for i, mod in ipairs(modules) do
    local file = string.format("%s/%s/%s.lua", base, mod, mod)
    hum.log:debug(string.format("Loading %s...", file))
    dofile(file)
    hum.log:debug("Ok")
    hum.log:info(string.format("Loaded module %s", file))
end

hum.action = action or {}
hum.delay = delay or {}
hum.swatch = swatch or {}
hum.ticker = ticker or {}
