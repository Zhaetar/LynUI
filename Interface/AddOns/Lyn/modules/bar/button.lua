local E, F, C = unpack(select(2, ...))

local BarPositions = {
	['LynBar1'] = {'BOTTOM', UIParent, 'BOTTOM', -220, 7},
	['LynBar2'] = {'BOTTOM', UIParent, 'BOTTOM', 220, 7},
	['LynBar3'] = {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -82, 7},
	['LynBar4'] = {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -15, 60},
	['LynBar5'] = {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -15, 93},
	['LynBar6'] = {'BOTTOM', UIParent, 'BOTTOM', -220, 60},
	['LynBar7'] = {'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 10, 7}
}

local SetPagingPosition = function()
	for _, v in pairs({
		MainMenuBarPageNumber,
		ActionBarUpButton,
		ActionBarDownButton
	}) do
		v:ClearAllPoints()
	end
	ActionBarUpButton:SetPoint('TOPRIGHT', _G['LynBar1'], 'TOPLEFT', -5, 9)
	ActionBarDownButton:SetPoint('TOP', ActionBarUpButton, 'BOTTOM', 0, 16)
	MainMenuBarPageNumber:SetPoint('TOPRIGHT', ActionBarUpButton, 'BOTTOMLEFT', 0, 16)
	MainMenuBarPageNumber:SetFont([[Fonts\ARIALN.ttf]], 14, 'OUTLINE')
end

local SetPositions = function()
		-- this is what our buttons are originally parented to!
	MainMenuBarArtFrame:SetParent(_G['LynBar1'])
	MainMenuBarArtFrame:EnableMouse(false)

		-- unpack positions
	for i = 1, 7 do
		local bar   = _G['LynBar'..i]
		local point = BarPositions['LynBar'..i]
		if not InCombatLockdown() then
			bar:ClearAllPoints()
			bar:SetPoint(point[1], point[2], point[3], point[4], point[5])
		end
	end

		-- EAB
	ExtraActionBarFrame:SetParent(UIParent)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame.ignoreFramePositionManager = true
	ExtraActionBarFrame:SetPoint('BOTTOM', -400, 250)

		--	reposition elements
	SetPagingPosition()
end

local AddVehicleLeaveButton = function(self, event, ...)
	local bu = CreateFrame('CheckButton', 'LynVehicleExitButton', UIParent, 'ActionButtonTemplate, SecureHandlerClickTemplate')

	bu:SetPoint('BOTTOM', -410, 132)
	bu:RegisterForClicks'AnyUp'

	F:PrepareButton(bu)
	F:SkinButton(bu)

	bu.icon:SetDrawLayer'OVERLAY'
	bu.icon:SetTexture[[Interface\Vehicles\UI-Vehicles-Button-Exit-Up]]
	bu.icon:ClearAllPoints()
	bu.icon:SetPoint('CENTER', bu)
	bu.icon:SetSize(30, 30)
	bu.icon:SetTexCoord(.2, .8, .2, .8)

	bu:SetScript('OnClick', function() VehicleExit() bu:SetChecked(false) end)
	RegisterStateDriver(bu, 'visibility', '[canexitvehicle] show; hide')
end

local GetButtonList = function(buttonName, numButtons)
	local buttonList = {}
	for i = 1, numButtons do
		local  button = _G[buttonName..i]
		if not button then break end
		table.insert(buttonList, button)
	end
	return buttonList
end

local AddPgNo = function()
	for _, v in pairs({
		MainMenuBarPageNumber,
		ActionBarUpButton, ActionBarDownButton,
	}) do
		v:ClearAllPoints()
		if v == MainMenuBarPageNumber then v:SetFontObject(GameFontHighlight) end
		if v ~= MainMenuBarPageNumber then
			v.t = v:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
			v.t:SetPoint'LEFT'
			v.t:SetJustifyH'LEFT'
			v.t:SetText(v == ActionBarUpButton and 'Up' or 'Dn')
			v:SetBackdropColor(0, 0, 0, 0)	-- undo!
		end
	end
end

local paging = function(bar)
	local list = GetButtonList('ActionButton', NUM_ACTIONBAR_BUTTONS)
	for i, button in next, list do
		bar:SetFrameRef('ActionButton'..i, button)
	end
	RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show')
	bar:Execute(([[
		buttons = table.new()
		for i = 1, %d do
		  table.insert(buttons, self:GetFrameRef("%s"..i))
		end
	]]):format(NUM_ACTIONBAR_BUTTONS, 'ActionButton'))
	bar:SetAttribute('_onstate-page', [[
		-- print('_onstate-page','index',newstate)
		for i, button in next, buttons do
		  button:SetAttribute('actionpage', newstate)
		end
	]])
	RegisterStateDriver(bar, 'page', '[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;1')
end


local g = CreateFrame'Frame'
local AddGrid = function()
	local list = GetButtonList('ActionButton', 12)
	if InCombatLockdown() then
		g:RegisterEvent'PLAYER_REGEN_ENABLED'
		g:SetScript('OnEvent', AddGrid)
		return
	end
	local var = tonumber(GetCVar'alwaysShowActionBars')
	g:UnregisterEvent'PLAYER_REGEN_ENABLED'
	for i, button in next, list do
		button:SetAttribute('showgrid', var)
		ActionButton_ShowGrid(button)
	end
end

local AddBars = function()					-- 1:  action 	2:  multileft 	3:  multiright
	for i = 1, 7 do							-- 4:  right	5:  left	6:  stance	7: pet
		local x, y = _G['ActionButton1']:GetSize()
		local bar  = CreateFrame('Frame', 'LynBar'..i, UIParent, 'SecureHandlerStateTemplate')
		bar:SetSize((x*12) + 4*(i < 7 and 12 or 10), y)
		if i == 1 then
			AddGrid()
			paging(bar)
		else
			RegisterStateDriver(bar, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show')
		end
	end
	AddVehicleLeaveButton()
	SetPositions()
end


local HideBar = function(parent)
	if  parent then
		if  InCombatLockdown() then
			parent:RegisterEvent'PLAYER_REGEN_ENABLED'
			parent:SetScript('OnEvent', function(self)
				self:Hide()
				self:UnregisterAllEvents()
			end)
		else
			parent:Hide()
		end
	end
end

local EAB = function(self)
	if  HasExtraActionBar() then
		local bar = ExtraActionBarFrame
		bar.button.style:SetSize(178, 88)
		bar.button.style:SetDrawLayer('BACKGROUND', -7)
		F:SkinButton(bar.button, true)
	end
end

local AddButtonsToBar = function(num, name, parent)
	for i = 1, num do
		local bu = _G[name..i]
		bu:ClearAllPoints()

		if i == 1 then
			bu:SetPoint('BOTTOMLEFT', parent)
			--AddBarBD(bu, parent)
		else
			bu:SetPoint('LEFT', _G[name..i - 1], 'RIGHT', 4.5, 0)
		end
				-- TODO:  give these individual functions?
			--  stance bar will show or hide whether the player uses it or not
			--  so w have to override it in our factory function
		if name == 'StanceButton' then
			if StanceBarFrame:IsShown() then
				_G['LynBar6']:Show()
				bu:Show()
				bu:SetParent(parent)
			else
				_G['LynBar6']:Hide()
				bu:Hide()
			end
		end
			--  pet bar is parented to blizzard frames that we hide, so parent it to bar
			--  TODO:   taint double check (should be fine)
		if name == 'PetActionButton' then
			bu:SetParent(parent)
		end

		if name ~= 'ActionButton' and name ~= 'MultiBarBottomLeftButton' and name ~= 'StanceButton' then
			bu:SetAlpha(.3)
		end

	end
	parent._buttonList = GetButtonList(name, num)
end



function E:PLAYER_ENTERING_WORLD()
		-- create single backpack button
	F:AddBackpack()
		-- create bars to parent buttons to
	AddBars()
		--  begin button reparenting
	AddButtonsToBar(12, 'ActionButton', _G['LynBar1'])
	AddButtonsToBar(12, 'MultiBarBottomLeftButton', _G['LynBar2'])
	AddButtonsToBar(12, 'MultiBarBottomRightButton', _G['LynBar3'])
	AddButtonsToBar(12, 'MultiBarRightButton', _G['LynBar4'])
	AddButtonsToBar(12, 'MultiBarLeftButton', _G['LynBar5'])
	AddButtonsToBar(10, 'StanceButton', _G['LynBar6'])
	AddButtonsToBar(10, 'PetActionButton', _G['LynBar7'])

		--  set new ExtraActionButton format
	hooksecurefunc('ExtraActionBar_Update', EAB)
		-- 	position bars
		--	TODO:	this event runs fairly infrequently but we should double check
		--			that we're not overdoing it
	hooksecurefunc('MultiActionBar_Update', function()
		if not InCombatLockdown() then
			SetPositions()
		end
	end)

end

hooksecurefunc('MultiActionBar_UpdateGridVisibility', AddGrid)
hooksecurefunc('HidePetActionBar', function()
	HideBar(_G['LynBar7'])
end)
