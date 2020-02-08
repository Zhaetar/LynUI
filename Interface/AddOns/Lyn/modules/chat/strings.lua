-- LOCALS
local type, gsub, time, floor,  _ = type, _G.string.gsub, time, math.floor, _

-- flags
CHAT_FLAG_AFK = 'AFK - '
CHAT_FLAG_DND = 'DND - '
CHAT_FLAG_GM = 'GM - '

-- channels
CHAT_SAY_GET = "%s: "
CHAT_YELL_GET = "%s: "

CHAT_GUILD_GET = '|Hchannel:Guild|h/g|h %s:\32'
CHAT_OFFICER_GET = '|Hchannel:o|h/o|h %s:\32'

CHAT_RAID_GET = '|Hchannel:raid|h/r|h %s:\32'
CHAT_RAID_WARNING_GET = 'RW! %s:\32'
CHAT_RAID_LEADER_GET = '|Hchannel:raid|h/r|h %s:\32'

CHAT_BATTLEGROUND_GET = '|Hchannel:Battleground|h/bg|h %s:\32'
CHAT_BATTLEGROUND_LEADER_GET = '|Hchannel:Battleground|h/bg|h %s:\32'

CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE_CHAT|h/i|h %s:\32"
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|h/i|h %s:\32"

CHAT_PARTY_GET = '|Hchannel:party|h/p|h %s:\32'
CHAT_PARTY_LEADER_GET = '|Hchannel:party|h/p|h %s:\32'
CHAT_PARTY_GUIDE_GET = '|Hchannel:party|h/p|h %s:\32'
CHAT_MONSTER_PARTY_GET = '|Hchannel:raid|h/r|h %s:\32'

--[[
CHAT_WHISPER_INFORM_GET = "< %s: "
CHAT_WHISPER_GET = "> %s: "
CHAT_BN_WHISPER_INFORM_GET = "< %s: "
CHAT_BN_WHISPER_GET = "> %s: "
--]]

-- this is a global change, affects lootframe etc. too.
_G.GOLD_AMOUNT = '|cffffffff%d|r|TInterface\\MONEYFRAME\\UI-GoldIcon:14:14:2:0|t'
_G.SILVER_AMOUNT = '|cffffffff%d|r|TInterface\\MONEYFRAME\\UI-SilverIcon:14:14:2:0|t'
_G.COPPER_AMOUNT = '|cffffffff%d|r|TInterface\\MONEYFRAME\\UI-CopperIcon:14:14:2:0|t'

-- shorten some chat events
local chatevents = {
	CHAT_MSG_AFK = {
		-- empty tables like this mean messages will not fire
		-- useful for spammy/pointless chat messages
	},
	CHAT_MSG_CHANNEL_JOIN = {
	},
	CHAT_MSG_COMBAT_FACTION_CHANGE = {
		['Reputation with (.+) increased by (.+).'] = '+ %2 %1 rep.',
		['You are now (.+) with (.+).'] = '%2 standing is now %1.',
	},
	CHAT_MSG_COMBAT_XP_GAIN = {
		['(.+) dies, you gain (.+) experience. %(%+(.+)exp Rested bonus%)'] = '+ %2 (+%3) xp from %1.',
		['(.+) dies, you gain (.+) experience.'] = '+ %2 xp from %1.',
		['You gain (.+) experience.'] = '+ %1 xp.',
	},
	CHAT_MSG_CURRENCY = {
		['You receive currency: (.+)%.'] = '+ %1.',
		['You\'ve lost (.+)%.'] = '- %1.',
	},
	CHAT_MSG_GUILD_ACHIEVEMENT = {
		['(.+) has earned the achievement (.+)!'] = '%1 achieved %2.',
	},
	CHAT_MSG_ACHIEVEMENT = {
		['(.+) has earned the achievement (.+)!'] = '%1 achieved %2.',
	},
	CHAT_MSG_LOOT = {
		['You receive item: (.+)%.'] = '+ %1.',
		['You receive loot: (.+)%.'] = '+ %1.',
		['You receive bonus loot: (.+)%.'] = '+ bonus %1.',
		['You create: (.+)%.'] = '+ %1.',
		['You are refunded: (.+)%.'] = '+ %1.',
		['You have selected (.+) for: (.+)'] = 'Selected %1 for %2.',
		['Received item: (.+)%.'] = '+ %1.',
		['(.+) receives item: (.+)%.'] = '+ %2 for %1.',
		['(.+) receives loot: (.+)%.'] = '+ %2 for %1.',
		['(.+) receives bonus loot: (.+)%.'] = '+ bonus %2 for %1.',
		['(.+) creates: (.+)%.'] = '+ %2 for %1.',
		['(.+) was disenchanted for loot by (.+).'] = '%2 disenchanted %1.',
	},
	CHAT_MSG_SKILL = {
		['Your skill in (.+) has increased to (.+).'] = '%1 lvl %2.'
	},
	CHAT_MSG_SYSTEM = {
		['Received (.+), (.+).'] = '+ %1, %2.',
		['Received (.+).'] = '+ %1.',
		['Received (.+) Silver'] = '+ %1 s',
		['Received (.+) of item: (.+).'] = '+ %2x%1.',
		['(.+) is now your follower.'] = '+ follower %1.',
		['(.+) completed.'] = '|cfff86256- Quest:|r %1',
		['Quest accepted: (.+)'] = '|cfff86256+ Quest:|r %1',
		['Received item: (.+)%.'] = '+ %1.',
		['Experience gained: (.+).'] = '+ %1 xp.',
		['(.+) has come online.'] = '%1 has come |cff20ff20online|r.',
		['(.+) has gone offline.'] = '%1 has gone |cffff2020offline|r.',
		['You are now Busy: in combat'] = '+ Combat.',
		['You are no longer marked Busy.'] = '- Combat.',
		['Discovered (.+): (.+) experience gained'] = '+ %2 xp, found %1.',
		['You are now (.+) with (.+).'] = '+ %2 faction, now %1.',
		['Quest Accepted (.+)'] = '|cfff86256+ Quest:|r %1',
		['You are now Away: AFK'] = '+ AFK.',
		['You are no longer Away.'] = '- AFK.',
		['You are no longer rested.'] = '- Rested.',
		['You don\'t meet the requirements for that quest.'] = '|cffff000!|r Quest requirements not met.',
		['(.+) has joined the raid group.'] = '+ Raider |cffff7d00%1|r.',
		['(.+) has left the raid group.'] = '- Raider |cffff7d00%1|r.',
		['You have earned the title \'(.+)\'.'] = '+ Title %1.',
	},
	CHAT_MSG_TRADESKILLS = {
		['(.+) creates (.+).'] = '%1 |cffffff00->|r %2.',
	},
}

