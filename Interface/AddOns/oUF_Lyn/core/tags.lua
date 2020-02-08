local _, A = ...
local cfg = A.config
local lib = A.library

local E, F, C = unpack(_G['Lyn'])

local T	= oUF.Tags.Methods or oUF.Tags
local TE	= oUF.TagEvents or oUF.Tags.Events

oUF.colors.power['MANA'] = {0.37, 0.6, 1}
oUF.colors.power['RAGE']  = {0.9,  0.3,  0.23}
oUF.colors.power['FOCUS']  = {1, 0.81,  0.27}
oUF.colors.power['RUNIC_POWER']  = {0, 0.81, 1}
oUF.colors.power['AMMOSLOT'] = {0.78,1, 0.78}
oUF.colors.power['FUEL'] = {0.9,  0.3,  0.23}
oUF.colors.power['POWER_TYPE_STEAM'] = {0.55, 0.57, 0.61}
oUF.colors.power['POWER_TYPE_PYRITE'] = {0.60, 0.09, 0.17}
oUF.colors.power['POWER_TYPE_HEAT'] = {0.55,0.57,0.61}
oUF.colors.power['POWER_TYPE_OOZE'] = {0.76,1,0}
oUF.colors.power['POWER_TYPE_BLOOD_POWER'] = {0.7,0,1}


T['lyn:pvp'] = function(unit)
	if UnitIsPVP(unit) or UnitIsPVPFreeForAll(unit) then
		return '|cff50BB33PVP|r'
	end
	return ''
end
TE['lyn:pvp'] = 'UNIT_FACTION'

T["lyn:hpp"] = function(unit)
	if not UnitIsConnected(unit) then
		return "|cff999999OFFLINE|r"
	elseif UnitIsGhost(unit) then
		return "|cff999999GHOST|r"
	elseif UnitIsDead(unit) then
		return "|cff999999DEAD|r"
	end

	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local percent = math.floor((min / max) * 100+0.5)

	if percent < 100 then
		return F:RGBtoHex(oUF.ColorGradient(min, max, 1,0,0, 1,1,0, 0,1,0)) .. percent .. "%"
	end

   return ''
end
TE["lyn:hpp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_DEAD PLAYER_ALIVE"

T['lyn:hps'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	if min <= 1 or ( (unit == 'player' or unit:sub(1, 5) == 'party' or unit == 'pet') and min == max) or not UnitIsConnected(unit) or UnitIsGhost(unit) or UnitIsDead(unit) then
		return ''
	end

	return F:ShortValue(min)
end
TE['lyn:hps'] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE"

T['lyn:hp'] = function(unit)
	if UnitIsGhost(unit) then
		return "|cff999999('o')|r"
	elseif UnitIsDead(unit) then
		return "|cff999999(x.x)|r"
	end

	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local percent = math.floor((min / max) * 100+0.5)

	return '|cffffffff' .. F:ShortValue(min) .. '|r ' .. F:RGBtoHex(oUF.ColorGradient(min, max, 1,0,0, 1,1,0, 0,1,0)) .. percent .. '%|r'
end
TE['lyn:hp'] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_DEAD PLAYER_ALIVE"

T['lyn:power'] = function(unit)
	local min, max = UnitPower(unit, UnitPowerType(unit)), UnitPowerMax(unit,  UnitPowerType(unit))
	if(min == 0 or max == 0 or min == max or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then
		return ''
	end

	local _, powerType = UnitPowerType(unit)
	return F:RGBtoHex(oUF.colors.power[powerType]) ..F:ShortValue(min) .. '|r'
end
TE['lyn:power'] = "UNIT_MAXPOWER UNIT_POWER UNIT_CONNECTION PLAYER_DEAD PLAYER_ALIVE"

T["lyn:name"] = function(unit)
	local name, realm = UnitName(unit)
	return F:AbbreviateName(string.upper(name))
end
TE["lyn:name"] = "UNIT_NAME_UPDATE"

T['lyn:classification'] = function(unit)
	local c = UnitClassification(unit)
	if(c == 'rare') then
		return '|cffF6C6F9RARE|r'
	elseif(c == 'rareelite') then
		return '|cffF6C6F9RARE+|r'
	elseif(c == 'elite') then
		return '|cff41C2B3ELITE|r'
	elseif(c == 'worldboss') then
		return '|cff9AF5DEBOSS|r'
	elseif(c == 'minus') then
		return ''
	end
	return ''
end
TE['lyn:classification'] = 'UNIT_CLASSIFICATION_CHANGED'

T["lyn:color"] = function(unit)
	local _, class = UnitClass(unit)
	local reaction = UnitReaction(unit, "player")

	if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
		return "|cffA0A0A0"
	elseif UnitIsTapDenied(unit) then
		return F:RGBtoHex(oUF.colors.tapped)
	elseif unit == "pet" then
		return F:RGBtoHex(oUF.colors.class[class])
	elseif UnitIsPlayer(unit) then
		return F:RGBtoHex(oUF.colors.class[class])
	elseif reaction then
		return F:RGBtoHex(oUF.colors.reaction[reaction])
	end
	return F:RGBtoHex(1, 1, 1)
end
TE["lyn:color"] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS UNIT_CONNECTION'
