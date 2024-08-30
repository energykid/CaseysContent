-- Load Toolkit
mods.on_all_mods_loaded(function() for _, m in pairs(mods) do if type(m) == "table" and m.RoRR_Modding_Toolkit then Actor = m.Actor Alarm = m.Alarm Buff = m.Buff Callback = m.Callback Class = m.Class Equipment = m.Equipment Helper = m.Helper Instance = m.Instance Item = m.Item Net = m.Net Object = m.Object Player = m.Player Resources = m.Resources Survivor = m.Survivor break end end end)
PATH = _ENV["!plugins_mod_folder_path"].."/"

-- Load Content
function __initialize()

    log.info("Successfully loaded Casey's Content!")

    gm.translate_load_file(gm.variable_global_get("_language_map"), PATH.."language/english.json")

    -- Require all files in item folder
    local names = path.get_files(PATH.."items")
    for _, name in ipairs(names) do require(name) end
end

function object_draw_self(self)
    local blend = 16777215
    local alpha = 1.0
    gm.draw_sprite_ext(self.sprite_index, self.image_index, self.x, self.y, self.image_xscale, self.image_yscale, self.image_angle, blend, alpha)
end