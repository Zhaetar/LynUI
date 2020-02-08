local _, A = ...
local cfg = A.config
local lib = CreateFrame'Frame'
A.library = lib

local E, F, C = unpack(_G['Lyn'])

local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60
local bnot, band = bit.bnot, bit.band

lib.CreateFrameLayout = function(frame, inset)
		frame:SetBackdrop({
			bgFile = C.PLAIN_TEXTURE, tiled = false,
			insets = {left = 1, top = 1, right = 1, bottom = 1}
		})
		frame:SetBackdropColor(0, 0, 0, 1)

		local Border = CreateFrame('Frame', nil, frame)
		Border:SetAllPoints()
		Border:SetFrameLevel(4)
		F:CreateBorder(Border, inset or 0)
		Border:SetBorderColor(unpack(C.BORDER_COLOR_DARK))

		frame.Border = Border
end

lib.CreateFrameShadow = function(frame, inset)
	local offset = inset or 13
	local Shadow = CreateFrame('Frame', nil, frame)
	Shadow:SetSize(frame:GetWidth() + offset, frame:GetHeight() + offset)
	Shadow:SetPoint('CENTER', frame)
	Shadow:SetBackdrop({
		edgeFile = [[Interface\AddOns\Lyn\assets\shadow.tga]],
		edgeSize = 10, tiled = false,
		insets = {left = 0, top = 0, right = 0, bottom = 0}
	})
	Shadow:SetBackdropBorderColor(0, 0, 0, .8)
	Shadow:SetFrameLevel(0)
	Shadow:SetFrameStrata('BACKGROUND')
	frame.Shadow = Shadow
end

lib.CreateRessourceLayout = function(self, alpha, inset)
	local offset = inset or 0
	local f = self:CreateTexture(nil, "BACKGROUND")
	f:SetColorTexture(0, 0, 0, alpha or 1)
	f:SetPoint('TOPLEFT', self, -offset, offset)
	f:SetPoint('BOTTOMRIGHT', self, offset, -offset)
end

lib.HealPredictionPostUpdate = function(self, _, unit)
	if self.unit ~= unit then return end
	local myIncomingHeal		= UnitGetIncomingHeals(unit, 'player') or 0
	local IncomingHeal		= UnitGetIncomingHeals(unit) or 0
	local totalAbsorb 		= UnitGetTotalAbsorbs(unit) or 0
	local CurrentHealAbsorb	= UnitGetTotalHealAbsorbs(unit) or 0
	local v, max 				= UnitHealth(unit), UnitHealthMax(unit)
	local Glow					= self.HealPrediction.absorbBar.overGlow
	local showGlow 			= false

	if (v - CurrentHealAbsorb + IncomingHeal + totalAbsorb >= max or v + totalAbsorb >= max) then
		if totalAbsorb > 0 then
			showGlow = true
		else
			showGlow = false
		end
	end

	if  Glow then
		if showGlow then
			Glow:Show()
		else
			Glow:Hide()
		end
	end
end

lib.PostUpdateHealth = function(health, unit, min, max)
	if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
		health:SetValue(0)
	end

	local percent = math.floor((min / max) * 100+0.5)
	if unit ~= 'target' and ((unit == 'player' or unit:sub(1, 5) == 'party') and percent < 75) then
		local r, g, b = oUF.ColorGradient(min, max, 1,0,0, 1,1,0, 0,1,0)
		health:SetStatusBarColor(r, g, b)
	end
end

lib.PostUpdatePower = function(power, unit, min, max)
	local parent = power:GetParent()
	if(
		min == 0 or max == 0 or not UnitIsConnected(unit) or
		UnitIsDead(unit) or UnitIsGhost(unit) or unit:sub(1, 4) == 'boss'
	) then
		power:Hide()
		power:SetBackdropColor(0, 0, 0, 0)
		parent.Health:ClearAllPoints()
		parent.Health:SetPoint('TOPLEFT', parent, 2, -2)
		parent.Health:SetPoint('BOTTOMRIGHT', parent, -2, 2)
	else
		power:Show()
		power:SetBackdropColor(0, 0, 0, 1)
		parent.Health:ClearAllPoints()
		parent.Health:SetPoint('TOPLEFT', parent, 2, -2)
		parent.Health:SetPoint('BOTTOMRIGHT', parent, -2, 8)
	end
