
	-- !ClassColors settings
	local f = CreateFrame'Frame'
	f:RegisterEvent'ADDON_LOADED'
	f:SetScript('OnEvent', function(self, event, addon)
		if addon == '!ClassColors' then
			ClassColorsDB = {
				["DEATHKNIGHT"] = {
					["b"] = 0.274509803921569,
					["colorStr"] = "ffd21446",
					["g"] = 0.0784313725490196,
					["r"] = 0.823529411764706,
				},
				["WARRIOR"] = {
					["b"] = 0.431372549019608,
					["colorStr"] = "ffd6936e",
					["g"] = 0.580392156862745,
					["r"] = 0.83921568627451,
				},
				["PALADIN"] = {
					["b"] = 0.658823529411765,
					["colorStr"] = "ffff5ea8",
					["g"] = 0.372549019607843,
					["r"] = 1,
				},
				["MAGE"] = {
					["b"] = 1,
					["colorStr"] = "ff00c1ff",
					["g"] = 0.76078431372549,
					["r"] = 0,
				},
				["PRIEST"] = {
					["b"] = 1,
					["colorStr"] = "ffffffff",
					["g"] = 1,
					["r"] = 1,
				},
				["SHAMAN"] = {
					["b"] = 1,
					["colorStr"] = "ff316fff",
					["g"] = 0.435294117647059,
					["r"] = 0.196078431372549,
				},
				["WARLOCK"] = {
					["b"] = 0.933333333333333,
					["colorStr"] = "ff8b76ed",
					["g"] = 0.462745098039216,
					["r"] = 0.549019607843137,
				},
				["DEMONHUNTER"] = {
					["b"] = 0.83921568627451,
					["colorStr"] = "ff862bd6",
					["g"] = 0.172549019607843,
					["r"] = 0.529411764705882,
				},
				["ROGUE"] = {
					["b"] = 0,
					["colorStr"] = "ffffe700",
					["g"] = 0.909803921568627,
					["r"] = 1,
				},
				["DRUID"] = {
					["b"] = 0.247058823529412,
					["colorStr"] = "ffff6e3f",
					["g"] = 0.431372549019608,
					["r"] = 1,
				},
				["MONK"] = {
					["b"] = 0.737254901960784,
					["colorStr"] = "ff00ffbb",
					["g"] = 1,
					["r"] = 0,
				},
				["HUNTER"] = {
					["b"] = 0.411764705882353,
					["colorStr"] = "ff8bdc69",
					["g"] = 0.862745098039216,
					["r"] = 0.549019607843137,
				},
			}

			f:UnregisterEvent'ADDON_LOADED'
		end
	end)
