local _, A = ...
local cfg = A.config
local lib = A.library
local E, F, C = unpack(_G['Lyn'])
local _, class = UnitClass('player')

local CreateLayout = function(self, unit)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:RegisterForClicks('AnyUp')

	self:SetWidth(300)
	self:SetHeight(40)
	self:SetPoint('BOTTOM', UIParent, -185, 125)

	lib.CreateFrameLayout(self)
	lib.CreateFrameShadow(self)

	local health = CreateFrame("StatusBar", nil, self)
	health:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	health:SetStatusBarColor(.1, .1, .1)
	health:SetPoint('TOPLEFT', 2, -2)
	health:SetPoint('BOTTOMRIGHT', -2, 8)

	local healthbg = health:CreateTexture(nil, 'BORDER')
	healthbg:SetAllPoints()
	healthbg:SetTexture(C.STATUSBAR_TEXTURE)
	healthbg:SetVertexColor(.15, .15, .15, 1)

	health.frequentUpdates = true
	health.colorReaction = true
	health.colorClass = true
	health.Smooth = true
	health.PostUpdate = lib.PostUpdateHealth

	self.Health = health

	local absorb = CreateFrame('StatusBar', nil, health)
	absorb:SetPoint('TOP')
	absorb:SetPoint('BOTTOM')
	absorb:SetPoint('LEFT',health:GetStatusBarTexture(), 'RIGHT')
	absorb:SetWidth(health:GetWidth())
	absorb:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	absorb:SetStatusBarColor(0.6, 0.6, 0.6, 0.5)

	absorb.overlay = absorb:CreateTexture(nil, 'OVERLAY')
	absorb.overlay:SetTexture[[Interface\RaidFrame\Shield-Overlay]]
	absorb.overlay:SetPoint('TOPLEFT', absorb:GetStatusBarTexture())
	absorb.overlay:SetPoint('BOTTOMRIGHT', absorb:GetStatusBarTexture())

	absorb.overGlow = absorb:CreateTexture(nil, 'OVERLAY', 'OverAbsorbGlowTemplate')
	absorb.overGlow:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', -5, 2)
	absorb.overGlow:SetPoint('BOTTOMRIGHT', self.Health, 2, -2)
	absorb.overGlow:SetBlendMode'ADD'
	absorb.overGlow:Hide()

	local mybar = CreateFrame('StatusBar', nil, health)
	mybar:SetPoint('TOP')
	mybar:SetPoint('BOTTOM')
	mybar:SetPoint('LEFT',health:GetStatusBarTexture(), 'RIGHT')
	mybar:SetWidth(health:GetWidth())
	mybar:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	mybar:SetStatusBarColor(12/255, 217/255, 21/255, .5)

	local otherbar = CreateFrame('StatusBar', nil, health)
	otherbar:SetPoint('TOP')
	otherbar:SetPoint('BOTTOM')
	otherbar:SetPoint('LEFT',health:GetStatusBarTexture(), 'RIGHT')
	otherbar:SetWidth(health:GetWidth())
	otherbar:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	otherbar:SetStatusBarColor(12/255, 217/255, 21/255, .5)

	local healabsorb = CreateFrame('StatusBar', nil, health)
	healabsorb:SetPoint('TOP')
	healabsorb:SetPoint('BOTTOM')
	healabsorb:SetPoint('LEFT',health:GetStatusBarTexture(), 'RIGHT')
	healabsorb:SetWidth(health:GetWidth())
	healabsorb:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	healabsorb:SetStatusBarColor(200/255, 72/255, 59/255)

	self.HealPrediction = {
		absorbBar = absorb,
		myBar = mybar,
		otherBar = otherbar,
		healAbsorbBar = healabsorb,
		maxOverflow = 1.05,
		frequentUpdates = true,
	}

	self.HealPrediction.PostUpdate = lib.HealPredictionPostUpdate
	self:RegisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', lib.HealPredictionPostUpdate)
	table.insert(self.__elements, lib.HealPredictionPostUpdate)

	local power = CreateFrame("StatusBar", nil, self)
	power:SetPoint('BOTTOMLEFT', 2, 2)
	power:SetPoint('TOPRIGHT', -2, -33)
	power:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	power:SetStatusBarColor(.1, .1, .1)

	local powerbg = power:CreateTexture(nil, 'BORDER')
	powerbg:SetAllPoints()
	powerbg:SetTexture(C.STATUSBAR_TEXTURE)
	powerbg:SetVertexColor(.15, .15, .15, 1)

	local predict = CreateFrame('StatusBar', nil, power)
	predict:SetPoint('TOP')
	predict:SetPoint('BOTTOM')
	predict:SetPoint('RIGHT', power:GetStatusBarTexture())
	predict:SetWidth(power:GetWidth())
	predict:SetFrameLevel(power:GetFrameLevel() + 1)
	predict:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	predict:SetStatusBarColor(1, 0, 0)
	predict:SetReverseFill(true)

	self.PowerPrediction = {
		mainBar = predict
	}

	power.colorPower = true
	power.altPowerColor = true
	power.frequentUpdates = true
	power.Smooth = true
	power.PostUpdate = lib.PostUpdatePower

	self.Power = power

	local pvp = self:CreateFontString(nil, "OVERLAY")
	pvp:SetPoint('TOP', self, 'BOTTOM', 0, -5)
	pvp:SetPoint('LEFT', 0, 0)
	pvp:SetJustifyH('LEFT')
	pvp:SetHeight(10)
	pvp:SetFont(cfg.FONT_BIG, 12, 'OUTLINE')
	pvp:SetShadowOffset(1, -1)
	pvp:SetShadowColor(0, 0, 0, 1)
	pvp:SetTextColor(1, 1, 1)
	self:Tag(pvp, '[lyn:pvp]')

	local resting = CreateFrame('Frame', nil, self)
	resting:SetFrameLevel(power:GetFrameLevel()+1)
	resting:SetPoint('LEFT', pvp, 'RIGHT', 0, 1)
	resting:SetHeight(10)

	resting.text = resting:CreateFontString(nil, "OVERLAY")
	resting.text:SetFont(cfg.FONT_BIG, 12, 'OUTLINE')
	resting.text:SetTextColor(1, 1, 1)
	resting.text:SetShadowOffset(1, -1)
	resting.text:SetShadowColor(0, 0, 0, 1)
	resting.text:SetJustifyH('LEFT')
	resting.text:SetPoint('LEFT', 0, -1)
	resting.text:SetText('|cff5F9BFFRESTING|r')
	resting:SetWidth(resting.text:GetStringWidth())
	self.Resting = resting

	local overlay = CreateFrame('Frame', nil, health)
	overlay:SetAllPoints(health)
	overlay:SetFrameLevel(health:GetFrameLevel() + 5)

	local hp = overlay:CreateFontString(nil, "OVERLAY")
	hp:SetPoint('RIGHT', overlay, -7, -.5)
	hp:SetShadowColor(0, 0, 0, 1)
	hp:SetTextColor(1, 1, 1)
	hp:SetShadowOffset(1, -1)
	hp:SetJustifyH('RIGHT')
	hp:SetFont(cfg.FONT_BIG, 22, 'OUTLINE')
	hp:SetTextColor(1, 1, 1)
	self:Tag(hp, '[lyn:hpp]')

	local hpv = overlay:CreateFontString(nil, "OVERLAY")
	hpv:SetPoint('RIGHT', hp, 'LEFT', -5, 1)
	hpv:SetJustifyH('RIGHT')
	hpv:SetFont(cfg.FONT_BIG, 10, 'OUTLINE')
	hpv:SetShadowOffset(1, -1)
	hpv:SetShadowColor(0, 0, 0, 1)
	hpv:SetTextColor(.8, .8, .8)
	self:Tag(hpv, '[lyn:hps]')

	-- local pp = overlay:CreateFontString(nil, "OVERLAY")
	-- pp:SetPoint('LEFT', overlay, 7, -.5)
	-- pp:SetShadowColor(0, 0, 0, 1)
	-- pp:SetTextColor(1, 1, 1)
	-- pp:SetShadowOffset(1, -1)
	-- pp:SetJustifyH('LEFT')
	-- pp:SetFont(cfg.FONT_BIG, 22, 'OUTLINE')
	-- pp:SetTextColor(1, 1, 1)
	-- self:Tag(pp, '[lyn:power]')

	local marker = overlay:CreateTexture(nil, 'OVERLAY')
	marker:SetSize(32, 32)
	marker:SetPoint('TOP', overlay, 'BOTTOM', 0, 15)
	self.RaidIcon = marker

	local leader = overlay:CreateTexture(nil, "OVERLAY")
	leader:SetSize(13, 13)
	leader:SetTexture([[Interface\AddOns\oUF_Lyn\assets\commander.tga]])
	leader:SetPoint("BOTTOM", overlay, "TOP", 0, -5)
	leader:SetPoint("RIGHT", -6, 0)
	self.Leader = leader

	local lines = 1
	if class == 'ROGUE' or class == 'MONK' or class == 'DEATHKNIGHT' then
		lines = 2
	end
	local auras = lib.CreateAura(self, 10, lines, 32)
	auras:SetPoint('BOTTOM', self, 'TOP', 0, 6)
	auras:SetPoint('RIGHT', -1, 0)
	auras["growth-x"] = 'LEFT'
	auras["growth-y"] = 'UP'
	auras.initialAnchor = "BOTTOMRIGHT"
	auras.showDebuffType = true
	auras.CustomFilter = lib.PlayerCustomFilter
	auras.PostUpdateIcon = lib.PostUpdateIcon
	self.Auras = auras

	local ClassIcons = {}
	ClassIcons.UpdateTexture = lib.UpdateClassIconTexture
	ClassIcons.PostUpdate = lib.PostUpdateClassIcon

	for index = 1, 8 do
		local ClassIcon = CreateFrame('Frame', nil, self)
		ClassIcon:SetSize(16, 16)
		lib.CreateFrameLayout(ClassIcon, -1)

		Texture = ClassIcon:CreateTexture(nil, 'BORDER')
		Texture:SetAllPoints(ClassIcon)
		Texture:SetTexture(C.STATUSBAR_TEXTURE)
		ClassIcon.Texture = Texture

		if index > 1 then
			ClassIcon:SetPoint('LEFT', ClassIcons[index - 1], 'RIGHT', 7, 0)
		else
			ClassIcon:SetPoint('LEFT', self, 1, 34)
		end

		ClassIcons[index] = ClassIcon
	end

	self.ClassIcons = ClassIcons

	if(class == 'DEATHKNIGHT') then
		local Runes = {}
		for index = 1, 6 do
			local Rune = CreateFrame('StatusBar', nil, self)
			Rune:SetSize(16, 16)
			Rune:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
			Rune:SetStatusBarColor(151/255, 220/225, 235/255)
			lib.CreateFrameLayout(Rune, -1)

			if(index > 1) then
				Rune:SetPoint('LEFT', Runes[index - 1], 'RIGHT', 7, 0)
			else
				Rune:SetPoint('LEFT', self, 1, 34)
			end

			Runes[index] = Rune
		end
		self.Runes = Runes
	end

	lib.CreateCastbar(self, 'player')
end

oUF:RegisterStyle('oUF_LynPlayer', CreateLayout)
oUF:SetActiveStyle('oUF_LynPlayer')
oUF:Spawn('player','oUF_LynPlayer')