end

local IsPlayer = { player = true, pet = true, vehicle = true }

lib.PlayerCustomFilter = function(self, unit, iconFrame, name, rank, icon, count, debuffType, duration, expirationTime, caster, canStealOrPurge, _, spellID, canApplyAura, isBossAura, casterIsPlayer, nameplateShowAll, timeMod)
	if cfg.PLAYER_AURA_FILTER[spellID] then
		 return true
	 end
	return false
end

local ProxyOverlay = function(overlay, ...)
	local r, g, b  = ...
	overlay:GetParent():SetBorderColor(r, g, b, 1)
end

local HideOverlay = function(overlay)
	overlay:GetParent():SetBorderColor(unpack(C.BORDER_COLOR_DARK))
end

local PostCreateIcon = function(Auras, button)
	local count = button.count
	count:ClearAllPoints()
	count:SetFont(cfg.FONT_BIG, 12, 'OUTLINE')
	count:SetPoint('BOTTOMRIGHT', button, -1, 1)

	button.icon:SetTexCoord(.07, .93, .07, .93)

	F:CreateBorder(button, -1)
	button:SetBorderColor(unpack(C.BORDER_COLOR_DARK))

	button.duration = button:CreateFontString(nil, 'OVERLAY')
	button.duration:SetPoint('TOP', button, 0, -2)
	button.duration:SetFont(cfg.FONT_BIG, 14, 'OUTLINE')
	button.duration:SetTextColor(1, 0.82, 0)
	button.duration:SetShadowOffset(1, -1)
	button.duration:SetShadowColor(0, 0, 0, 1)
	button.duration:SetJustifyH('CENTER')

	local overlay = button.overlay
	overlay.SetVertexColor = ProxyOverlay
	overlay:Hide()
	overlay.Show = overlay.Hide
	overlay.Hide = HideOverlay
end

lib.CreateAura = function(self, num, rows, size)
	local Auras = CreateFrame('Frame', nil, self)

	Auras:SetSize((num * (size + 6))/rows, (size + 6) * rows)
	Auras.num 		= num
	Auras.size		= size
	Auras.spacing	= 6

	Auras.disableCooldown	= true
	Auras.PostCreateIcon		= PostCreateIcon

	return Auras
end

local AuraTimer_OnUpdate = function(icon, elapsed)
	if icon.timeLeft then
		icon.timeLeft = math.max(icon.timeLeft - elapsed, 0)

		if icon.timeLeft > 0 and icon.timeLeft < 60 then
			icon.duration:SetFormattedText(F:FormatTime(icon.timeLeft))

			if (icon.timeLeft < 6) then
				icon.duration:SetTextColor(0.69, 0.31, 0.31)
			else
				icon.duration:SetTextColor(1, 0.82, 0)
			end

		else
			icon.duration:SetText()
		end
	end
end

lib.PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
	local name, _, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

	if duration and duration > 0 then
		icon.timeLeft = expirationTime - GetTime()
	else
		icon.timeLeft = math.huge
	end

	if icon.isDebuff and unit == 'target' and cfg.SHOW_ONLY_PLAYER_DEBUFFS == false then
		if icon.isPlayer then
			icon.icon:SetDesaturated(false)
			icon.count:SetAlpha(1)
		else
			icon:SetBorderColor(unpack(C.BORDER_COLOR_DARK))
			icon.icon:SetDesaturated(true)
			icon.timeLeft = math.huge
			icon.count:SetAlpha(0)
		end
	end

	icon:SetScript('OnUpdate', function(self, elapsed)
		AuraTimer_OnUpdate(self, elapsed)
	end)
end

lib.PostUpdateClassIcon = function(element, cur, max, diff, event)
	if(diff or event == 'ClassPowerEnable') then
		element:UpdateTexture()
	end
end

lib.UpdateClassIconTexture = function(element)
	local r, g, b
	if(playerClass == 'MONK') then
		r, g, b = 0, 4/5, 3/5
	elseif(playerClass == 'WARLOCK') then
		r, g, b = 2/3, 1/3, 2/3
	elseif(playerClass == 'PRIEST') then
		r, g, b = 2/3, 1/4, 2/3
	elseif(playerClass == 'PALADIN') then
		r, g, b = 1, 1, 2/5
	elseif(playerClass == 'MAGE') then
		r, g, b = 5/6, 1/2, 5/6
	else
		r, g, b = 1, 186/255, 0
	end

	for index = 1, 8 do
		local ClassIcon = element[index]
		ClassIcon.Texture:SetVertexColor(r, g, b)
	end
