	local E, F, C = unpack(select(2, ...))

                        -- tooltip mod
                        -- with some bits pinched from an ancient (early-WOTLK!) version of rantTooltip
                        -- credits to Rummie
                        -- obble


        -- default tooltip position
	--local TipPosition = {'BOTTOMRIGHT', UIParent, -50, 50 }
	local TipPosition = {'BOTTOMRIGHT', UIParent, -50, 125 }


    local RAID_CLASS_COLORS = RAID_CLASS_COLORS
    local FACTION_BAR_COLORS = FACTION_BAR_COLORS
    local r, g, b = 103/255, 103/255, 103/255
    local WorldFrame = WorldFrame
    local GameTooltip = GameTooltip
    local GameTooltipStatusBar = GameTooltipStatusBar
    local BACKDROP = {
        bgFile = [[Interface/Tooltips/UI-Tooltip-Background]],
		  edgeFile = [[Interface/Tooltips/UI-Tooltip-Border]],
        tiled = false,
		  edgeSize = 16,
        insets = {left = 3, right = 3, top = 3, bottom = 3}
    }

	TOOLTIP_DEFAULT_COLOR.r = 0.8
	TOOLTIP_DEFAULT_COLOR.g = 0.8
	TOOLTIP_DEFAULT_COLOR.b = 0.8

	TOOLTIP_DEFAULT_BACKGROUND_COLOR.r = 0
	TOOLTIP_DEFAULT_BACKGROUND_COLOR.g = 0
	TOOLTIP_DEFAULT_BACKGROUND_COLOR.b = 0

        -- TEXT
    GameTooltipHeaderText:SetFont(C.TOOLTIP_HEADER_FONT, 18)
    GameTooltipHeaderText:SetShadowOffset(1, -1)
    GameTooltipHeaderText:SetShadowColor(0, 0, 0, 1)

    GameTooltipText:SetFont(STANDARD_TEXT_FONT, 11)
    GameTooltipText:SetShadowOffset(1, -1)
    GameTooltipText:SetShadowColor(0, 0, 0,1)

    Tooltip_Small:SetFont(STANDARD_TEXT_FONT, 11)
    Tooltip_Small:SetShadowOffset(1, -1)
    Tooltip_Small:SetShadowColor(0, 0, 0, 1)

	 SmallTextTooltipText:SetFont(STANDARD_TEXT_FONT, 11)


        -- HP BAR
	GameTooltipStatusBar:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil, 'BACKGROUND')
	GameTooltipStatusBar.bg:SetTexture(C.STATUSBAR_TEXTURE)
	GameTooltipStatusBar.bg:SetAllPoints(GameTooltipStatusBar)

    GameTooltip:HookScript("OnTooltipCleared", function(self)
		GameTooltip_ClearStatusBars(self)
	end)

        -- COLOURING NAME
    local GetHexColor = function(colour)
        return ('%.2x%.2x%.2x'):format(colour.r*255, colour.g*255, colour.b*255)
    end


    local reactionColors = {}
    for i = 1, #FACTION_BAR_COLORS do
        reactionColors[i] = GetHexColor(FACTION_BAR_COLORS[i])
    end

	local classColors = {}
    for class, color in pairs(RAID_CLASS_COLORS) do
        classColors[class] = GetHexColor(CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class])
    end


        -- POSITION
	local SetDefaultAnchorHook = function(tooltip, parent)
		if cursor and GetMouseFocus() == WorldFrame then
			tooltip:SetOwner(parent, 'ANCHOR_CURSOR')
		else
			tooltip:ClearAllPoints()
			tooltip:SetOwner(parent, 'ANCHOR_NONE')

			GameTooltipStatusBar:ClearAllPoints()
			GameTooltipStatusBar:SetHeight(1)
			GameTooltipStatusBar:SetPoint('LEFT', 5, 0)
			GameTooltipStatusBar:SetPoint('RIGHT', -5.5, 0)
			GameTooltipStatusBar:SetPoint('BOTTOM', tooltip, 'TOP', 0, -5)
			GameTooltipStatusBar:SetOrientation'HORIZONTAL'
			GameTooltipStatusBar:SetRotatesTexture(false)
			tooltip:SetPoint(TipPosition[1], TipPosition[2], TipPosition[3], TipPosition[4], TipPosition[5])
			--tooltip:SetScript('OnUpdate', nil)
		end
	end

	hooksecurefunc('GameTooltip_SetDefaultAnchor', SetDefaultAnchorHook)

	local SpellTooltipHook = function(self)
		local _, _, id = self:GetSpell()

		if not id then return end

		for i = 1, self:NumLines() do
			if strfind(_G["GameTooltipTextLeft"..i]:GetText(), "|cffffd100ID:|r "..id) then
				return
			end
		end

		self:AddLine(" ")
		self:AddLine("|cffffd100ID:|r "..id, 1, 1, 1)
		self:Show()
	end
	GameTooltip:HookScript("OnTooltipSetSpell", SpellTooltipHook)

	local AuraTooltipHook = function(self, unit, index, filter)
		local _, _, _, _, _, _, _, caster, _, _, id = UnitAura(unit, index, filter)

		if not id then return end

		self:AddLine(" ")

		if caster then
			local name = UnitName(caster)
			local color

			if UnitIsPlayer(caster) then
				local _, class = UnitClass(unit)
				color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
			else
				color = FACTION_BAR_COLORS[UnitReaction(caster, 'player')] and FACTION_BAR_COLORS[UnitReaction(caster, 'player')] or { r = .5, g = .5, b = .5 }
			end

			self:AddDoubleLine("|cffffd100ID:|r "..id, name, 1, 1 , 1, color.r, color.g, color.b)
		else
			self:AddLine("|cffffd100ID:|r "..id, 1, 1, 1)
		end

		self:Show()
	end
	hooksecurefunc(GameTooltip, "SetUnitAura", AuraTooltipHook)
	hooksecurefunc(GameTooltip, "SetUnitBuff", AuraTooltipHook)
	hooksecurefunc(GameTooltip, "SetUnitDebuff", AuraTooltipHook)

	local ItemTooltipHook = function(self)
		local _, link = self:GetItem()

		if not link then return end

		local total = GetItemCount(link, true)
		local _, _, id = strfind(link, "item:(%d+)")

		if id == "0" or id == nil then return end

		for i = 1, self:NumLines() do
			if strfind(_G["GameTooltipTextLeft"..i]:GetText(), "|cffffd100ID:|r "..id) then
				return
			end
		end

		self:AddLine(" ")
		self:AddDoubleLine("|cffffd100ID:|r "..id, "|cffffd100Total:|r "..total, 1, 1, 1, 1, 1, 1)
		self:Show()
	end
	GameTooltip:HookScript("OnTooltipSetItem", ItemTooltipHook)

        -- LEVEL

	local GetFormattedUnitClassification = function(unit)
		local unitClassification = UnitClassification(unit)
		if unitClassification == 'worldboss' or UnitLevel(unit) == -1 then
			return 'B'
		elseif unitClassification == 'rare' then
			return 'R'
		elseif unitClassification == 'rareelite' then
			return 'R+'
		elseif unitClassification == 'elite' then
			return '+'
		else
			return ''
		end
	end

  local GetFormattedUnitLevel = function(unit)
		local diff = GetQuestDifficultyColor(UnitLevel(unit))
		local type = GetFormattedUnitClassification(unit)
		if UnitLevel(unit) == -1 then
			return '|cffff0000??' .. type .. '|r '
		elseif UnitLevel(unit) == 0 then
			return '?' .. type .. ' '
		else
			return format('|cff%02x%02x%02x%s%s|r ', diff.r*255, diff.g*255, diff.b*255, UnitLevel(unit), type)
		end
	end

        -- CLASS
    local GetFormattedUnitClass = function(unit)
		local _, class = UnitClass(unit)
		local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		if color then
			return format('|cff%02x%02x%02x%s|r', color.r*255, color.g*255, color.b*255, UnitClass(unit))
		end
    end


        -- MOB TYPE
	local GetFormattedUnitType = function(unit)
		local creaturetype = UnitCreatureType(unit)
		if creaturetype then
			return creaturetype
		else
			return ''
		end
	end


        -- CREATE LEVEL/RACE/CLASS/TYPE STRING
	local GetFormattedLevelString = function(unit, specIcon)
		if UnitIsPlayer(unit) then
			if not UnitRace(unit) then return nil end
			return GetFormattedUnitLevel(unit)..UnitRace(unit)..' '..GetFormattedUnitClass(unit)
		else
			return GetFormattedUnitLevel(unit)..GetFormattedUnitType(unit)
		end
	end




        -- TARGET
    local GetTarget = function(unit)
		local _, class = UnitClass(unit)
        if UnitIsUnit(unit, 'player') then
            return ('|cffff0000%s|r'):format('—YOU—')
        elseif UnitIsPlayer(unit, 'player')then
            return ('|cff%s%s|r'):format(classColors[class], UnitName(unit))
        elseif UnitIsPlayer(unit, 'player') and UnitFactionGroup(unit) == 'Horde' then
            return ('|TInterface\\AddOns\\LynTooltip\\assets\\horde.tga:12:12|t'..'|cff%s%s|r'):format(classColors[class], UnitName(unit))
        elseif UnitIsPlayer(unit, 'player') and UnitFactionGroup(unit) == 'Alliance' then
            return ('|TInterface\\AddOns\\LynTooltip\\assets\\alliance.tga:12:12|t '..'|cff%s%s|r'):format(classColors[class], UnitName(unit))
        elseif UnitReaction(unit, 'player') then
            return ('|cff%s%s|r'):format(reactionColors[UnitReaction(unit, 'player')], UnitName(unit))
        else
            return ('|cffffffff%s|r'):format(UnitName(unit))
        end
    end


        -- SET-UP UNIT TOOLTIP
	local UnitTooltipHook = function(self,...)
		local unit = select(2, self:GetUnit()) or (GetMouseFocus() and GetMouseFocus():GetAttribute('unit')) or (UnitExists('mouseover') and 'mouseover')
		if not unit or (unit and type(unit) ~= 'string') then return end
		if not UnitGUID(unit) then return end

		-- colour sb bg
		local red, green, blue = GameTooltipStatusBar:GetStatusBarColor()
		GameTooltipStatusBar.bg:SetVertexColor(red*.2, green*.2, blue*.2)

		-- reaction colour
		local unitReaction = FACTION_BAR_COLORS[UnitReaction(unit, 'player')] and FACTION_BAR_COLORS[UnitReaction(unit, 'player')] or { r = .5, g = .5, b = .5 }

		-- raid icons
		local ricon = GetRaidTargetIndex(unit)
		if ricon then
			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetText(('%s %s'):format(ICON_LIST[ricon]..'14|t', text))
		end

		-- hide/show titles
		local title = UnitPVPName(unit)
		local name = UnitName(unit)
		local relationship = UnitRealmRelationship(unit)
		local faction = UnitFactionGroup(unit) == FACTION_HORDE and '|cff333333 / |r|cff852726H|r' or UnitFactionGroup(unit) == FACTION_ALLIANCE and '|cff333333 / |r|cff193FABA|r' or ''
		local flag = UnitIsAFK(unit) and '|cff333333 / |r|cff00ff00AFK|r' or UnitIsDND(unit) and '|cff333333 / |r|cff00ff00DND|r' or ''

		GameTooltipTextLeft1:SetText(name .. ((relationship == 2 or relationship == 3) and ' |cff444444#|r' or '') .. faction .. flag)


        for i = 2, GameTooltip:NumLines() do
            local line = _G['GameTooltipTextLeft'..i]
            local text = line:GetText()
            if  line then
				-- if text color goes here
                -- remove faction & pvp flag
				local t = gsub(text, '(.+)', '%1')
                if t == '' or t == PVP_ENABLED
                or t == FACTION_ALLIANCE or t == FACTION_HORDE then
        			line:SetText(nil)
        		end
            end
        end

            -- flags and reaction colours for name & hp bar
            -- + guild
        if UnitIsPlayer(unit) then
                -- hp & name class colouring
			local _, class = UnitClass(unit)
            local colour = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
            local unitName, unitRealm = UnitName(unit)

			if not colour then
				colour = { r = 1, g = 1, b = 1 }
			end

            GameTooltipStatusBar:SetStatusBarColor(colour.r, colour.g, colour.b)
            GameTooltipTextLeft1:SetTextColor(colour.r, colour.g, colour.b)
        else
                -- hp & name reaction colouring
			local reaction = UnitReaction(unit, 'player')
            if reaction then
                local colour = FACTION_BAR_COLORS[reaction] and FACTION_BAR_COLORS[reaction] or { r = .5, g = .5, b = .5 }
                if colour then
                     GameTooltipStatusBar:SetStatusBarColor(colour.r, colour.g, colour.b)
                     GameTooltipTextLeft1:SetTextColor(colour.r, colour.g, colour.b)
                end
             end

        end

            -- ghost/dead
        if UnitIsGhost(unit) then
            self:AppendText' |cffaaaaaa—GHOST—|r'
            GameTooltipTextLeft1:SetTextColor(.5, .5, .5)
        elseif UnitIsDead(unit) then
            self:AppendText' |cffaaaaaa—DEAD—|r'
            GameTooltipTextLeft1:SetTextColor(.5, .5, .5)
        end

            -- target
        if UnitExists(unit..'target') then
			GameTooltip:AddDoubleLine('|cffffd100Target:|r', GetTarget(unit..'target') or 'Unknown')
        end

        -- level
        for i = 2, GameTooltip:NumLines() do
            local line = _G['GameTooltipTextLeft'..i]
            local text = line:GetText()
            if line and text and text:find('^'..TOOLTIP_UNIT_LEVEL:gsub('%%s', '.+')) then
                _G['GameTooltipTextLeft'..i]:SetText(GetFormattedLevelString(unit, specIcon))
            end
        end

		GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
    end
    GameTooltip:HookScript('OnTooltipSetUnit', UnitTooltipHook)

	-- ON VALUE CHANGE
	local OnValueChangedHook = function(self, value)
		if not value then
			return
		end
		local min, max = self:GetMinMaxValues()
		if value < min or value > max then
			return
		end
		local _, unit  = GameTooltip:GetUnit()
		if unit then
			if UnitIsPlayer(unit) then
				local _, class = UnitClass(unit)
				local colour = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

				GameTooltipStatusBar:SetStatusBarColor(colour.r, colour.g, colour.b)
			else
                -- hp & name reaction colouring
				local reaction = UnitReaction(unit, 'player')
				if reaction then
					local colour = FACTION_BAR_COLORS[reaction]
					if colour then
						 GameTooltipStatusBar:SetStatusBarColor(colour.r, colour.g, colour.b)
					end
				 end
			end
		end
	end
	GameTooltipStatusBar:HookScript("OnValueChanged", OnValueChangedHook)

	-- Compare
	-- sadly, this hook is horrible
	local ShowCompareHook = function(self, anchorFrame)
		if ( not self ) then
			self = GameTooltip;
		end

		if( not anchorFrame ) then
			anchorFrame = self.overrideComparisonAnchorFrame or self;
		end

		if ( self.needsReset ) then
			self:ResetSecondaryCompareItem();
			GameTooltip_AdvanceSecondaryCompareItem(self);
			self.needsReset = false;
		end

		local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips);
		local primaryItemShown, secondaryItemShown = shoppingTooltip1:SetCompareItem(shoppingTooltip2, self);


		-- 1
		shoppingTooltip1:SetBackdrop(BACKDROP)
		shoppingTooltip1:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
		shoppingTooltip1:SetBackdropBorderColor(.2, .2, .2, 1)

		ShoppingTooltip1TextLeft2:SetFont(C.TOOLTIP_HEADER_FONT, 18)
		ShoppingTooltip1TextLeft2:SetShadowOffset(1, -1)
		ShoppingTooltip1TextLeft2:SetShadowColor(0, 0, 0, 1)

		ShoppingTooltip1TextLeft3:SetFont(STANDARD_TEXT_FONT, 11)
		ShoppingTooltip1TextLeft3:SetShadowOffset(1, -1)
		ShoppingTooltip1TextLeft3:SetShadowColor(0, 0, 0, 1)

		-- 2
		shoppingTooltip2:SetBackdrop(BACKDROP)
		shoppingTooltip2:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
		shoppingTooltip2:SetBackdropBorderColor(.2, .2, .2, 1)

		ShoppingTooltip2TextLeft2:SetFont(C.TOOLTIP_HEADER_FONT, 18)
		ShoppingTooltip2TextLeft2:SetShadowOffset(1, -1)
		ShoppingTooltip2TextLeft2:SetShadowColor(0, 0, 0, 1)

		ShoppingTooltip2TextLeft3:SetFont(STANDARD_TEXT_FONT, 11)
		ShoppingTooltip2TextLeft3:SetShadowOffset(1, -1)
		ShoppingTooltip2TextLeft3:SetShadowColor(0, 0, 0, 1)

		local leftPos = anchorFrame:GetLeft();
		local rightPos = anchorFrame:GetRight();

		local side;
		if ( self.overrideComparisonAnchorSide ) then
			side = self.overrideComparisonAnchorSide;
		else
			-- find correct side
			local rightDist = 0;
			if ( not rightPos ) then
				rightPos = 0;
			end
			if ( not leftPos ) then
				leftPos = 0;
			end

			rightDist = GetScreenWidth() - rightPos;

			if (leftPos and (rightDist < leftPos)) then
				side = "left";
			else
				side = "right";
			end
		end

		-- see if we should slide the tooltip
		if ( self:GetAnchorType() and self:GetAnchorType() ~= "ANCHOR_PRESERVE" ) then
			local totalWidth = 0;
			if ( primaryItemShown  ) then
				totalWidth = totalWidth + shoppingTooltip1:GetWidth();
			end
			if ( secondaryItemShown  ) then
				totalWidth = totalWidth + shoppingTooltip2:GetWidth();
			end

			if ( (side == "left") and (totalWidth > leftPos) ) then
				self:SetAnchorType(self:GetAnchorType(), (totalWidth - leftPos), 0);
			elseif ( (side == "right") and (rightPos + totalWidth) >  GetScreenWidth() ) then
				self:SetAnchorType(self:GetAnchorType(), -((rightPos + totalWidth) - GetScreenWidth()), 0);
			end
		end

		if ( secondaryItemShown ) then
			shoppingTooltip2:SetOwner(self, "ANCHOR_NONE");
			shoppingTooltip2:ClearAllPoints();
			if ( side and side == "left" ) then
				shoppingTooltip2:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -8, 0);
			else
				shoppingTooltip2:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 8, 0);
			end

			shoppingTooltip1:SetOwner(self, "ANCHOR_NONE");
			shoppingTooltip1:ClearAllPoints();

			if ( side and side == "left" ) then
				shoppingTooltip1:SetPoint("TOPRIGHT", shoppingTooltip2, "TOPLEFT", -8, 0);
			else
				shoppingTooltip1:SetPoint("TOPLEFT", shoppingTooltip2, "TOPRIGHT", 8, 0);
			end
		else
			shoppingTooltip1:SetOwner(self, "ANCHOR_NONE");
			shoppingTooltip1:ClearAllPoints();

			if ( side and side == "left" ) then
				shoppingTooltip1:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -8, 0);
			else
				shoppingTooltip1:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 8, 0);
			end

			shoppingTooltip2:Hide();
		end

		-- We have to call this again because :SetOwner clears the tooltip.
		shoppingTooltip1:SetCompareItem(shoppingTooltip2, self);
		shoppingTooltip1:Show();

	end

	hooksecurefunc('GameTooltip_ShowCompareItem', ShowCompareHook)

	hooksecurefunc(GameTooltip, "Show", function(self)
		self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
	end)

	GameTooltip:HookScript("OnUpdate", function(self, elapsed)
		self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
	end)


        -- STYLE TOOLTIP
        -- table of tooltips and menus to be modified

