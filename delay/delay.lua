delay = delay or {}

delay.delays = delay.delays or {}
delay.log = delay.log or {}

local function notify(color, msg)
    cecho("<"..color..">[ DELAY ] <reset>"..msg.."\n")
end

local function eval(code)
    local f, e = loadstring("return "..code)
    if not f then
        f, e = assert(loadstring(code))
    end
    
    local r = f()
    if r ~= nil then display(r) end
end

function delay.log:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function delay.log:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

function delay.log:warn(msg)
    local color = "yellow"
    notify(color, msg)
end

local help = [=[
<yellow>SUMMARY<reset>
Delays are used to execute a chunk of code sometime in the future. They are 
especially useful when you want to be notified of some event that happened
somewhere else (like a repop or restock for example).

<yellow>ALIASES<reset>
delay <seconds> <code>                  create a new delay
undelay <code>                          destroy an existing delay
delays                                  list all existing delays
delay help                              show this help

<yellow>EXAMPLES<reset>
The example below will execute a notification message 10 minutes (600 seconds)
into the future using the delay's built-in logging system:

    <cyan>delay 600 delay.log:info("Hello from the past!")<reset>

The command below would destroy the delay created in the previous example:

    <cyan>undelay delay.log:info("Hello from the past!")<reset>

If you frequenly need to undelay it might be useful to store the code in a
variable:

    <cyan>lua code = [[delay.log:info("Hello from the past!")]]<reset>
    <cyan>delay 600 code<reset>

And then later you can easily undelay this by using the code variable:

    <cyan>undelay code<reset>

Because you're executing Lua code, if you want to send commands to the game
you'll have to use the send function. The example below will send a command to
the game in 30 seconds:

    <cyan>delay 30 send("say Belated hi!")<reset>

<yellow>REMARKS<reset>
When you list delays you will see an id and tte field. The id field is used 
internally and the tte field shows the time-to-execute for that delay.
]=]

function delay:help()
    cecho(help)
end

function delay:list()
    if table.getn(self.delays) <= 0 then
        self.log:info("There's no active delays")
        return
    end

    cecho(string.format("<yellow>%5s %-64s %5s %5s<reset>\n", "id", "code", "sec", "tte"))
    local t = os.time()
    for code, delay in pairs(self.delays) do
        local tte = delay.seconds - (t - delay.start)
        cecho(string.format("%5d %-64s %5d %5d\n", delay.id, code:cut(64), delay.seconds, tte))
    end
end

function delay:create(seconds, code)
    self.delays[code] = {
        seconds = seconds,
        start = os.time(),
        id = tempTimer(seconds, function ()
            eval(code)
            self.delays[code] = nil
        end),
    }
    self.log:info(string.format("Ok, in %d seconds '%s' is executed", seconds, code))
end

function delay:destroy(id)
    if not self.delays[id] then return end
    killTimer(id)
    self.delays[id] = nil
    self.log:info(string.format("Ok, delay '%s' is no more", id))
end