end


local CastbarCheckShield = function(self, unit)
	local color
	if self.interrupt and UnitCanAttack("player", unit) then
		color = { r = .4, g = .4, b = .4 }
	elseif unit == 'player' and playerClass == 'PRIEST' then
		color = { r = 252/255, g = 100/255, b = 74/255 }
	elseif unit ~= 'target' then
		color = { r = 1, g = 1, b = 1 }
	else
		color = { r = 12/255, g = 211/255, b = 99/255 }
	end
	self:SetStatusBarColor(color.r, color.g, color.b, 1)
end

local CastbarCheckCast = function(bar, unit, name, rank, castid)
	CastbarCheckShield(bar, unit)
	if bar.Text and bar.Text:GetText() then
		bar.Text:SetText(string.upper(bar.Text:GetText()))
	end
end

local CastbarCheckChannel = function(bar, unit, name, rank)
	CastbarCheckShield(bar, unit)
	if bar.Text then
		bar.Text:SetText(string.upper(bar.Text:GetText()))
	end
end

local CastbarCustomTimeText = function(self, duration)
	self.Time:SetFormattedText("%.1f", self.max - duration)
end

lib.CreateCastbar = function(self, unit)
	local castbar = CreateFrame('StatusBar', 'oUF_LynCastbar' .. unit, self)

	if unit == 'target' then
		local height = 24

		castbar:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
		castbar:SetHeight(height)
		castbar:SetWidth(300)
		castbar:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 350)

		lib.CreateFrameLayout(castbar, -1)

		local spark = castbar:CreateTexture(nil, 'OVERLAY')
		spark:SetBlendMode('ADD')
		spark:SetSize(height * 1.2, height * 2)
		castbar.Spark = spark

		local text = castbar:CreateFontString(nil, "OVERLAY")
		text:SetFont(cfg.FONT_BIG, 12)
		text:SetShadowColor(0,0,0,0.8)
		text:SetShadowOffset(1, -1)
		text:SetPoint('LEFT', castbar, 'LEFT', 5, 0)
		text:SetJustifyH('LEFT')
		castbar.Text = text

		local ctime = castbar:CreateFontString(nil, "OVERLAY")
		ctime:SetFont(cfg.FONT_BIG, 12)
		ctime:SetShadowColor(0,0,0,0.8)
		ctime:SetShadowOffset(1, -1)
		ctime:SetPoint('RIGHT', castbar, 'RIGHT', -5, 0)
		ctime:SetJustifyH('RIGHT')
		castbar.Time = ctime
	elseif unit == 'player' then
		castbar:SetStatusBarTexture(C.STATUSBAR_TEXTURE_STRIPED)
		castbar:SetAllPoints(self.Health)
		castbar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
		castbar:SetAlpha(1)

		local spark = castbar:CreateTexture(nil,'OVERLAY')
		spark:SetBlendMode('ADD')
		spark:SetSize(24, castbar:GetHeight() * 2)
		castbar.Spark = spark

		local text = castbar:CreateFontString(nil, "OVERLAY")
		text:SetFont(cfg.FONT_BIG, 12, 'OUTLINE')
		text:SetShadowColor(0,0,0,1)
		text:SetShadowOffset(1, -1)
		text:SetPoint('TOP', self, 'BOTTOM', 0, -4)
		text:SetPoint('RIGHT', 0, 0)
		text:SetJustifyH('RIGHT')
		castbar.Text = text
	elseif unit == 'focus' then
		castbar:SetStatusBarTexture(C.STATUSBAR_TEXTURE_STRIPED)
		castbar:SetAllPoints(self.Health)
		castbar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
		castbar:SetAlpha(1)
	end

	self.Castbar = castbar

	self.Castbar.CustomTimeText = CastbarCustomTimeText
	self.Castbar.PostCastStart = CastbarCheckCast
	self.Castbar.PostChannelStart = CastbarCheckChannel
end
