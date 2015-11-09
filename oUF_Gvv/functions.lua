local ADDON_NAME, ns = ...

function ns.PostUpdateHealth(Health, unit, cur, max)
	local self = Health:GetParent()
	local perc = floor(cur / max * 100)
	
	if self.Portrait then
		UpdatePortraitColor(self, unit)
	end
	
	-- TODO: use the new alpha animation in wod--
	if self.bse then
		if perc <= 50 and cur > 1 then
			self.bse:SetAlpha(1 - perc / 100)
		else
			self.bse:SetAlpha(0)
		end
	end
	
	if Health.lowHP then
		if perc <= 50 and cur > 1 then
			Health.lowHP.animation:Play()
		else
			Health.lowHP.animation:Stop()
		end
	end
	
	if not cur then
		cur = UnitHealth(unit)
		max = UnitHealthMax(unit) or 1
	end
	
	if UnitIsDeadOrGhost(unit) then
		Health:SetValue(0)
		Health.Value:SetText(nil)
		--return
	end
	
	if ( unit == 'target' or unit == 'focus' or unit == 'targettarget' or unit == 'focustarget') then
		if cur > 1 and (cur < max or (not ns.C.ahfHPtext)) then
			Health.Value:SetText(format('%s', ns.FormatValue(cur)))
		else
			Health.Value:SetText(nil)
		end
		if self.tcover and ns.C.ei > 0 and unit == 'target' then
			if perc <= ns.C.ei and cur > 1 then
				self.tcover:SetVertexColor(0.8, 0.0, 0.0)
			else
				self.tcover:SetVertexColor(0.0, 0.0, 0.0)
			end
		end
	elseif unit == 'pet' then
		Health.Value:SetText(format('%s', ns.FormatValue(cur)))
	elseif unit == 'player' or unit == 'vehicle' then
		if GetCVar("statusTextDisplay") == "PERCENT" then
			Health.Value:SetText(format('%d%%', perc))
		elseif GetCVar("statusTextDisplay") == "BOTH" then
			Health.Value:SetText(format('%s/%d%%', ns.FormatValue(cur), perc))
		else
			Health.Value:SetText(format('%s', BreakUpLargeNumbers(cur)))
		end
	else
		Health.Value:SetText(nil)
	end
end

function ns.UpdatePower(self, unit, cur, max)
	if not self.value then return end

	if max == 0 then
		self.value:SetText(nil)
		return
	end

	if UnitIsDeadOrGhost(unit) then
		self:SetValue(0)
		self.value:SetText(nil)
		return
	end
	
	if (cur < max or (not ns.C.ahfMPtext)) and cur > 0 then
		self.value:SetText(format('%s', ns.FormatValue(cur)))
	else
		self.value:SetText(nil)
	end

end

function ns.CreateFontString(parent, size, justify, outline)
	local fs = parent:CreateFontString(nil, "ARTWORK")
	fs:SetFont('Interface\\Addons\\oUF_Gvv\\fonts\\menomonia.ttf', size, outline)
	fs:SetJustifyH(justify or "CENTER")
	--fs:SetShadowOffset(1, -1)
	fs.basesize = size 
	if outline and type(outline) == 'string' then
		fs.ignoreOutline = true
	end

	--tinsert(ns.fontstrings, fs)
	return fs
end

function ns.CreateAlphaAnimation(self, change, duration, loopType)
	self.animation = self:CreateAnimationGroup()
	self.animation:SetLooping(loopType or "BOUNCE")
	local glowAnimation = self.animation:CreateAnimation("ALPHA")
	glowAnimation:SetDuration(duration or 1)
	glowAnimation:SetChange(change)
end

function ns.FormatValue(value)
	local absvalue = abs(value)

	if absvalue >= 1e10 then
		return format('%.1f', value/1e9)..'b'
	elseif absvalue >= 1e9 then
		return format('%.2f', value/1e9)..'b'
	elseif absvalue >= 1e7 then
		return format('%.1f', value/1e6)..'m'
	elseif absvalue >= 1e6 then
		return format('%.2f', value/1e6)..'m'
	elseif absvalue >= 1e5 then
		return format('%.0f', value/1e3)..'k'
	elseif absvalue >= 1e3 then
		return format('%.1f', value/1e3)..'k'
	else
		return format('%i', value)
	end
