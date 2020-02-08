local _, A = ...
local cfg = A.config
local lib = A.library
local E, F, C = unpack(_G['Lyn'])

local CreateLayout = function(self, unit)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:RegisterForClicks('AnyUp')

	self:SetWidth(342)
	self:SetHeight(40)
	self:SetPoint('BOTTOM', UIParent, 187, 125)

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
	health.colorTapping = true
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
	hpv:SetFont(cfg.FONT_SMALL_BOLD, 10, 'OUTLINE')
	hpv:SetShadowOffset(1, -1)
	hpv:SetShadowColor(0, 0, 0, 1)
	hpv:SetTextColor(.8, .8, .8)
	self:Tag(hpv, '[lyn:hps]')

	local name = overlay:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH('LEFT')
	name:SetShadowColor(0, 0, 0, 1)
	name:SetTextColor(1, 1, 1)
	name:SetShadowOffset(1, -1)
	name:SetFont(cfg.FONT_BIG, 18, 'OUTLINE')
	name:SetPoint("LEFT", health, 7, -.5)
	name:SetWidth(260)
	self.Name = name
	self:Tag(self.Name, '[lyn:name]')

	local classification = overlay:CreateFontString(nil, "OVERLAY")
	classification:SetPoint('BOTTOM', overlay, 'TOP', 0, -4)
	classification:SetPoint('RIGHT', -6, 0)
	classification:SetJustifyH('RIGHT')
	classification:SetFont(cfg.FONT_BIG, 12, 'OUTLINE')
	classification:SetShadowOffset(1, -1)
	classification:SetShadowColor(0, 0, 0, 1)
	classification:SetTextColor(1, 1, 1)
	classification:SetHeight(10)
	self:Tag(classification, '[lyn:classification]')

	local quest = overlay:CreateFontString(nil, "OVERLAY")
	quest:SetFont(cfg.FONT_BIG, 12, 'OUTLINE')
	quest:SetShadowColor(0,0,0,1)
	quest:SetShadowOffset(1,-1)
	quest:SetJustifyH('RIGHT')
	quest:SetPoint('RIGHT', classification, 'LEFT', -1, 0)
	quest:SetText('|cffffe400QUEST|r')
	self.QuestIcon = quest

	local pvp = overlay:CreateFontString(nil, "OVERLAY")
	pvp:SetPoint('BOTTOM', overlay, 'TOP', 0, -4)
	pvp:SetPoint('LEFT', 6, 0)
	pvp:SetJustifyH('LEFT')
	pvp:SetHeight(10)
	pvp:SetFont(cfg.FONT_BIG, 12, 'OUTLINE')
	pvp:SetShadowOffset(1, -1)
	pvp:SetShadowColor(0, 0, 0, 1)
	pvp:SetTextColor(1, 1, 1)
	self:Tag(pvp, '[lyn:pvp]')

	local marker = overlay:CreateTexture(nil, 'OVERLAY')
	marker:SetSize(32, 32)
	marker:SetPoint('TOP', overlay, 'BOTTOM', 0, 15)
	self.RaidIcon = marker

	local buffs = lib.CreateAura(self, 12, 1, 22)
	buffs:SetPoint("TOP", self, "BOTTOM", 0, -6)
	buffs:SetPoint('LEFT', 1, 0)
	buffs.initialAnchor = "TOPLEFT"
	buffs["growth-x"] = 'RIGHT'
	buffs["growth-y"] = 'DOWN'

	buffs.PostUpdateIcon = lib.PostUpdateIcon
	self.Buffs = buffs

	local debuffs = lib.CreateAura(self, 27, 3, 32)
	debuffs:SetPoint('BOTTOM', self, 'TOP', 0, 6)
	debuffs:SetPoint('LEFT', 1, 0)
	debuffs.showDebuffType = true
	debuffs.onlyShowPlayer = cfg.SHOW_ONLY_PLAYER_DEBUFFS
	debuffs.showStealableBuffs = true
	debuffs.initialAnchor = 'BOTTOMLEFT'
	debuffs["growth-x"] = 'RIGHT'

	debuffs.PostUpdateIcon = lib.PostUpdateIcon
	self.Debuffs = debuffs

	lib.CreateCastbar(self, 'target')
end

oUF:RegisterStyle('oUF_LynTarget', CreateLayout)
oUF:SetActiveStyle('oUF_LynTarget')
oUF:Spawn('target','oUF_LynTarget')
