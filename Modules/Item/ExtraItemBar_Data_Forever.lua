local W = unpack((select(2, ...))) ---@type WindTools
local EB = W:GetModule("ExtraItemsBar") ---@class ExtraItemsBar

-- Forever on-use consumables from wow.export\Forever
local foreverPotions = {
	118, -- Minor Healing Potion
	858, -- Lesser Healing Potion
	929, -- Healing Potion
	1450, -- Potion of Fervor
	1710, -- Greater Healing Potion
	2455, -- Minor Mana Potion
	2456, -- Minor Rejuvenation Potion
	2459, -- Swiftness Potion
	2633, -- Jungle Remedy
	3087, -- Mug of Shimmer Stout
	3384, -- Minor Magic Resistance Potion
	3385, -- Lesser Mana Potion
	3387, -- Limited Invulnerability Potion
	3823, -- Lesser Invisibility Potion
	3827, -- Mana Potion
	3928, -- Superior Healing Potion
	4596, -- Minor Discolored Healing Potion
	4623, -- Lesser Stoneshield Potion
	5631, -- Rage Potion
	5633, -- Great Rage Potion
	5634, -- Free Action Potion
	6048, -- Shadow Protection Potion
	6049, -- Fire Protection Potion
	6050, -- Frost Protection Potion
	6051, -- Holy Protection Potion
	6052, -- Nature Protection Potion
	6149, -- Greater Mana Potion
	6372, -- Swim Speed Potion
	9030, -- Restorative Potion
	9036, -- Magic Resistance Potion
	9144, -- Wildvine Potion
	9172, -- Invisibility Potion
	9260, -- Volatile Rum
	12190, -- Dreamless Sleep Potion
	13442, -- Mighty Rage Potion
	13443, -- Superior Mana Potion
	13444, -- Major Mana Potion
	13446, -- Major Healing Potion
	13455, -- Greater Stoneshield Potion
	13456, -- Greater Frost Protection Potion
	13457, -- Greater Fire Protection Potion
	13458, -- Greater Nature Protection Potion
	13459, -- Greater Shadow Protection Potion
	13460, -- Greater Holy Protection Potion
	13461, -- Greater Arcane Protection Potion
	13462, -- Purification Potion
	17348, -- Major Healing Draught
	17349, -- Superior Healing Draught
	17351, -- Major Mana Draught
	17352, -- Superior Mana Draught
	18253, -- Major Rejuvenation Potion
	20002, -- Greater Dreamless Sleep Potion
	20008, -- Living Action Potion
	23578, -- Diet McWeaksauce
	23579, -- The McWeaksauce Classic
	23696, -- [PH] Potion of Heightened Senses [DEP]
	241650, -- Major Discolored Healing Potion
	247239, -- Lesser Discolored Healing Potion
	247240, -- Discolored Healing Potion
	247241, -- Greater Discolored Healing Potion
	247242, -- Superior Discolored Healing Potion
	250932, -- Minor Spellblasting Potion
	250933, -- Lesser Spellblasting Potion
	250934, -- Spellblasting Potion
	250935, -- Greater Spellblasting Potion
	250936, -- Superior Spellblasting Potion
	250937, -- Major Spellblasting Potion
	250938, -- Minor Frenzy Potion
	250939, -- Lesser Frenzy Potion
	250940, -- Frenzy Potion
	250941, -- Greater Frenzy Potion
	250942, -- Superior Frenzy Potion
	250943, -- Major Frenzy Potion
	250944, -- Minor Mender's Potion
	250945, -- Lesser Mender's Potion
	250946, -- Mender's Potion
	250947, -- Greater Mender's Potion
	250948, -- Superior Mender's Potion
	250949, -- Major Mender's Potion
	250950, -- Potion of Venomous Blood
	250951, -- Caustic Smog Potion
	250953, -- Dragonfire Potion
	250954, -- Potion of Elemental Purging
	250955, -- Potion of Beast Slaying
	268881, -- Perishable Minor Healing Potion
	268882, -- Perishable Lesser Healing Potion
	268883, -- Perishable Healing Potion
	274709, -- Potion of Experience - Level 23
	274710, -- Potion of Experience - Level 38
	274711, -- Potion of Experience - Level 57
	274712, -- Potion of Experience - Level 60
	274935, -- Tessa's Tonic
	278069, -- Potion of Tradeskill Testing - Level 60
	281234, -- Potion of Winterspring Shrouding
	282011, -- Restored Healing Potion
	282013, -- Restored Mana Potion
	287966, -- Minor Healing Potion
	287967, -- Lesser Healing Potion
	287968, -- Minor Mana Potion
	287969, -- Lesser Mana Potion
	287975, -- Swiftness Potion
	287976, -- Free Action Potion
	287977, -- Greater Healing Potion
	288896, -- Superior Healing Potion
	288897, -- Superior Mana Potion
	288898, -- Swiftness Potion
}

local foreverElixirs = {
	2454, -- Elixir of Minor Strength
	2457, -- Elixir of Minor Agility
	2458, -- Elixir of Minor Fortitude
	3382, -- Minor Troll's Blood Elixir
	3383, -- Elixir of Wisdom
	3386, -- Potion of Poison Cleansing
	3388, -- Lesser Troll's Blood Elixir
	3389, -- Elixir of Lesser Defense
	3390, -- Elixir of Lesser Agility
	3391, -- Elixir of Ogre Strength
	3825, -- Elixir of Lesser Fortitude
	3826, -- Troll's Blood Elixir
	3828, -- Draught of Detect Lesser Invisibility
	5996, -- Draught of Water Breathing
	5997, -- Elixir of Minor Defense
	6373, -- Elixir of Fire Power
	6662, -- Elixir of Giant Growth
	8529, -- Noggenfogger Elixir
	8827, -- Draught of Water Walking
	8949, -- Elixir of Agility
	8951, -- Elixir of Defense
	9088, -- Gift of Arthas
	9154, -- Draught of Detect Undead
	9155, -- Arcane Elixir
	9179, -- Elixir of Greater Intellect
	9187, -- Elixir of Greater Agility
	9197, -- Draught of Dream Vision
	9206, -- Elixir of Greater Strength
	9224, -- Potion of Demon Slaying
	9233, -- Draught of Detect Demon
	9264, -- Elixir of Shadow Power
	10592, -- Catseye Draught
	12820, -- Winterfall Firewater
	13445, -- Elixir of Greater Defense
	13447, -- Elixir of the Sages
	13452, -- Elixir of the Mongoose
	13453, -- Elixir of Brute Force
	13454, -- Greater Arcane Elixir
	17708, -- Elixir of Frost Power
	18294, -- Draught of Greater Water Breathing
	20004, -- Major Troll's Blood Elixir
	20007, -- Mageblood Elixir
	21546, -- Elixir of Holy Power
	217398, -- Lesser Arcane Elixir
	246948, -- Distilled Firewater
	247754, -- Minor Arcane Elixir
	247755, -- Elixir of Minor Force
	250327, -- Potion of Predatory Senses
	250328, -- Elixir of Cunning
	250329, -- Elixir of the Phalanx
	250330, -- Minor Cleric's Elixir
	250331, -- Lesser Cleric's Elixir
	250332, -- Cleric's Elixir
	250333, -- Greater Cleric's Elixir
	250334, -- Elixir of Fortitude
	250335, -- Elixir of Greater Fortitude
	250336, -- Elixir of Wicked Regeneration
	250337, -- Elixir of the Owl
	250338, -- Elixir of Sages
	250339, -- Minor Mageblood Elixir
	250340, -- Lesser Mageblood Elixir
	250341, -- Greater Mageblood Elixir
	250342, -- Lesser Arcane Elixir
	250343, -- Elixir of Nature Power
	250344, -- Elixir of Minor Spirit
	250345, -- Elixir of Lesser Spirit
	250346, -- Elixir of Spirit
	250347, -- Elixir of Greater Spirit
	250348, -- Elixir of the Whale
	250349, -- Elixir of Strength
	250350, -- Elixir of Ferocity
	250351, -- Elixir of the Grizzly
	250353, -- Elixir of Lesser Intellect
	250354, -- Elixir of Intellect
	289081, -- Noggenfogger Elixir
	289082, -- Elixir of Endless Intellect
	289083, -- Elixir of Endless Power
	289084, -- Elixir of Endless Healing
	289086, -- Elixir of Endless Rapidity
	289087, -- Elixir of Endless Opportunity
	289321, -- Elixir of Endless Mana
	289329, -- Elixir of Endless Growth
	289334, -- Elixir of Endless Experience
}

