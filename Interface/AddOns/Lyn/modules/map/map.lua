local E, F, C = unpack(select(2, ...))

MinimapCluster:ClearAllPoints()
MinimapCluster:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -34, -34)
MinimapCluster:EnableMouse(false)
MinimapCluster:SetClampedToScreen(false)
MinimapCluster:SetSize(200,200)
Minimap:SetClampedToScreen(false)
Minimap:SetSize(200, 200)
Minimap:SetMaskTexture([[Interface\Buttons\WHITE8x8]])
--Minimap:SetHitRectInsets(0, 0, 24, 24)
Minimap:ClearAllPoints()
Minimap:SetAllPoints(MinimapCluster)
Minimap:SetFrameLevel(2)

function GetMinimapShape() return 'SQUARE' end

local Border = Minimap:CreateTexture(nil, 'OVERLAY', nil, 2)
Border:SetTexture([[Interface\AddOns\Lyn\assets\minimap.tga]])
Border:SetPoint('TOPLEFT', -15, 15)
Border:SetPoint('BOTTOMRIGHT', 15, -15)
Border:SetVertexColor(unpack(C.BORDER_COLOR_GOLD))

Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, arg1)
	if arg1 > 0 then Minimap_ZoomIn() else Minimap_ZoomOut() end
end)

Minimap:SetScript('OnMouseUp', function(self, button)
	--Minimap:StopMovingOrSizing()
	if button == 'RightButton' then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * .005), -20)
	elseif button == 'MiddleButton' then
		securecall(ToggleCalendar)
	else
		Minimap_OnClick(self)
	end
end)

GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetParent(Minimap)
GarrisonLandingPageMinimapButton:SetPoint('TOPRIGHT', Minimap, 0, 5)
GarrisonLandingPageMinimapButton:SetSize(48, 48)
hooksecurefunc('GarrisonLandingPageMinimapButton_UpdateIcon', function(self)
	self:SetNormalTexture('')
	self:SetPushedTexture('')
	self:SetHighlightTexture('')

	if not self.icon then
		local icon = self:CreateTexture(nil,'OVERLAY',nil,7)
		icon:SetSize(32, 32)
		icon:SetPoint('CENTER')
		--icon:SetTexture([[Interface/MINIMAP/TRACKING/Profession]])
		icon:SetTexture([[Interface/AddOns/Lyn/assets/garrison.tga]])
		icon:SetVertexColor(1, 1, 1)
		self.icon = icon
	end

	if (C_Garrison.GetLandingPageGarrisonType() == LE_GARRISON_TYPE_6_0) then
		self.title = GARRISON_LANDING_PAGE_TITLE;
		self.description = MINIMAP_GARRISON_LANDING_PAGE_TOOLTIP;
	else
		self.title = ORDER_HALL_LANDING_PAGE_TITLE;
		self.description = MINIMAP_ORDER_HALL_LANDING_PAGE_TOOLTIP;
	end
end)

MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint('TOPLEFT', Minimap, 10, 7)
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint('TOPLEFT', Minimap, 10, 7)
MiniMapChallengeMode:ClearAllPoints()
MiniMapChallengeMode:SetPoint('TOPLEFT', Minimap, 10, 7)

local lfg = MiniMapLFGFrame or QueueStatusMinimapButton
lfg:SetScale(.9)
lfg:ClearAllPoints()
lfg:SetParent(Minimap)
lfg:SetFrameStrata'HIGH'
lfg:SetPoint('BOTTOMLEFT', Minimap, 15, -18)
QueueStatusMinimapButtonBorder:SetVertexColor(unpack(C.BORDER_COLOR_GOLD))

MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetParent(Minimap)
MiniMapMailFrame:SetFrameStrata'HIGH'
MiniMapMailFrame:SetPoint('BOTTOMRIGHT', Minimap, -13, -18)
MiniMapMailBorder:SetVertexColor(unpack(C.BORDER_COLOR_GOLD))

hooksecurefunc(DurabilityFrame, 'SetPoint', function(self, _, parent)
	if parent=='MinimapCluster' or parent==_G['MinimapCluster'] then
		self:ClearAllPoints()
		self:SetPoint('RIGHT', Minimap, 'LEFT', -90, -250)
		self:SetScale(.7)
	end
end)

hooksecurefunc(VehicleSeatIndicator,'SetPoint', function(self, _, parent)
	if parent=='MinimapCluster' or parent==_G['MinimapCluster'] then
		self:ClearAllPoints()
		self:SetPoint('RIGHT', Minimap, 'LEFT', -100, -250)
		self:SetScale(.7)
	end
end)

hooksecurefunc('UIParent_ManageFramePositions', function()
	 if NUM_EXTENDED_UI_FRAMES then
		  for i = 1, NUM_EXTENDED_UI_FRAMES do
				local bar = _G['WorldStateCaptureBar'..i]
				if bar and bar:IsVisible() then
					 bar:ClearAllPoints()
					 if i == 1 then
						  bar:SetPoint('BOTTOM', MinimapCluster, 'TOP', 0, 30)
					 else
						  bar:SetPoint('BOTTOM', _G['WorldStateCaptureBar'..(i - 1)], 'TOP', 0, 20)
					 end
				end
		  end
	 end
end)


-- HIDE
----------------------------------------------
MinimapBackdrop:Hide()
MinimapBorder:Hide()
MinimapBorderTop:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MiniMapVoiceChatFrame:Hide()
GameTimeFrame:Hide()
MinimapZoneTextButton:Hide()
MiniMapTracking:Hide()
MinimapNorthTag:SetAlpha(0)
Minimap:SetArchBlobRingScalar(0)
Minimap:SetArchBlobRingAlpha(0)
Minimap:SetQuestBlobRingScalar(0)
Minimap:SetQuestBlobRingAlpha(0)

LoadAddOn'Blizzard_TimeManager'
local region = TimeManagerClockButton:GetRegions()
region:Hide()
TimeManagerClockButton:Hide()
