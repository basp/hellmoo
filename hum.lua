local base = [[d:/dev/hellmoo]]

hum = hum or {}
hum.base = hum.base or base
hum.aliases = hum.aliases or {}

hum.Logger = {}

hum.Logger.colors = {
    info = "LightSteelBlue",
    debug = "SkyBlue",
    warn = "yellow",
    error = "orange",
    fatal = "red",
}

function hum.Logger:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function hum.Logger:fwrite(level, msg, ...)
    local color = self.colors[level]
    msg = string.format(msg, unpack(arg))
    cecho(string.format("<green>[ %s ]<reset> <%s>(%s)<reset> %s\n", self.name, color, level, msg))
end

function hum.Logger:info(msg, ...)
    self:fwrite("info", msg, unpack(arg))
end

function hum.Logger:debug(msg, ...)
    self:fwrite("debug", msg, unpack(arg))
end

function hum.Logger:warn(msg, ...)
    self:fwrite("warn", msg, unpack(arg))
end

function hum.Logger:error(msg, ...)
    self:fwrite("error", msg, unpack(arg))
end

function hum.Logger:fatal(msg, ...)
    self:fwrite("fatal", msg, unpack(arg))
end

hum.log = hum.Logger:new{name = "HUM"}

local help = [=[
<magenta>--------------------------------------------------------------------------------<reset>   
<yellow>SUMMARY<reset>
This is the hum module loader. It's main purpose is to offer an easier and 
safer way to load modules than using Lua's dofile function directly.

<yellow>ALIASES<reset>
hum load {<module>}                     load a module
hum load all                            load all available modules
hum list                                list module info
hum help                                show this help
<magenta>--------------------------------------------------------------------------------<reset>
]=]

function hum:help()
    cecho(help)
end

local aliases = {
    ["^hum load \\{(.+)\\}$"] = [[hum:load(matches[2])]],
    ["^hum load all$"] = [[hum:loadall()]],
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
    self.log:debug("Initialized module")    
end

function hum:load(module)
    local file = string.format("%s/%s/%s.lua", self.base, module, module)
    hum.log:debug("Loading %s...", file)
    dofile(file)
    hum.log:debug("Ok, loaded module %s", file)
end

local modules = {
    "action",
    "delay",
    "swatch",
    "ticker",
    "gag",
    "highlight",
    "mapper",
}

function hum:loadall()
    for i, mod in ipairs(modules) do
        self:load(mod)
    end
end

function hum:list()
    cecho(string.format("<yellow>%-32s %-6s<reset>\n", "module", "loaded"))
    for i, mod in ipairs(modules) do
        local color = "gray"
        local loaded = false 
        if hum[mod] then 
            loaded = true 
            color = "white"
        end
        cecho(string.format("<%s>%-32s %-6s<reset>\n", color, mod, tostring(loaded)))
    end
end

hum:init()