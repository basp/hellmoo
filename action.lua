action = action or {}

action.actions = action.actions or {}
action.log = action.log or {}

local function notify(color, msg)
    cecho("<"..color..">[ ACTION ] <reset>"..msg.."\n")
end

local function eval(code)
    local f, e = loadstring("return "..code)
    if not f then
        f, e = assert(loadstring(code))
    end
    
    local r = f()
    if r ~= nil then display(r) end
end

function action.log:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function action.log:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

function action.log:warn(msg)
    local color = "yellow"
    notify(color, msg)
end

function action:create(pattern, code)
    if self.actions[pattern] then
        local existing = self.actions[pattern].id
        killTrigger(existing)
        self.log:debug(string.format("Killing existing trigger with id %d", existing))
        self.log:debug(string.format("Overwriting exiting action for '%s'", pattern))
    end

    self.actions[pattern] = {
        code = code,
        id = tempRegexTrigger(pattern, code),
    }
    local msg = string.format("Action will execute `%s` on trigger '%s'", code, pattern)
    self.log:info(msg)
end

function action:destroy(pattern)
    local id = self.actions[pattern].id
    killTrigger(id)
    self.actions[pattern] = nil
    self.log:info(string.format("Trigger '%s' is no more", pattern))
end

function action:list()
    cecho(string.format("%5s %-32s %s\n", "id", "pattern", "code"))
    for pat, act in pairs(self.actions) do
        cecho(string.format("%5d %-32s %s\n", act.id, pat, act.code))
    end
end

-- send("say Hi %1")       => send("say Hi "..matches[2])
-- send("say Hi %1 you!")  => send("say Hi "..matches[2].." you!")
