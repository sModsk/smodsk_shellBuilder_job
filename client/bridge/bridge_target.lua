function CreateTargetZone(data)
    local options = {}
    if ox_target then
        for k,v in pairs(data.options) do
            table.insert(options, {
                event = v.event,
                icon = v.icon,
                label = v.label,
                onSelect = v.onSelect,
                canInteract = v.canInteract
            })
        end
        print(data.coords, data.radius)
        ox_target:addSphereZone({
            name = data.name,
            coords = data.coords,
            radius = data.radius,
            options = options
        })
    elseif qb_target then
         -- TODO --
    end
end