--Player buff by lightspark(http://www.wowinterface.com/forums/member.php?action=getinfo&userid=301665)
--Modified by Raka from LotC.cc
local _, ns = ...
local C = ns.C

function ns.SetDurationText(duration, arg1, arg2)
	duration:SetText(format(gsub(arg1, "[ .]", ""), arg2))
end

local function UpdateBuffAnchors()
	local numBuffs, slack = 0, 0
	local button, previous, above

	if IsInGroup() and GetCVarBool("consolidateBuffs") then
		slack = 1
	end

	for i = 1, BUFF_ACTUAL_DISPLAY do
		button = _G["BuffButton"..i]

		if not button.consolidated then
			numBuffs = numBuffs + 1
			index = numBuffs + slack

			if button.parent ~= BuffFrame then
				button.count:SetFont(C.normalFont, 12, "THINOUTLINE")
				button:SetParent(BuffFrame)
				button.parent = BuffFrame
			end

			button:ClearAllPoints()
			button:SetSize(C.buffIconSize, C.buffIconSize)

			if index > 1 and (mod(index, 12) == 1) then
				if index == 13 then
					button:SetPoint("BOTTOM", ConsolidatedBuffs, "TOP", 0, 4)
				else
					button:SetPoint("BOTTOM", above, "TOP", 0, 4)
				end

				above = button
			elseif index == 1 then
				button:SetPoint("BOTTOMLEFT", BuffFrame, "BOTTOMLEFT", 0, 0)

				above = button
			else
				if numBuffs == 1 then
					button:SetPoint("LEFT", ConsolidatedBuffs, "RIGHT", 2, 0)
				else
					button:SetPoint("LEFT", previous, "RIGHT", 2, 0)
				end
			end

			previous = button
		end
	end
end

local function UpdateDebuffAnchors(buttonName, index)
	local rows = ceil(BUFF_ACTUAL_DISPLAY / 12)
	local button = _G[buttonName..index]

	button:ClearAllPoints()
	button:SetSize(C.buffIconSize, C.buffIconSize)

	if index == 1 then
		button:SetPoint("BOTTOMLEFT", dheader, "BOTTOMLEFT", 0, 0)
	else
		button:SetPoint("LEFT", _G[buttonName..(index - 1)], "RIGHT", 2, 0)
	end
end

function ns.UpdateTemporaryEnchantAnchors(self)
	local previous
	for i = 1, NUM_TEMP_ENCHANT_FRAMES do
		local button = _G["TempEnchant"..i]
		if button then
			button:ClearAllPoints()
			button:SetSize(C.buffIconSize, C.buffIconSize)

			if i == 1 then
				button:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
			else
				button:SetPoint("RIGHT", previous, "LEFT", -2, 0)
			end

			previous = button
		end
	end
end

function ns.SetAuraButtonStyle(btn, index, atype)
	local name = btn..(index or "")
	local button = _G[name]

	if not button then return end
	if button.styled then return end

	local bBorder = _G[name.."Border"]
	local bIcon = _G[name.."Icon"]
	local bCount = _G[name.."Count"]
	local bDuration = _G[name.."Duration"]

	if bIcon then
		if atype == "CONSOLIDATED" then
			bIcon:SetSize(C.buffIconSize, C.buffIconSize)
			bIcon:SetTexCoord(18 / 128, 46 / 128, 18 / 64, 46 / 64)
		end
	end

	if bCount then
		bCount:SetFont(C.normalFont, 12, "THINOUTLINE")
		bCount:ClearAllPoints()
		bCount:SetPoint("TOPRIGHT", 0, 0)
	end

	if bDuration then
		bDuration:SetFont(C.normalFont, 12, "THINOUTLINE")
		bDuration:ClearAllPoints()
		bDuration:SetPoint("BOTTOM", button, "BOTTOM", 0, 0)
		hooksecurefunc(bDuration, "SetFormattedText", ns.SetDurationText)
	end
	
	if bBorder then
		bBorder:Hide()
	end

	button.styled = true
end

if ns.C.useBuffframe then
	local bp = CreateFrame('Frame', nil)
	bp:RegisterEvent('PLAYER_ENTERING_WORLD')
	local function bpeh(self, event)
		local BuffFrame = _G["BuffFrame"]
		local ConsolidatedBuffs = _G["ConsolidatedBuffs"]

		local bheader = CreateFrame("Frame", "bheader", UIParent)
		bheader:SetSize(C.buffIconSize, C.buffIconSize)
		bheader:SetPoint("BOTTOM", "UIParent", "BOTTOM", C.bframeX, C.bframeY)

		local dheader = CreateFrame("Frame", "dheader", UIParent)
		dheader:SetSize(C.buffIconSize, C.buffIconSize)
		dheader:SetPoint("BOTTOM", "UIParent", "BOTTOM", C.bframeX, C.bframeY + 4 + 2 * C.buffIconSize)

		local theader = CreateFrame("Frame", "theader", UIParent)
		theader:SetSize(C.buffIconSize, C.buffIconSize)
		theader:SetPoint("BOTTOM", "UIParent", "BOTTOM", C.bframeX - 5, C.bframeY + C.buffIconSize)
		
		
		BuffFrame:SetParent(bheader)
		BuffFrame:ClearAllPoints()
		BuffFrame:SetPoint("BOTTOMLEFT", 0, 0)
		
		ConsolidatedBuffs:SetParent(bheader)
		ConsolidatedBuffs:ClearAllPoints()
		ConsolidatedBuffs:SetSize(C.buffIconSize, C.buffIconSize)
		ConsolidatedBuffs:SetPoint("BOTTOMLEFT", 0, 0)
		
		TemporaryEnchantFrame:SetParent(theader)
		TemporaryEnchantFrame:ClearAllPoints()
		TemporaryEnchantFrame:SetPoint("BOTTOMLEFT", 0, 0)
		
		ConsolidatedBuffsTooltip:SetScale(1)
	end
	bp:SetScript('OnEvent', bpeh)
	
	local bf = CreateFrame('Frame', nil)
	bf:RegisterEvent('UNIT_AURA')
	local function bfeh(self, event, unit)
		if string.lower(unit) == 'player' then
			ns.UpdateTemporaryEnchantAnchors(theader)

			for i = 1, NUM_TEMP_ENCHANT_FRAMES do
				ns.SetAuraButtonStyle("TempEnchant", i, "TEMPENCHANT")
			end

			ns.SetAuraButtonStyle("ConsolidatedBuffs", nil, "CONSOLIDATED")
		end
	end
	bf:SetScript('OnEvent', bfeh)
	
	hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffAnchors)
	hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffAnchors)
	hooksecurefunc("AuraButton_Update", ns.SetAuraButtonStyle)
end