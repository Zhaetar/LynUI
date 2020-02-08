local _, A = ...
local cfg = A.config
local lib = A.library
local E, F, C = unpack(_G['Lyn'])

local CreateLayout = function(self, unit)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:RegisterForClicks('AnyUp')

	self:SetWidth(160)
	self:SetHeight(20)

	lib.CreateFrameLayout(self, -1)
	lib.CreateFrameShadow(self)

	local health = CreateFrame("StatusBar", nil, self)
	health:SetAllPoints(self)
	health:SetStatusBarTexture(C.STATUSBAR_TEXTURE)
	health:SetStatusBarColor(.1, .1, .1)

	local healthbg = health:CreateTexture(nil, 'BORDER')
	healthbg:SetAllPoints()
	healthbg:SetTexture(C.STATUSBAR_TEXTURE)
	healthbg:SetVertexColor(.15, .15, .15, 1)

	health.frequentUpdates = true
	health.colorTapping = true
	health.colorClass = true
	health.colorReaction = true
	health.Smooth = true
	health.PostUpdate = lib.PostUpdateHealth

	self.Health = health

	local overlay = CreateFrame('Frame', nil, self)
	overlay:SetAllPoints(self)
	overlay:SetFrameLevel(self:GetFrameLevel() + 5)

	local portrait = CreateFrame('PlayerModel', nil, overlay)
	portrait:SetSize(42, 42)
	portrait:SetPoint('BOTTOMLEFT', overlay, 1.5, 1.5)
	self.Portrait = portrait

	local marker = overlay:CreateTexture(nil, 'OVERLAY')
	marker:SetSize(18, 18)
	marker:SetPoint('TOP', 0, 10)
	self.RaidIcon = marker

	local leader = overlay:CreateTexture(nil, "OVERLAY")
	leader:SetSize(12, 12)
	leader:SetTexture([[Interface\AddOns\oUF_Lyn\assets\commander.tga]])
	leader:SetPoint("BOTTOM", overlay, "TOP", 0, -5)
	leader:SetPoint("RIGHT", -6, 0)
	self.Leader = leader

	local role = portrait:CreateTexture(nil, 'OVERLAY')
	role:SetSize(16, 16)
	role:SetPoint('LEFT', -8.5, -12.5)
	self.LFDRole = role

	local pvp = overlay:CreateFontString(nil, "OVERLAY")
	pvp:SetPoint('BOTTOM', overlay, 'TOP', 0, 5)
	pvp:SetPoint('RIGHT', 0, 0)
	pvp:SetJustifyH('RIGHT')
	pvp:SetFont(cfg.FONT_BIG, 10)
	pvp:SetShadowOffset(1, -1)
	pvp:SetShadowColor(0, 0, 0, 1)
	pvp:SetTextColor(1, 1, 1)
	self:Tag(pvp, '[lyn:pvp]')

	local hp = overlay:CreateFontString(nil, "OVERLAY")
	hp:SetPoint('RIGHT', health, -2, 0)
	hp:SetShadowColor(0, 0, 0, 1)
	hp:SetTextColor(1, 1, 1)
	hp:SetShadowOffset(1, -1)
	hp:SetJustifyH('RIGHT')
	hp:SetFont(cfg.FONT_BIG, 16, 'OUTLINE')
	hp:SetTextColor(1, 1, 1)
	self:Tag(hp, '[lyn:hpp]')

	local hpv = overlay:CreateFontString(nil, "OVERLAY")
	hpv:SetPoint('RIGHT', hp, 'LEFT', 0, 0)
	hpv:SetJustifyH('RIGHT')
	hpv:SetFont(cfg.FONT_BIG, 12, 'OUTLINE')
	hpv:SetShadowOffset(1, -1)
	hpv:SetShadowColor(0, 0, 0, 1)
	hpv:SetTextColor(.8, .8, .8)
	self:Tag(hpv, '[lyn:hps]')

	local name = overlay:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH('LEFT')
	name:SetShadowColor(0, 0, 0, 1)
	name:SetTextColor(1, 1, 1)
	name:SetShadowOffset(1, -1)
	name:SetFont(cfg.FONT_BIG, 13, 'OUTLINE')
	name:SetPoint('BOTTOM', overlay, 'TOP', 0, 4)
	name:SetPoint('LEFT', 40, 0)

	self.Name = name
	self:Tag(self.Name, '[lyn:name]')

	local debuffs = lib.CreateAura(self, 4, 1, 18)
	debuffs:SetPoint("RIGHT", self, "LEFT", -9, -4)
	debuffs['growth-x'] = 'LEFT'
	debuffs.initialAnchor = "TOPRIGHT"
	debuffs.showDebuffType = true
	debuffs.onlyShowPlayer = true
	debuffs.PostUpdateIcon = lib.PostUpdateIcon
	self.Debuffs = debuffs

	self.Range = {
		insideAlpha = 1,
		outsideAlpha = .5,
	}

end

for n=1, MAX_BOSS_FRAMES or 5 do
	oUF:RegisterStyle('oUF_LynBoss' .. n, CreateLayout)
	oUF:SetActiveStyle('oUF_LynBoss' .. n)
	local object = oUF:Spawn('boss' .. n, 'oUF_LynBoss' .. n)
	object:SetPoint('TOPRIGHT', UIParent, -325, -300 - ((20 + 30) * n))
end

SlashCmdList["TESTBOSS"] = function()
	oUF_LynBoss1.unit = "player" oUF_LynBoss1:Show(); oUF_LynBoss1.Hide = function() end
	oUF_LynBoss2.unit = "player" oUF_LynBoss2:Show(); oUF_LynBoss2.Hide = function() end
	oUF_LynBoss3.unit = "player" oUF_LynBoss3:Show(); oUF_LynBoss3.Hide = function() end
	oUF_LynBoss4.unit = "player" oUF_LynBoss4:Show(); oUF_LynBoss4.Hide = function() end
	oUF_LynBoss5.unit = "player" oUF_LynBoss5:Show(); oUF_LynBoss5.Hide = function() end
end
SLASH_TESTBOSS1 = "/tb"
