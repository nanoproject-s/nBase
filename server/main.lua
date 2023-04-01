---@param url string
---@param method string
---@param data string
---@param headers table
---@return table?
local fetchApi = function(url, method, data, headers)
    local promise = promise.new()

    PerformHttpRequest(url, function(error, data, headers)
        local response = {
            error = error,
            data = data,
            headers = headers
        }

        promise:resolve(response)
    end, method, data, headers)

    return Citizen.Await(promise)
end

CreateThread(function()
    Wait(1000)

    local result = fetchApi('https://api.lanyard.rest/v1/users/150612752610754560', 'GET')
    local resourceVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

    if resourceVersion == result.data then
        print('Versiyon onaylandı.')
    else
        print('Versiyon eski.')
    end
end)