local foreverFlasks = {
	13506, -- Flask of Petrification
	13510, -- Flask of the Titans
	13511, -- Flask of Distilled Wisdom
	13512, -- Flask of Supreme Power
	13513, -- Flask of Chromatic Resistance
	274273, -- Flask of Natural Accuracy
	274274, -- Flask of Natural Aggression
	274275, -- Flask of Natural Precision
	274276, -- Flask of Natural Swiftness
}

local foreverScrolls = {
	954, -- Scroll of Strength
	955, -- Scroll of Intellect
	1180, -- Scroll of Stamina
	1181, -- Scroll of Spirit
	1477, -- Scroll of Agility II
	1478, -- Scroll of Protection II
	1711, -- Scroll of Stamina II
	1712, -- Scroll of Spirit II
	2289, -- Scroll of Strength II
	2290, -- Scroll of Intellect II
	3012, -- Scroll of Agility
	3013, -- Scroll of Protection
	4419, -- Scroll of Intellect III
	4421, -- Scroll of Protection III
	4422, -- Scroll of Stamina III
	4424, -- Scroll of Spirit III
	4425, -- Scroll of Agility III
	4426, -- Scroll of Strength III
	10305, -- Scroll of Protection IV
	10306, -- Scroll of Spirit IV
	10307, -- Scroll of Stamina IV
	10308, -- Scroll of Intellect IV
	10309, -- Scroll of Agility IV
	10310, -- Scroll of Strength IV
	213548, -- Scroll of Liminal Passage
	213564, -- Scroll of Minor Evocation
	215257, -- Scroll of Comprehension
	217495, -- Scroll of Cryoblast
	274947, -- Scroll of Imbue Lesser Flame
	275067, -- Scroll of Imbue Chillknife
	275069, -- Scroll of Rat Familiar
	277483, -- Scroll of Frog Familiar
	277485, -- Scroll of Imbue Frost
	277486, -- Scroll of Imbue Striking
	277487, -- Scroll of Imbue Baleflame
	277488, -- Scroll of Imbue Iceknife
	277489, -- Scroll of Imbue Spark
	277492, -- Scroll of Khadgar's Unlocking
	277493, -- Scroll of Cat Familiar
	277494, -- Scroll of Imbue Accuracy
	277495, -- Scroll of Imbue Quickening
	277496, -- Scroll of Imbue Balefrost
	277497, -- Scroll of Imbue Flame
	277498, -- Scroll of Imbue Manablade
	277499, -- Scroll of Greater Cryoblast
	277500, -- Scroll of Imbue Greater Flame
	277501, -- Scroll of Imbue Greater Frost
	277502, -- Scroll of Imbue Precision
	277503, -- Scroll of Imbue Spellbreak
	289088, -- Scroll of Endless Fortitude
	289330, -- Scroll of Endless Speed
}

