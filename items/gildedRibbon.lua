local sprite = Resources.sprite_load(PATH.."assets/sprites/gildedRibbon.png", 1, false, false, 16, 18);

local item = Item.create("CaseysContent", "gildedRibbon");
Item.set_sprite(item, sprite);
Item.set_tier(item, Item.TIER.common)
Item.set_loot_tags(item, Item.LOOT_TAG.category_utility)

-- Buff

local gildedRibbonSpeedBoost = function(stack)
    return 2.8 * (0.2 + (0.1 * (stack - 1)))
end

local buff = Buff.create("CaseysContent", "ribbonBoost")
Buff.set_property(buff, Buff.PROPERTY.show_icon, false)

Buff.add_callback(buff, "onApply", function(actor, stack)
    local count = Item.get_stack_count(actor, item)
    actor.pHmax_base = actor.pHmax_base + gildedRibbonSpeedBoost(count)
end)

Buff.add_callback(buff, "onRemove", function(actor, stack)
    local count = Item.get_stack_count(actor, item)
    actor.pHmax_base = actor.pHmax_base - gildedRibbonSpeedBoost(count)
end)

-- Script for determining mobility skill activation effects

gm.pre_script_hook(gm.constants.skill_activate, function(self, other, result, args)
    if args[1].value ~= 2.0 or gm.array_get(self.skills, 2).active_skill.skill_id == 70.0 then return true end
    
    local count = Item.get_stack_count(self, item)

    if (count > 0) then
        Buff.apply(self, buff, 30 + (10 * (count - 1)), count)
    end
end)