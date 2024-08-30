
local sprite = Resources.sprite_load(PATH.."assets/sprites/coalChunk.png", 1, false, false, 17, 12);
local buffSprite = Resources.sprite_load(PATH.."assets/sprites/coalBoostBuff.png", 1, false, false, 5, 6);

local item = Item.create("CaseysContent", "coalChunk");
Item.set_sprite(item, sprite);
Item.set_tier(item, Item.TIER.common)
Item.set_loot_tags(item, Item.LOOT_TAG.category_utility)

-- Buff

local coalChunkSpeedBoost = function(stack)
    return 2.8 * (0.2 + (0.1 * (stack - 1)))
end

local buff = Buff.create("CaseysContent", "coalBoost")
Buff.set_property(buff, Buff.PROPERTY.icon_sprite, buffSprite)

Buff.add_callback(buff, "onApply", function(actor, stack)
    local count = Item.get_stack_count(actor, item)
    actor.pHmax_base = actor.pHmax_base + coalChunkSpeedBoost(count)
end)

Buff.add_callback(buff, "onRemove", function(actor, stack)
    local count = Item.get_stack_count(actor, item)
    actor.pHmax_base = actor.pHmax_base - coalChunkSpeedBoost(count)
end)

Item.add_callback(item, "onStep", function(actor, stack)
    if actor.object_index == gm.constants.oP then
        if (gm.player_get_gold(actor) < (stack * 25)) then
            Buff.apply(actor, buff, 10)
        end
    end
end)