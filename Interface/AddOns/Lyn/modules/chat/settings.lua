local E, F, C, L = unpack(select(2, ...))

local CHANNEL_TAB_NAME 	= "Town"
local LocalDefense 		= "LocalDefense"
local GuildRecruitment 	= "GuildRecruitment"
local LookingForGroup 	= "LookingForGroup"

local ChatMove = function()
	ChatFrame1:SetUserPlaced(true)
	ChatFrame1:SetWidth(400)
	ChatFrame1:SetHeight(250)
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 50, 95)

	FCF_SetWindowAlpha(ChatFrame1, 0, true)
	FCF_SetWindowAlpha(ChatFrame2, 0, true)
end

local ChatInitialize = function()
	FCF_ResetChatWindows()
	FCF_SetWindowName(ChatFrame1, GENERAL)
	FCF_SetChatWindowFontSize(nil, ChatFrame1, 13)
	FCF_SetLocked(ChatFrame1, 1)

	FCF_DockFrame(ChatFrame2)
	FCF_SetWindowName(ChatFrame2, 'Log')
	FCF_SetChatWindowFontSize(nil, ChatFrame2, 13)
	FCF_SetLocked(ChatFrame2, 1)

	FCF_OpenNewWindow(L.CHAT_TAB_GENERAL)
	FCF_SetLocked(ChatFrame3, 1)
	FCF_SetChatWindowFontSize(nil, ChatFrame3, 13)
	FCF_DockFrame(ChatFrame3)

	FCF_OpenNewWindow(LOOT)
	FCF_SetLocked(ChatFrame4, 1)
	FCF_SetChatWindowFontSize(nil, ChatFrame4, 13)
	FCF_DockFrame(ChatFrame4)

	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_RemoveChannel(ChatFrame1, TRADE)
	ChatFrame_RemoveChannel(ChatFrame1, GENERAL)
	ChatFrame_RemoveChannel(ChatFrame1, L.CHAT_TAB_LOCAL_DEFENSE)
	ChatFrame_RemoveChannel(ChatFrame1, L.CHAT_TAB_GUILD_RECRUITMENT)
	ChatFrame_RemoveChannel(ChatFrame1, L.CHAT_TAB_LOOKING_FOR_GROUP)

	ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame1, "DND")
	ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
	ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_INLINE_TOAST_ALERT")

	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddChannel(ChatFrame3, TRADE)
	ChatFrame_AddChannel(ChatFrame3, GENERAL)
	ChatFrame_AddChannel(ChatFrame3, L.CHAT_TAB_LOCAL_DEFENSE)
	ChatFrame_AddChannel(ChatFrame3, L.CHAT_TAB_GUILD_RECRUITMENT)
	ChatFrame_AddChannel(ChatFrame3, L.CHAT_TAB_LOOKING_FOR_GROUP)

	ChatFrame_RemoveAllMessageGroups(ChatFrame4)
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame4, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONEY")
	ChatFrame_AddMessageGroup(ChatFrame4, "SKILL")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_GUILD_XP_GAIN")

		-- Enable Classcolor
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")

	FCF_SelectDockFrame(ChatFrame1)

	ChangeChatColor("WHISPER_INFORM", 153/255, 74/255, 153/255)
	ChangeChatColor("BN_WHISPER_INFORM", 0/255, 119/255, 116/255)
	ChangeChatColor("WHISPER", 255/255, 128/255, 255/255)
	ChangeChatColor("BN_WHISPER", 0/255, 255/255, 246/255)

	ChatMove()
end

SLASH_LYNCHAT1 = '/lc'
SLASH_LYNCHAT2 = '/lynchat'
SlashCmdList.LYNCHAT = ChatInitialize

function E:PLAYER_LOGIN()
	ChatMove()
end
