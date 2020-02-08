local gsub = string.gsub

local skin = function(self)
	local hotkey = _G[self:GetName()..'HotKey']
	local text = hotkey:GetText()

	text = gsub(text, '(s%-)', 'S')
	text = gsub(text, '(a%-)', 'A')
	text = gsub(text, '(c%-)', 'C')
	text = gsub(text, '(st%-)', 'C') -- german control 'Steuerung'

	for i = 1, 30 do
		 text = gsub(text, _G['KEY_BUTTON'..i], 'M'..i)
	end

	for i = 1, 9 do
		 text = gsub(text, _G['KEY_NUMPAD'..i], 'N'..i)
	end

	text = gsub(text, KEY_NUMPADDECIMAL, 'N.')
	text = gsub(text, KEY_NUMPADDIVIDE, 'N/')
	text = gsub(text, KEY_NUMPADMINUS, 'N')
	text = gsub(text, KEY_NUMPADMULTIPLY, 'N*')
	text = gsub(text, KEY_NUMPADPLUS, 'N+')

	text = gsub(text, KEY_MOUSEWHEELUP, 'MU')
	text = gsub(text, KEY_MOUSEWHEELDOWN, 'MD')
	text = gsub(text, KEY_NUMLOCK, 'NuL')
	text = gsub(text, KEY_PAGEUP, 'PU')
	text = gsub(text, KEY_PAGEDOWN, 'PD')
	text = gsub(text, KEY_SPACE, '_')
	text = gsub(text, KEY_INSERT, 'Ins')
	text = gsub(text, KEY_HOME, 'Hm')
	text = gsub(text, KEY_DELETE, 'Del')

	text = gsub(text, ' ', '')

	hotkey:SetText(text)
end

hooksecurefunc('ActionButton_UpdateHotkeys', skin)
hooksecurefunc('ActionButton_Update', skin)
