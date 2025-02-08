Wait(100)
OpenMenu = nil

if lib then
    lib.registerContext({
        id = 'sm_project_menu',
        title = GetLocale("PROJECT_MENU"),
        options = { 
            {
                title = GetLocale("CREATE_PROJECT"),
                onSelect = function()
                    if CanCreateProject() then
                        local project = OpenNewProjectDialog()
                        if project then
                            TriggerServerEvent("smodsk_shellBuilder_job:CreateProject", project)
                        end
                        
                    else
                        Notify(GetLocale("NO_PERMISSION"), 6000, false)
                    end
                    lib.showContext('sm_project_menu')
                end
            },
            {
                title = GetLocale("ACTIVE_PROJECTS"),
                onSelect = function()
                    RequestDataFromServer("smodsk_shellBuilder_job:GetActiveProjects", {}, function(projects)
                        local options = {}
                        for i=1,#projects do
                            local project = projects[i]
                            options[i] = {
                                title = project.name,
                                metadata = {
                                    id = project.id,
                                    size = project.size[1].."x"..project.size[2]
                                },
                                onSelect = function()
                                    -- Lets open yet another menu...
                                    local options = {}
                                    table.insert(options, {
                                        title = GetLocale("ENTER_PROJECT"),
                                        onSelect = function()
                                            SpawnShell(project.id)
                                        end
                                    })


                                    table.insert(options, {
                                        title = GetLocale("SET_PREVIEW").." "..(project.preview and GetLocale("OFF") or GetLocale("ON")),
                                        onSelect = function()
                                            TriggerServerEvent("smodsk_shellBuilder_job:SetPreviewMode", project.id, not project.preview)
                                        end
                                    })

                                    if CanPublishProject() then
                                        table.insert(options, {
                                            title = GetLocale("PUBLISH_PROJECT"),
                                            onSelect = function()
                                                TriggerServerEvent("smodsk_shellBuilder_job:PublishProject", project.id)
                                            end
                                        })
                                    end
                                   
                                    if CanRemoveProject() then
                                        table.insert(options, {
                                            title = GetLocale("REMOVE_PROJECT"),
                                            onSelect = function()
                                                TriggerServerEvent("smodsk_shellBuilder_job:RemoveProject", project.id)
                                            end
                                            
                                        })
                                    end 
                                    
                                    lib.registerContext({
                                        id = "sm_project_menu_2",
                                        title = project.name,
                                        menu = "sm_project_menu_1",
                                        options = options
                                    })
                                    
                                    lib.showContext('sm_project_menu_2')
                                end
                            }
                        end

                        lib.registerContext({
                            id = "sm_project_menu_1",
                            title = GetLocale("ACTIVE_PROJECTS"),
                            menu = "sm_project_menu",
                            options = options
                        })

                        lib.showContext('sm_project_menu_1')
                    end)
                end
            },
            {
                title = GetLocale("PUBLISHED_PROJECTS"),
                onSelect = function()
                    RequestDataFromServer("smodsk_shellBuilder_job:GetPublishedProjects", {}, function(projects)
                        local options = {}
                        for i=1,#projects do
                            local project = projects[i]
                            options[i] = {
                                title = project.name,
                                onSelect = function()
                                    if CanUnpublishProject() then
                                        table.insert(options, {
                                            title = GetLocale("UNPUBLISH_PROJECT"),
                                            onSelect = function()
                                                TriggerServerEvent("smodsk_shellBuilder_job:UnpublishProject", project.id)
                                            end
                                        })
                                    end                       
                                    lib.registerContext({
                                        id = "sm_project_menu_2",
                                        title = project.name,
                                        menu = "sm_project_menu_1",
                                        options = options
                                    })
                                    
                                    lib.showContext('sm_project_menu_2')
                                end
                            }
                        end

                        lib.registerContext({
                            id = "sm_project_menu_1",
                            title = GetLocale("PUBLISHED_PROJECTS"),
                            menu = "sm_project_menu",
                            options = options
                        })

                        lib.showContext('sm_project_menu_1')
                    end)
                end
            },
        }
    })
     

    OpenMenu = function ()
        lib.showContext('sm_project_menu')
    end
elseif QBCore then
    OpenMenu = function ()
        -- TODO --
    end
end
