local base = [[d:/dev/hellmoo]]

hum = hum or {}
hum.base = hum.base or base
hum.log = hum.log or {}
hum.aliases = hum.aliases or {}

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

local help = [=[
<yellow>SUMMARY<reset>
This is the hum module loader. It's main purpose is to offer an easier and 
safer way to load modules than using Lua's dofile function directly.

<yellow>ALIASES<reset>
hum load {<module>}                     load a module
hum loadall                             load all modules
hum list                                list module info
hum help                                show this help
]=]

function hum:help()
    cecho(help)
end

local aliases = {
    ["^hum load \\{(.+)\\}$"] = [[hum:load(matches[2])]],
    ["^hum loadall$"] = [[hum:loadall()]],
    ["^hum help$"] = [[hum:help()]],
    ["^hum list$"] = [[hum:list()]],
    ["^hum$"] = [[hum:help()]],
}

function hum:init()
    for pat, code in pairs(aliases) do
        if self.aliases[pat] then
            killAlias(self.aliases[pat].id)
        end
        self.aliases[pat] = {
            id = tempAlias(pat, code),
            code = code,
        }
    end
    self.log:debug("Initialized hum module")    
end

function hum:load(module)
    local file = string.format("%s/%s/%s.lua", self.base, module, module)
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

function hum:list()
    cecho(string.format("<yellow>%-32s %-6s<reset>\n", "module", "loaded"))
    for i, mod in ipairs(modules) do
        local loaded = false 
        if hum[mod].log then 
            loaded = true 
        end
        cecho(string.format("%-32s %-6s\n", mod, tostring(loaded)))
    end
end

hum.action = action or {}
hum.delay = delay or {}
hum.swatch = swatch or {}
hum.ticker = ticker or {}
hum.gag = gag or {}

hum:init()
hum.log:info("Ready.")