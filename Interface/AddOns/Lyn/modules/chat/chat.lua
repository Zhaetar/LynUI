local E, F, C, L = unpack(select(2, ...))

-- CONFIG
local fixedChat = true
local position 	= {'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 50, 80}

-- LOCALS
local type, gsub, time, floor,  _ = type, _G.string.gsub, time, math.floor, _

local _, class = UnitClass('player')
local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

-- FONTS
ChatFontNormal:SetFont(C.CHAT_FONT, 12)
ChatFontNormal:SetShadowOffset(1, -1)
ChatFontNormal:SetShadowColor(0, 0, 0, 1)

-- FRAME FADE TIMES/ALPHA LEVELS
DEFAULT_CHATFRAME_ALPHA = 0--.25
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_FADE_OUT_TIME = .1
CHAT_FRAME_FADE_TIME = .1
CHAT_TAB_SHOW_DELAY = 0
CHAT_TAB_HIDE_DELAY = 0

-- MORE FONT SIZES IM POPUP
CHAT_FONT_HEIGHTS = {
	[1] = 8, [2] = 9, [3] = 10, [4] = 11, [5] = 12, [6] = 13,
	[7] = 14, [8] = 15, [9] = 16, [10] = 17, [11] = 18, [12] = 19, [13] = 20,
}

-- FLAVOUR TEXT
-- http://eu.battle.net/wow/en/forum/topic/12286978621
-- ForceGossip = function() return true end

-- RESPOSITION
-- if fixedChat then
	-- local ChatFrameN = CreateFrame('Frame', nil, UIParent)
	-- ChatFrameN:RegisterEvent'PLAYER_ENTERING_WORLD'
	-- ChatFrameN:SetScript('OnEvent', function()
		-- ChatFrame1:ClearAllPoints()
		-- ChatFrame1:SetPoint(position[1], position[2], position[3], position[4], position[5])
		-- ChatFrame1:SetUserPlaced(true)
	-- end)
-- end

-- CLASS COLOURED NAMES
local f = CreateFrame("Frame")
f:RegisterEvent("UPDATE_CHAT_COLOR_NAME_BY_CLASS")
f:SetScript("OnEvent",function(self,event,type,set)
	if not set then SetChatColorNameByClass(type,true); end
end)

-- HIDE BUTTONS
if FriendsMicroButton and FriendsMicroButton:IsShown() then
	FriendsMicroButton:SetAlpha(0)
	FriendsMicroButton:EnableMouse(false)
	FriendsMicroButton:UnregisterAllEvents()
end

if QuickJoinToastButton and QuickJoinToastButton:IsShown() then
	QuickJoinToastButton:SetAlpha(0)
	QuickJoinToastButton:EnableMouse(false)
	QuickJoinToastButton:UnregisterAllEvents()
end

if ChatFrameMenuButton and ChatFrameMenuButton:IsShown() then
	ChatFrameMenuButton:SetAlpha(0)
	ChatFrameMenuButton:EnableMouse(false)
end

hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, direction)
	local buttonBottom = _G[self:GetName() .. 'ButtonFrameBottomButton']
	if self:AtBottom() then
		buttonBottom:Hide()
	else
		buttonBottom:Show()
		buttonBottom:SetAlpha(1)
	end

	if(direction > 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToTop()
		else
			self:ScrollUp()
		end
	else
		if(IsShiftKeyDown()) then
			self:ScrollToBottom()
		else
			self:ScrollDown()
		end
	end
end)

-- EDITBOX (this just hides it when in the default IM mode)
for i = 1, NUM_CHAT_WINDOWS do
	local editBox = _G[('ChatFrame%d'):format(i)..'EditBox']
	editBox:Hide()
	editBox:HookScript('OnEditFocusLost', function(self)
		self:Hide()
	end)
	 editBox:HookScript('OnEditFocusGained', function(self)
		self:Show()
	end)
end

