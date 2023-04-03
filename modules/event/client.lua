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
    TriggerServerEvent(prefix:format('response'), name, callbacks[name](...))
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
function event.triggerServer(name, ...)
    local promise = promise:new()

    callbacks[name] = function(...)
        promise:resolve({...})
    end
    
    TriggerServerEvent(prefix:format('trigger'), name, ...)

    return table.unpack(Citizen.Await(promise))
end

Base.event = event