utils = utils or {}

local help = [=[
SUMMARY
This module currently contains a stand-alone reference version of the eval 
function that is also included locally in most other modules. This is the
same function that is inluded in Mudlet and runs the lua alias.
]=]

function utils:eval(code)
    local f, e = loadstring("return "..code)
    if not f then
        f, e = assert(loadstring(code))
    end
    
    local r = f()
    if r ~= nil then display(r) end
end
