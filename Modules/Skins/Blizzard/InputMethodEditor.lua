local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS

function S:InputMethodEditor()
    if not self:CheckDB(nil, "inputMethodEditor") then
        return
    end

    for i = 1, NUM_CHAT_WINDOWS do
        -- 输入框
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        -- 输入法语言标识
        local langIcon = _G["ChatFrame" .. i .. "EditBoxLanguage"]

        if editBox then
            self:CreateShadow(editBox)
            if langIcon then
                langIcon:StripTextures()
                langIcon:CreateBackdrop("Transparent")
                langIcon:Size(20, 22)
                langIcon:ClearAllPoints()
                langIcon:Point("TOPLEFT", editBox, "TOPRIGHT", 7, 0)
                self:CreateShadow(langIcon)
            end
        end
    end

    -- 输入法候选框
    local IMECandidatesFrame = _G.IMECandidatesFrame
    if not IMECandidatesFrame then
        return
    end

    IMECandidatesFrame:StripTextures()
    IMECandidatesFrame:SetTemplate()
    self:CreateShadow(IMECandidatesFrame)

    for i = 1, 10 do
        local cf = IMECandidatesFrame["c" .. i]
        if cf then
            F.SetFontWithDB(cf.label, E.private.WT.skins.ime.label)
            F.SetFontWithDB(cf.candidate, E.private.WT.skins.ime.candidate)
            cf.candidate:Width(1000) -- 去除候选词句的显示宽度限制
        end
    end
end

S:AddCallback("InputMethodEditor")
