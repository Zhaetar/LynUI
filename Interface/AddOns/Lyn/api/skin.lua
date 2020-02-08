local E, F, C = unpack(select(2, ...))

local AddHighlight = function(bu)
	if bu.enter then return end
	bu.enter = bu:CreateTexture(nil, 'OVERLAY', nil, 2)
	bu.enter:SetPoint('TOPLEFT', -7, 7)
	bu.enter:SetPoint('BOTTOMRIGHT', 7, -7)
	bu.enter:SetTexture[[Interface/Glues/CHARACTERCREATE/UI-CharacterCreate-IconGlow]]
	bu.enter:SetVertexColor(0, .5, 1, 1)
	bu.enter:SetBlendMode'ADD'
	bu.enter:SetAlpha(0)
end

local ToggleHighlight = function(bu, show)
	AddHighlight(bu)
	bu.enter:SetAlpha(show and 1 or 0)
end

local sections = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "TOP", "BOTTOM", "LEFT", "RIGHT"}

local function SetBorderColor(self, r, g, b, a)
	local t = self.borderTextures
	if not t then return end

	for _, tex in pairs(t) do
		tex:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
	end
end

local function GetBorderColor(self)
	return self.borderTextures and self.borderTextures.TOPLEFT:GetVertexColor()
end

function F:CreateBorder(object, offset)
	if type(object) ~= "table" or not object.CreateTexture or object.borderTextures then return end

	local t = {}
	offset = offset or 0

	for i = 1, #sections do
		local x = object:CreateTexture(nil, "OVERLAY", nil, 1)
		x:SetTexture("Interface\\AddOns\\Lyn\\assets\\border\\"..sections[i], i > 4 and true or nil)
		t[sections[i]] = x
	end

	t.TOPLEFT:SetSize(8, 8)
	t.TOPLEFT:SetPoint("BOTTOMRIGHT", object, "TOPLEFT", 6 + offset, -6 - offset)

	t.TOPRIGHT:SetSize(8, 8)
	t.TOPRIGHT:SetPoint("BOTTOMLEFT", object, "TOPRIGHT", -6 - offset, -6 - offset)

	t.BOTTOMLEFT:SetSize(8, 8)
	t.BOTTOMLEFT:SetPoint("TOPRIGHT", object, "BOTTOMLEFT", 6 + offset, 6 + offset)

	t.BOTTOMRIGHT:SetSize(8, 8)
	t.BOTTOMRIGHT:SetPoint("TOPLEFT", object, "BOTTOMRIGHT", -6 - offset, 6 + offset)

	t.TOP:SetHeight(8)
	t.TOP:SetHorizTile(true)
	t.TOP:SetPoint("TOPLEFT", t.TOPLEFT, "TOPRIGHT", 0, 2)
	t.TOP:SetPoint("TOPRIGHT", t.TOPRIGHT, "TOPLEFT", 0, 2)

	t.BOTTOM:SetHeight(8)
	t.BOTTOM:SetHorizTile(true)
	t.BOTTOM:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "BOTTOMRIGHT", 0, -2)
	t.BOTTOM:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "BOTTOMLEFT", 0, -2)

	t.LEFT:SetWidth(8)
	t.LEFT:SetVertTile(true)
	t.LEFT:SetPoint("TOPLEFT", t.TOPLEFT, "BOTTOMLEFT", -2, 0)
	t.LEFT:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "TOPLEFT", -2, 0)

	t.RIGHT:SetWidth(8)
	t.RIGHT:SetVertTile(true)
	t.RIGHT:SetPoint("TOPRIGHT", t.TOPRIGHT, "BOTTOMRIGHT", 2, 0)
	t.RIGHT:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "TOPRIGHT", 2, 0)

	object.borderTextures = t
	object.SetBorderColor = SetBorderColor
	object.GetBorderColor = GetBorderColor
end

function F:PrepareIcon(button)
	local icon  = button.icon or button.Icon or button.IconTexture or _G[button:GetName()..'Icon'] or _G[button:GetName()..'IconTexture']
	if icon then
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		icon:SetDrawLayer('ARTWORK')
	end
end

