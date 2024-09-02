require("math")

local sprite = Resources.sprite_load(PATH.."assets/sprites/spaceRadio.png", 1, false, false, 18, 16);
local procSprite = Resources.sprite_load(PATH.."assets/sprites/spaceRadioProc.png", 9, false, false, 24, 11);
local sound = Resources.sfx_load(PATH.."assets/sounds/spaceRadioProc.ogg")

local item = Item.create("CaseysContent", "spaceRadio");
Item.set_sprite(item, sprite);
Item.set_tier(item, Item.TIER.uncommon)
Item.set_loot_tags(item, Item.LOOT_TAG.category_utility)

Item.add_callback(item, "onPickup", function(actor, stack)
    actor.oldVsp = actor.pVspeed
end)
Item.add_callback(item, "onStep", function(actor, stack)

    if (actor.oldVsp ~= 0.0 and actor.pVspeed == 0.0) then 
        if (actor.sprite_index ~= actor.sprite_climb) then
            local chance = 15 + (math.max(stack - 1, 0) * 7)

            if (math.random(100) <= chance) then

                -- Damage and stun nearby enemies

                local dist = 60
                local damage_coeff = 1 + (0.25 * (stack - 1))
                local stun_coeff = 0.5 + (0.2 * (stack - 1))
                Actor.fire_explosion(actor, lerp(actor.bbox_left, actor.bbox_right, 0.5), actor.bbox_bottom, dist, dist, damage_coeff, stun_coeff)

                -- Spawn effects
                local inst = Object.spawn(Object.find("CaseysContent", "spaceRadioProc"), lerp(actor.bbox_left, actor.bbox_right, 0.5), actor.bbox_bottom + 1)

                inst.depth = actor.depth

                gm.sound_play_at(sound, 1.0, 1.0, actor.x, actor.y, 1.0)
            end
        end
    end
    actor.oldVsp = actor.pVspeed
end)

--#region Proc Object

local projObj = Object.create("CaseysContent", "spaceRadioProc")

Object.add_callback(projObj, "Init", function(self)
    self.sprite_index = procSprite
    self.t = 0
end)

Object.add_callback(projObj, "Step", function(self)
    self.t = self.t + 0.2

    if (self.t >= 9) then
        gm.instance_destroy(self, false)
    end
end)

Object.add_callback(projObj, "Draw", function (self)
    local blend = 16777215
    gm.draw_sprite_ext(self.sprite_index, self.t, self.x, self.y, 1.0, 1.0, self.image_angle, blend, 1.0)
end)

--#endregion