-- TABS
local function SkinTab(self)
	local chat = _G[self]

	-- hide textures
	local tab = _G[self..'Tab']
	for i = 1, select('#', tab:GetRegions()) do
		local texture = select(i, tab:GetRegions())
		if texture and texture:GetObjectType() == 'Texture' then
			texture:SetTexture(nil)
		end
	end

	-- text
	local tabText = _G[self..'TabText']
	tabText:SetJustifyH('LEFT')
	--tabText:SetWidth(40)
	tabText:SetFont(C.BIG_FONT, 11, 'OUTLINE')
	tabText:SetShadowOffset(1, -1)
	tabText:SetShadowColor(0, 0, 0, 1)
	tabText:SetDrawLayer('OVERLAY', 7)
	tabText:SetTextColor(color.r, color.g, color.b)
	tabText:SetAlpha(0)


	-- move tab text
	local a = {tabText:GetPoint()}
	tabText:SetPoint(a[1], a[2], a[3], a[4], 2)

	-- move the tabs dock
	-- GENERAL_CHAT_DOCK:ClearAllPoints()
	-- GENERAL_CHAT_DOCK:SetPoint('TOPLEFT', ChatFrame1, 0, 22)
	-- GENERAL_CHAT_DOCK:SetWidth(ChatFrame1:GetWidth())

	hooksecurefunc('FCFDock_UpdateTabs', function()
		if not tab.wasShown then
			if chat:IsMouseOver() then
		  		tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
			else
		  		tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
			end
			tab.wasShown = true
		end
	end)


end

FCFTab_UpdateColors = function(self, selected)
	if (selected) then
		self:GetFontString():SetTextColor(color.r, color.g, color.b)
	else
		self:GetFontString():SetTextColor(.3, .3, .3)
	end
end


-- STYLE CHAT (+ edit box)
local function StyleChat(self)
	local chat = _G[self]

	-- boundaries
	chat:SetShadowOffset(1, -1)
	chat:SetClampedToScreen(false)
	chat:SetClipsChildren(true)
	-- local _, fs = chat:GetFont()
	-- chat:SetFont(C.CHAT_FONT, fs, 'OUTLINE')
	-- chat:SetClampRectInsets(0, 0, 0, 0)
	chat:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
	chat:SetMinResize(150, 25)
	chat:SetSpacing(5)

	-- implement tab modification
	SkinTab(self)

	-- hide scroll up
	local buttonUp = _G[self..'ButtonFrameUpButton']
	buttonUp:SetAlpha(0)
	buttonUp:EnableMouse(false)

	-- hide scroll down
	local buttonDown = _G[self..'ButtonFrameDownButton']
	buttonDown:SetAlpha(0)
	buttonDown:EnableMouse(false)

	-- hide scroll bottom
	-- and reposition ready if it's reshown
	local buttonBottom = _G[self..'ButtonFrameBottomButton']
	buttonBottom:Hide()
	buttonBottom:ClearAllPoints()
	buttonBottom:SetPoint('RIGHT', chat, 'BOTTOMLEFT', -10, 12)
	buttonBottom:HookScript('OnClick', function(self)
		self:Hide()
	end)

	-- hide the weird extra background for now non-existent buttons
	for _, texture in pairs({
		'ButtonFrameBackground',
		'ButtonFrameTopLeftTexture',
		'ButtonFrameBottomLeftTexture',
		'ButtonFrameTopRightTexture',
		'ButtonFrameBottomRightTexture',
		'ButtonFrameLeftTexture',
		'ButtonFrameRightTexture',
		'ButtonFrameBottomTexture',
		'ButtonFrameTopTexture',
	}) do
		_G[self..texture]:SetTexture(nil)
	end

		-- edit box
	local editbox = _G[self..'EditBox']
	local header = _G[self..'EditBoxHeader']
	local suffix = _G[self..'EditBoxHeaderSuffix']
	local focusleft = _G[self..'EditBoxFocusLeft']
	local focusright = _G[self..'EditBoxFocusRight']
	local focusmid = _G[self..'EditBoxFocusMid']
	local editleft  = _G[self..'EditBoxLeft']
	local editright = _G[self..'EditBoxRight']
	local editmid  = _G[self..'EditBoxMid']

	editbox:SetAltArrowKeyMode(false)
	editbox:ClearAllPoints()
	--editbox:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', -2, 35)
	--editbox:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 2, 35)
	editbox:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -2, -10)
	editbox:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 2, -10)
	editbox:SetHeight(24)
	editbox:SetTextInsets(12 + header:GetWidth() + (suffix:IsShown() and suffix:GetWidth() or 0), 12, 0, 0)
	editbox:SetBackdrop({
		bgFile = C.PLAIN_TEXTURE,
		tiled = false,
		insets = {left = 1, right = 1, top = 1, bottom = 1}
	})
	F:CreateBorder(editbox, -1)
	editbox:SetBorderColor(unpack(C.BORDER_COLOR_DARK))
	editbox:SetBackdropColor(0 , 0 , 0, 0.6)
	editbox:SetBackdropBorderColor(0 , 0 , 0, 0)

	editbox:SetFont(C.CHAT_FONT, 13)--, 'OUTLINE')
	header:SetFont(C.SMALL_FONT, 13)--, 'OUTLINE')
	suffix:SetFont(C.SMALL_FONT, 13)--, 'OUTLINE')

	focusleft:SetAlpha(0)
	focusright:SetAlpha(0)
	focusmid:SetAlpha(0)
	editleft:SetAlpha(0)
	editright:SetAlpha(0)
	editmid:SetAlpha(0)

	-- Hide editbox every time we click on a tab
	_G[self.."Tab"]:HookScript("OnClick", function()
		editbox:Hide()
	end)

