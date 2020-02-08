local E, F = unpack(select(2, ...))

local isMerchant
local numItems = 0

local SellTrashItems =  function()
	if not isMerchant then return end

	numItems = 0
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local _, _, _, quality = GetContainerItemInfo(bag, slot)
			if quality == LE_ITEM_QUALITY_POOR then
				numItems = numItems + 1
				UseContainerItem(bag, slot)
			end
		end
	end
end

function E:MERCHANT_SHOW()
	isMerchant = true
	if not IsShiftKeyDown() then
		SellTrashItems()
	end
end

function E:MERCHANT_CLOSED()
	isMerchant = false
end

function E:BAG_UPDATE_DELAYED()
	if numItems > 0 then
		SellTrashItems()
	end
end