local foreverFoods = {
	117, -- Tough Jerky
	159, -- Refreshing Spring Water
	414, -- Dalaran Sharp
	422, -- Dwarven Mild
	724, -- Goretusk Liver Pie
	733, -- Westfall Stew
	787, -- Slitherskin Mackerel
	961, -- Healing Herb
	1017, -- Seasoned Wolf Kabob
	1072, -- Full Moonshine
	1082, -- Redridge Goulash
	1113, -- Conjured Bread
	1114, -- Conjured Rye
	1119, -- Bottled Spirits
	1179, -- Ice Cold Milk
	1205, -- Melon Juice
	1326, -- Sauteed Sunfish
	1401, -- Green Tea Leaf
	1487, -- Conjured Pumpernickel
	1645, -- Moonberry Juice
	1707, -- Stormwind Brie
	1708, -- Sweet Nectar
	2070, -- Darnassian Bleu
	2136, -- Conjured Purified Water
	2287, -- Haunch of Meat
	2288, -- Conjured Fresh Water
	2593, -- Flask of Stormwind Tawny
	2594, -- Flagon of Dwarven Honeymead
	2595, -- Jug of Badlands Bourbon
	2596, -- Skin of Dwarven Stout
	2679, -- Charred Wolf Meat
	2680, -- Spiced Wolf Meat
	2681, -- Roasted Boar Meat
	2682, -- Cooked Crab Claw
	2683, -- Crab Cake
	2684, -- Coyote Steak
	2685, -- Succulent Pork Ribs
	2686, -- Thunder Ale
	2687, -- Dry Pork Ribs
	2723, -- Bottle of Dalaran Noir
	2888, -- Beer Basted Boar Ribs
	2894, -- Rhapsody Malt
	3220, -- Blood Sausage
	3448, -- Senggin Root
	3662, -- Crocolisk Steak
	3663, -- Murloc Fin Soup
	3664, -- Crocolisk Gumbo
	3665, -- Curiously Tasty Omelet
	3666, -- Gooey Spider Cake
	3703, -- Southshore Stout
	3726, -- Big Bear Steak
	3727, -- Hot Lion Chops
	3728, -- Tasty Lion Steak
	3729, -- Soothing Turtle Bisque
	3770, -- Mutton Chop
	3771, -- Wild Hog Shank
	3772, -- Conjured Spring Water
	3927, -- Fine Aged Cheddar
	4457, -- Barbecued Buzzard Wing
	4536, -- Shiny Red Apple
	4537, -- Tel'Abim Banana
	4538, -- Snapvine Watermelon
	4539, -- Goldenbark Apple
	4540, -- Tough Hunk of Bread
	4541, -- Freshly Baked Bread
	4542, -- Moist Cornbread
	4544, -- Mulgore Spice Bread
	4592, -- Longjaw Mud Snapper
	4593, -- Bristle Whisker Catfish
	4594, -- Rockscale Cod
	4595, -- Junglevine Wine
	4599, -- Cured Ham Steak
	4600, -- Cherry Grog
	4601, -- Soft Banana Bread
	4602, -- Moon Harvest Pumpkin
	4604, -- Forest Mushroom Cap
	4605, -- Red-speckled Mushroom
	4606, -- Spongy Morel
	4607, -- Delicious Cave Mold
	4608, -- Raw Black Truffle
	4656, -- Small Pumpkin
	4791, -- Enchanted Water
	5057, -- Ripe Watermelon
	5066, -- Fissure Plant
	5095, -- Rainbow Fin Albacore
	5265, -- Watered-down Beer
	5342, -- Raptor Punch
	5349, -- Conjured Muffin
	5350, -- Conjured Water
	5472, -- Kaldorei Spider Kabob
	5473, -- Scorpid Surprise
	5474, -- Roasted Kodo Meat
	5476, -- Fillet of Frenzy
	5477, -- Strider Stew
	5478, -- Dig Rat Stew
	5479, -- Crispy Lizard Tail
	5480, -- Lean Venison
	5525, -- Boiled Clams
	5526, -- Clam Chowder
	5527, -- Goblin Deviled Clams
	6038, -- Giant Clam Scorcho
	6290, -- Brilliant Smallfish
	6299, -- Sickly Looking Fish
	6316, -- Loch Frenzy Delight
	6522, -- Deviate Fish
	6657, -- Savory Deviate Delight
	6807, -- Frog Leg Stew
	6887, -- Spotted Yellowtail
	6888, -- Herb Baked Egg
	6890, -- Smoked Bear Meat
	7097, -- Leg Meat
	7228, -- Tigule's Strawberry Ice Cream
	7676, -- Thistle Tea
	7806, -- Lollipop
	7807, -- Candy Bar
	7808, -- Chocolate Square
	8075, -- Conjured Sourdough
	8076, -- Conjured Sweet Roll
	8077, -- Conjured Mineral Water
	8078, -- Conjured Sparkling Water
	8079, -- Conjured Crystal Water
	8243, -- Scooby Snack
	8364, -- Mithril Head Trout
	8543, -- Underwater Mushroom Cap
	8766, -- Morning Glory Dew
	8932, -- Alterac Swiss
	8948, -- Dried King Bolete
	8950, -- Homemade Cherry Pie
	8952, -- Roasted Quail
	8953, -- Deep Fried Plantains
	8957, -- Spinefin Halibut
	9360, -- Cuergo's Gold
	9361, -- Cuergo's Gold with Worm
	9451, -- Bubbling Water
	9681, -- Grilled King Crawler Legs
	10841, -- Goldthorn Tea
	11109, -- Special Chicken Feed
	11415, -- Mixed Berries
	11444, -- Grim Guzzler Boar
	11584, -- Cactus Apple Surprise
	11846, -- Wizbang's Special Brew
	11951, -- Whipper Root Tuber
	12003, -- Dark Dwarven Lager
	12209, -- Lean Wolf Steak
	12210, -- Roast Raptor
	12212, -- Jungle Stew
	12213, -- Carrion Surprise
	12214, -- Mystery Stew
	12215, -- Heavy Kodo Stew
	12216, -- Spiced Chili Crab
	12217, -- Dragonbreath Chili
	12218, -- Monster Omelet
	12224, -- Crispy Bat Wing
	12238, -- Darkshore Grouper
	12763, -- Un'Goro Etherfruit
	13546, -- Bloodbelly Fish
	13724, -- Enriched Manna Biscuit
	13755, -- Raw Winter Squid
	13810, -- Blessed Sunfruit
	13851, -- Hot Wolf Ribs
	13893, -- Large Raw Mightfish
	13927, -- Cooked Glossy Mightfish
	13928, -- Grilled Squid
	13929, -- Hot Smoked Bass
	13930, -- Filet of Redgill
	13931, -- Nightfin Soup
	13932, -- Poached Sunscale Salmon
	13933, -- Lobster Stew
	13934, -- Mightfish Steak
	13935, -- Baked Salmon
	16166, -- Bean Soup
	16167, -- Versicolor Treat
	16168, -- Heaven Peach
	16169, -- Wild Ricecake
	16170, -- Steamed Mandu
	16171, -- Shinsollo
	16766, -- Undermine Clam Chowder
	16971, -- Clamlette Surprise
	17119, -- Deeprun Rat Kabob
	17196, -- Holiday Spirits
	17197, -- Gingerbread Cookie
	17198, -- Egg Nog
	17222, -- Spider Sausage
	17344, -- Candy Cane
	17402, -- Greatfather's Winter Ale
	17403, -- Steamwheedle Fizzy Spirits
	17404, -- Blended Bean Brew
	17406, -- Holiday Cheesewheel
	17407, -- Graccu's Homemade Meat Pie
	17408, -- Spicy Beefstick
	18045, -- Tender Wolf Steak
	18254, -- Runn Tum Tuber Surprise
	18255, -- Runn Tum Tuber
	18287, -- Evermurky
	18288, -- Molasses Firewater
	18300, -- Hyjal Nectar
	18632, -- Moonbrook Riot Taffy
	18633, -- Styleen's Sour Suckerpop
	18635, -- Bellara's Nutterbar
	19221, -- Darkmoon Special Reserve
	19222, -- Cheap Beer
	19223, -- Darkmoon Dog
	19224, -- Red Hot Wings
	19225, -- Deep Fried Candybar
	19299, -- Fizzy Faire Drink
	19300, -- Bottled Winterspring Water
	19301, -- Alterac Manna Biscuit
	19304, -- Spiced Beef Jerky
	19305, -- Pickled Kodo Foot
	19306, -- Crunchy Frog
	19696, -- Harvest Bread
	19994, -- Harvest Fruit
	19995, -- Harvest Boar
	19996, -- Harvest Fish
	20031, -- Essence Mango
	20074, -- Heavy Crocolisk Stew
	20452, -- Smoked Desert Dumplings
	20516, -- Bobbing Apple
	20709, -- Rumsey Rum Light
	21023, -- Dirge's Kickin' Chimaerok Chops
	21030, -- Darnassus Kimchi Pie
	21031, -- Cabbage Kimchi
	21033, -- Radish Kimchi
	21072, -- Smoked Sagefish
	21114, -- Rumsey Rum Dark
	21151, -- Rumsey Rum Black Label
	21215, -- Graccu's Mince Meat Fruitcake
	21217, -- Sagefish Delight
	21235, -- Winter Veil Roast
	21236, -- UNUSED ITEM
	21240, -- UNUSED ITEM
	21254, -- Winter Veil Cookie
	21552, -- Striped Yellowtail
	21721, -- Moonglow
	22324, -- Winter Kimchi
	22895, -- Conjured Cinnamon Roll
	23160, -- Friendship Bread
	23172, -- Refreshing Red Apple
	231778, -- Mountain Spring Water
	238638, -- Filet o' Flank
	247824, -- Thunder Applejack
	248613, -- Lightning in a Bottle
	249796, -- Hyjal Berries
	249865, -- Peace Tea
	249866, -- Royal Tea
	249867, -- Root Tea
	249868, -- Triage Tea
	249869, -- Sunny Tea
	249870, -- Sage's Tea
	249871, -- Venomous Smoothie
	249872, -- Slimy Smoothie
	249873, -- Mrrggl Smrrthle
	249874, -- Calcified Smoothie
	249875, -- Spicy Smoothie
	249876, -- Wicked Smoothie
	250065, -- Savory Stag Sliders
	250066, -- Soaring Pamplona
	250067, -- Bat Hachee
	250068, -- Savory Turtle Stew
	250069, -- Flank au Poivre
	250070, -- Bear Bruscitti
	250071, -- Steaming Stag Steak
	250072, -- Swiftstrike Steak
	250073, -- Raging Raptor Ribs
	250074, -- Bear Brisket
	250075, -- Prehistoric Pulled Raptor
	250076, -- Raptor Rouladen
	250077, -- Twice-Spiced Raptor Slice
	250078, -- Giant Scrambled Eggs
	250079, -- Tasty Raptor Bites
	250080, -- Breakfast Omelette
	250081, -- Clam Linguine
	252022, -- Galestrider Jerky
	252023, -- Zaalanarr Sharp
	252026, -- Gustberry Pie
	252027, -- Gustberry Juice
	252028, -- Fresh Gustberry Bread
	252029, -- Hippogryph Flank
	252030, -- Pungent Skycheddar
	252031, -- Crisp Spring Water
	252032, -- Red Delicious Stormapple
	260623, -- Candied Fruit Sampler
	260624, -- Pristine Peach
	260625, -- Garnished Rice Cake
	260627, -- Savory Shen'dralar Steak
	260628, -- Stuffed Pumpkin
	260629, -- Spectral Spirits
	260631, -- Arcane Wine
	260632, -- Slushberry Brandy
	260633, -- Sip of Lemonale
	262433, -- Ketharas' Hyjal Stew
	263509, -- Skywall Souffle
	263512, -- Pincer Bites
	267341, -- Sweetpaw Jam
	267474, -- Galeswept Forestshroom
	268912, -- Expiring Crab Cake
	268913, -- Expiring Crocolisk Steak
	274971, -- Briny Seafood Stew
	274976, -- Plain Ol' Paletusk
	278117, -- Hard Boiled Eggs
	278118, -- Rich Broth
	278119, -- Bread with Butter
	278120, -- Fruit Platter
	278121, -- Smoked Sausage
	278122, -- Carrot Salad
	278265, -- Nutritious Slime Sludge
	278569, -- Yesterday's Leftovers
	281282, -- A Little Somethin'
	282018, -- Restorative Bread
	286152, -- Plated Armorfish
	287416, -- Truskis' Cheesecake Slice
	287963, -- Roasted Quail
	287964, -- Morning Glory Dew
	287972, -- Rumsey Rum Dark
	287973, -- Tender Wolf Steak
	287974, -- Grilled Squid
}

