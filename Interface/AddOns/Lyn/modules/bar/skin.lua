local E, F, C = unpack(select(2, ...))

local function IsButton(self, name)
     if self:GetName():match(name) then return true else return false end
 end

local Zone = function(self)
	if  ZoneAbilityFrame then
		UIPARENT_MANAGED_FRAME_POSITIONS.ZoneAbilityFrame = nil
		ZoneAbilityFrame:SetParent(UIParent)
		ZoneAbilityFrame:SetScale(1)
		ZoneAbilityFrame:ClearAllPoints()
		ZoneAbilityFrame:SetPoint('BOTTOM', UIParent, -600, 250)
	end
end

local pet = function(self)
	for _, name in pairs({
         'PetActionButton',
         'PossessButton',
         'StanceButton',
     }) do
         for i = 1, 12 do
             local bu = _G[name..i]
			local ic = _G[name..i..'Icon']
			local bg = _G[name..i..'FloatingBG']
			local bo = _G[name..i..'Border']
			local no = _G[name..i..'NormalTexture'] or _G[name..i..'NormalTexture2']

			if bu then
				if not bu.style then
					F:PrepareButton(bu, 1, true)
					F:SkinButton(bu)
					bu.style = true
				end

				for _, v in pairs({bg, bo, no}) do
					if v then v:SetAlpha(0) end
				end

				if name == 'PetActionButton' then
                    local shine = _G[name..i..'Shine']
                    local auto  = _G[name..i..'AutoCastable']

                    if  shine then
                        shine:ClearAllPoints()
                        shine:SetPoint('TOPLEFT', bu, 1.5, -1.5)
                        shine:SetPoint('BOTTOMRIGHT', bu, -1.5, 1.5)
                        shine:SetFrameStrata'HIGH'
                    end

                    if  auto then
                        auto:SetSize(44, 44)
                        auto:SetDrawLayer('OVERLAY', 7)
                    end
                end
			end
		end
	end
end

local skin = function(self)
	local name = self:GetName()
	local bu = _G[name]
	local bg = _G[name..'FloatingBG']
	local bo = _G[name..'Border']
	local fly  = _G[name..'FlyoutBorder']
	local flys = _G[name..'FlyoutBorderShadow']
	local flya = _G[name..'FlyoutArrow']

	if not bu.skinned then
		F:PrepareButton(bu, 1, true)
		F:SkinButton(bu)
		bu.skinned = true
	end

	if flya then
		flya:SetDrawLayer('OVERLAY', 2)
	end

	local state = bu:GetButtonState()
	if IsEquippedAction(self.action) then
		 bu:SetBorderColor(0, 1, 0, 1)
	elseif state == 'PUSHED' then
		 bu:SetBorderColor(1, .9, 0, 1)
	-- elseif bu:GetChecked() then
	-- 	 bu:SetBorderColor(0, .7, 1, 1)
	else
		 bu:SetBorderColor(unpack(C.BUTTON_BORDER_COLOR_BASE))
	end

	if IsButton(self, 'ExtraActionButton') or IsButton(self, 'ZoneActionBarFrameButton') then
		Zone(bu)
	end

	for _, v in pairs({fly, flys}) do
		if v then v:SetTexture'' end
	end

	for _, v in pairs({bg, bo}) do
		if v then v:SetAlpha(0) end
	end
end

local AddFlyoutSkin = function(self)
	local i = 1
	while _G['SpellFlyoutButton'..i] do
		local bu = _G['SpellFlyoutButton'..i]
		local ic = _G['SpellFlyoutButton'..i..'Icon']
		F:PrepareButton(bu, 1, true)
		F:SkinButton(bu)

		for _, v in pairs({
			SpellFlyoutBackgroundEnd,
			SpellFlyoutHorizontalBackground, SpellFlyoutVerticalBackground
		}) do
			v:SetTexture''
		end
		i = i + 1
	end
end

SpellFlyout:HookScript('OnShow', AddFlyoutSkin)
hooksecurefunc('PetActionBar_Update', pet)
hooksecurefunc('StanceBar_UpdateState', pet)
securecall'PetActionBar_Update'
hooksecurefunc('ActionButton_Update', skin)
