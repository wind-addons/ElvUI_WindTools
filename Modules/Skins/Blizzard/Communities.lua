local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs
local select = select

local GetClassInfo = GetClassInfo

local function updateClassIcon(row)
	if not row or not row.expanded then
		return
	end

	local memberInfo = row:GetMemberInfo()
	local classId = memberInfo and memberInfo.classID
	local englishClassName = classId and select(2, GetClassInfo(classId))
	if englishClassName then
		row.Class:SetTexture(F.GetClassIconWithStyle(englishClassName, "flat"))
		row.Class:SetTexCoord(0, 1, 0, 1)
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
		local target = memberList.ScrollBox:GetScrollTarget()
		if not target or not target.GetChildren then
			return
		end

		for _, row in pairs({ target:GetChildren() }) do
			if row and not row.__windSkinHook then
				hooksecurefunc(row, "RefreshExpandedColumns", updateClassIcon)
				row.__windSkinHook = true
			end
		end
	end)

	local BossModel = _G.CommunitiesFrameGuildDetailsFrameNews.BossModel
	self:CreateShadow(BossModel)
	self:CreateShadow(BossModel.TextFrame)

	hooksecurefunc(CommunitiesFrame.GuildBenefitsFrame.Rewards.ScrollBox, "Update", function(scrollBox)
		for _, child in next, { scrollBox.ScrollTarget:GetChildren() } do
			if not child.IsSkinned then
				self:Proxy("HandleIcon", child.Icon, true)
				child:StripTextures()
				child:CreateBackdrop("Transparent")
				child.backdrop:ClearAllPoints()
				child.backdrop:Point("TOPLEFT", child.Icon.backdrop)
				child.backdrop:Point("BOTTOMLEFT", child.Icon.backdrop)
				child.backdrop:Width(child:GetWidth() - 5)
				child.IsSkinned = true
			end

			if not child.__windSkin and W.AsianLocale then
				child.backdrop:ClearAllPoints()
				child.backdrop:Point("TOPLEFT", child.Icon.backdrop, -7, 5)
				child.backdrop:Point("BOTTOMLEFT", child.Icon.backdrop, -7, -5)
				child.backdrop:Width(child:GetWidth() + 9)
				child.__windSkin = true
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_Communities")
