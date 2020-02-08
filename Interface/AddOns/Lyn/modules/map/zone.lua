-- zone text
local function GetZoneColor()
	local zoneType = GetZonePVPInfo()
	if (zoneType == 'sanctuary') then
		return 0.4, 0.8, 0.94
	elseif (zoneType == 'arena') then
		return 1, 0.1, 0.1
	elseif (zoneType == 'friendly') then
		return 0.1, 1, 0.1
	elseif (zoneType == 'hostile') then
		return 1, 0.1, 0.1
	elseif (zoneType == 'contested' or zoneType == 'combat') then
		return 1, 0.8, 0
	else
		return 1, 1, 1
	end
end

local zone = Minimap:CreateFontString(nil, 'OVERLAY')
zone:SetFont([[Interface\AddOns\Lyn\assets\fonts\PassionOne-Regular.ttf]], 12, 'OUTLINE')
zone:SetPoint('TOPRIGHT', Minimap, 2, 20)
zone:SetShadowOffset(1, -1)
zone:SetShadowColor(0, 0, 0)
zone:SetAlpha(1)
zone:SetSize(200, 10)
zone:SetJustifyH('RIGHT')
zone:SetTextColor(GetZoneColor())
if GetSubZoneText() == '' then
	zone:SetText(string.upper(GetZoneText()))
else
	zone:SetText(string.upper(GetSubZoneText()))
end

Minimap:HookScript('OnUpdate', function()
	if GetSubZoneText() == '' then
		zone:SetText(string.upper(GetZoneText()))
	else
		zone:SetText(string.upper(GetSubZoneText()))
	end
	zone:SetTextColor(GetZoneColor())
end)
