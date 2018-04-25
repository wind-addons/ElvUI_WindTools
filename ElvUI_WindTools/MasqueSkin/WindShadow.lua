-- 独特的阴影Masque皮肤
-- 原作：Masque Shadow
-- 修改：houshuu

local MSQ = LibStub("Masque", true)
if not MSQ then return end
MSQ:AddSkin("WindShadow",
{
	Author = "Fang2hou",
	Version = "7.2.5",
	Shape = "Square",
	Masque_Version = 60200,
	Backdrop = {
		Width = 42,
		Height = 42,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\Addons\ElvUI_WindTools\MasqueSkin\WindShadow\Backdrop]],
	},
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\Addons\ElvUI_WindTools\MasqueSkin\WindShadow\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\Addons\ElvUI_WindTools\MasqueSkin\WindShadow\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\ElvUI_WindTools\MasqueSkin\WindShadow\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\Addons\ElvUI_WindTools\MasqueSkin\WindShadow\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0.77, 0.12, 0.23, 1},
		Texture = [[Interface\Addons\ElvUI_WindTools\MasqueSkin\WindShadow\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\Addons\ElvUI_WindTools\MasqueSkin\WindShadow\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\Addons\ElvUI_WindTools\MasqueSkin\WindShadow\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\ElvUI_WindTools\MasqueSkin\WindShadow\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "TOP",
		OffsetX = -1,
		OffsetY = 3,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 1,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
}, true)