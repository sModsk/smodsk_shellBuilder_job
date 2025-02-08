Config = {

    jobName = "police",
    creatorGrade = 2, -- Job grade you need have to create new project to build
    publisherGrade = 3, -- Job grade you need to set shell to public

    menuSettings = {
        coords = vec3(-1070.789, -2868.408, 13.951),
        radius = 1.0
    },

    -- From this menu other players can enter to shells that are marked for previewing
    previewMenuSettings = {
        coords = vec3(-1072.637, -2866.397, 13.951),
        radius = 1.0
    },

    shellSizes = {
        { locale = "MINI_ONE", size = {5, 1} },
        { locale = "MINI_TWO", size = {5, 2} },
        { locale = "MINI_THREE", size = {5, 3} },
        
        { locale = "MEDIUM_ONE", size = {7, 1} },
        { locale = "MEDIUM_TWO", size = {7, 2} },
        { locale = "MEDIUM_THREE", size = {7, 2} },
        
        { locale = "LARGE_ONE", size = {9, 1} },
        { locale = "LARGE_TWO", size = {9, 2} },
        { locale = "LARGE_THREE", size = {9, 2} },
    },

    shellSpawnPositions = {
        vec3(-1400, -2800, -100), 
        vec3(-1400, -2900, -100), 
        vec3(-1400, -3000, -100), 
        vec3(-1400, -3100, -100), 
        vec3(-1500, -2800, -100), 
        vec3(-1500, -2900, -100), 
        vec3(-1500, -3000, -100), 
        vec3(-1500, -3100, -100), 
    }
    
}


-- if not IsDuplicityVersion() then
-- CreateThread(function ()
--     while true do

--         for k,v in pairs(Config.shellSpawnPositions) do
--             DrawMarker(28, 
--                 v.x, v.y, v.z, 
--                 0.0, 0,0, 0,0, 0.0,
--                 10.0, 10.0, 10.0,
--                 255, 0, 0, 255,
--                 false, false, false, false, false)
--         end

--         Wait(1)
--     end
-- end)
-- end
