
	-- ls: Toast custom pos on login
	local f = CreateFrame'Frame'
	f:RegisterEvent'ADDON_LOADED'
	f:SetScript('OnEvent', function(self, event, addon)
		if addon == 'ls_Toasts' then
			LS_TOASTS_CFG_GLOBAL = {
				["Default"] = {
					["sfx_enabled"] = true,
					["fadeout_delay"] = 2.8,
					["point"] = {
						[1] = "BOTTOM",
						[2] = "UIParent",
						[3] = "BOTTOM",
						[4] = 0,
						[5] = 250
					},
					["colored_names_enabled"] = true,
					["garrison_6_0_enabled"] = false,
					["garrison_7_0_enabled"] = true,
					["archaeology_enabled"] = true,
					["world_enabled"] = true,
					["achievement_enabled"] = true,
					["transmog_enabled"] = true,
					["growth_direction"] = "UP",
					["dnd"] = {
						["achievement"] = false,
						["archaeology"] = false,
						["recipe"] = false,
						["instance"] = false,
						["loot_special"] = false,
						["loot_common"] = false,
						["garrison_6_0"] = false,
						["garrison_7_0"] = true,
						["loot_currency"] = false,
						["world"] = false,
						["transmog"] = false,
					},
					["instance_enabled"] = true,
					["max_active_toasts"] = 10,
					["loot_special_enabled"] = true,
					["loot_common_enabled"] = false,
					["loot_common_quality_threshold"] = 1,
					["loot_currency_enabled"] = true,
					["scale"] = 1,
					["recipe_enabled"] = true,
				}
			}
			f:UnregisterEvent'ADDON_LOADED'
		end
	end)