end


-- HAX
-- fix buggy bottoms with a more vigorous hook
-- otherwise cinematics/world map make the scroll2bottom button visible again.
hooksecurefunc('ChatFrame_OnUpdate', function(self)
	local buttonBottom = _G[self:GetName()..'ButtonFrameBottomButton']
	if self:AtBottom() and buttonBottom:IsShown() then
		buttonBottom:Hide()
	end
end)


-- IMPLEMENT
local function StyleTheChat()
	-- make chat windows transparent
	for i = 1, NUM_CHAT_WINDOWS do
		SetChatWindowAlpha(i, 0)
	end

	-- style
	for _, v in pairs(CHAT_FRAMES) do
		local chat = _G[v]
		if chat and not chat.styled then
			StyleChat(chat:GetName())

			local convButton = _G[chat:GetName()..'ConversationButton']
			if convButton then
				convButton:SetAlpha(0)
				convButton:EnableMouse(false)
			end

			local chatMinimize = _G[chat:GetName()..'ButtonFrameMinimizeButton']
			if chatMinimize then
				chatMinimize:SetAlpha(0)
				chatMinimize:EnableMouse(0)
			end
			chat.styled = true
		end
	end
end

hooksecurefunc('FCF_OpenTemporaryWindow', StyleTheChat)
StyleTheChat()


-- CHAT MENU ON TAB 1
---------------------------------------------

hooksecurefunc('ChatFrameMenu_UpdateAnchorPoint', function()
	if ( FCF_GetButtonSide(DEFAULT_CHAT_FRAME) == "right" ) then
		ChatMenu:ClearAllPoints();
		ChatMenu:SetPoint("BOTTOMRIGHT", ChatFrame1Tab, "TOPLEFT");
	else
		ChatMenu:ClearAllPoints();
		ChatMenu:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPRIGHT");
	end
end)
ChatFrame1Tab:RegisterForClicks('AnyUp')
ChatFrame1Tab:HookScript('OnClick', function(self, button)
    if button == 'MiddleButton' then
        if (ChatMenu:IsShown()) then
            ChatMenu:Hide()
        else
            ChatMenu:Show()
        end
    else
        ChatMenu:Hide()
    end
end)
