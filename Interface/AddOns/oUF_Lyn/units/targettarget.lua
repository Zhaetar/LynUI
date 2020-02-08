local _, A = ...
local cfg = A.config
local lib = A.library
local E, F, C = unpack(_G['Lyn'])


local CreateLayout = function(self, unit)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:RegisterForClicks('AnyUp')

	self:SetWidth(180)
	self:SetHeight(12)
	self:SetPoint('BOTTOM', oUF_LynTarget, 'TOP', 0, -7)
	self:SetFrameLevel(oUF_LynTarget:GetFrameLevel() + 5)

	-- name
	local name = self:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH('CENTER')
	name:SetTextColor(1, 1, 1)
	name:SetShadowOffset(1, -1)
	name:SetShadowColor(0, 0, 0, 1)
	name:SetFont(cfg.FONT_BIG, 12, 'OUTLINE')
	name:SetPoint("CENTER", self, 0, 0)
	name:SetWidth(self:GetWidth())

	self.Name = name
	self:Tag(self.Name, '[lyn:color][lyn:name]')
end

oUF:RegisterStyle('oUF_LynTargettarget', CreateLayout)
oUF:SetActiveStyle('oUF_LynTargettarget')
oUF:Spawn('targettarget','oUF_LynTargettarget')
