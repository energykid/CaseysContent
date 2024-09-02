require("math")

DevAuraTimer = 0 

AddFunction(PrePlayerGlobalDraw, function(self)

    local p = Helper.get_player_from_name("ENNWAY")
    if (p == self) then
        DevAuraTimer = DevAuraTimer + 1

        local aa = math.abs(math.sin(DevAuraTimer / 30) * 1.3)

        local col = 0x00C7D620

        local bm = gm.gpu_get_blendmode()
        gm.gpu_set_blendmode(1)
        gm.draw_sprite_ext(self.sprite_index, self.image_index, self.x, self.y, self.image_xscale * aa, self.image_yscale * aa, self.image_angle, col, 0.5)
        gm.gpu_set_blendmode(bm)
        end
end)