local foreverBandages = {
	1251, -- Linen Bandage
	2581, -- Heavy Linen Bandage
	3530, -- Wool Bandage
	3531, -- Heavy Wool Bandage
	6450, -- Silk Bandage
	6451, -- Heavy Silk Bandage
	8544, -- Mageweave Bandage
	8545, -- Heavy Mageweave Bandage
	14529, -- Runecloth Bandage
	14530, -- Heavy Runecloth Bandage
	19066, -- Warsong Gulch Runecloth Bandage
	19067, -- Warsong Gulch Mageweave Bandage
	19068, -- Warsong Gulch Silk Bandage
	19307, -- Alterac Heavy Runecloth Bandage
	20065, -- Arathi Basin Mageweave Bandage
	20066, -- Arathi Basin Runecloth Bandage
	20067, -- Arathi Basin Silk Bandage
	20232, -- Defiler's Mageweave Bandage
	20234, -- Defiler's Runecloth Bandage
	20235, -- Defiler's Silk Bandage
	20237, -- Highlander's Mageweave Bandage
	20243, -- Highlander's Runecloth Bandage
	20244, -- Highlander's Silk Bandage
	23684, -- Crystal Infused Bandage
	272056, -- Darkspear Islands Silk Bandage
	272057, -- Darkspear Islands Mageweave Bandage
	272058, -- Darkspear Islands Runecloth Bandage
}

