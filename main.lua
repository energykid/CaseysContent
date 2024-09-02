-- Load requires
require("math")

-- Load Toolkit
mods.on_all_mods_loaded(function() for _, m in pairs(mods) do if type(m) == "table" and m.RoRR_Modding_Toolkit then Actor = m.Actor Alarm = m.Alarm Buff = m.Buff Callback = m.Callback Class = m.Class Equipment = m.Equipment Helper = m.Helper Instance = m.Instance Item = m.Item Net = m.Net Object = m.Object Player = m.Player Resources = m.Resources Survivor = m.Survivor break end end end)

-- Load Helper Functions
mods.on_all_mods_loaded(function() for k, v in pairs(mods) do if type(v) == "table" and v.hfuncs then Helper = v end end end)

-- Initialize PATH
PATH = _ENV["!plugins_mod_folder_path"].."/"

-- #region Global Functions
GlobalStep = {
}
GlobalDraw = {
}

AddFunction = function(tab, func)
    table.insert(tab, func)
end

function RunFunctionsFromTable(tableToRunFrom)
    for _, i in ipairs(tableToRunFrom) do
        if type(i) == "function" then
            i()
        end
    end
end

-- #endregion

-- Load Content
function __initialize()

    gm.translate_load_file(gm.variable_global_get("_language_map"), PATH.."language/english.json")

    -- Require all files in item folder
    local names = path.get_files(PATH.."items")
    for _, name in ipairs(names) do require(name) end

    -- Require all files in global folder
    local names2 = path.get_files(PATH.."globals")
    for _, name in ipairs(names2) do require(name) end

    require("globalBehavior")

    log.info("Successfully loaded Casey's Content!")
end