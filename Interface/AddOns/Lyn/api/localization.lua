local E, F, C, L = unpack(select(2, ...))
local CURRENT_LOCALE = GetLocale()

setmetatable(L, { __index = function(t, k)
	local v = tostring(k)
	t[k] = v
	return v
end })


L.CHAT_TAB_GENERAL = "Town"
L.CHAT_TAB_LOCAL_DEFENSE = "LocalDefense"
L.CHAT_TAB_GUILD_RECRUITMENT = "GuildRecruitment"
L.CHAT_TAB_LOOKING_FOR_GROUP = "LookingForGroup"


if CURRENT_LOCALE == "enUS" then return end

-- ---------------------------------------------
-- deDE

if CURRENT_LOCALE == "deDE" then

end

-- ---------------------------------------------
-- itIT

if CURRENT_LOCALE == "itIT" then

end

-- ---------------------------------------------
-- ptBR

if CURRENT_LOCALE == "ptBR" then

end

-- ---------------------------------------------
-- esMX

if CURRENT_LOCALE == "esMX" then

end

-- ---------------------------------------------
-- esES

if CURRENT_LOCALE == "esES" then

end

-- ---------------------------------------------
-- ruRU

if CURRENT_LOCALE == "ruRU" then

end

-- ---------------------------------------------
-- zhTW

if CURRENT_LOCALE == "zhTW" then

end

-- ---------------------------------------------
-- zhCN

if CURRENT_LOCALE == "zhCN" then

end

-- ---------------------------------------------
-- koKR

if CURRENT_LOCALE == "koKR" then

end

-- ---------------------------------------------
-- frFR

if CURRENT_LOCALE == "frFR" then

end
