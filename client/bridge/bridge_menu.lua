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
                                -- Not safe to UnpublishProject since multiple apartments might share this data --
                                onSelect = function()
                                    local options = {}
                                    --[[
                                    if CanUnpublishProject() then
                                        table.insert(options, {
                                            title = GetLocale("UNPUBLISH_PROJECT"),
                                            onSelect = function()
                                                TriggerServerEvent("smodsk_shellBuilder_job:UnpublishProject", project.id)
                                            end
                                        })
                                    end   
                                    ]]
                                    table.insert(options, {
                                        title = GetLocale("ENTER_PROJECT"),
                                        onSelect = function()
                                            SpawnShell(project.id)
                                        end
                                    })
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

    -- QB 

    RegisterNetEvent("smodsk_shellBuilder_job:CREATE_PROJECT", function ()
        local project = OpenNewProjectDialog()
        if project then
            TriggerServerEvent("smodsk_shellBuilder_job:CreateProject", project)
        end
    end)

    RegisterNetEvent("smodsk_shellBuilder_job:ACTIVE_PROJECT:SELECT", function(data)
        local action = data.action
        local project = data.project
        if action == "enter" then 
            SpawnShell(project.id) 
        elseif action == "preview" then
            TriggerServerEvent("smodsk_shellBuilder_job:SetPreviewMode", project.id, not project.preview)
        elseif action == "publish" then
            TriggerServerEvent("smodsk_shellBuilder_job:PublishProject", project.id)
        elseif action == "remove" then
            TriggerServerEvent("smodsk_shellBuilder_job:RemoveProject", project.id)
        end
    end)

    RegisterNetEvent("smodsk_shellBuilder_job:ACTIVE_PROJECT", function(data)
       local project = data.project
       local options = {}


       table.insert(options, {
            header = GetLocale("ENTER_PROJECT"),
            params = {
                event = "smodsk_shellBuilder_job:ACTIVE_PROJECT:SELECT",
                args = {
                   action = "enter",
                   project = project
                }
           }
        })

        table.insert(options, {
            header = GetLocale("SET_PREVIEW").." "..(project.preview and GetLocale("OFF") or GetLocale("ON")),
            params = {
                event = "smodsk_shellBuilder_job:ACTIVE_PROJECT:SELECT",
                args = {
                   action = "preview",
                   project = project
                }
           }
        })

        if CanPublishProject() then
            table.insert(options, {
                header = GetLocale("PUBLISH_PROJECT"),
                params = {
                    event = "smodsk_shellBuilder_job:ACTIVE_PROJECT:SELECT",
                    args = {
                       action = "publish",
                       project = project
                    }
               }
            })
        end
   
        if CanRemoveProject() then
            table.insert(options, {
                header = GetLocale("REMOVE_PROJECT"),
                params = {
                    event = "smodsk_shellBuilder_job:ACTIVE_PROJECT:SELECT",
                    args = {
                       action = "remove",
                       project = project
                    }
               }
            })
        end 

        exports['qb-menu']:openMenu(options)
    end)

    RegisterNetEvent("smodsk_shellBuilder_job:ACTIVE_PROJECTS", function ()
        RequestDataFromServer("smodsk_shellBuilder_job:GetActiveProjects", {}, function(projects)
            local options = {
                {
                    header = GetLocale("ACTIVE_PROJECTS"),
                    isMenuHeader = true,
                }
            }
            for i=1,#projects do
                local project = projects[i]
                options[i+1] = {
                    header = project.name,
                    params = {
                         event = "smodsk_shellBuilder_job:ACTIVE_PROJECT",
                         args = {
                            project = project
                         }
                    }
                }
            end

            exports['qb-menu']:openMenu(options)
        end)
    end)


    RegisterNetEvent("smodsk_shellBuilder_job:PUBLISHED_PROJECT:ENTER", function (data)
        SpawnShell(data.project.id) 
    end)

    RegisterNetEvent("smodsk_shellBuilder_job:PUBLISHED_PROJECT", function(data)
        local project = data.project
        local options = {
            {
                header = GetLocale("ENTER_PROJECT"),
                params = {
                    event = "smodsk_shellBuilder_job:PUBLISHED_PROJECT:ENTER",
                    args = {
                       project = project
                    }
               }
            }
        }

        exports['qb-menu']:openMenu(options)
    end)

    RegisterNetEvent("smodsk_shellBuilder_job:PUBLISHED_PROJECTS", function ()
        RequestDataFromServer("smodsk_shellBuilder_job:GetPublishedProjects", {}, function(projects)
            local options = {
                {
                    header = GetLocale("ACTIVE_PROJECTS"),
                    isMenuHeader = true,
                }
            }
            for i=1,#projects do
                local project = projects[i]
                options[i+1] = {
                    header = project.name,
                    params = {
                         event = "smodsk_shellBuilder_job:PUBLISHED_PROJECT",
                         args = {
                            project = project
                         }
                    }
                }
            end

            exports['qb-menu']:openMenu(options)
        end)
    end)

    OpenMenu = function ()
        exports['qb-menu']:openMenu({
            {
                header = GetLocale("PROJECT_MENU"),
                isMenuHeader = true,
            },
            {
                header =  GetLocale("CREATE_PROJECT"),
                params = { event = "smodsk_shellBuilder_job:CREATE_PROJECT"}
            }, 
            {
                header =  GetLocale("ACTIVE_PROJECTS"),
                params = { event = "smodsk_shellBuilder_job:ACTIVE_PROJECTS"}
            }, 
            {
                header =  GetLocale("PUBLISHED_PROJECTS"),
                params = { event = "smodsk_shellBuilder_job:PUBLISHED_PROJECTS"}
            }, 
        })
    end
end