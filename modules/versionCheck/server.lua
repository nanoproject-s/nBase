---@param url string
---@param method string
---@param data string
---@param headers table
---@return table?
local function fetchApi(url, method, data, headers)
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
    local result = fetchApi('https://api.github.com/repos/nanoproject-s/nBase/releases/latest', 'GET')
    local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version'):gsub('%.', '')
    local latestVersion = json.decode(result.data).tag_name:sub(2):gsub('%.', '')

    if tonumber(latestVersion) > tonumber(currentVersion) then
        print('^3An update is available for nBase.\nhttps://github.com/nanoproject-s/nBase/releases/latest^0')
    end

    -- if resourceVersion == result.data then
    --     print('Versiyon onaylandı.')
    -- else
    --     print('Versiyon eski.')
    -- end
end)