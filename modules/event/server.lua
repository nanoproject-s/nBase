local event = {}
local callbacks = {}
local prefix = ('event__nano_%s')

---@param name string
---@param ... any
RegisterNetEvent(prefix:format('response'), function(name, ...)
    callbacks[name](...)
end)

---@param name string
---@param ... any
RegisterNetEvent(prefix:format('trigger'), function(name, ...)
    TriggerClientEvent(prefix:format('response'), source, name, callbacks[name](source, ...))
end)

---@param name string
---@param callback function
function event.register(name, callback)
    callbacks[name] = callback
end

---@param name string
---@param ... any
function event.trigger(name, ...)
    return callbacks[name](...)
end

---@param name string
---@param source number
---@param ... any
---@return ...
function event.triggerClient(name, source, ...)
    local promise = promise:new()

    callbacks[name] = function(...)
        promise:resolve({...})
    end
    
    TriggerClientEvent(prefix:format('trigger'), source, name, ...)

    return table.unpack(Citizen.Await(promise))
end

Base.event = event