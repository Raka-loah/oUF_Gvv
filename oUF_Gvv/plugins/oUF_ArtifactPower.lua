--[[
# Element: ArtifactPower

Handles updating and visibility of a status bar that displays the player's artifact power.

## Widget

ArtifactPower - a `StatusBar` used to display the player's artifact power

## Options

.onAlpha  - alpha value of the widget when it is mouse-enabled and hovered (number [0-1])
.offAlpha - alpha value of the widget when it is mouse-enabled and not hovered (number [0-1])

## Notes

A default texture will be applied if the widget is a `StatusBar` and doesn't have a texture or color set.
`OnEnter` and `OnLeave` handlers to display a tooltip will be set on the widget, if it is mouse-enabled and the scripts
are not set by the layout.

## Examples

    -- Position and size
    local ArtifactPower = CreateFrame("StatusBar", nil, self)
    ArtifactPower:SetSize(200, 5)
    ArtifactPower:SetPoint("TOP", self, "BOTTOM")

    -- Enable the tooltip
    ArtifactPower:EnableMouse(true)

    -- Register with oUF
    self.ArtifactPower = ArtifactPower
--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--[[ Override: ArtifactPower:OnEnter()
Called when the mouse cursor enters the widget's interactive area.

* self - the ArtifactPower widget (StatusBar)
--]]
local function OnEnter(element)
	element:SetAlpha(element.onAlpha)
	GameTooltip:SetOwner(element)
	GameTooltip:SetText(element.name, HIGHLIGHT_FONT_COLOR:GetRGB())
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_TITLE:format(element.totalPower, element.power, element.powerForNextTrait), nil, nil, nil, true)
	GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(element.numTraitsLearnable), nil, nil, nil, true)
	GameTooltip:Show()
end

--[[ Override: ArtifactPower:OnEnter()
Called when the mouse cursor leaves the widget's interactive area.

* self - the ArtifactPower widget (StatusBar)
--]]
local function OnLeave(element)
	element:SetAlpha(element.offAlpha)
	GameTooltip_Hide()
end

local function Update(self, event, unit)
	if (unit and unit ~= self.unit) then return end

	local element = self.ArtifactPower
	--[[ Callback: ArtifactPower:PreUpdate(event)
	Called before the element has been updated.

	* self  - the ArtifactPower widget (StatusBar)
	* event - the event that triggered the update (string)
	--]]
	if (element.PreUpdate) then element:PreUpdate(event) end

	local show = HasArtifactEquipped() and not UnitHasVehicleUI('player')
	if (show) then
		local _, _, name, _, totalPower, traitsLearned, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
		local numTraitsLearnable, power, powerForNextTrait = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower, tier);

		element:SetMinMaxValues(0, powerForNextTrait)
		element:SetValue(power)

		element.name = name
		element.power = power
		element.powerForNextTrait = powerForNextTrait
		element.totalPower = totalPower
		element.numTraitsLearnable = numTraitsLearnable
		element.traitsLearned = traitsLearned
		element.tier = tier

		element:Show()
	else
		element:Hide()
	end

	--[[ Callback: ArtifactPower:PostUpdate(event, show)
	Called after the element has been updated.

	* self  - the ArtifactPower widget (StatusBar)
	* event - the event that triggered the update (string)
	* show  - true if the element is shown, false else (boolean)
	--]]
	if (element.PostUpdate) then
		return element:PostUpdate(event, show)
	end
end

local function Path(self, ...)
	--[[ Override: ArtifactPower:Override(event, ...)
	Used to completely override the element's update process.

	* self  - the ArtifactPower widget
	* event - the event that triggered the update
	* ...   - the arguments accompanying the event
	--]]
	return (self.ArtifactPower.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.ArtifactPower
	if (not element or unit ~= 'player') then return end

	element.__owner = self
	element.ForceUpdate = ForceUpdate

	if (element:IsObjectType('StatusBar') and not element:GetStatusBarTexture()) then
		element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		element:SetStatusBarColor(.901, .8, .601)
	end

	if (element:IsMouseEnabled()) then
		element.onAlpha = element.onAlpha or 1
		element.offAlpha = element.offAlpha or 1
		element:SetAlpha(element.offAlpha)
		if (not element:GetScript('OnEnter')) then
			element:SetScript('OnEnter', element.OnEnter or OnEnter)
		end
		if (not element:GetScript('OnLeave')) then
			element:SetScript('OnLeave', element.OnLeave or OnLeave)
		end
	end

	self:RegisterEvent('ARTIFACT_XP_UPDATE', Path, true)
	self:RegisterEvent('UNIT_INVENTORY_CHANGED', Path)

	return true
end

local function Disable(self)
	local element = self.ArtifactPower
	if (not element) then return end

	self:UnregisterEvent('ARTIFACT_XP_UPDATE', Path)
	self:UnregisterEvent('UNIT_INVENTORY_CHANGED', Path)
	element:Hide()
end

oUF:AddElement('ArtifactPower', Path, Enable, Disable)
