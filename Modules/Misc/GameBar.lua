local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local GB = W:NewModule("GameBar", "AceEvent-3.0", "AceHook-3.0")

local ButtonTypes = {
    CHARACTER = {
        name = L["Character"],
        icon = W.Media.Icons.barCharacter,
        func = function()
            print("character")
        end
    },
    SPELLS = {
        name = L["Spells"],
        icon = W.Media.Icons.barSpells,
        func = function()
            print("Spells")
        end
    },
    FRIENDS = {
        name = L["Friends"],
        icon = W.Media.Icons.barFriends,
        func = function()
            print("character")
        end
    },
    GUILD = {
        name = L["Guild"],
        icon = W.Media.Icons.barGuild,
        func = function()
            print("Guild")
        end
    },
    ENCOUNTERJOURNAL = {
        name = L["Encounter Journal"],
        icon = W.Media.Icons.barJournal,
        func = function()
            print("Encounter Journal")
        end
    },
    PETJOURNAL = {
        name = L["Pet Journal"],
        icon = W.Media.Icons.barJournal,
        func = function()
            print("Pet Journal")
        end
    },
    PVE = {
        name = L["PVE"],
        icon = W.Media.Icons.barPVE,
        func = function()
            print("PVE")
        end
    }
}

-------------------------
-- 条
function GB:ConstructBar()
    local bar = CreateFrame("Frame", "WTGameBar", E.UIParent)
    bar:Size(300, 40) -- 临时大小, 需要在之后进行重新更新计算
    bar:Point("CENTER")
    bar:CreateBackdrop("Transparent")

    if E.private.WT.skins.enable and E.private.WT.skins.windtools then
        S:CreateShadow(bar.backdrop)
    end

    bar.buttons = {}

    self.bar = bar
end

-------------------------
-- 按钮
function GB:ButtonOnEnter(button)
    E:UIFrameFadeIn(button.hoverTex, self.db.fadeTime, button.hoverTex:GetAlpha(), 1)
end

function GB:ButtonOnLeave(button)
    E:UIFrameFadeOut(button.hoverTex, self.db.fadeTime, button.hoverTex:GetAlpha(), 0)
end

function GB:ConstructButton(config)
    if not self.bar then
        return
    end

    local button = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate, BackdropTemplate")
    button:Size(self.db.buttonSize)

    local normalTex = button:CreateTexture(nil, "ARTWORK")
    normalTex:Point("CENTER")
    normalTex:Size(self.db.buttonSize)
    normalTex:SetTexture(config.icon)
    button.normalTex = normalTex

    local hoverTex = button:CreateTexture(nil, "ARTWORK")
    hoverTex:Point("CENTER")
    hoverTex:Size(self.db.buttonSize)
    hoverTex:SetTexture(config.icon)
    hoverTex:SetAlpha(0)
    button.hoverTex = hoverTex

    button:SetScript(
        "OnClick",
        function()
            config.func()
        end
    )

    button.name = config.name

    self:HookScript(button, "OnEnter", "ButtonOnEnter")
    self:HookScript(button, "OnLeave", "ButtonOnLeave")

    self:UpdateButton(button)

    tinsert(self.bar.buttons, button)
end

function GB:UpdateButton(button) -- 颜色, 尺寸
    if not button.normalTex or not button.hoverTex then
        return
    end

    local size = self.db.buttonSize
    button:Size(size)

    local r, g, b = 1, 1, 1
    if self.db.normalColor == "CUSTOM" then
        r = self.db.customNormalColor.r
        g = self.db.customNormalColor.g
        b = self.db.customNormalColor.b
    elseif self.db.normalColor == "CLASS" then
        local classColor = E:ClassColor(E.myclass, true)
        r = classColor.r
        g = classColor.g
        b = classColor.b
    elseif self.db.normalColor == "VALUE" then
        r, g, b = unpack(E.media.rgbvaluecolor)
    end

    button.normalTex:Size(size)
    button.normalTex:SetVertexColor(r, g, b)

    r, g, b = 1, 1, 1

    if self.db.hoverColor == "CUSTOM" then
        r = self.db.customHoverColor.r
        g = self.db.customHoverColor.g
        b = self.db.customHoverColor.b
    elseif self.db.hoverColor == "CLASS" then
        local classColor = E:ClassColor(E.myclass, true)
        r = classColor.r
        g = classColor.g
        b = classColor.b
    elseif self.db.hoverColor == "VALUE" then
        r, g, b = unpack(E.media.rgbvaluecolor)
    end

    button.hoverTex:Size(size)
    button.hoverTex:SetVertexColor(r, g, b)
end

function GB:RenewButton(button, config) -- 执行函数, 名称, 材质
    button.name = config.name
    button.normalTex:SetTexture(config.icon)
    button.hoverTex:SetTexture(config.icon)
    button:SetScript(
        "OnClick",
        function()
            config.func()
        end
    )
end

function GB:ConstructButtons()
    self:ConstructButton(ButtonTypes.CHARACTER)
    local button = self.bar.buttons[1]
    button:Point("LEFT", self.bar, "LEFT", 3, 0)
end

-------------------------
-- 排列
function GB:UpdateLayout()
    if self.db.backdrop then
        self.bar.backdrop:Hide()
    else
        self.bar.backdrop:Show()
    end
end


function GB:Initialize()
    self.db = E.db.WT.misc.gameBar
    if not self.db or not self.db.enable then
        return
    end
end

W:RegisterModule(GB:GetName())
