local job = {}

RegisterNetEvent('esx:setJob', function(_job, _lastJob)
    job = _job
end)
RegisterNetEvent('esx:playerLoaded',function(xPlayer, isNew, skin)
    job = xPlayer.job
end)
CreateThread(function () Wait(100) job = ESX.PlayerData.job end)

function GetJob()
    if ESX then 
        return job
    else
        return QBCore.Functions.GetPlayerData().job
    end
end