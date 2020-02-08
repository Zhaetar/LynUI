local _, A = ...
local cfg = A.config
local lib = A.library
local E, F, C = unpack(_G['Lyn'])

local CreateLayout = function(self, unit)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:RegisterForClicks('AnyUp')

	self:SetWidth(140)
	self:SetHeight(26)
	self:SetPoint('BOTTOMLEFT', UIParent, 50, 525)

	lib.CreateFrameLayout(self, -1)
	lib.CreateFrameShadow(self)

	local health = CreateFrame("StatusBar", nil, self)
	health:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	health:SetStatusBarColor(.1, .1, .1)
	health:SetAllPoints(self)

	local healthbg = health:CreateTexture(nil, 'BORDER')
	healthbg:SetAllPoints()
	healthbg:SetTexture(C.STATUSBAR_TEXTURE)
	healthbg:SetVertexColor(.15, .15, .15, 1)

	health.frequentUpdates = true
	health.colorTapping = true
	health.colorClass = true
	health.Smooth = true
	health.colorReaction = true
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

	local overlay = CreateFrame('Frame', nil, self)
	overlay:SetAllPoints(health)
	overlay:SetSize(32, 32)
	overlay:SetFrameLevel(health:GetFrameLevel() + 3)

	local hp = overlay:CreateFontString(nil, "OVERLAY")
	hp:SetFont(cfg.FONT_BIG, 13, 'OUTLINE')
	hp:SetShadowOffset(1, -1)
	hp:ClearAllPoints()
	hp:SetPoint("RIGHT", overlay, -7, 0)
	self:Tag(hp, '[lyn:hpp]')
	health.value = hp

	local name = overlay:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH('LEFT')
	name:SetShadowColor(0, 0, 0, 1)
	name:SetTextColor(1, 1, 1)
	name:SetShadowOffset(1, -1)
	name:SetFont(cfg.FONT_BIG, 13, 'OUTLINE')
	name:SetPoint("LEFT", overlay, 7, 0)
	name:SetWidth(360)

	self.Name = name
	self:Tag(self.Name, '[lyn:name]')

	local marker = overlay:CreateTexture(nil, 'OVERLAY')
	marker:SetSize(24, 24)
	marker:SetPoint('TOP', 0, 11)
	self.RaidIcon = marker

	local buffs = lib.CreateAura(self, 5, 1, 22)
	buffs:SetPoint("TOP", self, "BOTTOM", 0, -9)
	buffs:SetPoint('LEFT', 0, 0)
	buffs.initialAnchor = "TOPLEFT"
	buffs["growth-x"] = 'RIGHT'
	buffs["growth-y"] = 'DOWN'

	buffs.PostUpdateIcon = lib.PostUpdateIcon
	self.Buffs = buffs

	local debuffs = lib.CreateAura(self, 5, 1, 22)
	debuffs:SetPoint('BOTTOM', self, 'TOP', 0, 9)
	debuffs:SetPoint('LEFT', 0, 0)
	debuffs.showDebuffType = true
	debuffs.onlyShowPlayer = true
	debuffs.initialAnchor = 'BOTTOMLEFT'
	debuffs["growth-x"] = 'RIGHT'

	debuffs.PostUpdateIcon = lib.PostUpdateIcon
	self.Debuffs = debuffs

	lib.CreateCastbar(self, 'focus')
end

oUF:RegisterStyle('oUF_LynFocus', CreateLayout)
oUF:SetActiveStyle('oUF_LynFocus')
oUF:Spawn('focus','oUF_LynFocus')
