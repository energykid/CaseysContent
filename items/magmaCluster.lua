
local sprite = Resources.sprite_load(PATH.."assets/sprites/magmaCluster.png", 1, false, false, 16, 18);

local item = Item.create("CaseysContent", "magmaCluster");
Item.set_sprite(item, sprite);
Item.set_tier(item, Item.TIER.common)
Item.set_loot_tags(item, Item.LOOT_TAG.category_damage)

Item.add_callback(item, "onPickup", function(actor, stack)
    if not actor.cascon_damageIncrease then 
        actor.cascon_damageIncrease = 0
        actor.cascon_damageIncreaseCap = 0.1
        actor.cascon_damageIncreaseResetTimer = 0
    end
end)

Item.add_callback(item, "onStep", function(actor, stack)
    if (actor.cascon_damageIncreaseResetTimer <= 0) then
        actor.cascon_damageIncrease = 0
    else
        actor.cascon_damageIncreaseResetTimer = actor.cascon_damageIncreaseResetTimer - 1
    end
end)

Item.add_callback(item, "onAttack", function(actor, damager, stack)

    damager.damage = damager.damage * (1 + actor.cascon_damageIncrease);

    local num = Helper.mixed_hyperbolic(stack, 0.005, 0.01)
    actor.cascon_damageIncrease = actor.cascon_damageIncrease + num
    actor.cascon_damageIncrease = math.min(actor.cascon_damageIncrease, Helper.mixed_hyperbolic(stack, 0.05, 0.1))
end)

Item.add_callback(item, "onHit", function(actor, victim, damager, stack)
    actor.cascon_damageIncreaseResetTimer = 60
end)