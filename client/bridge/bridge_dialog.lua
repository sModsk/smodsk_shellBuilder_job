Wait(1000)

OpenNewProjectDialog = nil
OpenPublishDialog = nil
OpenUnpublishDialog = nil

if lib then
    OpenNewProjectDialog = function()
        local selection = {}
        for i=1,#Config.shellSizes do
            local data = Config.shellSizes[i]
            print(data.locale)
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
    -- TODO --
end