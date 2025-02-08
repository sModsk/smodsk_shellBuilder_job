local job = {}

RegisterNetEvent('esx:setJob', function(_job, _lastJob)
    job = _job
end)

RegisterNetEvent('esx:playerLoaded',function(xPlayer, isNew, skin)
    job = xPlayer.job
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    job = val.job
end)

function GetJob()
    return job
end