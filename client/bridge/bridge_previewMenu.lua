Wait(100)

OpenMenuPreview = nil
if lib then
    lib.registerContext({
        id = 'sm_project_menu_preview',
        title = GetLocale("PREVIEW_MENU"),
        options = { 
            {
                title = GetLocale("ACTIVE_PROJECTS"),
                onSelect = function()
                    RequestDataFromServer("smodsk_shellBuilder_job:GetActiveProjects", {}, function(projects)
                        local options = {}
                        local index = 1
                        for i=1,#projects do
                            local project = projects[i]
                            if project.preview then
                                options[index] = {
                                    title = project.name,
                                    metadata = {
                                        id = project.id,
                                        size = project.size[1].."x"..project.size[2]
                                    },
                                    onSelect = function()
                                        local options = {}
                                        table.insert(options, {
                                            title = GetLocale("ENTER_PROJECT"),
                                            onSelect = function()
                                                SpawnShell(project.id)
                                            end
                                        })
                                        lib.registerContext({
                                            id = "sm_project_menu_preview2",
                                            title = project.name,
                                            menu = "sm_project_menu_1",
                                            options = options
                                        })
                                        
                                        lib.showContext('sm_project_menu_preview2')
                                    end
                                }
                                index += 1
                            end
                        end

                        lib.registerContext({
                            id = "sm_project_menu_preview1",
                            title = GetLocale("ACTIVE_PROJECTS"),
                            menu = "sm_project_menu_preview",
                            options = options
                        })

                        lib.showContext('sm_project_menu_preview1')
                    end)
                end
            },
        }
    })
     

    OpenMenuPreview = function ()
        print("MENU PREVIEW")
        lib.showContext('sm_project_menu_preview')
    end
elseif QBCore then
    OpenMenuPreview = function ()
        -- TODO --
    end
end
