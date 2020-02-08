local E, F, C, L = unpack(select(2, ...))

C.NAME = ...

C.PLAIN_TEXTURE = [[Interface\Buttons\WHITE8x8]]
--C.STATUSBAR_TEXTURE = [[Interface\TARGETINGFRAME\UI-StatusBar-Glow]]
C.STATUSBAR_TEXTURE = [[Interface\AddOns\Lyn\assets\statusbars\fer35.tga]]
C.STATUSBAR_TEXTURE_STRIPED = [[Interface\AddOns\Lyn\assets\statusbars\lyn2.tga]]

C.DAMAGE_FONT = [[Interface\AddOns\Lyn\assets\fonts\CAMELTOEkalypse.ttf]]

C.BIG_FONT = [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Bold.ttf]]
C.SMALL_FONT = [[Fonts\ARIALN.ttf]]

C.CHAT_FONT = [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Bold.ttf]]

C.MICRO_MENU_FONT = [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Regular.ttf]]

C.ACTION_BUTTON_NAME_FONT = [[Fonts\ARIALN.ttf]]
C.ACTION_BUTTON_HOTKEY_FONT = [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Regular.ttf]]
C.ACTION_BUTTON_COUNT_FONT = [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Bold.ttf]]

C.AURA_DURATION_FONT = [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Regular.ttf]]
C.AURA_NAME_FONT = [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Bold.ttf]]
C.AURA_COUNT_FONT = [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Bold.ttf]]

C.TOOLTIP_HEADER_FONT =  [[Interface\AddOns\Lyn\assets\fonts\PassionOne-Regular.ttf]]
C.CLOCK_FONT = [[Interface\AddOns\Lyn\assets\fonts\RobotoSlab-Bold.ttf]]

C.BUTTON_BORDER_COLOR_BASE = { .2, .2, .2, 1 }
C.BORDER_COLOR_DARK = { .2, .2, .2, 1 }
C.BORDER_COLOR_GOLD = { 218/255, 193/255, 28/255, 1 }

C.OBJECTIVE_TRACKER_POSITION = {'TOPRIGHT', UIParent, -35, -290}
C.OBJECTIVE_TRACKER_HEIGHT = 650

-- -----------------------
_G[C.NAME] = {E, F, C, L}
