function RequestDataFromServer(event, data, callback)
    local eventHandler
    data = data or {}  
    eventHandler = RegisterNetEvent(event, function(receivedData)
        if callback then
            callback(receivedData)
        end
        RemoveEventHandler(eventHandler)
    end)
    
    TriggerServerEvent(event, data)
end