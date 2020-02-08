SLASH_LYNRELOADUI1 = '/rl'
SlashCmdList.LYNRELOADUI = ReloadUI

SLASH_LYNFRAMESTACK1 = '/fs'
SlashCmdList.LYNFRAMESTACK = function(msg)
	UIParentLoadAddOn'Blizzard_DebugTools'
	FrameStackTooltip_Toggle()
end

SLASH_LYNEVENTTRACE1 = '/et'
SlashCmdList.LYNEVENTTRACE = function(msg)
	UIParentLoadAddOn'Blizzard_DebugTools'
	EventTraceFrame_HandleSlashCmd(msg)
end

SLASH_LYNCALENDAR1 = '/cl'
SLASH_LYNCALENDAR2 = '/cal'
SLASH_LYNCALENDAR3 = '/calendar'
SlashCmdList.LYNCALENDAR = function()
	securecall(ToggleCalendar)
end

SLASH_TOAST1 = '/to'
SlashCmdList.TOAST = function()
	BNToastFrame:Show()
	BNToastFrameTopLine:SetText'Randal the Vandal'
	BNToastFrameMiddleLine:SetText'has gone offline'
end
