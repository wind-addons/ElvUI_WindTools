local W, F, E, L, V, P, G = unpack(select(2, ...))
local tinsert = tinsert

-- 移动框架添加 WindTools 分类
tinsert(E.ConfigModeLayouts, "WINDTOOLS")
E.ConfigModeLocalizedStrings["WINDTOOLS"] = L["WindTools"]

E.PopupDialogs.WINDTOOLS_EDITBOX = {
    text = W.Title,
    button1 = _G.OKAY,
    hasEditBox = 1,
    OnShow = function(self, data)
        self.editBox:SetAutoFocus(false)
        self.editBox.width = self.editBox:GetWidth()
        self.editBox:Width(280)
        self.editBox:AddHistoryLine("text")
        self.editBox.temptxt = data
        self.editBox:SetText(data)
        self.editBox:HighlightText()
        self.editBox:SetJustifyH("CENTER")
    end,
    OnHide = function(self)
        self.editBox:Width(self.editBox.width or 50)
        self.editBox.width = nil
        self.temptxt = nil
    end,
    EditBoxOnEnterPressed = function(self)
        self:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    EditBoxOnTextChanged = function(self)
        if self:GetText() ~= self.temptxt then
            self:SetText(self.temptxt)
        end
        self:HighlightText()
        self:ClearFocus()
    end,
    OnAccept = E.noop,
    whileDead = 1,
    preferredIndex = 3,
    hideOnEscape = 1
}
