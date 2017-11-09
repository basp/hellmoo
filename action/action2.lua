action2 = action2 or {}

action2.actions = action2.actions or {}
action2.log = action2.log or {}

local function notify(color, msg)
    cecho("<"..color..">[ ACTION ] <reset>"..msg.."\n")
end

function action2.log:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function action2.log:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

function action.log:warn(msg)
    local color2 = "yellow"
    notify(color, msg)
end

function action2:eval(code)
    local f, e = loadstring("return "..code)
    if not f then
        f, e = assert(loadstring(code))
    end
    
    local r = f()
    if r ~= nil then display(r) end
end

function action2:create(pattern, code)
    self.actions[pattern] = {
        code = code,
        id = tempRegexTrigger(pattern, [=[
            code = "]=]..code..[=["
            code = code:gsub("%%1", matches[2])
            cecho("\n"..code.."\n")
            --action:eval(code)
        ]=]),    
    }
end

function action2:destroy(pattern)
end

function action2:list()
    cecho(string.format("%5s %-32s %s\n", "id", "pattern", "commands"))
    for pat, act in pairs(self.actions) do
        cecho(string.format("%5d %-32s %s\n", act.id, pat, act.commands))
    end
end

-- send("say Hi %1")       => send("say Hi "..matches[2])
-- send("say Hi %1 you!")  => send("say Hi "..matches[2].." you!")
