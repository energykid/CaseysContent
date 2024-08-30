local sprite = Resources.sprite_load(PATH.."assets/sprites/runicEye.png", 1, false, false, 15, 13);

local item = Item.create("CaseysContent", "runicEye");
Item.set_sprite(item, sprite);
Item.set_tier(item, Item.TIER.common)
Item.set_loot_tags(item, Item.LOOT_TAG.category_damage)

-- Objects

local procSprite = Resources.sprite_load(PATH.."assets/sprites/runicEyeProc.png", 9, false, false, 12, 11)
local laserSprite = Resources.sprite_load(PATH.."assets/sprites/runicEyeProjectile.png", 1, false, false, 0, 2)
local sound = Resources.sfx_load(PATH.."assets/sounds/runicEyeSummon.ogg")
local soundShoot = Resources.sfx_load(PATH.."assets/sounds/runicEyeShoot.ogg")

--#region Proc Object

local procObj = Object.create("CaseysContent", "runicEyeProc")

Object.add_callback(procObj, "Init", function(self)
    self.sprite_index = procSprite
    self.image_index = 0
    self.t = -math.random(10)
end)

Object.add_callback(procObj, "Step", function(self)

    if (self.t < 0) then
        self.image_index = 0
        self.t = self.t + 1
    end

    self.image_speed = 0.8

    if (self.image_index > 8) then 
        self.image_index = 8 
        self.t = self.t + 1

        if (self.t == 10) then
            local target = nil
            local dist = 800
            if not target then
                local actors = Instance.find_all(gm.constants.pActor)
                for _, a in ipairs(actors) do
                    if a.team and a.team ~= self.parent.team then
                        local d = gm.point_distance(self.parent.x, self.parent.y, a.x, a.y)
                        if d <= dist then
                            dist = d
                            target = a
                        end
                    end
                end
            end
            if (not target) then else
                local damage_coeff = 2.5 + (0.25 * (Item.get_stack_count(self.parent, Item.find("CaseysContent-runicEye")) - 1))
                local blend = 13688896
                Actor.damage(target, self.parent, self.parent.damage * damage_coeff, target.x, target.y - 36, blend)

                gm.sound_play_at(soundShoot, 1.0, 1.0, self.x, self.y, 1.0)

                local inst = Object.spawn(Object.find("CaseysContent", "runicEyeProjectile"), self.x, self.y)
                inst.image_xscale = dist
                inst.image_angle = gm.point_direction(self.x, self.y, target.x, target.y)
            end
        end

        if (self.t > 30) then
            self.image_xscale = self.image_xscale + 0.05
            self.image_yscale = self.image_yscale - 0.05
            if (self.image_yscale <= 0) then gm.instance_destroy(self) end
        end
    end 
end)

Object.add_callback(procObj, "Draw", function (self)
    local blend = 16777215
    local alpha = 1.0
    if (self.t >= 0) then
        gm.draw_sprite_ext(self.sprite_index, self.image_index, self.x, self.y, self.image_xscale, self.image_yscale, self.image_angle, blend, alpha)
    end
end)

--#endregion

--#region Projectile Object

local projObj = Object.create("CaseysContent", "runicEyeProjectile")

Object.add_callback(projObj, "Init", function(self)
    self.sprite_index = laserSprite
    self.alph = 1
    self.t = 0
end)

Object.add_callback(projObj, "Step", function(self)
    self.alph = self.alph * 0.8
    if (self.alph < 0.1) then gm.instance_destroy(self) end
end)

Object.add_callback(projObj, "Draw", function (self)
    local blend = 16777215
    self.t = self.t + 1

    local ysc = 1
    local len = 40

    if (self.t % 4 < 2) then ysc = -1 end

    gm.draw_sprite_ext(self.sprite_index, self.image_index, self.x, self.y, self.image_xscale / len, ysc, self.image_angle, blend, self.alph)
end)

--#endregion

-- Script for determining secondary skill activation effects

gm.pre_script_hook(gm.constants.skill_activate, function(self, other, result, args)
    if args[1].value ~= 1.0 or gm.array_get(self.skills, 1).active_skill.skill_id == 70.0 then return true end
    
    local count = Item.get_stack_count(self, item)

    if (count > 0) then
        local coeff = 3
        coeff = coeff + (count - 1)
        for i = 1,coeff do
            local inst = Object.spawn(Object.find("CaseysContent", "runicEyeProc"), self.x + math.random(-50, 50), self.y + math.random(-50, 5))
            inst.parent = self
            
            gm.sound_play_at(sound, 1.0, 1.0, self.x, self.y, 1.0)
        end
    end
end)