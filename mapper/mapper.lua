mudlet = mudlet or {}; mudlet.mapper_script = true;

mapper = mapper or {}

mapper.log = mapper.log or hum.Logger:new{name = "MAPPER"}

mapper.flags = {
    static = true,
    nofollow = true,
}

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
        self.log:debug("Killing existing '"..event.."' handler")
        killAnonymousEventHandler(id)
    end

    for event, cmd in pairs(handlers) do
        self.log:debug("Registering '"..event.."' handler")
        self.handlers[event] = registerAnonymousEventHandler(event, cmd)
    end
end

function mapper:status()
    for k, v in pairs(self.flags) do
        cecho(string.format("%-16s %s\n", k, tostring(v)))
    end
end

function mapper:here()
    centerview(self.curr_room.id)
end

function mapper:off()
    self.flags.static = true
    self.flags.nofollow = true
    self.log:info("Dynamic mapping is OFF")
end

function mapper:on()
    self.flags.static = false
    self.flags.nofollow = false
    self.log:info("Dynamic mapping is ON")
end

function mapper:set(flag, value)
    if not table.contains(self.flags, flag) then
        self.log:info("Unknown flag: "..flag)
        return
    end
    self.flags[flag] = value
end

function mapper:create()
    local area_id, err = addAreaName(self.area_name)
    if not area_id then
        self.log:warn("Area '"..self.area_name.."' already exists.")
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
    self.log:info("Created new map for '"..self.area_name.."' ("..area_id..")")
end

function mapper:info(room_id)
    room_id = room_id or self.curr_room.id
    if not room_id then return end
    local room_name = getRoomName(room_id)
    local area_id = getRoomArea(room_id)
    local area_name = getRoomAreaName(area_id)
    local exits = getRoomExits(room_id)
    cecho("Room vnum: "..room_id.."\n")
    cecho("Room name: "..room_name.."\n")
    cecho("Area name: "..area_name.."\n")
    cecho("Exits:\n")
    for dir, id in pairs(exits) do
        dir = self:normalizeDirection(dir)
        cecho(string.format("  %-3s %s (%d)\n", dir, getRoomName(id), id))
    end
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

function mapper:move(direction)
end

function mapper:goto(room_id)
    local x, y, z = getRoomCoordinates(room_id)
    local room_name = getRoomName(room_id)
    self.prev_room = nil
    self.curr_room = {
        id = room_id,
        coords = {x = x, y = y, z = z },
    }
    centerview(room_id)
    self.log:info("Moved map to '"..room_name.."' ("..room_id..")")
end

function mapper:name(room_name)
    room_name = room_name or self.room_name
    setRoomName(self.curr_room.id, room_name)
    updateMap()
    self.log:info("Renamed room "..self.curr_room.id.." to '"..room_name.."'")
end

function mapper:area(area_name)
    area_name = area_name or self.area_name
    local area_id = getRoomAreaName(area_name)
    if area_id <= 0 then
        area_id, _ = addAreaName(area_name)
        self.log:info("Created new area '"..area_name.."' ("..area_id..")")
    end
    setRoomArea(self.curr_room.id, area_id)
    centerview(self.curr_room.id)
    self.log:info("Moved room to area '"..area_name.."' ("..area_id..")")
end

function mapper:link(direction, room_id, both)
    direction = self:normalizeDirection(direction)
    local from_name = getRoomName(self.curr_room.id)
    local to_name = getRoomName(room_id)
    setExit(self.curr_room.id, room_id, direction)
    self.log:info("Created '"..direction.."' exit from '"..from_name.."' ("..self.curr_room.id..") to '"..to_name.."' ("..room_id..")") 
    
    if not both then return end
    
    setExit(room_id, self.curr_room.id, reverse[direction])
    self.log:info("Created '"..reverse[direction].."' exit from '"..to_name.."' ("..room_id..") to '"..from_name.."' ("..self.curr_room.id..")") 
    updateMap()
end

function mapper:unlink(direction, both)
    direction = self:normalizeDirection(direction)
    local room_name = getRoomName(self.curr_room.id)
    local exits = getRoomExits(self.curr_room.id)
    local existing_exit = exits[exitmap[direction]]
    if not existing_exit then
        self.log:info("There's no '"..direction.."' exit from room '"..room_name.."' ("..self.curr_room.id..")")
        return
    end
    setExit(self.curr_room.id, -1, direction)
    self.log:info("Deleted '"..direction.."' exit from room '"..room_name.."' ("..self.curr_room.id..")")
end

function mapper:areas()
    display(getAreaTable())
end

function mapper:list(area_name)
    local area_name = area_name or self.area_name
    local area_id = getRoomAreaName(area_name)
    local areas = getAreaTable()
    if not areas[area_name] then 
        area_id = area_name
        area_name = getRoomAreaName(area_id)
    end
    self.log:info("Listing rooms for area '"..area_name.."' ("..area_id..")")
    local rooms, result = getAreaRooms(area_id), {}
    for _, id in pairs(rooms) do
        local name = getRoomName(id)
        cecho(string.format("%6s: %s\n", id, name))
    end
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
    self.log:info("Deleted room "..room_id.." in direction '"..dir.."'")
end

--[[ 
    This will most likely crash Mudlet. (3.5.0)
--]]
function mapper:destroy()
    local area_id = getRoomAreaName(self.area_name)
    deleteArea(area_id)
    self.log:info("Destroyed area '"..self.area_name.."' ("..area_id..")")
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

    local area_id = getRoomAreaName(self.area_name)
    local room_id = false

    local prev_room_exits = getRoomExits(self.prev_room.id)
    local px = self.prev_room.coords.x 
    local py = self.prev_room.coords.y
    local pz = self.prev_room.coords.z
    local nx, ny, nz = coordmap[cmd](px, py, pz)

    local existing_exit = prev_room_exits[exitmap[cmd]]
    -- See if we can find the next room id by its existing exits...
    if existing_exit and not self.nofollow then
        local name = getRoomName(existing_exit)
        self.log:debug("Room found on existing exit '"..exitmap[cmd].."' to '"..name.."' ("..existing_exit..")")
        room_id = existing_exit
    else
        -- otherwise just to try to grab a room id on projected location.
        room_id = select(2, next(getRoomsByPosition(area_id, nx, ny, nz))) 
    end

    if not room_id and not self.flags.static then
        room_id = createRoomID()
        addRoom(room_id)
        setRoomCoordinates(room_id, nx, ny, nz)
        setRoomArea(room_id, area_id)
        self.log:info("Created new room with id "..room_id)
    end

    local curr_room_exits = getRoomExits(room_id)

    local prev_exit = prev_room_exits[exitmap[cmd]]
    local curr_exit = curr_room_exits[exitmap[reverse[cmd]]]

    if not prev_exit and not self.flags.static then
        setExit(self.prev_room.id, room_id, cmd)
        self.log:info("Created exit '"..cmd.."' from room "..self.prev_room.id.." to room "..room_id)
    end

    if not curr_exit and not self.flags.static then
        setExit(room_id, self.prev_room.id, reverse[cmd])
        self.log:info("Created exit '"..reverse[cmd].."' from  "..room_id.." to room "..self.prev_room.id)
    end

    if not room_id then return end
    if not self.flags.nofollow then centerview(room_id) end

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