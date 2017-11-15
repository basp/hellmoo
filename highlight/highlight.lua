highlight = highlight or {}
highlight.log = highlight.log or {}
highlight.highlights = highlight.highlights or {}
highlight.aliases = highlight.aliases or {}

local function notify(color, msg)
    cecho("<"..color..">[ HIGHLIGHT ] <reset>"..msg.."\n")
end

function highlight.log:info(msg)
    local color = "yellow"
    notify(color, msg)
end

function highlight.log:debug(msg)
    local color = "yellow"
    notify(color, msg)    
end

function highlight.log:warn(msg)
    local color = "yellow"
    notify(color, msg)
end

local help = [=[
<magenta>--------------------------------------------------------------------------------<reset>
<yellow>SUMMARY<reset>
Highlights are used to make certain patterns of output stand out so it's easier
to see at a glance what is happening. Basically, anything output that requires
attention is a valid highlight candidate.

<yellow>ALIASES<reset>
highlight {<pattern>} {fg} {bg}         create a new highlight
unhighlight {<pattern>}                 destroy an existing highlight
highlights                              list all existing highlights
highlight colors                        show the list of supported colors
highlight help                          show this help

<yellow>EXAMPLES<reset>
Create a new highlight for "radiation sickness" with a red background and
yellow foreground:

    <cyan>highlight {radiation sickness} {yellow} {red}<reset>

We can destroy this highlight by using its pattern again:

    <cyan>unhighlight {radiation sickness}<reset>

We can inspect the list of supported colors with the colors alias:

    <cyan>highlight colors<reset>

<yellow>REMARKS<reset>
The values for the forground (fg) and background (bg) colors are taken from the
list of standard Mudlet colors. You can review this list with the showColors
function that is part of the Mudlet API. Highlights have full regex support.
<magenta>--------------------------------------------------------------------------------<reset>
]=]

function highlight:help()
    cecho(help)
end

local aliases = {
    ["^highlight \\{(.+)\\} \\{(.+)\\} \\{(.+)\\}$"] = [[highlight:create(matches[2], matches[3], matches[4])]],
    ["^unhighlight \\{(.+)\\}$"] = [[highlight:destroy(matches[2])]],
    ["^highlights$"] = [[highlight:list()]],
    ["^highlight colors$"] = [[showColors()]],
    ["^highlight help$"] = [[highlight:help()]],
    ["^highlight$"] = [[highlight:help()]],
}

function highlight:init()
    for pat, code in pairs(aliases) do
        if self.aliases[pat] then
            killAlias(self.aliases[pat].id)
        end
        self.aliases[pat] = {
            id = tempAlias(pat, code),
            code = code,
        }
    end
    self.log:debug("Initialized debug module")    
end

function highlight:create(pattern, fg, bg)
    if self.highlights[pattern] then
        killTrigger(self.highlights[pattern].id)
    end
    self.highlights[pattern] = {
         fg = fg,
         bg = bg,
         id = tempRegexTrigger(pattern, string.format([[
             selectCaptureGroup(1)
             fg("%s")
             bg("%s")
             resetFormat()
         ]], fg, bg))
     }
     self.log:info(string.format("Ok, pattern '%s' will now highlight with %s fg and %s bg", pattern, fg, bg))
end

function highlight:destroy(pattern)
    if not self.highlights[pattern] then return end
    killTrigger(self.highlights[pattern].id)
    self.highlights[pattern] = nil
    self.log:info(string.format("Ok, highlight '%s' is no more", pattern))
end

function highlight:list()
    if self:count() <= 0 then
        self.log:info("There are no active highlights")
        return
    end

    cecho(string.format("<yellow>%5s %-32s %-16s %-16s<reset>\n", "id", "pattern", "fg", "bg"))
    for pat, hl in pairs(self.highlights) do
        cecho(string.format("%5d %-32s %-16s %-16s\n", hl.id, pat, hl.fg, hl.bg))
    end
end

function highlight:count()
    local c = 0
    for pat, gag in pairs(self.highlights) do
        c = c + 1
    end
    return c
end