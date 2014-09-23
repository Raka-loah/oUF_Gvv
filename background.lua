--[[
GvvUI Background
Create GW2-like borders and backgrounds
By Raka from LotC.cc
]]
local _, ns = ...

--Resolution detect
local rw, rh = string.match((({GetScreenResolutions()})[GetCurrentResolution()] or ""), "(%d+).-(%d+)")

--Borders--
if ns.C.drawBorders then
	local borders = {
		['lotc_border_top'] = {rw, 20, 'TOP', 0, 5, 0}, --width, height, anchor, offsetX, offsetY, layer
		['lotc_border_bottom'] = {rw, 20, 'BOTTOM', 0, -5, 0},
		['lotc_border_left'] = {20, rh, 'LEFT', -5, 0, 0},
		['lotc_border_right'] = {20, rh, 'RIGHT', 5, 0, 0},
		['lotc_border_bottomleft'] = {64, 32, 'BOTTOMLEFT', 0, 0, 1},
		['lotc_border_bottomright'] = {32, 32, 'BOTTOMRIGHT', 0, 0, 1}
	}
	local bframe = CreateFrame("Frame", nil, UIParent)
	bframe:SetFrameStrata("BACKGROUND")
	for k, v in pairs(borders) do
		local t = bframe:CreateTexture(nil, 'BACKGROUND', nil, v[6])
		t:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\' .. k)
		t:SetSize(v[1],v[2])
		t:SetPoint(v[3], 'UIParent', v[3], v[4], v[5])
	end
	bframe:Show()
end

--Combat Indicator--
local gvvci = CreateFrame('Frame', nil, UIParent)
gvvci:SetFrameStrata("BACKGROUND")
gvvci:SetFrameLevel(1)
local t = gvvci:CreateTexture(nil, 'BACKGROUND', nil, 0)
t:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\lotc_background_normal')
t:SetSize(1024, 128)
t:SetPoint('BOTTOM', 'UIParent', 'BOTTOM', 0, 10)
t:SetAlpha(0.8)
gvvci.ci = gvvci:CreateTexture(nil, 'BACKGROUND', nil, 1)
gvvci.ci:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\lotc_background_battle')
gvvci.ci:SetSize(1024, 256)
gvvci.ci:SetPoint('BOTTOM', 'UIParent', 'BOTTOM', 0, 0)
gvvci.ci:SetAlpha(0)
gvvci.ci.fadein = gvvci.ci:CreateAnimationGroup()
gvvci.ci.fadeout = gvvci.ci:CreateAnimationGroup()
gvvci.ci.fadein:SetLooping('NONE')
gvvci.ci.fadeout:SetLooping('NONE')
gvvci.ci.fadein:SetScript('OnFinished', 
	function()
		gvvci.ci:SetAlpha(1)
	end)
gvvci.ci.fadeout:SetScript('OnFinished', 
	function()
		gvvci.ci:SetAlpha(0)
	end)
local fadein = gvvci.ci.fadein:CreateAnimation('ALPHA')
fadein:SetDuration(1.5)
fadein:SetChange(1)
local fadeout = gvvci.ci.fadeout:CreateAnimation('ALPHA')
fadeout:SetDuration(1.5)
fadeout:SetChange(-1)
gvvci:RegisterEvent('PLAYER_REGEN_ENABLED')
gvvci:RegisterEvent('PLAYER_REGEN_DISABLED')
function eventHandler(self, event)
	if event == 'PLAYER_REGEN_ENABLED' then
		gvvci.ci.fadeout:Play()
	elseif event == 'PLAYER_REGEN_DISABLED' then
		gvvci.ci.fadein:Play()
	end
end
gvvci:SetScript("OnEvent", eventHandler);

