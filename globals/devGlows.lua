require("math")

AddFunction(GlobalDraw, function()

    local p = Helper.get_player_from_name("ENNWAY")
    if (p) then
        if (math.random(100) < 30) then
            local inst = Object.spawn(Object.find("CaseysContent", "devSplatterParticle"), p.x + math.random(-2, 2), p.y + math.random(-2, 2))
            inst.depth = p.depth - 5
            inst.col = 0x00C7D620
        end
    end

end)


local spr = Resources.sprite_load(PATH.."assets/sprites/devSplatter.png", 1, false, false, 9, 9)
local partObj = Object.create("CaseysContent", "devSplatterParticle")
Object.add_callback(partObj, "Init", function(self)
    self.col = 16777215
    self.alph = 1.0
    self.sprite_index = spr
    self.image_angle = math.random(360)
    self.image_xscale = 1
    self.image_yscale = math.random(1.0, 2.0)
    self.t = 0
end)
Object.add_callback(partObj, "Step", function(self)
    self.alph = lerp(self.alph, 0.5, 0.3)
    self.image_xscale = lerp(self.image_xscale, 0.5, 0.3)
    self.image_yscale = lerp(self.image_yscale, 0.5, 0.3)

    self.t = self.t + 1
    if (self.t > 5) then 
        gm.instance_destroy(self, false)
    end
end)
Object.add_callback(partObj, "Destroy", function(self)
    
end)
Object.add_callback(partObj, "Draw", function (self)
    gm.draw_sprite_ext(self.sprite_index, self.image_index, self.x, self.y, self.image_xscale, self.image_yscale, self.image_angle, self.col, self.alph)
end)