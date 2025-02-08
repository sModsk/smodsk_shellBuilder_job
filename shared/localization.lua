Localization = {
    language = "EN",
    languages = {
        ["EN"] = {

            ["OPEN_MENU"] = "Open Project Menu",
            ["PROJECTS"] = "Projects",
            ["CREATE_PROJECT"] = "Create New Project",
            ["PROJECT_NAME"] = "Project name",
            ["PROJECT_SIZE"] = "Project size",
            ["PUBLISHED_PROJECTS"] = "Published Projects",
            ["ACTIVE_PROJECTS"] = "Active Projects",
            ["REMOVE_PROJECT"] = "Remove Project",
            ["PUBLISH_PROJECT"] = "Publish Project",
            ["UNPUBLISH_PROJECT"] = "Unpublish Project",
            ["PROJECT_MENU"] = "Project Menu",
            ["ENTER_PROJECT"] = "Enter Project",
            ["PROJECT_CREATED"] = "Project created",
            ["PROJECT_UNPUBLISHED"] = "Project Unpublished",
            ["PROJECT_REMOVED"] = "Project Removed",
            ["PROJECT_PUBLISHED"] = "Project Published",
            ["NO_PERMISSION"] = "You don't have permission to do this",
            
            ["PREVIEW_MENU"] = "Preview Menu",
            ["SET_PREVIEW"] = "Set Preview Mode ",
            ["OPEN_PREVIEW_MENU"] = "Open Preview Menu",
            ["ON"] = "ON",
            ["OFF"] = "OFF",
            ["PREVIEW_MODE_ON"] = "Preview mode is now ON",
            ["PREVIEW_MODE_OFF"] = "Preview mode is now OFF",
            
            ["MINI_ONE"] = "Mini One",
            ["MINI_TWO"] = "Mini Two",
            ["MINI_THREE"] = "Mini Three",
            ["MEDIUM_ONE"] = "Medium One",
            ["MEDIUM_TWO"] = "Medium Two",
            ["MEDIUM_THREE"] = "Medium Three",
            ["LARGE_ONE"] = "Large One",
            ["LARGE_TWO"] = "Large Two",
            ["LARGE_THREE"] = "Large Three",

            
        },
        ["FI"] = {
            ["OPEN_MENU"] = "Avaa projektivalikko",
            ["PROJECTS"] = "Projektit",
            ["CREATE_PROJECT"] = "Luo uusi projekti",
            ["PROJECT_NAME"] = "Projektin nimi",
            ["PROJECT_SIZE"] = "Projektin koko",
            ["PUBLISHED_PROJECTS"] = "Julkaistut projektit",
            ["ACTIVE_PROJECTS"] = "Aktiiviset projektit",
            ["REMOVE_PROJECT"] = "Poista projekti",
            ["PUBLISH_PROJECT"] = "Julkaise projekti",
            ["UNPUBLISH_PROJECT"] = "Peruuta projektin julkaisu",
            ["PROJECT_MENU"] = "Projektivalikko",
            ["ENTER_PROJECT"] = "Siirry projektiin",
            ["PROJECT_CREATED"] = "Projekti luotu",
            ["PROJECT_UNPUBLISHED"] = "Projekti peruutettu",
            ["PROJECT_REMOVED"] = "Projekti poistettu",
            ["PROJECT_PUBLISHED"] = "Projekti julkaistu",
            ["NO_PERMISSION"] = "Sinulla ei ole oikeuksia tehdä tätä",

            ["PREVIEW_MENU"] = "Preview Menu",
            ["SET_PREVIEW"] = "Set Preview Mode ",
            ["OPEN_PREVIEW_MENU"] = "Open Preview Menu",
            ["ON"] = "ON",
            ["OFF"] = "OFF",

            ["PREVIEW_MODE_ON"] = "Preview mode is now ON",
            ["PREVIEW_MODE_OFF"] = "Preview mode is now OFF",

            ["MINI_ONE"] = "Mini Yksi",
            ["MINI_TWO"] = "Mini Kaksi",
            ["MINI_THREE"] = "Mini Kolme",
            ["MEDIUM_ONE"] = "Keski Yksi",
            ["MEDIUM_TWO"] = "Keski Kaksi",
            ["MEDIUM_THREE"] = "Keski Kolme",
            ["LARGE_ONE"] = "Iso Yksi",
            ["LARGE_TWO"] = "Iso Kaksi",
            ["LARGE_THREE"] = "Iso Kolme",    
        }
    },
}


local missingLocales = {}

function GetLocale(locale)
    if Localization.languages[Localization.language] and Localization.languages[Localization.language][locale] then
        return Localization.languages[Localization.language][locale]
    else
        missingLocales[locale] = true
        return locale
    end
end

--[[
RegisterCommand("missingLocales", function()
    print(json.encode(missingLocales))
end, false)
]]

