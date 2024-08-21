local W, F, E, L, V, P, G = unpack((select(2, ...)))
local M = W.Modules.Misc

local hooksecurefunc = hooksecurefunc
local pairs = pairs

local texts = {}

function M:ElvUI_CreateCooldownTimer(parent)
	local db = E.db.WT.misc.cooldownTextOffset
	if parent and parent.timer and parent.timer.text then
		local text = parent.timer.text
		if not texts[text] then
			texts[text] = true
		end
		text:ClearAllPoints()
		text:Point("CENTER", parent, "CENTER", db.offsetX, db.offsetY)
	end
end

function M:UpdateCooldownTextOffset()
	for text in pairs(texts) do
		text:ClearAllPoints()
		text:Point(
			"CENTER",
			text:GetParent(),
			"CENTER",
			E.db.WT.misc.cooldownTextOffset.offsetX,
			E.db.WT.misc.cooldownTextOffset.offsetY
		)
	end
end

function M:CooldownTextOffset()
	hooksecurefunc(E, "CreateCooldownTimer", M.ElvUI_CreateCooldownTimer)
end

M:AddCallback("CooldownTextOffset")
