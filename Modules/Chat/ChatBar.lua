-- 原创模块
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local CB = E:NewModule('Wind_ChatBar', 'AceHook-3.0', 'AceEvent-3.0')

local _
local _G = _G
local ipairs = ipairs
local format = format
local CreateFrame = CreateFrame
local DefaultChatFrame = _G.DEFAULT_CHAT_FRAME

local normal_channels_index = {"SAY", "YELL", "PARTY", "INSTANCE", "RAID", "RAID_WARNING", "GUILD", "EMOTE"}

function CB:DebugPrint(text) print(L["WindTools"] .. "[聊天条]: " .. text) end

function CB:UpdateButton(name, func, anchor_point, x, y, color, tex, tooltip)
    local ElvUIValueColor = E.db.general.valuecolor

    if not self.bar[name] then
        -- 按键本体
        local button = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
        button:StripTextures()
        button:SetBackdropBorderColor(0, 0, 0)
        button:RegisterForClicks("AnyDown")
        button:SetScript("OnMouseUp", func)

        -- 鼠标提示
        button:SetScript("OnEnter", function(self)
			self:SetBackdropBorderColor(ElvUIValueColor.r, ElvUIValueColor.g, ElvUIValueColor.b)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:SetText(tooltip or _G[name] or "")
			GameTooltip:Show()
        end)
        
        button:SetScript("OnLeave", function(self)
			self:SetBackdropBorderColor(0, 0, 0)
			GameTooltip:Hide() 
		end)

        -- 块状风格条
        if self.db.style.block_type.enabled then
            button.colorBlock = button:CreateTexture(nil, "ARTWORK")
            button.colorBlock:SetAllPoints()
            button:CreateBackdrop('Transparent')
            button.backdrop:CreateShadow()
        end

        -- 文字风格条
        -- 预留（建立文字格式）

        self.bar[name] = button
    end

    -- 块状风格条 设置更新
    if self.db.style.block_type.enabled then
        self.bar[name].colorBlock:SetTexture(tex and E.Libs.LSM:Fetch('statusbar', tex) or E.media.normTex)
        self.bar[name].colorBlock:SetVertexColor(unpack(color or {1, 1, 1, 1}));
        if self.db.style.block_type.shadow then
            self.bar[name].backdrop.shadow:Show()
        else
            self.bar[name].backdrop.shadow:Hide()
        end
    end

    -- 尺寸和位置更新
    self.bar[name]:Size(CB.db.style.width, CB.db.style.height)
    self.bar[name]:ClearAllPoints()
    self.bar[name]:Point(anchor_point, CB.bar, anchor_point, x, y)

    self.bar[name]:Show()
end

function CB:DisableButton(name) if self.bar[name] then self.bar[name]:Hide() end end

function CB:UpdateBar()
    if not self.bar then
        self:DebugPrint("找不到母条！")
        return
    end
    -- 记录按钮个数来方便更新条的大小
    local numberOfButtons = 0
    local width, height

    -- 建立普通频道条
    local anchor = self.db.style.orientation == "HORIZONTAL" and "LEFT" or "TOP"
    local pos_x = 0
    local pos_y = 0

    if self.db.style.bar_backdrop then
        -- 有背景边距的情况下，初始化第一个按钮的定位
        if anchor == "LEFT" then
            pos_x = pos_x + self.db.style.padding
        else
            pos_y = pos_y - self.db.style.padding
        end
    end

    for _, name in ipairs(normal_channels_index) do
        local db = self.db.normal_channels[name]
        if db.enabled then
            local chatFunc = function()
                local currentText = DefaultChatFrame.editBox:GetText()
                local command = format("/%s ", db.cmd)
                ChatFrame_OpenChat(command .. currentText, DefaultChatFrame)
            end

            self:UpdateButton(name, chatFunc, anchor, pos_x, pos_y, db.color, self.db.style.block_type.tex)
            numberOfButtons = numberOfButtons + 1

            -- 调整锚点到下一个按钮的位置上
            if anchor == "LEFT" then
                pos_x = pos_x + self.db.style.width + self.db.style.padding
            else
                pos_y = pos_y - self.db.style.height - self.db.style.padding
            end
        else
            self:DisableButton(name)
        end
    end

    -- 计算条大小
    if self.db.style.bar_backdrop then
        if self.db.style.orientation == "HORIZONTAL" then
            width = self.db.style.padding * (numberOfButtons + 1) + self.db.style.width * numberOfButtons
            height = self.db.style.padding * 2 + self.db.style.height
        else
            width = self.db.style.padding * 2 + self.db.style.width
            height = self.db.style.padding * (numberOfButtons + 1) + self.db.style.height * numberOfButtons
        end
    else -- 如果没有背景，背景边距自然也不用算在框架大小内
        if self.db.style.orientation == "HORIZONTAL" then
            width = self.db.style.padding * (numberOfButtons - 1) + self.db.style.width * numberOfButtons
            height = self.db.style.height
        else
            width = self.db.style.width
            height = self.db.style.padding * (numberOfButtons - 1) + self.db.style.height * numberOfButtons
        end
    end

    self.bar:Size(width, height)

    if self.db.style.bar_backdrop then
        self.bar.backdrop:Show()
    else
        self.bar.backdrop:Hide()
    end
end

function CB:CreateBar()
    self.bar = CreateFrame("Frame", "Wind_ChatBar", E.UIParent, "SecureHandlerStateTemplate")
    self.bar:SetResizable(false)
    self.bar:SetClampedToScreen(true)
    self.bar:SetFrameStrata('LOW')
    self.bar:CreateBackdrop('Transparent')
    self.bar:ClearAllPoints()
    self.bar:Point("BOTTOMLEFT", LeftChatPanel, "TOPLEFT", 6, 3)
    self.bar.backdrop:CreateShadow()
end

function CB:PLAYER_ENTERING_WORLD()
    CB:CreateBar()
    CB:UpdateBar()
end

function CB:Initialize()
    if not E.db.WindTools["Chat"]["Chat Bar"].enabled then return end
    self.db = E.db.WindTools["Chat"]["Chat Bar"]

    tinsert(WT.UpdateAll, function() CB.db = E.db.WindTools["Chat"]["Chat Bar"] end)

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

local function InitializeCallback() CB:Initialize() end

E:RegisterModule(CB:GetName(), InitializeCallback)
