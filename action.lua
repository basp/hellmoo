action = action or {}

action.actions = action.actions or {}

function action:create(pattern, code)
    self.actions[pattern] = {
        code = code,
        id = tempRegexTrigger(pattern, code),
    }
end

function action:destroy(pattern)
    local id = self.actions[pattern].id
    killTrigger(id)
    self.actions[pattern] = nil
end

function action:list()
    cecho(string.format("%-24 %s\n", "pattern", "code"))
    for pat, act in pairs(self.actions) do
        cecho(string.format("%-24s %s\n", pat, act.code))
    end
end