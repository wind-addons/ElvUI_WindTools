local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select

local GetClassInfo = GetClassInfo

---Update class icon for member list row
---@param row Frame The member list row frame
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

---Handle styling for individual reward button
---@param skinModule Skins The skin module instance
---@param child Frame The reward button frame
local function handleRewardButton(skinModule, child)
	if not child.IsSkinned then
		skinModule:Proxy("HandleIcon", child.Icon, true)
		child:StripTextures()
		child:CreateBackdrop("Transparent")
		child.backdrop:ClearAllPoints()
		child.backdrop:Point("TOPLEFT", child.Icon.backdrop)
		child.backdrop:Point("BOTTOMLEFT", child.Icon.backdrop)
		child.backdrop:SetWidth(child:GetWidth() - 5)
		child.IsSkinned = true
	end
end

---Handle styling for all reward buttons in container
---@param skinModule Skins The skin module instance
---@param frame Frame The container frame with reward buttons
local function handleRewardButtons(skinModule, frame)
	---@param child Frame
	frame:ForEachFrame(function(child)
		handleRewardButton(skinModule, child)
	end)
end

---Skin the Blizzard Communities frame and related elements
function S:Blizzard_Communities()
	if not self:CheckDB("communities") then
		return
	end

	local CommunitiesFrame = _G.CommunitiesFrame ---@type Frame
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

	local ClubFinderFrame = _G.ClubFinderCommunityAndGuildFinderFrame ---@type Frame?
	if ClubFinderFrame then
		self:CreateShadow(ClubFinderFrame.ClubFinderPendingTab)
		self:CreateShadow(ClubFinderFrame.ClubFinderSearchTab)
		self:CreateShadow(ClubFinderFrame.RequestToJoinFrame)
	end

	---@param memberList Frame
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

	local BossModel = _G.CommunitiesFrameGuildDetailsFrameNews.BossModel ---@type Frame
	self:CreateShadow(BossModel)
	self:CreateShadow(BossModel.TextFrame)

	---@param frame Frame
	hooksecurefunc(CommunitiesFrame.GuildBenefitsFrame.Rewards.ScrollBox, "Update", function(frame)
		handleRewardButtons(self, frame)
	end)
end

S:AddCallbackForAddon("Blizzard_Communities")