end

function ns.CreateAura(self, unit)
	local frame = CreateFrame("Frame", nil, self)
	if unit == 'target' then
		local iconsperrow = math.floor(300 / ns.C.tbIconSize) -- max width of icon zone
		local rows = math.floor(100 / ns.C.tbIconSize)  -- max height of icon zone TODO:put these to config?
		frame:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -103)
		frame:SetWidth(ns.C.tbIconSize * iconsperrow + 4 * (iconsperrow - 1))
		frame:SetHeight(ns.C.tbIconSize * rows + 4 * (rows - 1))
		frame["growth-x"] = "RIGHT"
		frame["growth-y"] = "DOWN"
		frame["initialAnchor"] = "TOPLEFT"
		frame["size"] = ns.C.tbIconSize
		--well, not using this for now
	--[[elseif unit == 'player' then
		frame:SetPoint("LEFT", self, "RIGHT", 15, 75)
		frame:SetWidth(20 * 9 + 4 * 8)
		frame:SetHeight(20 * 3 + 4 * 2)
		frame["growth-x"] = "RIGHT"
		frame["growth-y"] = "UP"
		frame["initialAnchor"] = "BOTTOMLEFT"
		frame["size"] = 20]]
	elseif unit == 'party' then
		frame:SetPoint("TOPLEFT", self.Portrait, "TOPRIGHT", 5, 0)
		frame:SetWidth(15 * 5 + 4 * 4)
		frame:SetHeight(15 * 4 + 4 * 3)
		frame["growth-x"] = "RIGHT"
		frame["growth-y"] = "DOWN"
		frame["initialAnchor"] = "TOPLEFT"
		frame["size"] = 15
	end
	frame["num"] = 32
	frame["spacing-x"] = 4
	frame["spacing-y"] = 4
	frame.showStealableBuffs = true
	frame.onlyShowPlayer = ns.C.onlyShowPlayer
	frame.disableCooldown = true
	frame.gap = true
	
	frame.PreUpdate = ns.AuraPreUpdate
	frame.PostCreateIcon = ns.CreateAuraIcon
	frame.PostUpdateIcon = ns.UpdateAuraIcon

	return frame
end

function ns.CreateAuraIcon (self, button)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetDrawLayer("BACKGROUND", -8)

	--[[button.overlay:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\aura_border')
	button.overlay:SetPoint("CENTER", button)
	button.overlay:SetDrawLayer("OVERLAY", 0)
	ns.AlwaysShow(button.overlay)]]--

	button.stealable:SetTexture('Interface\\Buttons\\UI-Button-Outline')
	button.stealable:SetDrawLayer("OVERLAY", 1)
	button.stealable:ClearAllPoints()
	button.stealable:SetSize(ns.C.tbIconSize + 3, ns.C.tbIconSize + 3)
	button.stealable:SetTexCoord(14 / 64, 50 / 64, 14 / 64, 50 / 64)
	button.stealable:SetPoint("CENTER", 0, 0)
	button.stealable:SetVertexColor(1.0, 0.82, 0.0)

	button.fg = CreateFrame('Frame', 'buttonfg', button)
	button.fg:SetAllPoints(button)
	button.fg:SetFrameLevel(5)

	button.timer = button.fg:CreateFontString('auratimer','OVERLAY')
	button.timer:SetFont('Interface\\Addons\\oUF_Gvv\\fonts\\menomonia.ttf', 12, "THINOUTLINE")
	button.timer:SetPoint("BOTTOM", button.fg, "BOTTOM", 0, 0)

	button.count:ClearAllPoints()
	button.count:SetPoint("TOPRIGHT", button.fg, "TOPRIGHT", 4, 4)
	button.count:SetFont('Interface\\Addons\\oUF_Gvv\\fonts\\menomonia.ttf', 12, "THINOUTLINE")
	
	hooksecurefunc(button.icon, "SetTexture", function(self, texture)
		local button = self:GetParent()
		if texture and strlen(texture) > 0 then
			button.timer:Show()
			button.count:Show()
		else
			button.timer:Hide()
			button.count:Hide()
		end
	end)
