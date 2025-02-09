local job = {}

RegisterNetEvent('esx:setJob', function(_job, _lastJob)
    job = _job
end)
RegisterNetEvent('esx:playerLoaded',function(xPlayer, isNew, skin)
    job = xPlayer.job
end)
CreateThread(function () Wait(100) if ESX then job = ESX.PlayerData.job end end)

function GetJob()
    if ESX then 
        return job
    else
        local _job = QBCore.Functions.GetPlayerData().job
        job.name = _job.name
        job.grade = _job.grade.level
        return job
    end
end