-- local SetStyle = function(self)
--
-- 	if not self._skinned then
-- 		if self == WorldMapTooltip then
-- 			if self.BackdropFrame then
-- 				self.BackdropFrame:SetBackdrop(BACKDROP)
-- 				self.BackdropFrame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
-- 				self.BackdropFrame:SetBackdropBorderColor(.2, .2, .2, 1)
-- 			end
-- 			self:SetBackdrop(BACKDROP)
-- 			self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
-- 			self:SetBackdropBorderColor(.2, .2, .2, 1)
-- 		else
-- 			-- self:SetClampedToScreen(true)
-- 			self:SetBackdrop(BACKDROP)
-- 			self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
-- 			self:SetBackdropBorderColor(.2, .2, .2, 1)
-- 		end
--
-- 		self._skinned = true
-- 	end
--
-- 	-- if self.BorderTop then
-- 	-- 	self.BorderTopLeft:Hide()
-- 	-- 	self.BorderTopRight:Hide()
-- 	-- 	self.BorderBottomLeft:Hide()
-- 	-- 	self.BorderBottomRight:Hide()
-- 	-- 	self.BorderTop:Hide()
-- 	-- 	self.BorderLeft:Hide()
-- 	-- 	self.BorderRight:Hide()
-- 	-- 	self.BorderBottom:Hide()
-- 	-- 	self.Background:Hide()
-- 	-- end
-- end

