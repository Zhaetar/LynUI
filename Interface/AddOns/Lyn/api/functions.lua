local E, F, C = unpack(select(2, ...))

local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60
local bnot, band = bit.bnot, bit.band

function F:RegisterSlash(...)
	local name = C.NAME .. 'Slash' .. math.floor(GetTime())

	local numArgs = select('#', ...)
	local func = select(numArgs, ...)
	if(type(func) ~= 'function' or numArgs < 2) then
		error('Syntax: RegisterSlash("/slash1"[, "/slash2"], slashFunction)')
	end

	for index = 1, numArgs - 1 do
		local str = select(index, ...)
		if(type(str) ~= 'string') then
			error('Syntax: RegisterSlash("/slash1"[, "/slash2"], slashFunction)')
		end

		_G['SLASH_' .. name .. index] = str
	end

	SlashCmdList[name] = func
end

function F:dummy()
end

function F:DecimalRound(v)
	local  shift = 10^1
	local  result = floor(v*shift+.5)/shift
	return result
end

function F:ShortValue(v)
	if not v then return '' end
	local absvalue = abs(v)
	local str, val
	if absvalue >= 1e10 then
		str, val = '%.0fb', v/1e9
	elseif absvalue >= 1e9 then
		str, val = '%.1fb', v/1e9
	elseif absvalue >= 1e7 then
		str, val = '%.1fm', v/1e6
	elseif absvalue >= 1e6 then
		str, val = '%.2fm', v/1e6
	elseif absvalue >= 1e5 then
		str, val = '%.0fk', v/1e3
	elseif absvalue >= 1e3 then
		str, val = '%.1fk', v/1e3
	else
		str, val = '%d', v
	end
	return format(str, val)
end

function F:UTF8sub(string, i, dots)
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while pos <= bytes do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 194 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 244 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and '...' or '')
		else
			return string
		end
	end
end

function F:AbbreviateName(string)
	return string:gsub("(%w)[^%s]+%s", "%1. ")
end

function F:RGBtoHex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

function F:FormatTime(s)
	if s >= day then
		return format('%dd', floor(s/day + 0.5))
	elseif s >= hour then
		return format('%dh', floor(s/hour + 0.5))
	elseif s >= minute then
		return format('%dm', floor(s/minute + 0.5))
	end
	return format('%d', fmod(s, minute))
end

function SecondsToTimeAbbrev(time)
	local hr, m, s, text
	if time <= 0 then
		text = ''
	elseif time < 3600 and time > 60 then
		hr = floor(time/3600)
		m = floor(mod(time, 3600)/60 + 1)
		text = format('%dm', m)
	elseif time < 60 then
		m = floor(time/60)
		s = mod(time, 60)
		text = m == 0 and format('%ds', s)
	else
		hr = floor(time/3600 + 1)
		text = format('%dh', hr)
	end
	return text
end
