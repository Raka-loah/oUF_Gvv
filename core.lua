--[[
oUF_Gvv by Raka from LotC.cc
Please don't modify anything, very fragile.
Require oUF 1.6.x.
]]
local _, ns = ...

local function Gvv_Style(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	-- Frame layouts--
	if unit == 'player' then
		self:SetSize(128,128)
		self.orb = self:CreateTexture(nil, 'ARTWORK', nil, 0)
		self.orb:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_cover')
		self.orb:SetSize(128,128)
		self.orb:SetAllPoints(self)
	elseif unit == 'target' then
		self:SetSize(320,50)
		self.tcover = self:CreateTexture(nil, 'ARTWORK', nil, 0)
		self.tcover:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_target_cover')
		self.tcover:SetSize(256,16)
		self.tcover:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, -30)
		self.pback = self:CreateTexture(nil, 'BACKGROUND', nil, 0)
		self.pback:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\portrait_back')
		self.pback:SetSize(64,64)
		self.pback:SetPoint('RIGHT', self, 'RIGHT', 0, 0)
	elseif unit == 'pet' then
		self:SetSize(128,64)
	elseif unit == 'focus' or unit == 'targettarget' or unit == 'focustarget' then
		self:SetSize(180,40)
		self.tcover = self:CreateTexture(nil, 'ARTWORK', nil, 0)
		self.tcover:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_cover')
		self.tcover:SetSize(128,16)
		self.tcover:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, -20)
		self.pback = self:CreateTexture(nil, 'BACKGROUND', nil, 0)
		self.pback:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\portrait_back')
		self.pback:SetTexCoord(1,0,0,1)
		self.pback:SetSize(48,48)
		self.pback:SetPoint('LEFT', self, 'LEFT', 0, 0)
	end
	
	-- Health bar --
	self.Health = CreateFrame('StatusBar', 'healthbar', self)
	self.Health:SetFrameStrata('LOW')
	self.Health:SetFrameLevel(2)
	
	self.Health:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_filling')
	self.Health:SetStatusBarColor(0.95, 0.15, 0)
	self.Health.frequentUpdates = true
	self.Health.Smooth = true
	
	self.Health.PostUpdate = ns.PostUpdateHealth

	if (unit == 'player') then
		self.Health:SetSize(128, 128)
		self.Health:SetOrientation('VERTICAL')
		self.Health:SetStatusBarColor(0.95, 0.15, 0)
		self.Health:SetPoint('CENTER')
	elseif (unit == 'pet') then
		self.Health:SetSize(80, 6)
		self.Health:SetPoint('LEFT', self, 'LEFT', 12, 8)
		self.Health:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
		self.Health:SetOrientation('HORIZONTAL')
		self.Health:SetStatusBarColor(0.95, 0.15, 0)
		self.petback = self.Health:CreateTexture(nil, 'BACKGROUND', nil, 0)
		self.petback:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_back')
		self.petback:SetSize(128,64)
		self.petback:SetAllPoints(self)
		self.pethc = self:CreateTexture(nil, 'BACKGROUND', nil, 0)
		self.pethc:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_cover')
		self.pethc:SetSize(80,6)
		self.pethc:SetAllPoints(self.Health)
	elseif (unit == 'target') then
		self.Health:SetSize(256, 16)
		self.Health:SetStatusBarColor(0.95, 0.15, 0)
		self.Health:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_target_filling')
		self.Health:SetOrientation('HORIZONTAL')
		self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, -30)
	elseif (unit == 'focus' or unit == 'targettarget' or unit == 'focustarget') then
		self.Health:SetSize(128, 16)
		self.Health:SetStatusBarColor(0.95, 0.15, 0)
		self.Health:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
		self.Health:SetOrientation('HORIZONTAL')
		self.Health:SetPoint('CENTER',self.tcover)
	end

	if (unit == 'player') then
		self.Health.Value = ns.CreateFontString(self, 18, 'CENTER')
		self.Health.Value:SetTextColor(1.0, 1.0, 1.0)
		self.Health.Value:SetPoint('CENTER', self, 0, 0)
	elseif (unit == 'target') then
		self.Health.Value = ns.CreateFontString(self, 14, 'RIGHT')
		self.Health.Value:SetTextColor(1.0, 1.0, 1.0)
		self.Health.Value:SetPoint('RIGHT', self.tcover, 'RIGHT', -5, 0)
	elseif (unit == 'pet') then
		self.Health.Value = self:CreateFontString()
		self.Health.Value:SetFont('Interface\\Addons\\oUF_Gvv\\fonts\\digital.ttf', 16, 'THINOUTLINE')
		self.Health.Value:SetTextColor(1.0, 1.0, 1.0)
		self.Health.Value:SetJustifyH('LEFT')
		self.Health.Value:SetPoint('LEFT', self.Health, 'RIGHT', 5, 1)
	else
		self.Health.Value = ns.CreateFontString(self, 14, 'CENTER')
		self.Health.Value:SetPoint('RIGHT', self.tcover, 'RIGHT', -5, 0)
	end
	
	if (unit == 'player') then
		self.Health.lowHP = self.Health:CreateTexture(nil, 'BACKGROUND', nil, -7)
		self.Health.lowHP:SetTexture('Interface\\AddOns\\oUF_Gvv\\textures\\health_filling')
		self.Health.lowHP:SetSize(128, 128)
		self.Health.lowHP:SetPoint('CENTER')
		self.Health.lowHP:SetVertexColor(1.0, 1.0, 1.0)
		self.Health.lowHP:SetAlpha(0)
		ns.CreateAlphaAnimation(self.Health.lowHP, 1)
	end
	
	-- Power Bar --
	self.Power = CreateFrame('StatusBar', nil, self)
	self.Power:SetFrameStrata('LOW')
	self.Power:SetFrameLevel(3)
	self.Power:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\power_filling')
	self.Power:SetStatusBarColor(0.95, 0.85, 0)
	self.Power:SetOrientation('HORIZONTAL')
	self.Power.colorDisconnected = true
	if unit == 'player' then		
		self.cbar = self:CreateTexture(nil, 'ARTWORK', nil, 0)
		self.cbar:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\power_cover')
		self.cbar:SetSize(128,64)
		self.cbar:SetPoint('BOTTOM',self,'BOTTOM',0,91)
		self.Power:SetSize(125, 64)
		self.Power:SetPoint('CENTER',self.cbar)
	elseif unit == 'pet' then
		self.Power:SetSize(80, 6)
		self.Power:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
		self.Power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -3)
		self.petpc = self:CreateTexture(nil, 'BACKGROUND', nil, 0)
		self.petpc:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_cover')
		self.petpc:SetSize(80, 6)
		self.petpc:SetAllPoints(self.Power)
		--self.Power.colorPower = true
	elseif unit == 'target' then
		self.Power:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
		self.Power:SetStatusBarColor(0.95, 0.85, 0)
		self.Power:SetSize(252, 4)
		self.Power:SetPoint('TOP',self.Health,'BOTTOM',0,-1)
	elseif (unit == 'focus' or unit == 'targettarget' or unit == 'focustarget') then
		self.Power:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_target_filling')
		self.Power:SetStatusBarColor(0.95, 0.85, 0)
		self.Power:SetSize(124, 2)
		self.Power:SetPoint('TOP',self.Health,'BOTTOM',0,-1)			
	end
	self.Power.PostUpdate = ns.UpdatePower
	self.Power.Smooth = true
	--self.Power.colorPower = true --MOVE TO CONFIG
	self.Power.colorDisconnected = true
	self.Power.frequentUpdates = true
	
	if unit == 'player' then
		self.Power.value = ns.CreateFontString(self, 12, 'CENTER')
		self.Power.value:SetPoint('CENTER',self.cbar,'CENTER', 0, -10)
		self.Power.value:SetTextColor(1.0, 1.0, 1.0)
	elseif unit == 'target' then
		self.Power.value = ns.CreateFontString(self, 10, 'RIGHT')
		self.Power.value:SetPoint('RIGHT',self.Power,'RIGHT', -2, 0)
		self.Power.value:SetTextColor(1.0, 1.0, 1.0)
	elseif unit == 'pet' then
		self.Power.value = ns.CreateFontString(self, 10, 'LEFT')
		self.Power.value:SetPoint('LEFT', self.Power, 'RIGHT', 2, 0)
	end
	
	-- Name Text --
	if (unit == 'target') then
		self.Name = self:CreateFontString()
		self.Name:SetFont('Fonts\\ARHei.ttf', 16, 'THINOUTLINE')
		self.Name:SetShadowOffset(0, 0)
		self.Name:SetTextColor(0.8, 0.3, 0.3)
		self.Name:SetPoint('TOPLEFT',self,'TOPLEFT',0,-12)
		self:Tag(self.Name, '[Gvv:namecolor][Gvv:classification][name]|r')
	elseif unit == 'focus' or unit == 'targettarget' or unit == 'focustarget' then
		self.Name = self:CreateFontString()
		self.Name:SetFont('Fonts\\ARHei.ttf', 12, 'THINOUTLINE')
		self.Name:SetJustifyH('LEFT')
		self.Name:SetShadowOffset(0, 0)
		self.Name:SetTextColor(0.8, 0.3, 0.3)
		self.Name:SetPoint('BOTTOMLEFT',self.tcover,'TOPLEFT',0,2)
		self:Tag(self.Name, '[Gvv:namecolor][Gvv:classification][name]|r')
	end
	
	-- Level Text --
	if (unit == 'target') then
		self.Level = self:CreateFontString()
		self.Level:SetFont('Fonts\\ARHei.ttf', 16, 'THINOUTLINE')
		self.Level:SetJustifyH('RIGHT')
		self.Level:SetPoint('BOTTOMRIGHT', self.tcover, 'TOPRIGHT', 0, 2)
		self:Tag(self.Level, '[level]')
	elseif unit == 'focus' or unit == 'targettarget' or unit == 'focustarget' then
		self.Level = self:CreateFontString()
		self.Level:SetFont('Fonts\\ARHei.ttf', 14, 'THINOUTLINE')
		self.Level:SetJustifyH('RIGHT')
		self.Level:SetPoint('BOTTOMRIGHT', self.tcover, 'TOPRIGHT', 0, 1)
		self:Tag(self.Level, '[level]')		
	elseif unit == 'player' then
		self.Level = self:CreateFontString()
		self.Level:SetFont('Fonts\\ARHei.ttf', 16, 'THINOUTLINE')
		self.Level:SetJustifyH('CENTER')
		self.Level:SetPoint('BOTTOM', 'UIParent', 'BOTTOMLEFT', 30, 2)
		self:Tag(self.Level, '[level]')	
		self.Level = self:CreateFontString()
		self.Level:SetFont('Fonts\\ARHei.ttf', 14, 'THINOUTLINE')
		self.Level:SetJustifyH('CENTER')
		self.Level:SetPoint('BOTTOM', 'UIParent', 'BOTTOMRIGHT', -15, 2)
		self:Tag(self.Level, '[Gvv:nextlevel]')			
	end
		
	-- Portrait --
	if (unit == 'target') then
		self.Portrait = self:CreateTexture(nil, 'BACKGROUND',nil,0)
		self.Portrait:SetSize(48, 48)
		self.Portrait:SetTexCoord(1,0,0,1)
		self.Portrait:SetBlendMode('BLEND')
		self.Portrait:SetPoint('CENTER', self.pback)
	elseif unit == 'focus' or unit == 'targettarget' or unit == 'focustarget' then
		self.Portrait = self:CreateTexture(nil, 'BACKGROUND',nil,0)
		self.Portrait:SetSize(36, 36)
		self.Portrait:SetPoint('CENTER', self.pback)	
	end
	
	-- Target Auras --
	if (unit == 'target') then
		self.Auras = ns.CreateAura(self, unit)
	end
	
	-- Classification Texts --
	if (unit == 'target') then
		self.class = self:CreateFontString()
		self.class:SetFont('Fonts\\ARHei.ttf', 14, 'THINOUTLINE')
		self.class:SetPoint('TOP', self.Health, 'BOTTOM', 0, -15)
		self.class:SetTextColor(0.6,0.6,0.6)
		self:Tag(self.class,'[Gvv:theone][smartclass][Gvv:leader][Gvv:raidrole][Gvv:a][Gvv:lfdrole]')
	end
	
	-- Experience bar --
	local rw, rh = string.match((({GetScreenResolutions()})[GetCurrentResolution()] or ''), '(%d+).-(%d+)')
	if unit == 'player' then
		-- Position and size
		local Experience = CreateFrame('StatusBar', nil, self)
		
		Experience:EnableMouse(true)
		
		Experience:SetPoint('BOTTOM', 'UIParent', 'BOTTOM', 15, 0)
		Experience:SetHeight(14)
		Experience:SetWidth(rw - 90)
		Experience:SetFrameLevel(1)
		
		Experience:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_target_filling')
		Experience:SetStatusBarColor(211/255, 151/255, 0)
		
		-- Always show borders
		local tborder = self:CreateTexture(nil,'OVERLAY', nil, 0)
		tborder:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_border')
		tborder:SetSize(rw - 90,16)
		tborder:SetPoint('TOP', Experience, 'TOP', 0, 0)
		tborder:SetHorizTile(true)	
		tborder = self:CreateTexture(nil,'OVERLAY',nil, 0)
		tborder:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_border')
		tborder:SetSize(rw - 90,16)
		tborder:SetPoint('BOTTOM', Experience, 'BOTTOM', 0, 0)
		tborder:SetTexCoord(0,1,1,0)
		tborder:SetHorizTile(true)
		
		for i= 1, 11 do
		local t = self:CreateTexture(nil, 'OVERLAY', nil, -1)
		t:SetSize(3, 13)
		t:SetPoint('CENTER', Experience, 'LEFT', (rw - 90) * ( i - 1 ) / 10, 0)
		t:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_dark')
		end

		local Rested = CreateFrame('StatusBar', nil, Experience)
		Rested:SetAllPoints(Experience)
		Rested:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_target_filling')
		Rested:SetStatusBarColor(228/255, 192/255, 102/255)
		
		local Value = Experience:CreateFontString(nil, 'HIGHLIGHT')
		Value:SetPoint('CENTER', Experience, 'CENTER' , -15, 0)
		Value:SetFontObject(GameFontHighlight)
		self:Tag(Value, '[curxp] / [maxxp] [Gvv:currested]')
		
		local backgroundframe = CreateFrame('Frame')
		local bg = backgroundframe:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(Experience)
		bg:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_back')
		bg:SetHorizTile(true)
		
		self.Experience = Experience
		self.Experience.Rested = Rested
	end
	
	-- Reputation bar --
	if unit == 'player' then
		local Reputation = CreateFrame('StatusBar', nil, self)
		Reputation:SetPoint('BOTTOM', 'UIParent', 'BOTTOM', 15, 14)
		Reputation:SetFrameLevel(2)
		Reputation:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')		
		
		local maxLevel
		if IsTrialAccount() then
			maxLevel = select(1, GetRestrictedAccountData())
		else
			maxLevel = GetMaxPlayerLevel()
		end
		if UnitLevel(unit) < maxLevel then
			Reputation:SetHeight(5)
		else
			Reputation:SetPoint('BOTTOM', 'UIParent', 'BOTTOM', 15, 0)
			Reputation:SetHeight(14)
		end
		Reputation:SetWidth(rw - 90)
		Reputation.colorStanding = true
		self.Reputation = Reputation
	end
	
	-- Icons --
	if unit == 'player' then
		local Leader = self:CreateTexture(nil, 'OVERLAY')
		Leader:SetSize(16, 16)
		Leader:SetPoint('BOTTOM', self.Power, 'TOP' , 0, 3)
		self.Leader = Leader
	
		local MasterLooter = self:CreateTexture(nil, 'OVERLAY')
		MasterLooter:SetSize(16, 16)
		MasterLooter:SetPoint('BOTTOM', self.Power, 'TOP' , 18, 3)
		self.MasterLooter = MasterLooter
		
		local LFDRole = self:CreateTexture(nil, 'OVERLAY')
		LFDRole:SetSize(16, 16)
		LFDRole:SetPoint('BOTTOM', self.Power, 'TOP' , -18, 3)
		self.LFDRole = LFDRole
	elseif unit == 'target' then
		local PhaseIcon = self:CreateTexture(nil, 'OVERLAY')
		PhaseIcon:SetSize(16, 16)
		PhaseIcon:SetPoint('BOTTOMRIGHT', self.Level, 'TOPRIGHT', 0, 0)
		self.PhaseIcon = PhaseIcon
	end
	
	-- Alt Powers (definitely pain in the arse) --
	if unit == 'player' then
		-- APs will be drawn on this frame(in this area) --
		self.ap = CreateFrame('Frame', 'APframe', self)
		self.ap:SetSize(10, 30)
		self.ap:SetPoint('RIGHT', self, 'LEFT', -310, 19)
		
		local playerclass = string.upper(select(2, UnitClass('player')));
		
		if playerclass == 'SHAMAN' then
			-- Living Honor Points --
			local Totems = {}
			for index = 1, MAX_TOTEMS do
				local Totem = CreateFrame('StatusBar', nil, self.ap)
				Totem:EnableMouse(true)
				Totem:SetSize(40, 20)
				Totem:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 45, 0)
				Totem.destroy = true
				Totem:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
				Totem:SetMinMaxValues(0, 1)
				
				Totem.bg = Totem:CreateTexture(nil, 'BACKGROUND')
				Totem.bg:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
				Totem.bg:SetAllPoints()
				Totem.bg.multiplier = 0.3
				
				Totems[index] = Totem
			end
			self.TotemBar = Totems
		elseif playerclass == 'PRIEST' or playerclass == 'PALADIN' or playerclass == 'MONK' or playerclass == 'WARLOCK' then
			local ClassIcons = {}
			for index = 1, 5 do
				local Icon = self:CreateTexture(nil, 'BACKGROUND')
				Icon:SetSize(20, 20)
				Icon:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 25, 0)
				ClassIcons[index] = Icon
			end
			self.ClassIcons = ClassIcons
			
			if playerclass == 'WARLOCK' then
				-- Just WARLOCK things --
				local DemonicFuryBar = CreateFrame('StatusBar', nil, self)
				DemonicFuryBar:SetPoint('LEFT', self.ap, 'LEFT', 0, 0)
				DemonicFuryBar:SetSize(180, 20)
				DemonicFuryBar:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
				DemonicFuryBar:SetStatusBarColor(148/255, 130/255, 201/255)
				
				self.DemonicFury = DemonicFuryBar
				
				local BurningEmbers = {}
				for i = 1, 4 do
					local ember = CreateFrame('StatusBar', nil, self)
					ember:SetSize(40, 20)
					ember:SetPoint('LEFT', self.ap, 'LEFT', (i - 1) * 45, 0)
					ember:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
					BurningEmbers[i] = ember
				end
				
				self.BurningEmbers = BurningEmbers
			end
		elseif playerclass == 'DRUID' then --hate this class particularly
			-- BIG FAT CHICKEN BAR --
			local EclipseBar = CreateFrame('Frame', nil, self)
			EclipseBar:SetPoint('LEFT', self.ap, 'LEFT', 0, 0)
			EclipseBar:SetSize(180, 20)

			local LunarBar = CreateFrame('StatusBar', nil, EclipseBar)
			LunarBar:SetPoint('LEFT')
			LunarBar:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
			LunarBar:SetStatusBarColor(0.1,0.2,0.8)
			LunarBar:SetSize(180, 20)

			local SolarBar = CreateFrame('StatusBar', nil, EclipseBar)
			SolarBar:SetPoint('LEFT', LunarBar:GetStatusBarTexture(), 'RIGHT')
			SolarBar:SetSize(180, 20)
			SolarBar:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
			SolarBar:SetStatusBarColor(0.8,0.6,0.1)
			
			EclipseBar.LunarBar = LunarBar
			EclipseBar.SolarBar = SolarBar
			self.EclipseBar = EclipseBar
			
			-- USELESS MANA BAR --
			local DruidMana = CreateFrame('StatusBar', nil, self.ap)
			DruidMana:SetSize(180, 20)
			DruidMana:SetPoint('LEFT')
			DruidMana:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
			DruidMana:SetStatusBarColor(0.1,0.3,0.9)
			local Background = DruidMana:CreateTexture(nil, 'BACKGROUND')
			Background:SetAllPoints(DruidMana)
			Background:SetTexture(1, 1, 1, .5)
			self.DruidMana = DruidMana
			self.DruidMana.bg = Background
			
			-- TEEMO BAR --
			local Mushrooms = {}
			for index = 1, MAX_TOTEMS do
				local Mushroom = CreateFrame('Button', nil, self.ap)
				Mushroom:SetSize(20, 20)
				Mushroom:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 25, 12)

				local Icon = Mushroom:CreateTexture(nil, 'OVERLAY')
				Icon:SetAllPoints()

				local Cooldown = CreateFrame('Cooldown', nil, Mushroom)
				Cooldown:SetAllPoints()

				Mushroom.Icon = Icon
				Mushroom.Cooldown = Cooldown

				Mushrooms[index] = Mushroom
			end
			self.Totems = Mushrooms -- Yeah they count as TOTEMS.
		elseif playerclass == 'DEATHKNIGHT' then
			local Runes = {}
			for index = 1, 6 do
				local Rune = CreateFrame('StatusBar', nil, self.ap)
				Rune:SetSize(20, 20)
				Rune:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 25, 0)

				Runes[index] = Rune
			end
			self.Runes = Runes
		end
		
	end
	
	-- C-C-COMBO BAR! May be changed in WoD?--
	if unit == 'target' then
		local CPoints = {}
		for index = 1, MAX_COMBO_POINTS do
			local CPoint = self:CreateTexture(nil, 'BACKGROUND')

			CPoint:SetSize(12, 16)
			CPoint:SetPoint('BOTTOMLEFT', self.Name, 'TOPLEFT', (index - 1) * 17, 0)

			CPoints[index] = CPoint
		end
		self.CPoints = CPoints
	end
	
	-- Castbar. Maybe Quartz is better?--
	if unit == 'player' or unit == 'target' then
		local Castbar = CreateFrame('StatusBar', nil, self)
		
		if unit == 'player' then
			Castbar:SetSize(220, 20)
			Castbar:SetPoint('BOTTOM', self, 'TOP', 0, 100)
		elseif unit == 'target' then
			Castbar:SetSize(256, 10)
			Castbar:SetPoint('TOP', self.tcover, 'BOTTOM', 0, -35)
		end

		local Background = Castbar:CreateTexture(nil, 'BACKGROUND')
		Background:SetAllPoints(Castbar)
		Background:SetTexture(1, 1, 1, .5)

		local Spark = Castbar:CreateTexture(nil, 'OVERLAY')
		Spark:SetSize(20, 20)
		Spark:SetBlendMode('ADD')

		local Time = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
		Time:SetPoint('RIGHT', Castbar)

		local Icon = Castbar:CreateTexture(nil, 'OVERLAY')
		if unit == 'player' then
			Icon:SetSize(20, 20)
		elseif unit == 'target' then
			Icon:SetSize(10, 10)
		end
		Icon:SetPoint('TOPLEFT', Castbar, 'TOPLEFT')
		
		local Text = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
		Text:SetPoint('LEFT', Icon, 'RIGHT')

		local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
		Shield:SetSize(10, 10)
		
		Shield:SetPoint('CENTER', Castbar)

		local SafeZone = Castbar:CreateTexture(nil, 'OVERLAY')

		self.Castbar = Castbar
		self.Castbar.bg = Background
		self.Castbar.Spark = Spark
		self.Castbar.Time = Time
		self.Castbar.Text = Text
		self.Castbar.Icon = Icon
		self.Castbar.SafeZone = SafeZone
	end
	
	return self
end

oUF:Factory(function(self)
	oUF:RegisterStyle('Gvv', Gvv_Style)
	oUF:SetActiveStyle('Gvv')

	local player = self:Spawn('player', 'oUF_Gvv_Player')
	player:SetPoint('BOTTOM', 'UIParent', 'BOTTOM', 0, 20)
	
	local target = self:Spawn('target', 'oUF_Gvv_Target')
	target:SetPoint('TOP', 'UIParent', 'TOP', 0, -70)
	
	local pet = self:Spawn('pet', 'oUF_Gvv_Pet')
	pet:SetPoint('RIGHT', player, 'LEFT', 0, 25)
	
	local focus = self:Spawn('focus', 'oUF_Gvv_Focus')
	focus:SetPoint('TOP', 'UIParent', 'TOP', 250, -140)
	
	local targettarget = self:Spawn('targettarget', 'oUF_Gvv_TargetTarget')
	targettarget:SetPoint('TOP', 'UIParent', 'TOP', 250, -80)
	
	local focustarget = self:Spawn('focustarget', 'oUF_Gvv_FocusTarget')
	focustarget:SetPoint('TOP', focus, 'BOTTOM', 20, -10)
	
end)