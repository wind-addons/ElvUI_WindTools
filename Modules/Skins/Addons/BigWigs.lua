local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local unpack = unpack
local format = format

local C_Timer_NewTicker = C_Timer.NewTicker

function S:BigWigs_CreateBar(barLib, ...)
    local bar = self.hooks[barLib]["CreateBar"](barLib, ...)

    if E.private.WT.skins.shadow then
        self:CreateShadow(bar, 5)
        bar.candyBarIconFrame:CreateBackdrop()
        self:CreateShadow(bar.candyBarIconFrame.backdrop)
    end

    return bar
end

function S:BigWigs_Plugins()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.bigWigs then
        return
    end

    if not _G.BigWigs then
        return
    end

    local barLib = _G.BigWigs:GetPlugin("Bars")
    self:RawHook(barLib, "CreateBar", "BigWigs_CreateBar")
end

function S:BigWigs_QueueTimer()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.bigWigsQueueTimer then
        return
    end

    if _G.BigWigsLoader then
        _G.BigWigsLoader.RegisterMessage(
            "WindTools",
            "BigWigs_FrameCreated",
            function(_, frame, name)
                if name == "QueueTimer" then
                    local parent = frame:GetParent()
                    frame:StripTextures()
                    frame:CreateBackdrop("Transparent")
                    self:CreateShadow(frame.backdrop)
                    frame:SetStatusBarTexture(E.media.normTex)
                    frame:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
                    frame:Size(parent:GetWidth(), 10)
                    frame:ClearAllPoints()
                    frame:Point("TOPLEFT", parent, "BOTTOMLEFT", 0, -5)
                    frame:Point("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -5)
                    frame.text.SetFormattedText = function(self, _, time)
                        self:SetText(format("%d", time))
                    end
                    F.SetFontWithDB(
                        frame.text,
                        {
                            name = F.GetCompatibleFont("Montserrat"),
                            size = 16,
                            style = "OUTLINE"
                        }
                    )
                    frame.text:ClearAllPoints()
                    frame.text:Point("TOP", frame, "TOP", 0, -3)
                end
            end
        )

        E:Delay(
            2,
            function()
                _G.BigWigsLoader.UnregisterMessage("AddOnSkins", "BigWigs_FrameCreated")
            end
        )
    end
end

S:AddCallbackForAddon("BigWigs_Plugins")
S:AddCallbackForEnterWorld("BigWigs_QueueTimer")
