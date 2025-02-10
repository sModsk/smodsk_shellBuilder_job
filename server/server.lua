math.randomseed(os.time())

local projects = nil
local finishedProjects = nil

local spawnedShells = {}
local players = {}


local function generateUniqueId()
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local uniqueId = ""

    for i = 1, 8 do
        local randIndex = math.random(1, #charset)
        uniqueId = uniqueId .. charset:sub(randIndex, randIndex)
    end

    return uniqueId
end

local function loadProjects()
    if projects == nil then
        local projectString = GetResourceKvpString("projects")
        if projectString then 
            projects = json.decode(projectString) 
        else 
            projects = {} 
        end
    end
end

local function loadFinishedProjects()
    if finishedProjects == nil then
        local projectString = GetResourceKvpString("finishedProjects")
        if projectString then 
            finishedProjects = json.decode(projectString) 
        else 
            finishedProjects = {} 
        end
    end
end

local function addToFinished(project)
    loadFinishedProjects()
    table.insert(finishedProjects, project)
    SetResourceKvp("finishedProjects", json.encode(finishedProjects))
end

local function removeFromFinished(id)
    loadFinishedProjects()
    for i=1,#finishedProjects do
        local project = finishedProjects[i]
        if project.id == id then
            table.remove(finishedProjects, i)
            SetResourceKvp("finishedProjects", json.encode(finishedProjects))
            break
        end
    end
end

local function getFinishedProject(id)
    loadFinishedProjects()
    for i=1,#finishedProjects do
        if finishedProjects[i].id == id then
            return finishedProjects[i]
        end
    end
    return false
end

local function getProject(id)
    loadProjects()
    for i=1,#projects do
        if projects[i].id == id then
            return projects[i]
        end
    end
    return false
end

local function addProject(project)
    loadProjects()
    table.insert(projects, project)
    SetResourceKvp("projects", json.encode(projects))
end

local function updateProjects()
    SetResourceKvp("projects", json.encode(projects))
end

local function removeProject(id)
    loadProjects()
    for i=1,#projects do
        local project = projects[i]
        if project.id == id then
            table.remove(projects, i)
            SetResourceKvp("projects", json.encode(projects))
            break
        end
    end
end

local function destroyProject(id)
    removeProject(id)
    exports["smodsk_shellBuilder"]:DeleteShell(id)
end

local function publishProject(id)
    local project = getProject(id)
    if project then
        exports["smodsk_shellBuilder"]:SetPublic(id, true)
        removeProject(id)
        addToFinished(project)
        return true
    end
    return false
end

local function unpublishProject(id)
    local project = getFinishedProject(id)
    if project then
        exports["smodsk_shellBuilder"]:SetPublic(id, false)
        removeFromFinished(id)
        addProject(project)  
        return true
    end
    return false
end

local function notification(source, message, success)
    TriggerClientEvent("smodsk_shellBuilder_job:notification", source, message, 6000, true)
end


RegisterServerEvent("smodsk_shellBuilder_job:GetActiveProjects", function(...)
    local source = source
    loadProjects()
    TriggerClientEvent("smodsk_shellBuilder_job:GetActiveProjects", source, projects)
end)

RegisterServerEvent("smodsk_shellBuilder_job:GetPublishedProjects", function(...)
    local source = source
    loadFinishedProjects()
    TriggerClientEvent("smodsk_shellBuilder_job:GetPublishedProjects", source, finishedProjects)
end)

RegisterServerEvent("smodsk_shellBuilder_job:CreateProject", function(project)
    local source = source
    local project = {
        name = project[1],
        size = project[2],
        id = generateUniqueId()
    }

    addProject(project)
    local success, id = exports["smodsk_shellBuilder"]:CreateNewShell(project.id, project.size, project.name)
    notification(source, GetLocale("PROJECT_CREATED"), true)
end)

RegisterServerEvent("smodsk_shellBuilder_job:PublishProject", function(id)
    local source = source 
    if publishProject(id) then
        notification(source, GetLocale("PROJECT_PUBLISHED"), true)
    else
        notification(source, GetLocale("PROJECT_NOT_PUBLISHED"), true)
    end
end)

RegisterServerEvent("smodsk_shellBuilder_job:UnpublishProject", function(id)
    local source = source 
    if unpublishProject(id) then
        notification(source, GetLocale("PROJECT_UNPUBLISHED"), true)
    else
        notification(source, GetLocale("PROJECT_NOT_UNPUBLISHED"), false)
    end
end)

RegisterServerEvent("smodsk_shellBuilder_job:RemoveProject", function(id)
    local source = source 
    destroyProject(id)
    notification(source, GetLocale("PROJECT_REMOVED"), true)
end)

RegisterServerEvent("smodsk_shellBuilder_job:SetPreviewMode", function(id, value)
    local source = source 
    local project = getProject(id)
    project.preview = value
    updateProjects()

    if value then
        notification(source, GetLocale("PREVIEW_MODE_ON"), true)
    else
        notification(source, GetLocale("PREVIEW_MODE_OFF"), true)
    end
end)

RegisterServerEvent("smodsk_shellBuilder_job:EnterShell", function(data)
    local source = source 
    local id = data.id

    if spawnedShells[id] then
        players[source] = id
        table.insert(spawnedShells[id].players, source)
        TriggerClientEvent("smodsk_shellBuilder_job:EnterShell", source, spawnedShells[id].index)
    else
        local usedIndexes = {}
        for k,v in pairs(spawnedShells) do
            usedIndexes[v.index] = true
        end
        for i=1,#Config.shellSpawnPositions do
            if not usedIndexes[i] then
                players[source] = id
                spawnedShells[id] = {
                    players = {source},
                    index = i
                }

                TriggerClientEvent("smodsk_shellBuilder_job:EnterShell", source, i)
                break
            end
        end
    end
end)

local function exitShell(source)
    local id = players[source]
    players[source] = nil
    if id then
        if spawnedShells[id] then
            for i=1,#spawnedShells[id].players do
                if spawnedShells[id].players[i] == source then
                    table.remove(spawnedShells[id].players, i)
                    if #spawnedShells[id].players == 0 then
                        spawnedShells[id] = nil 
                    end
                    break
                end
            end
        end
    end
end

RegisterServerEvent("smodsk_shellBuilder_job:ExitShell", function()
    exitShell(source) 
end)

AddEventHandler('playerDropped', function(reason)
    exitShell(source)
end)