local foreverUtilities = {
	835, -- Large Rope Net
	1127, -- Flash Bundle
	1176, -- Smelling Salts
	1177, -- Oil of Olaf
	1178, -- Explosive Rocket
	1187, -- Spiked Collar
	1191, -- Bag of Marbles
	1262, -- Keg of Thunderbrew
	1322, -- Fishliver Oil
	1399, -- Magic Candle
	1400, -- Swiftfeather Token
	1402, -- Brimstone
	1434, -- Glowing Wax Stick
	1703, -- Crystal Basilisk Spine
	1851, -- Cleansing Water
	1970, -- Restoring Balm
	2091, -- Magic Dust
	2862, -- Rough Sharpening Stone
	2863, -- Coarse Sharpening Stone
	2871, -- Heavy Sharpening Stone
	2892, -- Deadly Poison
	2893, -- Deadly Poison II
	3239, -- Rough Weightstone
	3240, -- Coarse Weightstone
	3241, -- Heavy Weightstone
	3434, -- Slumber Sand
	3438, -- Ankh of Resurrection
	3775, -- Crippling Poison
	3776, -- Crippling Poison II
	3824, -- Shadow Oil
	3829, -- Frost Oil
	4358, -- Rough Dynamite
	4360, -- Rough Copper Bomb
	4365, -- Coarse Dynamite
	4366, -- Target Dummy
	4367, -- Small Seaforium Charge
	4370, -- Large Copper Bomb
	4374, -- Small Bronze Bomb
	4376, -- Flame Deflector
	4378, -- Heavy Dynamite
	4380, -- Big Bronze Bomb
	4384, -- Explosive Sheep
	4386, -- Ice Deflector
	4388, -- Discombobulator Ray
	4390, -- Iron Grenade
	4391, -- Compact Harvest Reaper Kit
	4392, -- Advanced Target Dummy
	4394, -- Big Iron Bomb
	4395, -- Goblin Land Mine
	4398, -- Large Seaforium Charge
	4403, -- Portable Bronze Mortar
	4405, -- Crude Scope
	4406, -- Standard Scope
	4407, -- Accurate Scope
	4479, -- Burning Charm
	4480, -- Thundering Charm
	4481, -- Cresting Charm
	4546, -- Call of the Raptor
	4598, -- Goblin Fishing Pole
	4852, -- Flash Bomb
	4941, -- Really Sticky Glue
	4945, -- Faintly Glowing Skull
	4952, -- Stormstout
	4953, -- Trogg Brew
	5013, -- Fertile Bulb
	5205, -- Sprouted Frond
	5206, -- Bogling Root
	5223, -- Empty Mana Gem
	5227, -- Empty Mana Jewel
	5229, -- Empty Greater Bloodstone
	5232, -- Minor Soulstone
	5237, -- Mind-numbing Poison
	5406, -- Empty Minor Bloodstone
	5421, -- Fiery Blaze Enchantment
	5457, -- Severed Voodoo Claw
	5507, -- Ornate Spyglass
	5509, -- Healthstone
	5510, -- Greater Healthstone
	5511, -- Lesser Healthstone
	5512, -- Minor Healthstone
	5513, -- Mana Jade
	5740, -- Red Fireworks Rocket
	5816, -- Light of Elune
	5823, -- Poisonous Mushroom
	5845, -- Flank of Meat
	5859, -- Party Grenade
	5878, -- Super Snuff
	5880, -- Crate With Holes
	5951, -- Moist Towelette
	6074, -- War Horn Mouthpiece
	6183, -- Unlit Poor Torch
	6452, -- Anti-Venom
	6453, -- Strong Anti-Venom
	6458, -- Oil Covered Fish
	6529, -- Shiny Bauble
	6530, -- Nightcrawlers
	6532, -- Bright Baubles
	6533, -- Aquadynamic Fish Attractor
	6635, -- Earth Sapta
	6636, -- Fire Sapta
	6637, -- Water Sapta
	6638, -- Air Sapta
	6714, -- Ez-Thro Dynamite
	6811, -- Aquadynamic Fish Lens
	6947, -- Instant Poison
	6949, -- Instant Poison II
	6950, -- Instant Poison III
	6951, -- Mind-numbing Poison II
	7307, -- Flesh Eating Worm
	7388, -- Skull Key
	7964, -- Solid Sharpening Stone
	7965, -- Solid Weightstone
	7970, -- E.C.A.C.
	8007, -- Mana Citrine
	8008, -- Mana Ruby
	8095, -- Hinott's Oil
	8410, -- R.O.I.D.S.
	8411, -- Lung Juice Cocktail
	8412, -- Ground Scorpok Assay
	8423, -- Cerebral Cortex Compound
	8424, -- Gizzard Gum
	8432, -- Eau de Mixilpixil
	8444, -- Executioner's Key
	8493, -- Weegli's Barrel
	8546, -- Powerful Smelling Salts
	8926, -- Instant Poison IV
	8927, -- Instant Poison V
	8928, -- Instant Poison VI
	8956, -- Oil of Immolation
	8984, -- Deadly Poison III
	8985, -- Deadly Poison IV
	9186, -- Mind-numbing Poison III
	9312, -- Blue Firework
	9313, -- Green Firework
	9314, -- Red Streaks Firework
	9315, -- Yellow Rose Firework
	9317, -- Red, White and Blue Firework
	9318, -- Red Firework
	9319, -- Nimboya's Laden Pike
	9421, -- Major Healthstone
	10507, -- Solid Dynamite
	10514, -- Mithril Frag Bomb
	10546, -- Deadly Scope
	10548, -- Sniper Scope
	10562, -- Hi-Explosive Bomb
	10586, -- The Big One
	10646, -- Goblin Sapper Charge
	10663, -- Essence of Hakkar
	10684, -- Colossal Parachute
	10687, -- Empty Vial Labeled #1
	10688, -- Empty Vial Labeled #2
	10689, -- Empty Vial Labeled #3
	10690, -- Empty Vial Labeled #4
	10719, -- Mobile Alarm
	10830, -- M73 Frag Grenade
	10918, -- Wound Poison
	10920, -- Wound Poison II
	10921, -- Wound Poison III
	10922, -- Wound Poison IV
	11148, -- Samophlange Manual Page
	11325, -- Dark Iron Ale Mug
	11590, -- Mechanical Repair Kit
	11825, -- Pet Bombling
	11826, -- Lil' Smoky
	11914, -- Empty Cursed Ooze Jar
	11948, -- Empty Tainted Ooze Jar
	11950, -- Windblossom Berries
	11952, -- Night Dragon's Breath
	11953, -- Empty Pure Sample Jar
	12404, -- Dense Sharpening Stone
	12440, -- Magic Knucklebone (DND)
	12586, -- Immature Venom Sac
	12643, -- Dense Weightstone
	12650, -- Attuned Dampener
	12886, -- Pamela's Doll's Head
	12922, -- Empty Canteen
	13156, -- Mystic Crystal
	13509, -- Clutch of Foresight
	13813, -- Blessed Sunfruit Juice
	14894, -- Lily Root
	15723, -- Tea with Sugar
	15778, -- Mechanical Yeti
	15846, -- Salt Shaker
	15869, -- Silver Skeleton Key
	15870, -- Golden Skeleton Key
	15871, -- Truesilver Skeleton Key
	15872, -- Arcanite Skeleton Key
	15993, -- Thorium Grenade
	16005, -- Dark Iron Bomb
	16023, -- Masterwork Target Dummy
	16040, -- Arcane Bomb
	16892, -- Lesser Soulstone
	16893, -- Soulstone
	16895, -- Greater Soulstone
	16896, -- Major Soulstone
	17048, -- Rumsey Rum
	17162, -- Eric Test Item A
	17716, -- Snowmaster 9000
	17747, -- Razorlash Root
	18209, -- Energized Sparkplug
	18232, -- Field Repair Bot 74A
	18262, -- Elemental Sharpening Stone
	18269, -- Gordok Green Grog
	18283, -- Biznicks 247x128 Accurascope
	18284, -- Kreeg's Stout Beatdown
	18297, -- Thornling Seed
	18588, -- Ez-Thro Dynamite II
	18594, -- Powerful Seaforium Charge
	18606, -- Alliance Battle Standard
	18607, -- Horde Battle Standard
	18640, -- Happy Fun Rock
	18641, -- Dense Dynamite
	18645, -- Gnomish Alarm-O-Bot
	18660, -- World Enlarger
	18662, -- Heavy Leather Ball
	18839, -- Combat Healing Potion
	18841, -- Combat Mana Potion
	19004, -- Minor Healthstone
	19005, -- Minor Healthstone
	19006, -- Lesser Healthstone
	19007, -- Lesser Healthstone
	19008, -- Healthstone
	19009, -- Healthstone
	19010, -- Greater Healthstone
	19011, -- Greater Healthstone
	19012, -- Major Healthstone
	19013, -- Major Healthstone
	19026, -- Snake Burst Firework
	19045, -- Stormpike Battle Standard
	19046, -- Frostwolf Battle Standard
	19060, -- Warsong Gulch Enriched Ration
	19061, -- Warsong Gulch Iron Ration
	19062, -- Warsong Gulch Field Ration
	19183, -- Hourglass Sand
	19318, -- Bottled Alterac Spring Water
	19440, -- Powerful Anti-Venom
	19997, -- Harvest Nectar
	20062, -- Arathi Basin Enriched Ration
	20063, -- Arathi Basin Field Ration
	20064, -- Arathi Basin Iron Ration
	20079, -- Spirit of Zanza
	20080, -- Sheen of Zanza
	20081, -- Swiftness of Zanza
	20222, -- Defiler's Enriched Ration
	20223, -- Defiler's Field Ration
	20224, -- Defiler's Iron Ration
	20225, -- Highlander's Enriched Ration
	20226, -- Highlander's Field Ration
	20227, -- Highlander's Iron Ration
	20388, -- Lollipop
	20389, -- Candy Corn
	20390, -- Candy Bar
	20397, -- Hallowed Wand - Pirate
	20398, -- Hallowed Wand - Ninja
	20399, -- Hallowed Wand - Leper Gnome
	20409, -- Hallowed Wand - Ghost
	20410, -- Hallowed Wand - Bat
	20411, -- Hallowed Wand - Skeleton
	20413, -- Hallowed Wand - Random
	20414, -- Hallowed Wand - Wisp
	20475, -- Soul Gem
	20557, -- Hallow's End Pumpkin Treat
	20744, -- Minor Wizard Oil
	20745, -- Minor Mana Oil
	20748, -- Brilliant Mana Oil
	20749, -- Brilliant Wizard Oil
	20750, -- Wizard Oil
	20844, -- Deadly Poison V
	21038, -- Hardpacked Snowball
	21212, -- Fresh Holly
	21238, -- UNUSED ITEM
	21241, -- Winter Veil Eggnog
	21325, -- Mechanical Greench
	21537, -- Festival Dumplings
	21711, -- Lunar Festival Invitation
	21713, -- Elune's Candle
	21744, -- Lucky Rocket Cluster
	21745, -- Elder's Moonstone
	22192, -- Bloodkelp Elixir of Dodging
	22193, -- Bloodkelp Elixir of Resistance
	22236, -- Buttermilk Delight
	22237, -- Dark Desire
	22238, -- Very Berry Cream
	22239, -- Sweet Surprise
	22259, -- Unbestowed Friendship Bracelet
	23122, -- Consecrated Sharpening Stone
	23123, -- Blessed Wizard Oil
	23161, -- Freshly-Squeezed Lemonade
	23163, -- Performer's Wand
	23164, -- Bubbly Beverage
	23175, -- Tasty Summer Treat
	23176, -- Fizzy Energy Drink
	23194, -- Lesser Mark of the Dawn
	23195, -- Mark of the Dawn
	23196, -- Greater Mark of the Dawn
	23211, -- Toasted Smorc
	23215, -- Bag of Smorc Ingredients
	23246, -- Fiery Festival Brew
	23326, -- Midsummer Sausage
	23327, -- Fire-toasted Bun
	23379, -- Cinder Bracers
	23435, -- Elderberry Pie
	23715, -- Permanent Lung Juice Cocktail
	23718, -- Permanent Ground Scorpok Assay
	23719, -- Permanent Cerebral Cortex Compound
	23721, -- Permanent Gizzard Gum
	23722, -- Permanent R.O.I.D.S.
	23794, -- Permanent Sheen of Zanza
	23795, -- Permanent Spirit of Zanza
	23796, -- Permanent Swiftness of Zanza
	184937, -- Chronoboon Displacer
	184938, -- Supercharged Chronoboon Displacer
	191204, -- Lesser Deathstone
	191267, -- Rune of Teleportation: Antechamber
	191268, -- Orb of Corruption
	191272, -- Rod of Necromancy
	191280, -- Fungal Spore Cluster
	191288, -- Rune of Teleportation: Frostwyrm's Lair
	191292, -- Ritual Dagger
	191313, -- Mask of Death
	191414, -- Skeletal Artifact
	191459, -- Rune of Fortune
	191660, -- Thaddius' Lightning Bolts
	191661, -- Monstrous Spider Fang
	202251, -- Bag of Pet Treats
	202316, -- Runecarving Test - Crippling Poison
	203726, -- Cutty's Rune
	203750, -- Elwynn Treasure Map
	203784, -- Top-Right Map Piece
	203785, -- Top-Left Map Piece
	203786, -- Bottom-Right Map Piece
	203787, -- Bottom-Left Map Piece
	203990, -- Rune of Mutilation
	203991, -- Rune of Quick Draw
	203992, -- Rune of Trickery
	203993, -- Rune of Slaughter
	203994, -- Rune of Deadly Brew
	204174, -- Rune of Precision
	204441, -- Rune of Blood Frenzy
	204688, -- Monster Hunter's First Rune Fragment
	204689, -- Monster Hunter's Second Rune Fragment
	204690, -- Monster Hunter's Third Rune Fragment
	204703, -- Rune of Devastate
	204716, -- Rune of Frenzied Assault
	204795, -- Rune of Shadowstrike
	204806, -- Rune of Victory Rush
	204809, -- Rune of Furious Thunder
	204912, -- Rune of Grace
	205022, -- Rune of Soul Siphon
	205215, -- Rune of Tactics
	205228, -- Rune of Chaos Bolt
	205230, -- Rune of Haunting
	205683, -- Rune of Rebuke
	205685, -- Rune of Aegis
	205897, -- Rune of Divine Light
	205905, -- Memory of a Devout Champion
	205932, -- Prophecy of a King's Demise
	205940, -- Memory of a Dark Purpose
	205942, -- Chimaeric Epiphany
	205943, -- Prophecy of a Desecrated Citadel
	205944, -- Reciprocal Epiphany
	205945, -- Memory of an Imprisoned Savior
	205946, -- Memory of a Leader's Betrayal
	205947, -- Prophecy of a Desecrated Citadel
	205948, -- Anodyne Epiphany
	205949, -- Manifold Epiphany
	205950, -- Tenebrous Epiphany
	205951, -- Memory of a Troubled Acolyte
	205952, -- Memory of a Shattered World
	205953, -- Prophecy of a Broken Vow
	205979, -- Rune of Flanking
	205995, -- Prairie Dog Musk
	206032, -- Rune of Carve
	206155, -- Rune of Marksmanship
	206168, -- Rune of the Chimera
	206169, -- Rune of Explosive Shot
	206177, -- Pine Nut Butter
	206264, -- Rune of Inspiration
	206466, -- Prairie Crown
	206469, -- Prairie Flower
	206963, -- Rune of Natural Potential
	206970, -- Rune of Life
	206985, -- Echo of the Alpha
	206989, -- Rune of the Sun
	206992, -- Rune of Skull Bash
	207106, -- Bottom-Left Map Piece
	207107, -- Bottom-Right Map Piece
	207108, -- Top-Left Map Piece
	207109, -- Top-Right Map Piece
	207110, -- Durotar Treasure Map
	207631, -- Adder Pheromone
	208034, -- Tirisfal Treasure Map
	208035, -- Top-Right Map Piece
	208036, -- Top-Left Map Piece
	208037, -- Bottom-Right Map Piece
	208038, -- Bottom-Left Map Piece
	208180, -- Rabbit Musk
	208213, -- Top-Right Map Piece
	208215, -- Top-Left Map Piece
	208218, -- Bottom-Right Map Piece
	208219, -- Bottom-Left Map Piece
	208220, -- Dun Morogh Treasure Map
	208601, -- Top-Right Map Piece
	208602, -- Top-Left Map Piece
	208603, -- Bottom-Right Map Piece
	208604, -- Bottom-Left Map Piece
	208605, -- Teldrassil Treasure Map
	208607, -- Deer Musk
	208609, -- Glade Flower
	208687, -- Rune of Lacerate
	208701, -- Rune of Beast Mastery
	208741, -- Rune of Endless Rage
	208744, -- Rune of Shadowbolts
	208750, -- Rune of Channeling
	208758, -- Earthen Rune
	208760, -- Glade Crown
	208764, -- Rune of the Mind
	208767, -- Rune of Mending
	208771, -- Rune of Blade Dance
	208772, -- Rune of Saber Slash
	208773, -- Fishing Harpoon
	208777, -- Rune of the Sniper
	208778, -- Rune of Quick Strike
	208799, -- Spell Notes: Living Bomb
	208823, -- Offering Coin
	208828, -- Memory of a Broken Vow
	208833, -- Malevolent Pie
	208843, -- Battle Totem
	208855, -- Rainbow Fin Albacore Chum
	209027, -- Crab Treats
	209047, -- Gnarled Harpoon
	209057, -- Prototype Engine
	209852, -- Rune of Kill Command
	210015, -- Rune of Raging Blow
	210137, -- Rune of Wild Growth
	210147, -- Shredder Autosalvage Unit
	210229, -- Rune of Mutilation
	210252, -- Rune of Shiving
	210253, -- Rot Totem
	210322, -- Rune of Venom
	210499, -- Marshroom
	210500, -- Rune of the Stars
	210569, -- Rune of Flagellation
	210573, -- Rune of Consuming Rage
	210589, -- Echo of the Ancestors
	210596, -- Rune of Cobra Strikes
	210653, -- Rune of Main Gauche
	210708, -- Elixir of Coalesced Regret
	210712, -- Elixir of Insight
	210746, -- Rune of Earth Shield
	210811, -- Rune of Primordial Fury
	210817, -- Rune of Survival
	210818, -- Rune of Lone Wolf
	210820, -- Rune of Sacrifice
	210822, -- Harmonious Epiphany
	210823, -- Rune of Dual Wield Specialization
	210824, -- Rune of the Pact
	210825, -- Rune of the Warbringer
	210979, -- Rune of Shadowstep
	210980, -- Rune of Metamorphosis
	211205, -- Rune of Cobra Slayer
	211301, -- Rune of Expose Weakness
	211385, -- Rune of Serpent Spread
	211387, -- Rune of Beckoning Light
	211390, -- Rune of Teasing
	211391, -- Rune of Healing Rain
	211392, -- Rune of Everlasting Affliction
	211393, -- Rune of Single-Minded Fury
	211476, -- Rune of Fires Wake
	211477, -- Rune of Incinerate
	211487, -- Demolition Explosives
	211488, -- Rune of the Avenger
	211490, -- Prophecy of a Thousand Lights
	211514, -- Spell Notes: Mass Regeneration
	211528, -- Dark Insight
	211530, -- Prophecy of a City Enthralled
	211531, -- Prophecy of Seven Visitors
	211534, -- Primal Insight
	211691, -- Spell Notes: Arcane Blast
	211800, -- Scroll of Reintegration
	211815, -- Silverwing Battle Hymn
	211816, -- Warsong Battle Drum
	211953, -- Scroll of Arcane Recovery I
	211954, -- Scroll of Arcane Accuracy I
	211955, -- Scroll of Arcane Protection - Fire I
	211956, -- Scroll of Arcane Protection - Frost I
	211957, -- Scroll of Arcane Power I
	212160, -- Chronoboon Displacer
	212548, -- Rune of Eclipse
	212549, -- Rune of the Trapper
	212551, -- Rune of Warfare
	212552, -- Psychosophic Epiphany
	212559, -- Rune of the Poisoned Blade
	212560, -- Rune of Ancestral Awakening
	212561, -- Rune of Burning Darkness
	212562, -- Rune of Healing Rage
	212568, -- Wolfshead Trophy
	213074, -- Rune of Nourishing
	213086, -- Rune of the Storm
	213090, -- Rune of Synergy
	213093, -- Rune of Power
	213094, -- Rune of Fire Nova
	213096, -- Rune of Decoys
	213098, -- Rune of Invocation
	213100, -- Rune of Forbidden Knowledge
	213101, -- Rune of Shadowflames
	213102, -- Rune of Wickedness
	213103, -- Rune of Blood Surge
	213104, -- Rune of Ruthless Precision
	213109, -- Rune of Focused Rage
	213110, -- Rune of the Commander
	213111, -- Rune of Intervention
	213112, -- Spell Notes: Missile Barrage
	213117, -- Rune of Berserk
	213118, -- Rune of the Jungle King
	213119, -- Rune of Instinct
	213120, -- Rune of the Dreamer
	213122, -- Rune of Steady Shot
	213123, -- Rune of Exposure
	213124, -- Rune of Close Combat
	213125, -- Rune of Invigoration
	213126, -- Rune of the Scrapper
	213128, -- Rune of Piety
	213129, -- Rune of Light's Embrace
	213130, -- Rune of Infusions
	213131, -- Rune of Sacred Shields
	213132, -- Rune of the Guardian
	213136, -- Rune of Subtlety
	213137, -- Rune of the Assailant
	213138, -- Rune of the Southpaw
	213139, -- Rune of the Assassin
	213140, -- Prophecy of the Quickened Path
	213141, -- Rune of Hope
	213142, -- Prophecy of Imprisoned Malice
	213143, -- Apocryphal Epiphany
	213144, -- Luminous Epiphany
	213426, -- Ogre Lightning Rod
	213550, -- Scroll of Polymorph: Odd Melon
	213599, -- Unsettling Vision
	215126, -- UNUSED Flask of Merciless Pursuit
	216606, -- Rune of Two-Handed Mastery
	216619, -- Student Fodder
	216748, -- Grimoire of Portal of Summoning
	216879, -- Mysterious Troll Scroll
	217308, -- Enchanted Sigil: Innovation
	217345, -- Sebacious Poison
	217346, -- Numbing Poison
	217347, -- Atrophic Poison
	217496, -- Scroll of the Blade
	217693, -- Invisibility Potion
	217736, -- Rune of the Coterie
	219147, -- Rune of Grace
	220164, -- Rune of the Gladiator
	220165, -- Rune of Wrath
	220217, -- Rune of the Ravenous
	220360, -- Rune of Efflorescence
	220610, -- Rune of Mental Dexterity
	220612, -- Rune of Tidal Waves
	220613, -- Rune of Rolling Thunder
	220614, -- Rune of Static Shock
	220616, -- Rune of Overcharged
	220617, -- Rune of Pandemic
	220618, -- Rune of Immolation Aura
	220682, -- Rune of the Unbridled
	220687, -- Rune of the Raptor
	220754, -- Rune of the Windstorm
	220791, -- Rune of the Jungle Cat
	220792, -- Scroll of Spatial Mending
	220913, -- Rune of Demolition
	221020, -- Rune of the Moon Goddess
	221199, -- Satyrweed Tincture
	221267, -- Rune of the Bloodthirsty
	221317, -- Feralas Leycryst
	221318, -- Azshara Leycryst
	221319, -- Blackrock Leycryst
	221320, -- Hinterlands Leycryst
	221418, -- Agamaggan's Roar
	221428, -- Rune of Foul Play
	221433, -- Rune of Focus
	221445, -- Rune of Focused Fire
	221461, -- Rune of Carnage
	221473, -- Rune of the Watchman
	221480, -- Spell Notes: Molten Armor
	221481, -- Nihilist Epiphany
	221482, -- Rune of Affliction
	221483, -- Rune of Burn
	221487, -- Spell Notes: Advanced Warding
	221488, -- Resolute Epiphany
	221489, -- Rune of Vengeance
	221490, -- Rune of Riptide
	221499, -- Rune of the Felguard
	221510, -- Rune of the Knight
	221511, -- Rune of the Protector
	221512, -- Rune of Alacrity
	221513, -- Rune of Potency
	221514, -- Rune of Firepower
	221515, -- Rune of Detonation
	221516, -- Rune of Primal Energy
	221517, -- Rune of Bloodshed
	221979, -- Prophecy of Verdant Winter
	221980, -- Prophecy of Awakened Chaos
	221981, -- Prophecy of the Lost Tribe
	222962, -- Hyjal's Wisdom
	223147, -- Spell Notes: Balefire Bolt
	223168, -- Worldcore Fragment
	223171, -- Scroll of Geomancy
	223288, -- Rune of the Hammer
	223912, -- Purification Potion
	223913, -- Major Healing Potion
	223914, -- Greater Healing Potion
	224806, -- Legion Portal Tuner
	224893, -- Overcharged Portal Tuner
	224912, -- Portal Tuner Tuner
	225686, -- Rune of Decimation
	225687, -- Rune of Infernal Armor
	225688, -- Rune of Mark of Chaos
	225689, -- Spell Notes: Arcane Barrage
	225690, -- Spell Notes: Frozen Orb
	225691, -- Spell Notes: Overheat
	225740, -- Rune of Composure
	225914, -- Rune of the Bound Spirit
	225955, -- Rune of the Resourceful
	226252, -- Rune of the Guerrilla
	226374, -- Occult Poison I
	226406, -- Rune of Sword Specialization
	226407, -- Rune of Axe Specialization
	226408, -- Rune of Mace Specialization
	226409, -- Rune of Dagger Specialization
	226410, -- Rune of Ranged Weapon Specialization
	226411, -- Rune of Fist Weapon Specialization
	226412, -- Rune of Pole Weapon Specialization
	226413, -- Rune of Arcane Specialization
	226414, -- Rune of Fire Specialization
	226415, -- Rune of Frost Specialization
	226416, -- Rune of Nature Specialization
	226417, -- Rune of Shadow Specialization
	226418, -- Rune of Holy Specialization
	226419, -- Rune of Feral Combat Specialization
	226587, -- Rune of Shelling
	226679, -- Timeless Wanderer's Insights
	226680, -- Rune of the First Warrior
	226694, -- Rune of Defense Specialization
	227286, -- Warmed Rumsey Rum with Cream
	227456, -- Rune of the Crimson Tempest
	227746, -- Rune of the World Tree
	227749, -- Rune of the Falling Star
	227797, -- Mysterious 'Darnassian' Scroll
	227921, -- Rune of Knives
	227922, -- Rune of the Swashbuckler
	228123, -- Jubilant Epiphany
	228124, -- Oneiric Epiphany
	228126, -- Aperitive Epiphany
	228227, -- Scroll of Overwhelming Power
	228978, -- Enchanted Sigil: Flowing Waters
	228980, -- Conductive Shield Coating
	231298, -- Scroll of Lesser Spatial Mending
	231828, -- Rune of Meditation Specialization
	231829, -- Rune of Healing Specialization
	231836, -- Glowing Scroll of Spatial Mending
	231843, -- First Sigil Fragment
	231844, -- Second Sigil Fragment
	231845, -- Third Sigil Fragment
	232343, -- QAEnchant Shield - Law of Nature
	232344, -- Vick's VIP Pass
	232433, -- Dense Runecloth Bandage
	232436, -- Darkclaw Bisque
	232438, -- Smoked Redgill
	232458, -- Rune of Improved Sanctuary
	232459, -- Rune of Backdraft
	232460, -- Rune of Displacement
	232461, -- Rune of Despair
	232462, -- Rune of Purifying Power
	232611, -- Magnificent Trollshine
	234444, -- Occult Poison II
	235597, -- Spell Notes: Deep Freeze
	235598, -- Spell Notes: Icy Veins
	235599, -- Spell Notes: Temporal Anomaly
	235600, -- Rune of Divine Storm
	235601, -- Rune of Fanaticism
	235602, -- Rune of Hammer of the Righteous
	235603, -- Rune of Righteous Vengeance
	235604, -- Rune of Shield of Righteousness
	235605, -- Rune of Shock and Awe
	237023, -- Pop-Up Shrub
	238637, -- Prowler Steak
	238639, -- Sunrise Omelette
	238641, -- Specklefin Feast
	238642, -- Grand Lobster Banquet
	240945, -- Slice of Carrie's Apple Pie
	242269, -- Brilliance of the Grand Sorcerer
	242270, -- Brilliance of the Grand Arcanist
	242271, -- Brilliance of the Grand Crusader
	242362, -- Brilliance of the Grand Inquisitor
	247840, -- Mining for Dummies
	247841, -- Wild Harvest
	247846, -- Pelt Collecting for Beginners
	248206, -- Sealed Craftsman's Writ
	248682, -- Waylaid Crate: Apprentice Herbs
	248683, -- Waylaid Crate: Apprentice Ore
	248684, -- Waylaid Crate: Apprentice Textiles
	248685, -- Waylaid Crate: Apprentice Curiosities
	248686, -- Waylaid Crate: Journeyman Herbs
	248687, -- Waylaid Crate: Journeyman Ore
	248688, -- Waylaid Crate: Journeyman Textiles
	248689, -- Waylaid Crate: Journeyman Curiosities
	248690, -- Waylaid Crate: Earthly Expert Herbs
	248691, -- Waylaid Crate: Flowering Expert Herbs
	248692, -- Waylaid Crate: Expert Ore
	248693, -- Waylaid Crate: Expert Textiles
	248694, -- Waylaid Crate: Expert Curiosities
	248695, -- Waylaid Crate: Earthly Artisan Herbs
	248696, -- Waylaid Crate: Flowering Artisan Herbs
	248697, -- Waylaid Crate: Artisan Ore
	248698, -- Waylaid Crate: Artisan Textiles
	248699, -- Waylaid Crate: Artisan Curiosities
	248702, -- Waylaid Crate: Apprentice Fabrics
	248703, -- Waylaid Crate: Apprentice Ingots
	248704, -- Waylaid Crate: Apprentice Parts
	248705, -- Waylaid Crate: Journeyman Fabrics
	248706, -- Waylaid Crate: Journeyman Ingots
	248707, -- Waylaid Crate: Journeyman Parts
	248708, -- Waylaid Crate: Expert Fabrics
	248709, -- Waylaid Crate: Expert Ingots
	248710, -- Waylaid Crate: Expert Parts
	248711, -- Waylaid Crate: Artisan Fabrics
	248712, -- Waylaid Crate: Artisan Ingots
	248713, -- Waylaid Crate: Artisan Parts
	251525, -- Savory Whimsyfin Delight
	251917, -- Falorne's Homemade Tart
	255663, -- Windstone
	260792, -- SAF-T Dynamite
	260793, -- SAF-T Copper Bomb
	260795, -- EZ-Thro Copper Bomb XL
	260797, -- SAF-T Bronze Bomb
	260798, -- SAF-T Jumbo Dynamite
	260800, -- Shafety Sheep
	260803, -- EZ-Thro Grenade
	260805, -- SAF-T Bomb
	260807, -- Compact Critter Carrier
	260809, -- Tru-Trigger Frag Bomb
	260814, -- SAF-T Clever Dynamite
	260816, -- EZ-Thro Thorium Grenade
	260817, -- EZ-Thro Dark Bomb
	260818, -- EZ-Thro Mana Bomb
	260822, -- Ultrasafe Rechargeable Battery
	260827, -- Stealthman 52
	260830, -- SAF-T Teleport
	262887, -- Sealed Apprentice's Writ
	262888, -- Sealed Journeyman's Writ
	262889, -- Sealed Expert's Writ
	262890, -- Sealed Artisan's Writ
	268880, -- "Secret" Bait
	269902, -- Hoof-Shaped Foot Pedal
	271871, -- Gift of Galloping
	272053, -- Darkspear Islands Field Ration
	272054, -- Darkspear Islands Iron Ration
	272055, -- Darkspear Islands Enriched Ration
	274917, -- Brittle Trap
	274918, -- Warding Candle
	274922, -- Riverglades Marsh Gas
	275633, -- Foxtail Ward
	275688, -- Power Recycler
	276145, -- Explosive Runeshard
	277132, -- Harvester Override Signalcaster
	277484, -- Scroll of Confuse Beast
	277490, -- Scroll of the Saber
	277491, -- Scroll of Rebuke Elemental
	277504, -- Scroll of Wit
	277519, -- Nelanna's Enchanted Jewel
	278543, -- Pouch of Tomb Dust
	279272, -- SAF-T Ultra Precision Scope
	279276, -- Mathystral Amulet Fragment
	279277, -- Mathystral Amulet
	279938, -- Trapper's Workbench
	279940, -- Toxin Study
	279941, -- Tanning Rack
	279943, -- Spinning Wheel
	279944, -- Sharpening Wheel
	279945, -- Sewing Machine
	279947, -- Seed Hybridizer
	279948, -- Rock Garden
	279949, -- Repair Bot
	279950, -- Reagent Bot
	279951, -- Plague Doctor's Laboratory
	279952, -- Molten Foundry
	279955, -- Master Forge
	279956, -- Mana Well
	279957, -- Cookie's Feast
	279959, -- Loom
	279960, -- Lodestone
	279961, -- Journeyman Campfire Kit
	279962, -- Incense Candle
	279964, -- Greenhouse
	279965, -- Fishing Rack
	279966, -- Fishing Hut
	279967, -- Fish Bowl
	279968, -- First Aid Kit
	279969, -- Field Guide
	279970, -- Fermenter
	279972, -- Faction Banner
	279973, -- Faction Banner
	279974, -- Expert Campfire Kit
	279976, -- Enchanted Lute
	279978, -- Camp Tent
	279979, -- Camp Chair
	279981, -- Basic Campfire Kit
	279982, -- Iron Oven
	279985, -- Arcane Salvager
	279987, -- Arcane Forge
	279988, -- Anvil
	279989, -- Anarchist's Workbench
	279990, -- Alchemy Laboratory
	281059, -- Loose Clearcutter Blade
	282006, -- Crumbling Hearthstone
	282285, -- Clearcutter Key
	284868, -- Holy Hand Grenade of Alterac
	284869, -- Unsanctified Grenade
	286405, -- Blooming Heart
	287978, -- Rough Sharpening Stone
	287980, -- Elemental Sharpening Stone
	288336, -- Blue Firework
	288337, -- Green Firework
	288338, -- Red Firework
	288339, -- Red Streaks Firework
	288340, -- Yellow Rose Firework
}

EB.StateCheckList = {}
EB.CountThreshold = {}
EB.ModuleList = {
	POTIONFOREVER = foreverPotions,
	ELIXIRFOREVER = foreverElixirs,
	FLASKFOREVER = foreverFlasks,
	SCROLLFOREVER = foreverScrolls,
	FOODFOREVER = foreverFoods,
	BANDAGEFOREVER = foreverBandages,
	UTILITYFOREVER = foreverUtilities,
}