local tooltips = {
	GameTooltip,
	FriendsTooltip,
	WorldMapTooltip,
	ItemRefTooltip,
	SmallTextTooltip,
	ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,
	ItemRefShoppingTooltip3,
	WorldMapCompareTooltip1,
	WorldMapCompareTooltip2,
	WorldMapCompareTooltip3,

	-- Garrison Specific Tooltips
	GarrisonBonusAreaTooltip,
	GarrisonFollowerTooltip,
	GarrisonFollowerAbilityTooltip,
	GarrisonMissionMechanicTooltip,
	GarrisonMissionMechanicFollowerCounterTooltip,
	GarrisonShipyardMapMissionTooltip,
	GarrisonShipyardFollowerTooltip,
	FloatingGarrisonShipyardFollowerTooltip,
}

for i, tooltip in ipairs(tooltips) do
	if not tooltip._skinned then
		if tooltip == WorldMapTooltip then
			if tooltip.BackdropFrame then
				tooltip.BackdropFrame:SetBackdrop(BACKDROP)
				tooltip.BackdropFrame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
				tooltip.BackdropFrame:SetBackdropBorderColor(.2, .2, .2, 1)
			end
			tooltip:SetBackdrop(BACKDROP)
			tooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
			tooltip:SetBackdropBorderColor(.2, .2, .2, 1)
		else
			-- tooltip:SetClampedToScreen(true)
			tooltip:SetBackdrop(BACKDROP)
			tooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
			tooltip:SetBackdropBorderColor(.2, .2, .2, 1)
		end

		tooltip._skinned = true
	end

	tooltip:HookScript('OnShow', function(tooltip)
		tooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
		tooltip:SetBackdropBorderColor(.2, .2, .2, 1)
	end)

	tooltip:HookScript('OnHide', function(tooltip) 
		tooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
		tooltip:SetBackdropBorderColor(.2, .2, .2, 1)
	end)
