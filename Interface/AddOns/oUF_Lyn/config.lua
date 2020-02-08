local _, A = ...
local C = CreateFrame'Frame'
A.config = C

C.FONT_SMALL_BOLD				= [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Bold.ttf]]
C.FONT_SMALL					= [[Fonts\ARIALN.ttf]]
C.FONT_BIG						= [[Interface\AddOns\Lyn\assets\fonts\PassionOne-Regular.ttf]]

C.SHOW_CASTBAR_SAFEZONE		= false
C.SHOW_ONLY_PLAYER_DEBUFFS	= true

C.PLAYER_AURA_FILTER = {
	-- MONK
	[129914] = true,	-- Power Strikes
	[196741] = true,	-- Hit Combo
	[116768] = true,	-- Blackout Kick!
	[195321] = true,	-- Transfer the Power
	[124275] = true,	-- Light Stagger
	[124274] = true,	-- Moderate Stagger
	[124273] = true,	-- Heavy Stagger
	-- SHAMAN
	[194084] = true,	-- Flametongue
	[196834] = true,	-- Frostbrand
	[210714] = true,	-- Ice Fury
	-- MAGE
	[48108] = true,	-- Hot Streak!
	[48107] = true,	-- Heating Up
	[190319] = true,	-- Combustion
	[11426] = true,	-- Ice Barrier
	[45438] = true,	-- Ice Block
	-- WARRIOR
	[215570] = true, 	-- Wrecking Ball
	[184362] = true,	-- Enrage
	[85739] = true,	-- Meat Cleaver
	[32216] = true,	-- Victory Rush
	[60503] = true,	-- Overpower!
	[209706] = true,	-- Shattered Defenses
	-- DRUID
	[164547] = true,	-- Lunar Empowerment
	[164545] = true,	-- Solar Empowerment
	[102560] = true, 	-- Incarnation: Chosen of Elune
	-- ROGUE
	[199603] = true,	-- Jolly Roger
	[193356] = true,	-- Broadsides
	[193357] = true,	-- Shark Infested Waters
	[199600] = true,	-- Buried Treasure
	[193359] = true,	-- True Bearing
	[193358] = true,	-- Grand Melee
	[199754] = true,	-- Riposte
	[1966] = true,		-- Feint
	[13750] = true,	-- Adrenaline Rush
	-- HUNTER
	[223138] = true,	-- Marking Targets
	[194594] = true,	-- Lock and Load
	[193526] = true,	-- Trueshot
	[186265] = true,	-- Aspect of the Turtle
	-- PALADIN
	[132403] = true,	-- Shield of the Righteous
	[188370] = true,	-- Consecration
	[31850] = true,	-- Ardent Defender
	[31884] = true,	-- Avenging Wrath
	[86659] = true,	-- Guardian of Ancient Kings
	[204018] = true,	-- Blessing of Spellwarding
	-- DEATH KNIGHT
	[195181] = true,	-- Bone Shield
	[81141] = true,	-- Crimson Scourge
	-- PRIEST
	[123254] = true,	-- Twist of Fate
	[197937] = true,	-- Lingering Insanity
}
