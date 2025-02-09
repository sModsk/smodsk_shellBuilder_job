Wait(1000)

OpenNewProjectDialog = nil
OpenPublishDialog = nil
OpenUnpublishDialog = nil

if lib then
    OpenNewProjectDialog = function()
        local selection = {}
        for i=1,#Config.shellSizes do
            local data = Config.shellSizes[i]
            table.insert(selection, {label = GetLocale(data.locale).." ("..data.size[1].."x"..data.size[2]..")", value = data.size})
        end

        return lib.inputDialog(GetLocale("CREATE_PROJECT"), {
            {type = 'input', label = GetLocale("PROJECT_NAME"), required = true, min = 4, max = 30},
            {type = 'select', label = GetLocale("PROJECT_SIZE"), required = true, options = selection},
        })
    end

    OpenPublishDialog = function(data)
        return lib.alertDialog({
            header = GetLocale("PUBLISH_PROJECT"),
            content = data.name,
            centered = true,
            cancel = true
        })
    end

    OpenUnpublishDialog = function(data)
        return lib.alertDialog({
            header = GetLocale("UNPUBLISH_PROJECT"),
            content = data.name,
            centered = true,
            cancel = true
        })
    end

    OpenDestroyDialog = function(data)
        return lib.alertDialog({
            header = GetLocale("DESTROY_PROJECT"),
            content = data.name,
            centered = true,
            cancel = true
        })
    end
    
elseif QBCore then
    OpenNewProjectDialog = function()
        local selection = {}
        for i=1,#Config.shellSizes do
            local data = Config.shellSizes[i]
            table.insert(selection, {text = GetLocale(data.locale).." ("..data.size[1].."x"..data.size[2]..")", value = data.size})
        end

        local dialog =  exports['qb-input']:ShowInput(
            {
                header = GetLocale("CREATE_PROJECT"), 
                inputs = {
                    {
                        type = 'text',
                        text = GetLocale("PROJECT_NAME"), 
                        name = "name",
                        isRequired  = true,
                    },
                    {
                        type = 'select', 
                        text = GetLocale("PROJECT_SIZE"), 
                        isRequired  = true,
                        name = "size",
                        options = selection
                    },
            }
        })
        if dialog == nil then return false end
        
        local t  = {}
        for num in string.gmatch(dialog.size, "%d+") do
            table.insert(t, tonumber(num))
        end

        return {
            dialog.name, t
        }
    end

    OpenPublishDialog = function(data)
        return exports['qb-input']:ShowInput({
            header = GetLocale("PUBLISH_PROJECT"),
            inputs = {}
        })
    end

    OpenUnpublishDialog = function(data)
        return exports['qb-input']:ShowInput({
            header = GetLocale("UNPUBLISH_PROJECT"),
            inputs = {}
        })
    end

    OpenDestroyDialog = function(data)
        return exports['qb-input']:ShowInput({
            header = GetLocale("DESTROY_PROJECT"),
            inputs = {}
        })
    end
end
