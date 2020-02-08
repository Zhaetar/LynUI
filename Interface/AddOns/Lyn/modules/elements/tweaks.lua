local E, F, C = unpack(select(2, ...))

-- Change damage font
DAMAGE_TEXT_FONT = C.DAMAGE_FONT

-- TalkingHeadFrame
LoadAddOn'Blizzard_TalkingHeadUI'
local TalkingHeadFrameWrapper = CreateFrame('Frame', 'TalkingHeadFrameWrapper', UIParent)
TalkingHeadFrameWrapper:SetScale(.75)
TalkingHeadFrameWrapper:SetPoint('TOP', UIParent, 0, -150)
TalkingHeadFrameWrapper:SetSize(10, 10)

TalkingHeadFrame:SetParent(TalkingHeadFrameWrapper)
TalkingHeadFrame:ClearAllPoints()
TalkingHeadFrame:SetPoint('CENTER')
TalkingHeadFrame.ignoreFramePositionManager = true

-- Order Hall
function E:ADDON_LOADED(addon)
	if addon == 'Blizzard_OrderHallUI' then
		OrderHallCommandBar:Hide()
		OrderHallCommandBar.Show = function() end
		return true
	end
end

-- PlayerPowerBarAlt
local ClearAllPointsHook = function(self)
	self:SetPoint("BOTTOM", PlayerPowerBarAltWrapper, 0, 0)
end

local PlayerPowerBarAltWrapper = CreateFrame('Frame', 'PlayerPowerBarAltWrapper', UIParent)
PlayerPowerBarAltWrapper:SetSize(64, 64)
PlayerPowerBarAltWrapper:SetPoint("TOP", 0, -80)

PlayerPowerBarAlt:SetParent(f)
PlayerPowerBarAlt:ClearAllPoints()
PlayerPowerBarAlt:SetPoint("BOTTOM", PlayerPowerBarAltWrapper, 0, 0)
PlayerPowerBarAlt.ignoreFramePositionManager = true

hooksecurefunc(PlayerPowerBarAlt, "ClearAllPoints", ClearAllPointsHook)

-- Battle.net Toasts
BNToastFrame:SetClampedToScreen(true)
BNToastFrame:HookScript('OnShow', function(self)
	F:CreateBorder(BNToastFrame)
	BNToastFrame:SetBorderColor(unpack(C.BORDER_COLOR_DARK))

	BNToastFrame:ClearAllPoints()
	BNToastFrame:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', 0, 45)
	BNToastFrame:SetBackdrop{
		bgFile = [[Interface/Tooltips/UI-Tooltip-Background]],
		tiled = false,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	}
	BNToastFrame:SetBackdropColor(0, 0, 0, 1)
	BNToastFrame:SetBackdropBorderColor(0, 0, 0, 0)

	--local ft, fs, ff = BNToastFrameTopLine:GetFont()
	BNToastFrameTopLine:SetFont(C.BIG_FONT, 12)
	BNToastFrameTopLine:SetShadowOffset(1, -1)
	BNToastFrameTopLine:SetShadowColor(0, 0, 0,1)

	BNToastFrameMiddleLine:SetFont(C.SMALL_FONT, 12)
	BNToastFrameMiddleLine:SetShadowOffset(.7, -.7)
	BNToastFrameMiddleLine:SetShadowColor(0, 0, 0,1)

	BNToastFrameBottomLine:SetFont(C.SMALL_FONT, 12)
	BNToastFrameBottomLine:SetShadowOffset(1, -1)
	BNToastFrameBottomLine:SetShadowColor(0, 0, 0,1)

	BNToastFrameDoubleLine:SetFont(C.SMALL_FONT, 12)
	BNToastFrameDoubleLine:SetShadowOffset(1, -1)
	BNToastFrameDoubleLine:SetShadowColor(0, 0, 0,1)

	BNToastFrameCloseButton:SetNormalTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Up]])
	BNToastFrameCloseButton:SetPushedTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Down]])
	BNToastFrameCloseButton:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
	BNToastFrameCloseButton:SetPoint('TOPRIGHT', -2, -2)

end)

-- eqb
if IsAddOnLoaded'ExtraQuestButton' then
	ExtraQuestButton:HookScript('OnShow', function(self)
		ExtraQuestButton.Artwork:SetSize(178, 88)
		if not InCombatLockdown() then
			F:SkinButton(ExtraQuestButton)
		end
	end)
end
