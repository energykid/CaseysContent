
local sprite = Resources.sprite_load(PATH.."assets/sprites/gildedRibbon.png", 1, false, false, 16, 18);

local item = Item.create("CaseysContent", "gildedRibbon");
Item.set_sprite(item, sprite);
Item.set_tier(item, Item.TIER.uncommon)
Item.set_loot_tags(item, Item.LOOT_TAG.category_utility)