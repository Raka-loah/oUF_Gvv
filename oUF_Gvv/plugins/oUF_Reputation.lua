local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF Reputation was unable to locate oUF install')

local function GetReputation()
	local name, standing, min, max, value, id = GetWatchedFactionInfo()
	local _, friendMin, friendMax, _, _, _, friendStanding, friendThreshold = GetFriendshipReputation(id)

	if(not friendMin) then
		return value - min, max - min, GetText('FACTION_STANDING_LABEL' .. standing, UnitSex('player'))
	else
		return friendMin - friendThreshold, math.min(friendMax - friendThreshold, 8400), friendStanding
	end
end

for tag, func in next, {
	['currep'] = function()
		local min = GetReputation()
		return min
	end,
	['maxrep'] = function()
		local _, max = GetReputation()
		return max
	end,
	['perrep'] = function()
		local min, max = GetReputation()
		return math.floor(min / max * 100 + 1/2)
	end,
	['standing'] = function()
		local _, _, standing = GetReputation()
		return standing
	end,
	['reputation'] = function()
		return GetWatchedFactionInfo()
	end,
} do
	oUF.Tags.Methods[tag] = func
	oUF.Tags.Events[tag] = 'UPDATE_FACTION'
end

oUF.Tags.SharedEvents.UPDATE_FACTION = true

local function Update(self, event, unit)
	local element = self.Reputation

	local name, standingID, _, _, _, id = GetWatchedFactionInfo()
	if(not name) then
		return element:Hide()
	else
		element:Show()
	end

	local min, max, standingText = GetReputation()
	element:SetMinMaxValues(0, max)
	element:SetValue(min)

	if(element.colorStanding) then
		local color = FACTION_BAR_COLORS[standingID]
		element:SetStatusBarColor(color.r, color.g, color.b)
	end

	if(element.PostUpdate) then
		return element:PostUpdate(unit, min, max, name, id, standingID, standingText)
	end
end

local function Path(self, ...)
	return (self.Reputation.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.Reputation
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UPDATE_FACTION', Path)

		if(not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		return true
	end
end

local function Disable(self)
	if(self.Reputation) then
		self:UnregisterEvent('UPDATE_FACTION', Path)
	end
end

oUF:AddElement('Reputation', Path, Enable, Disable)