end

function ns.UpdateAuraIcon(self, unit, icon, index, offset)
	local _, _, _, _, _, duration, expirationTime, _, stealable = UnitAura(unit, index, icon.filter)
	local texture = icon.icon

	if not self.onlyShowPlayer then
		if (icon.owner == "player" or icon.owner == "vehicle" or icon.owner == "pet") and icon.isDebuff
			or (not icon.isDebuff and (stealable or icon.owner == "player" or icon.owner == "vehicle" or icon.owner == "pet")) then
			icon:SetAlpha(1)
		else
			--texture:SetDesaturated(true)
			icon:SetAlpha(ns.C.npbOpacity or 0.5)
		end
	end

	if duration and duration > 0 then
		icon.timer:Show()
		icon.expires = expirationTime
		icon:SetScript("OnUpdate", function(self, elapsed)
			self.elapsed = (self.elapsed or 0) + elapsed
			if self.elapsed < 0.1 then return end
			self.elapsed = 0
			local timeLeft = self.expires - GetTime()
			if timeLeft then
				if timeLeft > 0 and timeLeft <= 30 then
					if timeLeft > 10 then
						self.timer:SetTextColor(0.9, 0.9, 0.9)
					elseif timeLeft > 5 and timeLeft <= 10 then
						self.timer:SetTextColor(1, 0.75, 0.1)
					elseif timeLeft <= 5 then
						self.timer:SetTextColor(0.9, 0.1, 0.1)
					end
					self.timer:SetText(ns.TimeFormat(timeLeft))
				else
					self.timer:SetText(ns.TimeFormat(timeLeft))
				end
			end
		end)
	else
		icon.timer:Hide()
		icon:SetScript("OnUpdate", nil)
	end
end

function ns.AuraPreUpdate(self, unit)
	if UnitCanAssist("player", unit) then
		if GetCVar("showCastableBuffs") == "1" and GetCVar("showDispelDebuffs") == "1" then
			self.filter = "HELPFUL|HARMFUL|RAID"
		elseif GetCVar("showDispelDebuffs") == "1" then
			self.filter = "HARMFUL|RAID"
		elseif GetCVar("showCastableBuffs") == "1" then
			self.filter = "HELPFUL|RAID"
		else
			self.filter = nil
		end
	end
end

function ns.AlwaysShow(self)
	if not self then return end
	self:Show()
	self.Hide = self.Show
end

function ns.TimeFormat(s)
	if s then
		if s >= 86400 then
			return format(gsub(DAY_ONELETTER_ABBR, "[ .]", ""), floor(s / 86400 + 0.5))
		elseif s >= 3600 then
			return format(gsub(HOUR_ONELETTER_ABBR, "[ .]", ""), floor(s / 3600 + 0.5))
		elseif s >= 60 then
			return format(gsub(MINUTE_ONELETTER_ABBR, "[ .]", ""), floor(s / 60 + 0.5))
		elseif s >= 1 then
			return format(gsub(SECOND_ONELETTER_ABBR, "[ .]", ""), math.fmod(s, 60))
		end
		return format("%.1f", s)
	else
		return nil
	end
end

function UpdatePortraitColor(self, unit)
	if (not UnitIsConnected(unit)) then
		self.Portrait:SetVertexColor(0.5, 0.5, 0.5, 0.7)
	elseif (UnitIsDead(unit)) then
		self.Portrait:SetVertexColor(0.35, 0.35, 0.35, 0.7)
	elseif (UnitIsGhost(unit)) then
		self.Portrait:SetVertexColor(0.3, 0.3, 0.9, 0.7)
	else
		self.Portrait:SetVertexColor(1, 1, 1, 1)
	end
end

-- TAGS. Mostly copied from official oUF tags.--
oUF.Tags.Methods['Gvv:nextlevel'] = function()
	local l = UnitLevel('player')
	local maxLevel
	if IsTrialAccount() then
		maxLevel = select(1, GetRestrictedAccountData())
	else
		maxLevel = GetMaxPlayerLevel()
	end
	if l < maxLevel then
		return (l + 1)
	else
		return l
	end
