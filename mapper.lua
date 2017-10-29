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

local reverse = {
    n           = "s",
    ne          = "sw",
    nw          = "se",
    e           = "w",
    w           = "e",
    s           = "n",
    se          = "nw",
    sw          = "ne",
    u           = "d",
    d           = "u",
}

local coordmap = {
    n   = function (x, y, z) return x,      y + 1,  z       end,
    s   = function (x, y, z) return x,      y - 1,  z       end,
    e   = function (x, y, z) return x + 1,  y,      z       end,
    w   = function (x, y, z) return x - 1,  y,      z       end,
    ne  = function (x, y, z) return x + 1,  y + 1,  z       end,
    nw  = function (x, y, z) return x - 1,  y + 1,  z       end,
    se  = function (x, y, z) return x + 1,  y - 1,  z       end,
    sw  = function (x, y, z) return x - 1,  y - 1,  z       end,
    u   = function (x, y, z) return x,      y,      z + 1   end,
    d   = function (x, y, z) return x,      y,      z - 1   end,
}

local handlers = {
    ["sysDataSendRequest"]  = [[mapper:onSysDataSendRequest]],
    ["onRoomData"]          = [[mapper:onRoomData]],
}

function mapper:isStandardDirection(cmd)
    return table.contains(exitmap, cmd)
end

function mapper:normalizeDirection(dir)
    if short[dir] then dir = short[dir] end
    return dir
end

function mapper:init()
    self.handlers = self.handlers or {}

    for event, id in pairs(self.handlers) do
        self:debug("Killing existing '"..event.."' handler")
        killAnonymousEventHandler(id)
    end

    for event, cmd in pairs(handlers) do
        self:debug("Registering '"..event.."' handler")
        self.handlers[event] = registerAnonymousEventHandler(event, cmd)
    end
end

function mapper:create()
    local area_id, err = addAreaName(self.area_name)
    if not area_id then
        mapper:warn("Area '"..self.area_name.."' already exists.")
        return
    end

    local room_id = createRoomID()
    
    addRoom(room_id)
    setRoomCoordinates(room_id, 0, 0, 0)
    setRoomArea(room_id, area_id)
    centerview(room_id)

    self.prev_room = nil
    self.curr_room = {
        id = room_id,
        coords = { x = 0, y = 0, z = 0 },
    }

    self:info("Created new map for '"..self.area_name.."' ("..area_id..")")
end

--[[ 
    This will most likely crash Mudlet. (3.5.0)
--]]
function mapper:destroy()
    local area_id = getRoomAreaName(self.area_name)
    deleteArea(area_id)
    self:info("Destroyed area '"..self.area_name.."' ("..area_id..")")
end

function mapper:jump(x, y, z)
    local area_id = getRoomAreaName(self.area_name)
    local room_id = select(2, next(getRoomsByPosition(area_id, x, y, z)))
    if not room_id then return end
    centerview(room_id)
    self.prev_room = nil
    self.curr_room = {
        id = room_id,
        coords = { x = x, y = y, z = z },
    }
end

--[[
    This Will crash Mudlet if you delete the current room so make sure
    to use `jump` to position the map to another room than the one that
    you're trying to delete.
--]]
function mapper:delete(dir)
    if not self:isStandardDirection(dir) then 
        return 
    end
    
    dir = self:normalizeDirection(dir)
    
    local area_id = getRoomAreaName(self.area_name)
    
    local cx = self.curr_room.coords.x
    local cy = self.curr_room.coords.y
    local cz = self.curr_room.coords.z    
    
    local nx, ny, nz = coordmap[dir](cx, cy, cz)
    
    local room_id = select(2, next(getRoomsByPosition(area_id, nx, ny, nz)))
    if not room_id then 
        return 
    end

    deleteRoom(room_id)
    centerview(self.curr_room.id)
    self:info("Deleted room "..room_id.." in direction '"..dir.."'")
end

function mapper:name(room_name)
    setRoomName(self.curr_room.id, room_name)
    centerview(self.curr_room.id)
    self:info("Renamed room "..self.curr_room.id.." to '"..room_name.."'")
end

--[[
    This will fire whenever the user sends a command, if it is a known
    standard direction we'll create a new room based on the coordinates
    of the previous room and the direction traveled.
--]]
function mapper:onSysDataSendRequest(_, cmd)
    if not self:isStandardDirection(cmd) then return end
    cmd = self:normalizeDirection(cmd)
    self.prev_room = table.deepcopy(self.curr_room)

    local px = self.prev_room.coords.x 
    local py = self.prev_room.coords.y
    local pz = self.prev_room.coords.z
    local nx, ny, nz = coordmap[cmd](px, py, pz)
    local area_id = getRoomAreaName(self.area_name)
    local room_id = select(2, next(getRoomsByPosition(area_id, nx, ny, nz)))

    if not room_id then
        room_id = createRoomID()
        addRoom(room_id)
        setRoomCoordinates(room_id, nx, ny, nz)
        setRoomArea(room_id, area_id)
        self:info("Created new room with id "..room_id)
    end

    setExit(self.prev_room.id, room_id, cmd)
    setExit(room_id, self.prev_room.id, reverse[cmd])
    centerview(room_id)
    
    self.curr_room = {
        id = room_id,
        coords = { x = nx, y = ny, z = nz },
    }
end

--[[
    This needs to be fired by a a client trigger. The format of the
    trigger depends on the actual game.
--]]
function mapper:onRoomData(_, room_name, area_name)
    self.room_name = room_name
    self.area_name = area_name
end