end

hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
	for i = 1, UIDROPDOWNMENU_MAXLEVELS do
		local menu = _G["DropDownList"..i.."MenuBackdrop"]
		local backdrop = _G["DropDownList"..i.."Backdrop"]
		if not backdrop._skinned then
			menu:SetBackdrop(BACKDROP)
			menu:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
			menu:SetBackdropBorderColor(.2, .2, .2, 1)

			backdrop:SetBackdrop(BACKDROP)
			backdrop:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
			backdrop:SetBackdropBorderColor(.2, .2, .2, 1)

			backdrop._skinned = true
		end
	end
end)

-- only works with Lyn activated
hooksecurefunc("Lib_UIDropDownMenu_CreateFrames", function(level, index)
	for i = 1, LIB_UIDROPDOWNMENU_MAXLEVELS do
		local menu = _G["Lib_DropDownList"..i.."MenuBackdrop"]
		local backdrop = _G["Lib_DropDownList"..i.."Backdrop"]
		if not backdrop._skinned then
			menu:SetBackdrop(BACKDROP)
			menu:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
			menu:SetBackdropBorderColor(.2, .2, .2, 1)

			backdrop:SetBackdrop(BACKDROP)
			backdrop:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
			backdrop:SetBackdropBorderColor(.2, .2, .2, 1)

			backdrop._skinned = true
		end
	end
end)


local menus =    {
	ChatMenu,
	EmoteMenu,
	LanguageMenu,
	VoiceMacroMenu,
}
for i, menu in ipairs(menus) do
	menu:SetBackdrop(BACKDROP)
	menu:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
	menu:SetBackdropBorderColor(.2, .2, .2, 1)
end
