local E, F, C = unpack(select(2, ...))

-- much love to obble. <3

local layout    = {
	  ['player|HELPFUL']  = {
		   template			 = 'LynBuffTemplate',
			point           = 'TOPRIGHT',
			sort            = 'TIME',
			minWidth        = 330,
			minHeight       = 100,
			x               = -38,
			y               = 0,
			wrapAfter       = 20,
			wrapY           = -40,
			direction       = '+',
			position        = {
				 'TOPRIGHT',
				 -250,
				 -30,
			},
	  },
	  ['player|HARMFUL']  = {
		   template			 = 'LynDebuffTemplate',
			point           = 'TOPRIGHT',
			sort            = 'TIME',
			minWidth        = 330,
			minHeight       = 100,
			x               = -55,
			wrapAfter       = 10,
			wrapY           = -50,
			direction       = '+',
			position        = {
				 'TOPRIGHT',
				 -250,
				 -180,
			},
	  },
	  ['weapons|NA']      =   {
		   template			 = 'LynBuffTemplate',
			xOffset         = 40,
			position        = {
				 'TOPRIGHT',
				 -300,
				 -200,
			},
	  },
 }

 local function OnUpdate(self, elapsed)
	if  self.expiration then
		self.expiration = max(self.expiration - elapsed, 0)
		self:SetText(SecondsToTimeAbbrev(self.expiration))
	end
 end

 local FormatDebuffs = function(self, name, dtype)
	  if  name then
			local colour = DebuffTypeColor[dtype or 'none']
			self.Name:SetText''
			--[[
			self.Name:SetText(strupper(name))
			self.Name:SetTextColor(colour.r*1.7, colour.g*1.7, colour.b*1.7)    -- brighten up
			self.Name:SetWidth(120)
			self.Name:SetWordWrap(true)
			--]]
			self:SetBorderColor(colour.r, colour.g, colour.b, 1)
	  else
			self.Name:SetText''
			self:SetBorderColor(.2, .2, .2, 1)
	  end
 end

 local OnAttributeChanged = function(self, attribute, index)
	if attribute ~= 'index' then return end
	local header = self:GetParent()
	local unit, filter = header:GetAttribute'unit', header:GetAttribute'filter'
	local name, _, icon, count, dtype, _, expiration = UnitAura(unit, index, filter)
	if  name then
		self:SetNormalTexture(icon)
		self.Count:SetText(count > 1 and count or '')
		self.expiration = expiration - GetTime()
			if filter == 'HARMFUL' then
				 FormatDebuffs(self, name, dtype)
			end
	end
 end

 local AddButton = function(self, name, bu)
	if not name:match'^child' then return end       -- ty p3lim

	F:SkinButton(bu, true)

	bu:SetScript('OnUpdate', OnUpdate)
	bu:SetScript('OnAttributeChanged', OnAttributeChanged)

	local icon = bu:CreateTexture('$parentTexture', 'BORDER')
	icon:SetPoint('TOPLEFT', 1.5, -1.5)
	icon:SetPoint('BOTTOMRIGHT', -1.5, 1.5)
	icon:SetTexCoord(.08, .92, .08, .92)

	local name = bu:CreateFontString('$parentName', nil, 'LynAuraNameFont')
	name:SetJustifyH'RIGHT'
	name:SetPoint('RIGHT', bu, 'LEFT', -15, 2)
	name:SetShadowOffset(1, -1)

	local d = bu:CreateFontString('$parentDuration', nil, 'LynAuraDurationFont')
	d:SetPoint('TOP', bu, 'BOTTOM', 0, -2)
	d:SetShadowOffset(1, -1)

	local count = bu:CreateFontString('$parentCount', nil, 'LynAuraCountFont')
	count:SetPoint('BOTTOMRIGHT', 2, 1)
	count:SetShadowOffset(1, -1)

	bu:SetFontString(d)
	bu:SetNormalTexture(icon)
	bu.Count = count
	bu.Name  = name
 end

 local AddHeader = function(unit, filter, attribute)
		local Header = CreateFrame('Frame', 'LynAura'..filter, UIParent, 'SecureAuraHeaderTemplate')
		Header:SetAttribute('template',         attribute.template)
		Header:SetAttribute('unit',             unit)
		Header:SetAttribute('filter',           filter)
		Header:SetAttribute('includeWeapons',   1)
		Header:SetAttribute('xOffset',          attribute.x)
		Header:SetPoint(unpack(attribute.position))

		if  unit ~= 'weapons' then
			Header:SetAttribute('sortDirection',    attribute.direction)
			Header:SetAttribute('sortMethod',       attribute.sort)
			Header:SetAttribute('sortDirection',    attribute.direction)
			Header:SetAttribute('point',            attribute.point)
			Header:SetAttribute('minWidth',         attribute.minWidth)
			Header:SetAttribute('minHeight',        attribute.minHeight)
			Header:SetAttribute('xOffset',          attribute.x)
			Header:SetAttribute('wrapYOffset',      attribute.wrapY)
			Header:SetAttribute('wrapAfter',        attribute.wrapAfter)
		end

		Header:HookScript('OnAttributeChanged', AddButton)
		Header:Show()

		RegisterAttributeDriver(Header, 'unit', '[vehicleui] vehicle; player')
 end

 local RemoveBuffFrame = function()
	  for _, v in pairs({TemporaryEnchantFrame, BuffFrame}) do
			v:UnregisterAllEvents()
			v:Hide()
	  end
 end

 function E:PLAYER_ENTERING_WORLD()
	  RemoveBuffFrame()
	  for i ,v in pairs(layout) do
			local unit, filter = i:match'(.-)|(.+)'
			if unit then
				 AddHeader(unit, filter, v)
			end
	  end
 end
