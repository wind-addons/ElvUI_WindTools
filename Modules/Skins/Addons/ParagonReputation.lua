local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

local pairs = pairs

local function reskinToast(toast)
	toast:SetTemplate("Transparent")
	toast:CreateShadow()

	toast.texture:Kill()

	S:Proxy("HandleButton", toast.reset)
	toast.reset:SetWidth(toast.reset:GetWidth() - 3)
	S:Proxy("HandleButton", toast.lock)
	toast.lock:SetWidth(toast.lock:GetWidth() - 3)
end

local function reskinSetting(frame)
	for i = 1, 5 do
		S:Proxy("HandleCheckBox", frame["color" .. i])
		frame["color" .. i]:Size(24)
		F.Move(frame["color" .. i], 0, -10)
		F.Move(frame["color" .. i].Text, 0, -2)

		S:Proxy("HandleCheckBox", frame["text" .. i])
		frame["text" .. i]:Size(24)
		F.Move(frame["text" .. i], 0, -10)
		F.Move(frame["text" .. i].Text, 0, -2)
	end

	F.Move(frame.label3, 0, -50)

	S:Proxy("HandleCheckBox", frame.toast)
	frame.toast:Size(28)

	F.Move(frame.description2, 0, -3)

	S:Proxy("HandleSliderFrame", frame.fade2)

	S:Proxy("HandleCheckBox", frame.sound)
	frame.sound:Size(24)
	F.Move(frame.sound, 0, -10)

	S:Proxy("HandleButton", frame.toggle)
	S:Proxy("HandleButton", frame.reset)
end

function S:ParagonReputation()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.paragonReputation then
		return
	end

	if _G.ParagonReputation_Toast then
		reskinToast(_G.ParagonReputation_Toast)
	end

	self:ReskinSettingFrame("Paragon Reputation", reskinSetting)
end

S:AddCallbackForAddon("ParagonReputation")
