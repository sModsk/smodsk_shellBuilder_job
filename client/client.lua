MyHouse = {}
InHouse = false


local function doorPositionChanged(key, position)
    MyHouse.exits[key] = position
end

local function teleport(position)
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local entity = (vehicle ~= 0) and vehicle or player
    SetEntityCoords(entity, position.x, position.y, position.z, false, false, false, false)
    SetEntityHeading(entity, position.w)
    if vehicle ~= 0 then 
        TaskWarpPedIntoVehicle(player, vehicle, -1) 
    end
end

local function enterHouse(doorPos, garagePos)
    if InHouse then return end 
    
    MyHouse.exits = { door = doorPos, garage = garagePos }
    local player, vehicle = PlayerPedId(), GetVehiclePedIsIn(PlayerPedId())
    local exitSpawn = GetEntityCoords(player)
    local exitHeading = GetEntityHeading(player) - 180

    if not garagePos and vehicle ~= 0 then
        print("^1 We can't teleport inside since there is no garagePos defined")
        exports["smodsk_shellBuilder"]:DespawnShell()
        return 
    else
        teleport((vehicle ~= 0) and garagePos or (doorPos ~= nil) and doorPos or garagePos)
    end

    InHouse = true

    CreateThread(function()
        while InHouse do
            player = PlayerPedId()
            local coords = GetEntityCoords(player)
            for _, pos in pairs(MyHouse.exits) do
                if pos then
                    local distance = #(coords - vec3(pos.x, pos.y, pos.z))
                    if distance < 20.0 then
                        DrawMarker(1, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 1, 1, .3, 255, 0, 0, 100, false, false, 2, false)
                        if distance < 2.0 and IsControlJustReleased(0, 38) then
                            teleport(vec4(exitSpawn.x, exitSpawn.y, exitSpawn.z, exitHeading))
                            exports["smodsk_shellBuilder"]:DespawnShell()
                            TriggerServerEvent("smodsk_shellBuilder_job:ExitShell")
                            MyHouse = {}
                            InHouse = false
                            return
                        end
                    end
                end
            end
            Wait(1)
        end
    end)
end

function SpawnShell(id)
    if InHouse then return end
    RequestDataFromServer("smodsk_shellBuilder_job:EnterShell", {id = id}, function(index)
        local success, doorPos, garagePos = exports["smodsk_shellBuilder"]:SpawnShell(
        {
            id = id,
            position = Config.shellSpawnPositions[index],
            doorPositionChanged = function(door, position)
                doorPositionChanged(door, position)
            end,
            canOpenMenu = function()
                return CanOpenMenu()
            end,
            canTogglePublic = function()
                return CanOpenMenu()
            end,
            canBuild = function()
                return CanOpenMenu()
            end,
            canPaint = function()
                return CanOpenMenu()
            end
        })
        if success then
            enterHouse(doorPos, garagePos)
        end
    end)
end


CreateTargetZone({
    coords = Config.menuSettings.coords,
    radius = Config.menuSettings.radius,
    name = "sm_building_menu",
    options = {
        {
            label = GetLocale("OPEN_MENU"),
            onSelect = function()
                OpenMenu()
            end,
            canInteract = function()
                return CanOpenMenu()
            end
        }
    }
})

CreateTargetZone({
    coords = Config.previewMenuSettings.coords,
    radius = Config.previewMenuSettings.radius,
    name = "sm_building_preview_menu",
    options = {
        {
            label = GetLocale("OPEN_PREVIEW_MENU"),
            onSelect = function()
                OpenMenuPreview()
            end,
            canInteract = function()
                return true
            end
        }
    }
})