function F:SkinButton(bu, noResize)
	local c  = bu.Count or _G[bu:GetName()..'Count']
	local cd = bu.Cooldown or _G[bu:GetName()..'Cooldown']
	local n = bu.Name or _G[bu:GetName()..'Name']
	local i  = bu.icon or bu.Icon or bu.IconTexture or _G[bu:GetName()..'Icon'] or _G[bu:GetName()..'IconTexture']

	for _, v in pairs({bu.Border, bu.FloatingBG}) do
		if v then v:SetAlpha(0) end
	end

	if not InCombatLockdown() and not noResize then
		bu:SetSize(30, 30)
	end

	-- if n then
	-- 	n:ClearAllPoints()
	-- 	n:SetPoint('BOTTOM', bu, 0, 1)
	-- 	n:SetFont(C.ACTION_BUTTON_NAME_FONT, 11, 'OUTLINE')
	-- 	n:SetShadowOffset(0, 0)
	-- 	n:SetJustifyH('CENTER')
	-- 	n:SetDrawLayer('OVERLAY', 7)
	-- end

	if c then
		c:ClearAllPoints()
		c:SetPoint('BOTTOMRIGHT', bu, 0, -1)
		c:SetFont(C.ACTION_BUTTON_COUNT_FONT, 14, 'OUTLINE')
		c:SetShadowOffset(0, 0)
		c:SetJustifyH('RIGHT')
		c:SetDrawLayer('OVERLAY', 7)
	end

	if cd then
		cd:ClearAllPoints()
		cd:SetPoint('TOPLEFT', 1.75, -1.75)
		cd:SetPoint('BOTTOMRIGHT', -1.75, 1.75)
	end

	if bu.HotKey then
		bu.HotKey:SetFont(C.ACTION_BUTTON_HOTKEY_FONT, 10, 'OUTLINE')
		bu.HotKey:SetShadowOffset(0, 0)
		bu.HotKey:ClearAllPoints()
		bu.HotKey:SetPoint('TOPRIGHT', bu, 1, -1)
		bu.HotKey:SetDrawLayer('OVERLAY',7)
		bu.HotKey:SetJustifyH('RIGHT')
		NumberFontNormalSmallGray:SetFontObject'GameFontHighlight'
	end

	if  i then
		 i:SetTexCoord(.08, .92, .08, .92)
		 i:SetDrawLayer'ARTWORK'
		 i:ClearAllPoints()
		 i:SetPoint('TOPLEFT', 1.5, -1.5)
		 i:SetPoint('BOTTOMRIGHT', -1.5, 1.5)
	end

	if  bu.Name then
		 bu.Name:SetWidth(bu:GetWidth() + 15)
		 bu.Name:SetFontObject'GameFontHighlight'
	end

	F:CreateBorder(bu)
	bu:SetBorderColor(.2, .2, .2, 1)
end

function F:PrepareButton(bu, a, hover)
	bu:SetBackdrop({
		bgFile = 'Interface\\Buttons\\UI-EmptySlot-White', tile = false,
		insets = {left = -7.5, right = -8, bottom = -9.5, top = -7}
	})
	bu:SetBackdropColor(.4, .4, .4, 1)
	bu:SetNormalTexture''
	bu:SetHighlightTexture''
	--bu:SetPushedTexture''
	if bu:GetPushedTexture() then
		bu:GetPushedTexture():SetDrawLayer('OVERLAY',2)
	end

	bu:HookScript('OnEnter', function()
		if hover then
			ToggleHighlight(bu, true)
		end
	end)
	bu:HookScript('OnLeave', function()
		if hover then
			ToggleHighlight(bu, false)
		end
	end)
end

local FadeIn = function(frame)
	if not InCombatLockdown() then
		UIFrameFadeIn(frame, .2, frame:GetAlpha(), 1)
	else
		frame:SetAlpha(1)
	end
end

local FadeOut = function(frame)
	if not InCombatLockdown() then
		UIFrameFadeOut(frame, .2, frame:GetAlpha(), .2)
	else
		frame:SetAlpha(.2)
	end
end

local FadeHandler = function(frame)
	if frame._faded then
		FadeIn(frame)
		for _, button in next, frame._buttonList do
			FadeIn(button)
		end
		frame._faded = false
	else
		FadeOut(frame)
		for _, button in next, frame._buttonList do
			FadeOut(button)
		end
		frame._faded = true
	end
end

local SubFadeHandler = function(frame)
  if not frame._parent then return end
  FadeHandler(frame._parent)
end

local FadeFrame = function(frame)
	frame:EnableMouse(true)
	frame:HookScript('OnEnter', FadeHandler)
	frame:HookScript('OnLeave', FadeHandler)
	FadeHandler(frame)
end

function F:FadeButtonFrame(frame)
	if not frame then return end
	FadeFrame(frame)
	if not frame._buttonList then return end
	for _, button in next, frame._buttonList do
		if not button._parent then
			button._parent = frame
			button:HookScript('OnEnter', SubFadeHandler)
			button:HookScript('OnLeave', SubFadeHandler)
		end
	end
end
