local E, F, C = unpack(select(2, ...))

local moving
hooksecurefunc(ObjectiveTrackerFrame, 'SetPoint', function(self)
	if moving then return end
	moving = true
	self:SetMovable(true)
	self:SetUserPlaced(true)
	self:ClearAllPoints()
	self:SetPoint(unpack(C.OBJECTIVE_TRACKER_POSITION))
	self:SetParent(Minimap) -- Only for default Blizzard unitframes.
	self:SetMovable(false)
	self:SetHeight(C.OBJECTIVE_TRACKER_HEIGHT)
	moving = nil
end)



hooksecurefunc('ObjectiveTracker_Update', function()
	if ObjectiveTrackerFrame.MODULES then
			for i = 1, #ObjectiveTrackerFrame.MODULES do
				local module	= ObjectiveTrackerFrame.MODULES[i]
				module.Header.Text:SetText(string.upper(module.Header.Text:GetText()))
				module.Header.Text:SetFont([[Interface\AddOns\Lyn\assets\fonts\PassionOne-Regular.ttf]], 16)
			end
		end
end)
