local MSQ = LibStub("Masque", true)
if not MSQ then return end

MSQ:AddSkin("FlatSquares", {
	Author = "ccfreak",
	Version = "1.0.7",
	Shape = "Square",
	Masque_Version = 70300,
	Backdrop = {
		Width = 32,
		Height = 32,
		Texture = [[Interface\AddOns\ElvUI_WindTools\MasqueSkin\FlatSquares\Backdrop]],
	},
	Icon = {
		Width = 31,
		Height = 31,		
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 32,
		Height = 32,
		Color = {1, 0, 0, 0.5},
		Texture = [[Interface\AddOns\ElvUI_WindTools\MasqueSkin\FlatSquares\Overlay]],
	},
	Cooldown = {
		Width = 31,
		Height = 31,
	},
	ChargeCooldown = {
		Width = 31,
		Height = 31,
	},
	Pushed = {
		Width = 32,
		Height = 32,
		Color = {0, 0, 0, 0.5},
		Texture = [[Interface\AddOns\ElvUI_WindTools\MasqueSkin\FlatSquares\Overlay]],
	},
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\AddOns\ElvUI_WindTools\MasqueSkin\FlatSquares\Normal]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 32,
		Height = 32,
		BlendMode = "ADD",
		Color = {0, 0.8, 1, 1},
		Texture = [[Interface\AddOns\ElvUI_WindTools\MasqueSkin\FlatSquares\Border]],
	},
	Border = {
		Width = 32,
		Height = 32,
		BlendMode = "ADD",
		Color = {0, 0, 0, 1},
		Texture = [[Interface\AddOns\ElvUI_WindTools\MasqueSkin\FlatSquares\Border]],
	},
	AutoCastable = {
		Width = 54,
		Height = 54,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 32,
		Height = 32,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.1},
		Texture = [[Interface\AddOns\ElvUI_WindTools\MasqueSkin\FlatSquares\Highlight]],
	},
	Name = {
		Width = 32,
		Height = 10,
		OffsetX = 0,
		OffsetY = 5,
	},
	Count = {
		Width = 32,
		Height = 10,
		OffsetX = -4,
		OffsetY = 5,
	},
	HotKey = {
		Width = 32,
		Height = 10,
		OffsetX = 1,
		OffsetY = -6,
	},
	Duration = {
		Width = 32,
		Height = 10,
		OffsetY = -2,
	},
	AutoCast = {
		Width = 26,
		Height = 26,
		OffsetX = 1,
		OffsetY = -1,
	},
}, true)