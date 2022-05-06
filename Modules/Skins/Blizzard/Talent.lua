local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local pairs = pairs
local select = select

local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecializationRole = GetSpecializationRole

local C_SpecializationInfo_IsInitialized = C_SpecializationInfo.IsInitialized

function S:BlizzardTalent()
    if not E.global.general.showMissingTalentAlert then
        return
    end

    if not self:CheckDB(nil, "talent") then
        return
    end

    local TalentMicroButtonAlert = _G.TalentMicroButtonAlert
    if TalentMicroButtonAlert and (not TalentMicroButtonAlert.shadow) then
        -- 防止重复扩大
        TalentMicroButtonAlert:SetWidth(TalentMicroButtonAlert:GetWidth() + 50)
        TalentMicroButtonAlert.Text:SetWidth(TalentMicroButtonAlert.Text:GetWidth() + 50)
    end

    self:CreateShadow(TalentMicroButtonAlert)
end

function S:Blizzard_TalentUI()
    if not self:CheckDB("talent") then
        return
    end

    self:CreateShadow(_G.PlayerTalentFrame)
    self:CreateShadow(_G.PlayerTalentFrameTalentsPvpTalentFrameTalentList)
    for i = 1, 3 do
        self:ReskinTab(_G["PlayerTalentFrameTab" .. i])
    end

    self:SecureHook(
        "PlayerTalentFrame_UpdateSpecFrame",
        function(self, spec)
            if not C_SpecializationInfo_IsInitialized() then
                return
            end

            local scrollChild = self.spellsScroll.child
            local playerTalentSpec = GetSpecialization(nil, self.isPet, _G.PlayerSpecTab2:GetChecked() and 2 or 1)
            local shownSpec = spec or playerTalentSpec or 1
            local role = select(5, GetSpecializationInfo(shownSpec, nil, self.isPet))

            if role and scrollChild.roleIcon then
                if not scrollChild.roleIcon.backdrop then
                    scrollChild.roleIcon:CreateBackdrop("Transparent")
                end
                scrollChild.roleIcon:SetTexture(W.Media.Textures.ROLES)
                scrollChild.roleIcon:SetTexCoord(F.GetRoleTexCoord(role))
            end

            local buttons = {
                "PlayerTalentFrameSpecializationSpecButton",
                "PlayerTalentFramePetSpecializationSpecButton"
            }

            for _, name in pairs(buttons) do
                for i = 1, 4 do
                    local button = _G[name .. i]

                    if button and button.backdrop then
                        button.backdrop:SetTemplate("Transparent")
                    end

                    local roleIcon = button.roleIcon
                    local role = GetSpecializationRole(i, false, button.isPet)
                    if role and roleIcon then
                        if not roleIcon.backdrop then
                            roleIcon:CreateBackdrop("Transparent")
                        end
                        roleIcon:SetTexture(W.Media.Textures.ROLES)
                        roleIcon:Size(20)
                        roleIcon:SetTexCoord(F.GetRoleTexCoord(role))
                    end
                end
            end
        end
    )
end

S:AddCallback("BlizzardTalent")
S:AddCallbackForAddon("Blizzard_TalentUI")
