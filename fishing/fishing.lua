fishing = fishing or {}
fishing.log = fishing.log or {}
fishing.aliases = fishing.aliases or {}

local aliases = {
    ["^fish (n|e|s|w|ne|nw|se|sw)$"] = [[
        send("bait pole with worm")
        send(string.format("cast worm to %s", matches[2]))
    ]],
}

function fishing:init()
    
end