end
oUF.Tags.Events['Gvv:nextlevel'] = 'UNIT_LEVEL PLAYER_LEVEL_UP'

oUF.Tags.Methods['Gvv:classification'] = function(unit)
	local c = UnitClassification(unit)
	if(c == 'rare') then
		return ns.L['Rare ']
	elseif(c == 'rareelite') then
		return ns.L['RareElite ']
	elseif(c == 'elite') then
		return ns.L['Elite ']
	elseif(c == 'worldboss') then
		return ns.L['Boss ']
	elseif(c == 'minus') then
		return ns.L['Minus ']
	end
end
oUF.Tags.Events['Gvv:classification'] = 'UNIT_CLASSIFICATION_CHANGED'

oUF.Tags.Methods['Gvv:namecolor'] = function(u)
	local reaction = UnitReaction('player', u)
	if (UnitIsTapped(u) and (not UnitIsTappedByPlayer(u))) then
		return '|cFFDCDCDC'
	else
		if(reaction) then
			if(UnitIsDead(u) or UnitIsGhost(u)) then
				return '|cFFDCDCDC'
			elseif(not UnitIsConnected(u)) then
				return '|cFFBABABA'
			elseif(reaction == 3) then
				return '|cFFFFB155'
			elseif(reaction == 4) then
				return '|cFFFFF000'
			elseif(reaction >= 5) then
				return '|cFF14D900'
			else
				return '|cFFCC4D4D'
			end
		end
	end
	return '|cFFBABABA'
end
oUF.Tags.Events['Gvv:namecolor'] = 'UNIT_HEALTH UNIT_CONNECTION'

oUF.Tags.Methods['Gvv:raidrole'] = function(unit)
	if(UnitInRaid(unit)) then
		if(GetPartyAssignment('MAINTANK', unit)) then
			return ns.L[' MT']
		elseif(GetPartyAssignment('MAINASSIST', unit)) then
			return ns.L[' MA']
		end
	end
end
oUF.Tags.Events['Gvv:raidrole'] = 'GROUP_ROSTER_UPDATE'

oUF.Tags.Methods['Gvv:a'] = function(u)
	if(UnitIsGroupAssistant(u)) then
		return ns.L[' A']
	end
end
oUF.Tags.Events['Gvv:a'] = 'GROUP_ROSTER_UPDATE'

oUF.Tags.Methods['Gvv:lfdrole'] = function(u)
	local role = UnitGroupRolesAssigned(u)
	if(role == 'TANK') then
		return ns.L[' Tank']
	elseif (role == 'HEALER') then
		return ns.L[' Healer']
	elseif (role == 'DAMAGER') then
		return ns.L[' Damager']
	end
end
oUF.Tags.Events['Gvv:lfdrole'] = 'GROUP_ROSTER_UPDATE'

oUF.Tags.Methods['Gvv:theone'] = function(u)
	if GetLocale == 'zhCN' then
		local n, r = UnitName(u)
		local rn = GetRealmName()
		if (rn == '艾莫莉丝') then
			if n == '奈漠' then
				return '|cFFFFD200牛逼闪闪的作者|r·'
			end
		else
			if (n == '奈漠' and r == '艾莫莉丝') then
				return '|cFFFFD200牛逼闪闪的作者|r·'
			end
		end
	end
end
oUF.Tags.Events['Gvv:theone'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['Gvv:masterlooter'] = function(u)
	if (IsMasterLooter(u)) then
		return ns.L[' Looter']
	end
end
oUF.Tags.Events['Gvv:masterlooter'] = 'PARTY_LOOT_METHOD_CHANGED GROUP_ROSTER_UPDATE'

oUF.Tags.Methods['Gvv:currested'] = function()
	local currested = GetXPExhaustion()
	if (currested) then
		return '(+' .. currested .. ')'
	end
end
oUF.Tags.Events['Gvv:currested'] = 'UPDATE_EXHAUSTION'