mudlet = mudlet or {}; mudlet.mapper_script = true;

mapper = mapper or {}

local function notify(color, level, msg)
    cecho("<"..color..">[ MAPPER ] <reset>"..msg.."\n")
end

function mapper:debug(msg)
    local color = "yellow"
    local level = "debug"
    notify(color, level, msg)
end

function mapper:info(msg)
    local color = "yellow"
    local level = "info"
    notify(color, level, msg)
end

function mapper:warn(msg)
    local color = "yellow"
    local level = "warn"
    notify(color, level, msg)
end

function mapper:error(msg)
    local color = "yellow"
    local level = "error"
    notify(color, level, msg)
end

local exitmap = {
    n           = "north",        
    ne          = "northeast",   
    nw          = "northwest",   
    e           = "east",         
    w           = "west",         
    s           = "south",        
    se          = "southeast",   
    sw          = "southwest",   
    u           = "up",           
    d           = "down",         
}

local short = {}
for k, v in pairs(exitmap) do short[v] = k end

local coordmap = {
    n   = function (x, y, z) return x,      y - 1,  z       end,
    s   = function (x, y, z) return x,      y + 1,  z       end,
    e   = function (x, y, z) return x + 1,  y,      z       end,
    w   = function (x, y, z) return x - 1,  y,      z       end,
    ne  = function (x, y, z) return x + 1,  y - 1,  z       end,
    nw  = function (x, y, z) return x - 1,  y - 1,  z       end,
    se  = function (x, y, z) return x + 1,  y + 1,  z       end,
    sw  = function (x, y, z) return x - 1,  y + 1,  z       end,
    u   = function (x, y, z) return x,      y,      z + 1   end,
    d   = function (x, y, z) return x,      y,      z - 1   end,
}

local function isStandardDirection(cmd)
    return table.contains(exitmap, cmd)
end

local function normalizeDirection(dir)
    if short[dir] then dir = short[dir] end
    return dir
end

function mapper:_onSysDataSendRequest(_, cmd)
    if not isStandardDirection(cmd) then return end
    cmd = normalizeDirection(cmd)
    local new_x, new_y, new_z = coordmap[cmd](mapper.x, mapper.y, mapper.z)
    mapper.x, mapper.y, mapper.z = new_x, new_y, new_z
end

function mapper:_onRoomData(_, room_name, area_name)
    mapper.room_name, mapper.area_name = room_name, area_name
end

local handlers = {
    ["sysDataSendRequest"]  = [[mapper:_onSysDataSendRequest]],
    ["onRoomData"]          = [[mapper:_onRoomData]],
}

function mapper:init()
    mapper.handlers = mapper.handlers or {}

    for event, id in pairs(mapper.handlers) do
        mapper:debug("Killing existing '"..event.."' handler")
        killAnonymousEventHandler(id)
    end

    for event, cmd in pairs(handlers) do
        mapper:debug("Registering '"..event.."' handler")
        mapper.handlers[event] = registerAnonymousEventHandler(event, cmd)
    end
end

function mapper:reset()
    mapper.x, mapper.y, mapper.z = 0, 0, 0
end

-- map create
-- map goto <room_number_or_name>
-- map name <room_name>