-- implement event subs
for event, eventFilters in pairs(chatevents) do
	ChatFrame_AddMessageEventFilter(event, function(frame, event, message, ...)
		for k, v in pairs(eventFilters) do
			-- print('trying', k, 'with', v..'.')

			if message:match(k) then
				-- print(k, 'is a match.')
				message = message:gsub(k, v)
				return nil, message, ...
			end
		end
			-- event/string finder, as long as an event is registered in the table
			-- this will return all messages fired by it.

		-- print(event, ':', message..'.')
		-- return nil, message, ...
	end)
end

-- implement general chat string subs
local AddMessage = ChatFrame1.AddMessage
local function FCF_AddMessage(self, text, ...)
	if type(text) == 'string' then
		local _, size = self:GetFont()

		text = gsub(text, '|TInterface\\Icons\\(.+):(.+)|t', '|TInterface\\Icons\\%1:'..size..':'..size..':0:0:64:64:8:56:8:56|t')
		text = gsub(text, "(|HBNplayer.-|h)%[(.-)%]|h", "%1%2|h")	-- battlenet player name
		text = gsub(text, "(|Hplayer.-|h)%[(.-)%]|h", "%1%2|h")		-- player name
		text = gsub(text, "%[(%d0?)%. (.-)%]", "/%1")				-- globals channels: [1. trade] > /1./
		text = gsub(text, "Guild Message of the Day:", "GMotD -")	-- message of the day
		text = gsub(text, "To (|HBNplayer.+|h):", "%1 >")				-- whisper to bnet
		text = gsub(text, "To (|Hplayer.+|h):", "%1 >")				-- whisper to
		text = gsub(text, ' whispers:', ' <')						-- whisper from
		text = gsub(text, 'Joined Channel:', '+')					-- channel join
		text = gsub(text, 'Left Channel:', '- ')					-- channel left
		text = gsub(text, 'Changed Channel:', '>')					-- channel change
		-- text = gsub(text, '|H(.-)|h%[(.-)%]|h', '|H%1|h%2|h')		-- strip brackets off've items iilinks style
		-- text = '|cff555555' .. date('%H:%M') .. '|r  ' .. text
	end
	return AddMessage(self, text, ...)
end

local function StyleTheChat()
	for i = 1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 ) then
			local f = _G["ChatFrame"..i]
			f.AddMessage = FCF_AddMessage
		end
	end
end

hooksecurefunc("FCF_OpenTemporaryWindow", StyleTheChat)
StyleTheChat()
