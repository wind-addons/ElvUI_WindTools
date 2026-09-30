local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs
local select = select

local GetClassInfo = GetClassInfo

local function UpdateClassIcon(row)
	if not row or not row.expanded then
		return
	end

	local memberInfo = row:GetMemberInfo()
	local classID = memberInfo and memberInfo.classID
	local englishClassName = classID and select(2, GetClassInfo(classID))
	if englishClassName then
		row.Class:SetTexture(F.GetClassIconWithStyle(englishClassName, "flat"))
		row.Class:SetTexCoord(0, 1, 0, 1)
	end
end

local function HandleRewardButton(button)
	if not button.IsSkinned then
		return
	end

	if not button.__windSkin and W.AsianLocale then
		button.backdrop:ClearAllPoints()
		button.backdrop:Point("TOPLEFT", button.Icon.backdrop, -7, 5)
		button.backdrop:Point("BOTTOMLEFT", button.Icon.backdrop, -7, -5)
		button.backdrop:Width(button:GetWidth() + 9)
		button.__windSkin = true
	end
end

function S:Blizzard_Communities()
	if not self:CheckDB("communities") then
		return
	end

	local CommunitiesFrame = _G.CommunitiesFrame
	if not CommunitiesFrame then
		return
	end

	self:CreateShadow(CommunitiesFrame)
	self:CreateShadow(CommunitiesFrame.ChatTab)
	self:CreateShadow(CommunitiesFrame.RosterTab)
	self:CreateShadow(CommunitiesFrame.GuildBenefitsTab)
	self:CreateShadow(CommunitiesFrame.GuildInfoTab)
	self:CreateShadow(CommunitiesFrame.GuildMemberDetailFrame)
	self:CreateShadow(CommunitiesFrame.ClubFinderInvitationFrame)
	self:CreateShadow(CommunitiesFrame.RecruitmentDialog)
	self:CreateShadow(_G.CommunitiesGuildLogFrame)
	self:CreateShadow(_G.CommunitiesSettingsDialog)
	self:CreateShadow(_G.CommunitiesGuildNewsFiltersFrame)

	for _, frame in pairs({
		_G.ClubFinderCommunityAndGuildFinderFrame,
		_G.ClubFinderGuildFinderFrame,
	}) do
		if frame then
			self:CreateShadow(frame.ClubFinderPendingTab)
			self:CreateShadow(frame.ClubFinderSearchTab)
			self:CreateShadow(frame.RequestToJoinFrame)
		end
	end

	hooksecurefunc(CommunitiesFrame.MemberList, "RefreshListDisplay", function(memberList)
		memberList.ScrollBox:ForEachFrame(function(frame)
			if frame and not self:IsHooked(frame, "RefreshExpandedColumns") then
				self:SecureHook(frame, "RefreshExpandedColumns", UpdateClassIcon)
			end
		end)
	end)

	local BossModel = _G.CommunitiesFrameGuildDetailsFrameNews.BossModel
	self:CreateShadow(BossModel)
	self:CreateShadow(BossModel.TextFrame)

	hooksecurefunc(CommunitiesFrame.GuildBenefitsFrame.Rewards.ScrollBox, "Update", function(scrollBox)
		scrollBox:ForEachFrame(HandleRewardButton)
	end)
end

S:AddCallbackForAddon("Blizzard_Communities")
