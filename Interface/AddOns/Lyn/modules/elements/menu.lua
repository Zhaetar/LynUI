local E, F, C = unpack(select(2, ...))

-- CONFIG
local _, class = UnitClass'player'
local _, race  = UnitRace'player'
local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
local Gender = {'neuter or unknown', 'male', 'female'}

--  thanks to sammojo
-- https://www.reddit.com/r/WowUI/comments/3oj7wm/help_requesting_basic_coding_help_for_interactive/cvzobjw

-- GAME MENU
local button = CreateFrame('BUTTON', 'LynMenuButton', MainMenuBarBackpackButton)
button:SetSize(30, 30)
button:SetPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT', -5, -1)
button:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
F:PrepareButton(button, 1, true)
F:SkinButton(button)

local icon = button:CreateTexture(nil,'OVERLAY')
icon:SetPoint('TOPLEFT', 1, -1)
icon:SetPoint('BOTTOMRIGHT', -1, 1)
if race == 'Worgen' then
	icon:SetTexture('Interface\\Icons\\achievement_worganhead')
else
	icon:SetTexture('Interface\\Icons\\Achievement_character_'..strlower(race == 'Scourge' and 'undead' or race)..'_'..Gender[UnitSex'player'])
end
icon:SetTexCoord(.08, .92, .08, .92)


-- DROPDOWN
local dropdown = CreateFrame('Frame', 'LynClockMicroMenu', UIParent, 'Lib_UIDropDownMenuTemplate')
dropdown.initialize = function(self, level)
	local info = Lib_UIDropDownMenu_CreateInfo()
	info.padding = 15
	info.fontObject = LynMicroMenuFont
	info.isLynMenu = true

	info.icon = [[Interface\AddOns\Lyn\assets\icons\char]]
	info.colorCode = '|cffffffff'
	info.text = CHARACTER_BUTTON
	info.notCheckable = true
	info.func =  function() securecall(ToggleCharacter, 'PaperDollFrame') end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\spell]]
	info.colorCode = '|cffffffff'
	info.text = SPELLBOOK_ABILITIES_BUTTON
	info.notCheckable = true
	info.func =  function() securecall(ToggleSpellBook, BOOKTYPE_SPELL) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\talent]]
	info.colorCode = '|cffffffff'
	info.text = TALENTS_BUTTON
	info.notCheckable = true
	info.func =  function() securecall(ToggleTalentFrame) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\social]]
	info.colorCode = '|cffffffff'
	info.text = SOCIAL_BUTTON
	info.notCheckable = true
	info.func =  function() securecall(ToggleFriendsFrame) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\guild]]
	info.colorCode = '|cffffffff'
	info.text = GUILD
	info.notCheckable = true
	info.func =  function() securecall(ToggleGuildFrame) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\ach]]
	info.colorCode = '|cffffffff'
	info.text = ACHIEVEMENT_BUTTON
	info.notCheckable = true
	info.func =  function() securecall(ToggleAchievementFrame) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\quest]]
	info.colorCode = '|cffffffff'
	info.text = QUESTLOG_BUTTON
	info.notCheckable = true
	info.func =  function() securecall(ToggleQuestLog) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\lfg]]
	info.colorCode = '|cffffffff'
	info.text = GROUP_FINDER
	info.notCheckable = true
	info.func =  function() securecall(PVEFrame_ToggleFrame, 'GroupFinderFrame') end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\journal]]
	info.colorCode = '|cffffffff'
	info.text = ADVENTURE_JOURNAL
	info.notCheckable = true
	info.func =  function() securecall(ToggleEncounterJournal) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\pvp]]
	info.colorCode = '|cffffffff'
	info.text = PVP_OPTIONS
	info.notCheckable = true
	info.func =  function() securecall(PVEFrame_ToggleFrame, 'PVPUIFrame', HonorFrame) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\pet]]
	info.colorCode = '|cffffffff'
	info.text = COLLECTIONS
	info.notCheckable = true
	info.func =  function()
		if InCombatLockdown() then
			print('|cffffdd00You are in combat.|r')
			return
		end
		securecall(ToggleCollectionsJournal)
	end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\shop]]
	info.colorCode = '|cffffffff'
	info.text = BLIZZARD_STORE
	info.notCheckable = true
	info.func =  function() securecall(ToggleStoreUI) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = [[Interface\AddOns\Lyn\assets\icons\help]]
	info.colorCode = '|cffffffff'
	info.text = HELP_BUTTON
	info.notCheckable = true
	info.func =  function() securecall(ToggleHelpFrame) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = nil
	info.colorCode = '|cff999999'
	info.text = ADDON_LIST
	info.notCheckable = true
	info.func = function() ToggleFrame(AddonList) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = nil
	info.colorCode = '|cff999999'
	info.text = LOOT_ROLLS
	info.notCheckable = true
	info.func =  function() securecall(ToggleLootHistoryFrame) end
	Lib_UIDropDownMenu_AddButton(info, level)

	info.icon = nil
	info.colorCode = '|cff999999'
	info.text = BATTLEFIELD_MINIMAP
	info.notCheckable = true
	info.func =  function() securecall(ToggleBattlefieldMinimap) end
	Lib_UIDropDownMenu_AddButton(info, level)

	wipe(info)
end

button:SetScript('OnClick', function(self, button, down)
	if button == 'LeftButton' then
		Lib_ToggleDropDownMenu(1, nil, dropdown, self, -90, 565)
	elseif button == 'RightButton' then
		if IsShiftKeyDown() then
			ReloadUI()
		else
			ToggleFrame(GameMenuFrame)
		end
	end
end)

hooksecurefunc('Lib_UIDropDownMenu_AddButton', function(info, level)
	if not level then level = 1 end
	for j = 1, _G.LIB_UIDROPDOWNMENU_MAXBUTTONS do
		LIB_UIDROPDOWNMENU_BUTTON_HEIGHT = info.isLynMenu and 26 or 16
		local button 	= _G['Lib_DropDownList'..level..'Button'..j]
		local icon 		= _G['Lib_DropDownList'..level..'Button'..j..'Icon']
		button:SetHeight(LIB_UIDROPDOWNMENU_BUTTON_HEIGHT)
		if not button.iconOnly and info.isLynMenu then
			icon:SetSize(24, 24)
		end
	end
end)
