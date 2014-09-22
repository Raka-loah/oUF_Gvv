local _, ns = ...

function ns.PostUpdateHealth(Health, unit, cur, max)
	if Health.lowHP then
		local perc = floor(cur / max * 100)
		if perc <= 35 and cur > 1 then
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
		return
	end
	
	if (unit == 'target' or unit == 'focus' or unit == 'targettarget' or unit == 'focustarget') then
		local reaction = UnitReaction('player', unit)
		if(reaction) then
			if(reaction == 3) then
				Health:SetStatusBarColor(1.0, 177/255, 85/255)
			elseif(reaction == 4) then
				Health:SetStatusBarColor(1.0, 240/255, 0)
			elseif(reaction > 4) then
				Health:SetStatusBarColor(20/255, 217/255, 0)
			else
				Health:SetStatusBarColor(0.95, 0.15, 0)
			end
		else
			Health:SetStatusBarColor(0.95, 0.15, 0)
		end
		
		if (cur > 1 and cur < max) then
			Health.Value:SetText(format('%s', BreakUpLargeNumbers(cur)))
		else
			Health.Value:SetText(nil)
		end
	elseif (unit == 'pet') then
		Health.Value:SetText(format('%s', ns.FormatValue(cur)))
	else
		Health.Value:SetText(format('%s', BreakUpLargeNumbers(cur)))
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
	
	if (cur < max and cur > 0) then
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
	frame:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -100)
	frame:SetWidth(20 * 14 + 4 * 13)
	frame:SetHeight(20 * 3 + 4 * 2)

	frame["growth-x"] = "RIGHT"
	frame["growth-y"] = "DOWN"
	frame["initialAnchor"] = "TOPLEFT"
	frame["num"] = 32
	frame["size"] = 20
	frame["spacing-x"] = 4
	frame["spacing-y"] = 4
	frame.showStealableBuffs = true

	frame.PreUpdate = ns.AuraPreUpdate
	frame.PostCreateIcon = ns.CreateAuraIcon
	frame.PostUpdateIcon = ns.UpdateAuraIcon

	return frame
end

function ns.CreateAuraIcon (self, button)
	button.cd:SetReverse()
	button.cd:SetPoint("TOPLEFT", 2, -2)
	button.cd:SetPoint("BOTTOMRIGHT", -2, 2)

	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetDrawLayer("BACKGROUND", -8)

	--[[button.overlay:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\aura_border')
	button.overlay:SetPoint("CENTER", button)
	button.overlay:SetDrawLayer("OVERLAY", 0)
	ns.AlwaysShow(button.overlay)]]--

	button.stealable:SetTexture('Interface\\Buttons\\UI-Button-Outline')
	button.stealable:SetDrawLayer("OVERLAY", 1)
	button.stealable:ClearAllPoints()
	button.stealable:SetSize(28, 28)
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
end

function ns.UpdateAuraIcon(self, unit, icon, index, offset)
	local _, _, _, _, _, duration, expirationTime, _, stealable = UnitAura(unit, index, icon.filter)
	local texture = icon.icon

	if not self.onlyShowPlayer then
		if (icon.owner == "player" or icon.owner == "vehicle" or icon.owner == "pet") and icon.isDebuff
			or (not icon.isDebuff and (stealable or icon.owner == "player" or icon.owner == "vehicle" or icon.owner == "pet")) then
			texture:SetDesaturated(false)
			icon:SetAlpha(1)
		else
			texture:SetDesaturated(true)
			icon:SetAlpha(0.75)
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
	if s >= 86400 then
		return format(gsub(DAY_ONELETTER_ABBR, "[ .]", ""), floor(s / 86400 + 0.5))
	elseif s >= 3600 then
		return format(gsub(ONELETTER_ABBR, "[ .]", ""), floor(s / 3600 + 0.5))
	elseif s >= 60 then
		return format(gsub(MINUTE_ONELETTER_ABBR, "[ .]", ""), floor(s / 60 + 0.5))
	elseif s >= 1 then
		return format(gsub(SECOND_ONELETTER_ABBR, "[ .]", ""), math.fmod(s, 60))
	end
	return format("%.1f", s)
end

-- TAGS. Mostly copied from official oUF tags.--
oUF.Tags.Methods['Gvv:nextlevel'] = function(unit)
	local l = UnitLevel(unit)
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
oUF.Tags.Events['Gvv:nextlevel'] = 'PLAYER_LEVEL_UP'

oUF.Tags.Methods['Gvv:classification'] = function(unit)
	local c = UnitClassification(unit)
	if(c == 'rare') then
		return '稀有 '
	elseif(c == 'rareelite') then
		return '稀有精英 '
	elseif(c == 'elite') then
		return '精英 '
	elseif(c == 'worldboss') then
		return '头目 '
	elseif(c == 'minus') then
		return '杂兵 '
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
			end
		end
	end
	return '|cFFCC4D4D'
end
oUF.Tags.Events['Gvv:namecolor'] = 'UNIT_HEALTH UNIT_CONNECTION'

oUF.Tags.Methods['Gvv:leader'] = function(u)
	if(UnitIsGroupLeader(u)) then
		return '·统领'
	end
end
oUF.Tags.Events['Gvv:leader'] = 'PARTY_LEADER_CHANGED'

oUF.Tags.Methods['Gvv:raidrole'] = function(unit)
	if(UnitInRaid(unit)) then
		if(GetPartyAssignment('MAINTANK', unit)) then
			return '·主坦克'
		elseif(GetPartyAssignment('MAINASSIST', unit)) then
			return '·MA'
		end
	end
end
oUF.Tags.Events['Gvv:raidrole'] = 'GROUP_ROSTER_UPDATE'

oUF.Tags.Methods['Gvv:a'] = function(u)
	if(UnitIsGroupAssistant(u)) then
		return '·A'
	end
end
oUF.Tags.Events['Gvv:a'] = 'GROUP_ROSTER_UPDATE'

oUF.Tags.Methods['Gvv:lfdrole'] = function(u)
	local role = UnitGroupRolesAssigned(u)
	if(role == 'TANK') then
		return '·坦克'
	elseif (role == 'HEALER') then
		return '·治疗'
	elseif (role == 'DAMAGER') then
		return '·输出'
	end
end
oUF.Tags.Events['Gvv:lfdrole'] = 'GROUP_ROSTER_UPDATE'

oUF.Tags.Methods['Gvv:theone'] = function(u)
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
oUF.Tags.Events['Gvv:theone'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['Gvv:currested'] = function()
	local currested = GetXPExhaustion()
	if (currested) then
		return '(+' .. currested .. ')'
	end
end
oUF.Tags.Events['Gvv:currested'] = 'UPDATE_EXHAUSTION'