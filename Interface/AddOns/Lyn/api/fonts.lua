local _, _, C = unpack(select(2, ...))

local t = CreateFont'LynAuraNameFont'
t:SetFont(C.AURA_NAME_FONT, 12, 'OUTLINE')
t:SetShadowOffset(1, -1)
t:SetShadowColor(0, 0, 0)

local t = CreateFont'LynAuraDurationFont'
t:SetFont(C.AURA_DURATION_FONT, 12)
t:SetShadowOffset(1, -1)
t:SetShadowColor(0, 0, 0)

local t = CreateFont'LynAuraCountFont'
t:SetFont(C.AURA_COUNT_FONT, 12, 'OUTLINE')
t:SetShadowOffset(1, -1)
t:SetShadowColor(0, 0, 0)

local t = CreateFont'LynMicroMenuFont'
t:SetFont(C.MICRO_MENU_FONT, 12)
t:SetShadowOffset(1, -1)
t:SetShadowColor(0, 0, 0)
