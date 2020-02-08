local E, F = unpack(select(2, ...))

local UpdateBackpackFreeSlots = function()
	local total = 0
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local free, family = GetContainerNumFreeSlots(i)
		if family == 0 then total = total + free end
	end
	MainMenuBarBackpackButtonCount:SetText(string.format('%s', total))
end

function F:AddBackpack()
	local bu = MainMenuBarBackpackButton
	bu:ClearAllPoints()
	bu:SetPoint('BOTTOMRIGHT', UIParent, -10, 8)
	F:PrepareButton(bu, 1, true)
	F:SkinButton(bu)

	UpdateBackpackFreeSlots()
	hooksecurefunc('MainMenuBarBackpackButton_UpdateFreeSlots', UpdateBackpackFreeSlots)
end

for i = 0, 3 do
	local slot = _G['CharacterBag'..i..'Slot']
	slot:Hide()
end
