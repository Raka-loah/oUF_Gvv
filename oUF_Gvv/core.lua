--[[
oUF_Gvv by Raka from LotC.cc
Please don't modify anything, very fragile.
Require oUF 7.0.x.
]]
local ADDON_NAME, ns = ...
if not CPS then CPS = {} end

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
		self.tcover:SetVertexColor(0.0, 0.0, 0.0)
		self.tcover:SetSize(256,16)
		self.tcover:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, -30)
		self.pback = self:CreateTexture(nil, 'BACKGROUND', nil, -1)
		self.pback:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\portrait_back')
		self.pback:SetSize(128,128)
		self.pback:SetPoint('RIGHT', self, 'RIGHT', 35, 0)
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
		self.pback:SetSize(96,96)
		self.pback:SetPoint('LEFT', self, 'LEFT', -24, 0)
	end
	
	if unit == 'target' and ns.C.showClsBdr then
		hooksecurefunc(self, 'Show', function(self)
			local class = UnitClassification(self.unit)
			if class ~= 'normal' and class ~= 'minus' and class ~= 'trivial' then
				if class == 'worldboss' then
					self.pback:SetTexture('Interface\\AddOns\\oUF_Gvv\\textures\\portrait_back_boss')
				elseif class == 'rare' or class == 'rareelite' then
					self.pback:SetTexture('Interface\\AddOns\\oUF_Gvv\\textures\\portrait_back_rare')
				elseif class == 'elite' then
					self.pback:SetTexture('Interface\\AddOns\\oUF_Gvv\\textures\\portrait_back_elite')
				end
			else
				self.pback:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\portrait_back')
			end
		end)
	end
	
	-- Health bar --
	self.Health = CreateFrame('StatusBar', 'healthbar', self)
	self.Health:SetFrameStrata('LOW')
	self.Health:SetFrameLevel(1)
	
	self.Health:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_filling')
	self.Health:SetStatusBarColor(0.95, 0.15, 0)
	self.Health.frequentUpdates = true
	self.Health.Smooth = true
	self.colors.reaction = {
		{ 0.7, 0.0, 0.0 },
		{ 0.7, 0.0, 0.0 },
		{ 0.7, 0.4, 0.0 },
		{ 0.7, 0.7, 0.0 },
		{ 0.0, 0.7, 0.0 },
		{ 0.0, 0.7, 0.0 },
		{ 0.0, 0.7, 0.0 },
		{ 0.0, 0.7, 0.0 },
	}
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
		self.Health:SetFrameStrata('LOW')
		self.Health:SetFrameLevel(1)
		self.Health:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_target_filling')
		self.Health:SetOrientation('HORIZONTAL')
		self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, -30)
		self.Health.colorTapping = true
		self.Health.colorDisconnected = true
		self.Health.colorClass = ns.C.colorClass
		self.Health.colorReaction = true
		--self.Health.colorHealth = true
	elseif (unit == 'focus' or unit == 'targettarget' or unit == 'focustarget') then
		self.Health:SetSize(128, 16)
		self.Health:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
		self.Health:SetOrientation('HORIZONTAL')
		self.Health:SetPoint('CENTER',self.tcover)
		self.Health.colorTapping = true
		self.Health.colorDisconnected = true
		self.Health.colorClass = ns.C.colorClass
		self.Health.colorReaction = true
		--self.Health.colorHealth = true
	elseif (unit == 'party') then
		self.Health:SetSize(70, 10)
		self.Health:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_target_filling')
		self.Health:SetOrientation('HORIZONTAL')
		self.Health:SetStatusBarColor(20/255, 217/255, 0)
		self.Health:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 26, -2)
		self.Health.colorClass = true
		self.Health.colorDisconnected = true
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
		self.Health.Value:SetFont('Interface\\Addons\\oUF_Gvv\\fonts\\menomonia.ttf', 14, 'THINOUTLINE')
		self.Health.Value:SetTextColor(1.0, 1.0, 1.0)
		self.Health.Value:SetJustifyH('LEFT')
		self.Health.Value:SetPoint('LEFT', self.Health, 'RIGHT', 5, 1)
	elseif (unit == 'party') then
		self.Health.Value = self:CreateFontString()
		self.Health.Value:SetFont('Interface\\Addons\\oUF_Gvv\\fonts\\menomonia.ttf', 12)
		self.Health.Value:SetTextColor(20/255, 217/255, 0)
		self.Health.Value:SetPoint('LEFT', self.Health, 'RIGHT', 2, 0)
	else
		self.Health.Value = ns.CreateFontString(self, 12, 'RIGHT')
		self.Health.Value:SetTextColor(1.0, 1.0, 1.0)
		self.Health.Value:SetPoint('RIGHT', self.tcover, 'RIGHT', -2, 1)
	end
	
	if (unit == 'player') then
		self.Health.lowHP = self.Health:CreateTexture(nil, 'BACKGROUND', nil, -7)
		self.Health.lowHP:SetTexture('Interface\\AddOns\\oUF_Gvv\\textures\\health_filling')
		self.Health.lowHP:SetSize(128, 128)
		self.Health.lowHP:SetPoint('CENTER')
		self.Health.lowHP:SetVertexColor(1.0, 1.0, 1.0)
		self.Health.lowHP:SetAlpha(0)
		ns.CreateAlphaAnimation(self.Health.lowHP, 0, 1)
	end
	
	-- Power Bar --
	self.Power = CreateFrame('StatusBar', nil, self)
	self.Power:SetFrameStrata('LOW')
	self.Power:SetFrameLevel(3)
	self.Power:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\power_filling')
	self.Power:SetStatusBarColor(0.8, 0.5, 0)
	if ns.C.colorPower then
		self.colors.power = {
			[0] = {0.3, 0.3, 0.9}, --mana
			[1] = {0.7, 0.1, 0.1}, --rage
			[2] = {1.0, 0.4, 0.1}, --focus
			[3] = {0.8, 0.5, 0.0}, --energy
			[6] = {0.3, 0.7, 0.8}  --runic
		}
		self.Power.colorPower = true
	end
	self.Power:SetOrientation('HORIZONTAL')
	if unit == 'player' then		
		self.cbar = self.Power:CreateTexture(nil, 'ARTWORK', nil, 0)
		self.cbar:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\power_cover')
		self.cbar:SetSize(128,64)
		self.cbar:SetPoint('BOTTOM',self,'BOTTOM',0,91)
		self.Power:SetSize(125, 64)
		self.Power:SetPoint('CENTER',self.cbar)
		local bg = self.Power:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(self.cbar)
		bg:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\power_bg')
		self.Power.bg = bg
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
		self.Power:SetFrameStrata('MEDIUM')
		self.Power:SetFrameLevel(1)
		self.Power:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')
		if not ns.C.colorPower then
			self.Power:SetStatusBarColor(0.95, 0.85, 0)
		end
		self.Power:SetSize(252, 4)
		self.Power:SetPoint('TOP',self.Health,'BOTTOM',0,-1)
	elseif (unit == 'focus' or unit == 'targettarget' or unit == 'focustarget') then
		self.Power:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\health_target_filling')
		if not ns.C.colorPower then
			self.Power:SetStatusBarColor(0.95, 0.85, 0)
		end
		self.Power:SetSize(124, 2)
		self.Power:SetPoint('TOP',self.Health,'BOTTOM',0,-1)			
	end
	self.Power.PostUpdate = ns.UpdatePower
	self.Power.Smooth = true
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
		self.Name:SetFont(ns.C.normalFont, 16, 'THINOUTLINE')
		self.Name:SetShadowOffset(0, 0)
		self.Name:SetTextColor(0.8, 0.3, 0.3)
		self.Name:SetPoint('TOPLEFT',self,'TOPLEFT',0,-12)
		self:Tag(self.Name, '[Gvv:namecolor][Gvv:classification][name]|r')
	elseif unit == 'focus' or unit == 'targettarget' or unit == 'focustarget' then
		self.Name = self:CreateFontString()
		self.Name:SetFont(ns.C.normalFont, 12, 'THINOUTLINE')
		self.Name:SetJustifyH('LEFT')
		self.Name:SetShadowOffset(0, 0)
		self.Name:SetTextColor(0.8, 0.3, 0.3)
		self.Name:SetPoint('BOTTOMLEFT',self.tcover,'TOPLEFT',0,2)
		self:Tag(self.Name, '[Gvv:namecolor][Gvv:classification][name]|r')
	elseif unit == 'party' then
		self.Name = self:CreateFontString()
		self.Name:SetFont(ns.C.normalFont, 14, 'THINOUTLINE')
		self.Name:SetJustifyH('LEFT')
		self.Name:SetShadowOffset(0, 0)
		self.Name:SetTextColor(0.8, 0.8, 0.8)
		self.Name:SetPoint('BOTTOMLEFT',self,'BOTTOMLEFT',25,0)
		self:Tag(self.Name, '[Gvv:namecolor][name]|r')
	end
	
	-- Level Text --
	if (unit == 'target') then
		self.Level = self:CreateFontString()
		self.Level:SetFont(ns.C.normalFont, 16, 'THINOUTLINE')
		self.Level:SetJustifyH('RIGHT')
		self.Level:SetPoint('BOTTOMRIGHT', self.tcover, 'TOPRIGHT', 0, 2)
		self:Tag(self.Level, '[level]')
	elseif unit == 'focus' or unit == 'targettarget' or unit == 'focustarget' then
		self.Level = self:CreateFontString()
		self.Level:SetFont(ns.C.normalFont, 14, 'THINOUTLINE')
		self.Level:SetJustifyH('RIGHT')
		self.Level:SetPoint('BOTTOMRIGHT', self.tcover, 'TOPRIGHT', 0, 1)
		self:Tag(self.Level, '[level]')		
	elseif unit == 'player' and ns.C.showExperience then
		local dumframe = CreateFrame('Frame', 'oUF_Gvv_DummyFrame', UIParent)
		dumframe:SetFrameLevel(4)
		self.Level = self:CreateFontString()
		self.Level:SetFont(ns.C.normalFont, 16, 'THINOUTLINE')
		self.Level:SetJustifyH('CENTER')
		self.Level:SetPoint('BOTTOM', UIParent, 'BOTTOMLEFT', 40, 2)
		self.Level:SetTextColor(218/256, 175/256, 57/256, 1) 
		self.Level:SetParent(dumframe)
		self:Tag(self.Level, '[level]')	
		self.LevelR = self:CreateFontString()
		self.LevelR:SetFont(ns.C.normalFont, 16, 'THINOUTLINE')
		self.LevelR:SetJustifyH('CENTER')
		self.LevelR:SetPoint('BOTTOM', UIParent, 'BOTTOMRIGHT', -40, 2)
		self.LevelR:SetTextColor(218/256, 175/256, 57/256, 1) 
		self.LevelR:SetParent(dumframe)
		self:Tag(self.LevelR, '[Gvv:nextlevel]')	
	elseif unit == 'party' then
		self.Level = self:CreateFontString()
		self.Level:SetFont(ns.C.normalFont, 14, 'THINOUTLINE')
		self.Level:SetJustifyH('CENTER')
		self.Level:SetPoint('CENTER', self, 'LEFT', 25, 0)
		local t = self:CreateTexture(nil, 'BACKGROUND',nil,2)
		t:SetTexture('Interface\\AddOns\\oUF_Gvv\\textures\\party_level_back')
		t:SetPoint('BOTTOM', self.Level, 'BOTTOM', 0, -2)
		self:Tag(self.Level, '[level]')
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
	elseif unit == 'party' then
		self.Portrait = self:CreateTexture(nil, 'BACKGROUND',nil,0)
		self.Portrait:SetSize(64, 64)
		self.Portrait:SetPoint('LEFT', self, 'LEFT', 25, 0)	
		self.pback = self:CreateTexture(nil, 'BACKGROUND', nil, 1)
		self.pback:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\party_back')
		self.pback:SetSize(128,128)
		self.pback:SetPoint('TOPLEFT', self, 'TOPLEFT', 25, 0)
	end
	
	-- Auras --
	if (unit == 'target' and ns.C.showTarget) then
		self.Auras = ns.CreateAura(self, unit)
	elseif (unit == 'party' and ns.C.showParty) then
		self.Auras = ns.CreateAura(self, unit)
	end
	
	-- Classification Texts --
	if (unit == 'target') then
		self.class = self:CreateFontString()
		self.class:SetFont(ns.C.normalFont, 14, 'THINOUTLINE')
		self.class:SetPoint('TOP', self.Health, 'BOTTOM', 0, -15)
		self.class:SetTextColor(0.6,0.6,0.6)
		self:Tag(self.class,'[Gvv:theone][smartclass][Gvv:raidrole][Gvv:masterlooter][Gvv:a][Gvv:lfdrole]')
	end
	
	-- Experience bar --
	local rw = GetScreenWidth()
	if ns.C.showExperience then
		if unit == 'player' then
			local ExpFrame = CreateFrame('Frame', 'oUF_Gvv_ExpFrame', self)
			self.ExpFrame = ExpFrame
			if CPS['ArtiFrameOn'] then 
				self.ExpFrame:Hide()
			else 
				self.ExpFrame:Show()
			end
			-- Position and size
			local Experience = CreateFrame('StatusBar', 'oUF_Gvv_ExpBar', self.ExpFrame)
			
			Experience:EnableMouse(true)
			
			Experience:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 0)
			Experience:SetHeight(14)
			Experience:SetWidth(rw - 160)
			Experience:SetFrameLevel(2)
			
			Experience:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_filling')
			Experience:SetStatusBarColor(211/255, 151/255, 0)
			
			-- Always show borders
			local expborder = CreateFrame('Frame', 'oUF_Gvv_ExpBdr', UIParent)
			expborder:SetAllPoints(Experience)
			expborder:SetFrameLevel(3)
			local tborder = expborder:CreateTexture(nil,'OVERLAY', nil, 0)
			tborder:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_border')
			tborder:SetSize(rw - 90,16)
			tborder:SetPoint('TOP', Experience, 'TOP', 0, 0)
			tborder:SetHorizTile(true)	
			tborder = expborder:CreateTexture(nil,'OVERLAY',nil, 0)
			tborder:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_border')
			tborder:SetSize(rw - 90,16)
			tborder:SetPoint('BOTTOM', Experience, 'BOTTOM', 0, 0)
			tborder:SetTexCoord(0,1,1,0)
			tborder:SetHorizTile(true)
			
--[[		for i= 1, 11 do
				local t = expborder:CreateTexture(nil, 'OVERLAY', nil, -1)
				t:SetSize(3, 13)
				t:SetPoint('CENTER', Experience, 'LEFT', (rw - 90) * ( i - 1 ) / 10, 0)
				t:SetColorTexture(0,0,0,1)
			end]]

			local Rested = CreateFrame('StatusBar', 'oUF_Gvv_ExpRested', Experience)
			Rested:SetAllPoints(Experience)
			Rested:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_filling')
			Rested:SetStatusBarColor(228/255, 192/255, 102/255)
			
			local Value = Experience:CreateFontString(nil, 'HIGHLIGHT')
			Value:SetPoint('CENTER', Experience, 'CENTER' , 0, 0)
			Value:SetFontObject(GameFontHighlight)
			self:Tag(Value, '[experience:cur] / [experience:max] ([experience:per]%) [Gvv:currested]')
			
			local backgroundframe = CreateFrame('Frame', nil, UIParent)
			backgroundframe:SetFrameStrata('LOW')
			backgroundframe:SetFrameLevel(0)
			local bg = backgroundframe:CreateTexture(nil, 'BACKGROUND')
			bg:SetAllPoints(Experience)
			bg:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_filling')
			bg:SetVertexColor(0.2, 0.2, 0.2)
			bg:SetAlpha(0.9)

			self.Experience = Experience
			self.Experience.Rested = Rested
			--self.Experience:SetParent(UIParent)
		end
		
		-- Reputation bar --
		if unit == 'player' then
			local Reputation = CreateFrame('StatusBar', 'oUF_Gvv_Reputation', self.ExpFrame)
			Reputation:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 9)
			Reputation:SetFrameLevel(2)
			Reputation:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\pet_filling')	
			Reputation:EnableMouse(true)

			local maxLevel
			if IsTrialAccount() then
				maxLevel = select(1, GetRestrictedAccountData())
			else
				maxLevel = GetMaxPlayerLevel()
			end
			if UnitLevel(unit) < maxLevel then
				Reputation:SetHeight(5)
			else
				Reputation:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 0)
				Reputation:SetHeight(14)
				Reputation:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_filling')	
				local Value = Reputation:CreateFontString(nil, 'HIGHLIGHT')
				Value:SetPoint('CENTER', Reputation, 'CENTER' , 0, 0)
				Value:SetFontObject(GameFontHighlight)
				self:Tag(Value, '[reputation:cur] / [reputation:max] ([reputation:per]%) [reputation:faction]')
			end
			Reputation:SetWidth(rw - 160)
			Reputation.colorStanding = true
			self.Reputation = Reputation
		end

		-- Artifact Power --
		-- if unit == 'player' then
		-- 	local ArtiFrame = CreateFrame('Frame', 'oUF_Gvv_ArtiFrame', self)
		-- 	self.ArtiFrame = ArtiFrame
		-- 	if CPS['ArtiFrameOn'] then 
		-- 		self.ArtiFrame:Show()
		-- 	else 
		-- 		self.ArtiFrame:Hide()
		-- 	end
		-- 	local ArtifactPower = CreateFrame('StatusBar', 'oUF_Gvv_ArtifactPower', self.ArtiFrame)
		-- 	ArtifactPower:SetFrameLevel(2)
		-- 	ArtifactPower:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\exp_filling')
		-- 	ArtifactPower:SetStatusBarColor(241/256, 198/256, 66/256)
		-- 	ArtifactPower:EnableMouse(true)

		-- 	ArtifactPower:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 0)
		-- 	ArtifactPower:SetHeight(14)
		-- 	ArtifactPower:SetWidth(rw - 160)
		-- 	local text = ArtifactPower:CreateFontString(nil, 'HIGHLIGHT')
		-- 	text:SetPoint('CENTER')
		-- 	text:SetFontObject(GameFontHighlight)
		-- 	ArtifactPower.text = text

		-- 	ArtifactPower.PostUpdate = function(self, event, isShown)
		-- 		if (not isShown) then return end
		-- 		self.text:SetFormattedText('%d / %d (%d%%) [Lv %d(+%d)]', self.power, self.powerForNextTrait, 100 * self.power / self.powerForNextTrait, self.traitsLearned, self.numTraitsLearnable)
		-- 	end

		-- 	self.ArtifactPower = ArtifactPower

		-- 	local ToggleButton = CreateFrame('Button', nil, self)
		-- 	ToggleButton:SetSize(77, 10)
		-- 	ToggleButton:SetFrameStrata('MEDIUM')
		-- 	ToggleButton:SetFrameLevel(5)
		-- 	local ntex = ToggleButton:CreateTexture()
		-- 	ntex:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\togglebutton')
		-- 	--ntex:SetTexCoord(0, 0.625, 0, 0.625)
		-- 	ntex:SetPoint('BOTTOM', ToggleButton, 'BOTTOM', 0, 0)
		-- 	ToggleButton:SetNormalTexture(ntex)
		-- 	local htex = ToggleButton:CreateTexture()
		-- 	htex:SetColorTexture(1.0, 1.0, 1.0, 0.3)
		-- 	htex:SetAllPoints()
		-- 	ToggleButton:SetHighlightTexture(htex)
		-- 	ToggleButton:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT',0 , 19)
		-- 	ToggleButton:EnableMouse('AnyUp')
		-- 	ToggleButton:RegisterForClicks('AnyUp')
		-- 	ToggleButton:SetScript('OnClick', function(self)
		-- 		local realself = self:GetParent()
		-- 		if realself.ArtiFrame:IsShown() then 
		-- 			realself.ArtiFrame:Hide() 
		-- 			CPS['ArtiFrameOn'] = false
		-- 		else 
		-- 			realself.ArtiFrame:Show()
		-- 			CPS['ArtiFrameOn'] = true
		-- 		end
		-- 		if realself.ExpFrame:IsShown() then 
		-- 			realself.ExpFrame:Hide()
		-- 			CPS['ArtiFrameOn'] = true
		-- 		else 
		-- 			realself.ExpFrame:Show() 
		-- 			CPS['ArtiFrameOn'] = false
		-- 		end
		-- 	end)
		-- 	self.ToggleButton = ToggleButton
		-- end
	end
	
	-- Status Icons --
	local Leader = self:CreateTexture(nil, 'OVERLAY')
	Leader:SetSize(16, 16)
	if unit == 'player' then
		Leader:SetPoint('TOP', self.Power, 'TOP' , 0, 0)
	elseif unit == 'target' then
		Leader:SetPoint('BOTTOMLEFT', self.Name, 'TOPLEFT' , 2, 3)
	elseif unit == 'focus' or unit == 'focustarget' or unit == 'targettarget' then
		Leader:SetPoint('BOTTOMLEFT', self.Name, 'TOPLEFT' , 0, 1)
	else
		Leader:SetPoint('TOPLEFT', self, 'TOPLEFT', 20, 10)
	end
	self.LeaderIndicator = Leader
	
	if unit == 'player' then
	local MasterLooter = self:CreateTexture(nil, 'OVERLAY')
		MasterLooter:SetSize(16, 16)
		MasterLooter:SetPoint('TOP', self.Power, 'TOP' , 18, 0)
		self.MasterLooterIndicator = MasterLooter
	
	local LFDRole = self:CreateTexture(nil, 'OVERLAY')
		LFDRole:SetSize(16, 16)
		LFDRole:SetPoint('TOP', self.Power, 'TOP' , -18, 0)
		self.GroupRoleIndicator = LFDRole
	end
	
	if unit == 'party' then
		local LFDRole = self:CreateTexture(nil, 'OVERLAY')
		LFDRole:SetSize(16, 16)
		LFDRole:SetPoint('TOPRIGHT', self.Portrait, 'TOPRIGHT' , 0, 0)
		self.GroupRoleIndicator = LFDRole
	end
	
	if unit == 'target' then
		local PhaseIcon = self:CreateTexture(nil, 'OVERLAY')
		PhaseIcon:SetSize(16, 16)
		PhaseIcon:SetPoint('BOTTOMRIGHT', self.Level, 'TOPRIGHT', 0, 0)
		self.PhaseIndicator = PhaseIcon
	end
	
	local RaidIcon = self:CreateTexture(nil, 'OVERLAY')
	RaidIcon:SetSize(16, 16)
	if unit == 'target' then
		RaidIcon:SetPoint('TOPRIGHT', self.Portrait, 'TOPRIGHT', 2, 2)
	elseif unit == 'focus' or unit == 'focustarget' or unit == 'targettarget' then
		RaidIcon:SetPoint('TOPLEFT', self.Portrait, 'TOPLEFT', -2, 2)
	elseif unit == 'player' then
		RaidIcon:SetPoint('BOTTOM', self, 'BOTTOM', 0, 10)
	else
		RaidIcon:SetPoint('TOPLEFT', self, 'TOPLEFT', 20, -2)
	end
	self.RaidTargetIndicator = RaidIcon
	
	-- Alt Powers (definitely pain in the arse) --
	if unit == 'player' and ns.C.showClassPower then
		-- APs will be drawn on this frame(in this area) --
		self.ap = CreateFrame('Frame', 'APframe', self)
		self.ap:Hide()
		self.ap:SetSize(200, 32)
		local t = self.ap:CreateTexture('ARTWORK')
		t:SetAllPoints()
		t:SetColorTexture(0, 0, 0, 0.5)
		if CPS ~= nil then
			if CPS['a1'] == nil or CPS['a2'] == nil or CPS['x'] == nil or CPS['y'] == nil then
				self.ap:SetPoint('RIGHT', self, 'LEFT', -110, 100)
			else
				if CPS['f'] then
					self.ap:SetPoint(CPS['a1'], CPS['f'], CPS['a2'], CPS['x'], CPS['y'])
				else
					self.ap:SetPoint(CPS['a1'], UIParent, CPS['a2'], CPS['x'], CPS['y'])
				end
			end
		else
			CPS = {}
			self.ap:SetPoint('RIGHT', self, 'LEFT', -110, 100)
		end
		self.ap:SetMovable(true)
		self.ap:EnableMouse(true)
		self.ap:SetScript('OnMouseDown', function(self, button)
			if button == 'LeftButton' and not self.isMoving then
				self:StartMoving()
				self.isMoving = true
			end
		end)
		self.ap:SetScript('OnMouseUp', function(self, button)
			if button == 'LeftButton' and self.isMoving then
				self:StopMovingOrSizing()
				self.isMoving = false
			end
		end)
		self.ap:SetScript('OnHide', function(self)
			if (self.isMoving) then
				self:StopMovingOrSizing()
				self.isMoving = false
			end
		end)
		SLASH_GVV1, SLASH_GVV2 = '/GVV', '/OGV'
		local function aphandler(msg)
			if string.lower(msg) == 'reset' then
				CPS = {}
				print('oUF_Gvv: ' .. ns.L['Class Power position reset.'])
			else	
				if self.ap:IsShown() then
					self.ap:Hide()
					if CPS == nil then
						CPS = {}
					end
					local region
					CPS['a1'], region, CPS['a2'], CPS['x'], CPS['y'] = self.ap:GetPoint(1)
					if region then
						CPS['f'] = region:GetName()
					else
						CPS['f'] = 'UIParent'
					end
					print('oUF_Gvv: ' .. ns.L['Class Power position saved.'])
					--print(self.ap:GetPoint(1))
				else
					self.ap:Show()
				end
			end
		end
		SlashCmdList['GVV'] = aphandler
		
		local playerclass = string.upper(select(2, UnitClass('player')))
		
		if playerclass == 'SHAMAN' then
			-- Living Honor Points --
			local Totems = {}
			for index = 1, 4 do
				local Totem = CreateFrame('StatusBar', nil, self)
				Totem:EnableMouse(true)
				Totem:SetSize(40, 20)
				Totem:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 45, 2)
				Totem.destroy = true
				Totem:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\otherbar_filling')
				Totem:SetMinMaxValues(0, 1)
				
				Totem.bg = Totem:CreateTexture(nil, 'BACKGROUND')
				Totem.bg:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\otherbar_filling')
				Totem.bg:SetTexCoord((10+(40*index))/256,(50+(40*index))/256,0/32,30/32)
				Totem.bg:SetAllPoints()
				Totem.bg.multiplier = 0.3
				
				Totems[index] = Totem
			end
			self.TotemBar = Totems
			
			local DruidMana = CreateFrame('StatusBar', nil, self)
			DruidMana:SetSize(175, 20)
			DruidMana:SetPoint('LEFT', self.ap, 'LEFT', 0, 25)
			DruidMana:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\otherbar_filling')
			DruidMana:SetStatusBarColor(0.4,0.4,0.9)
			DruidMana:EnableMouse(true)
			local ManaVal = DruidMana:CreateFontString(nil, 'HIGHLIGHT')
			ManaVal:SetPoint('CENTER', DruidMana, 'CENTER' , 0, -2)
			ManaVal:SetFont('Interface\\Addons\\oUF_Gvv\\fonts\\menomonia.ttf', 14, 'THINOUTLINE')
			ManaVal:SetTextColor(1.0, 1.0, 1.0)
			ManaVal:SetJustifyH('CENTER')
			self:Tag(ManaVal, '[curmana]')
			local Background = DruidMana:CreateTexture(nil, 'BACKGROUND')
			Background:SetAllPoints(DruidMana)
			Background:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\castbar_back')
			self.AdditionalPower = DruidMana
			self.AdditionalPower.bg = Background
			
		elseif playerclass == 'PRIEST' or playerclass == 'PALADIN' or playerclass == 'MONK' or playerclass == 'WARLOCK' or playerclass == 'EVOKER' then
			if playerclass == 'PRIEST' then
				local DruidMana = CreateFrame('StatusBar', nil, self)
				DruidMana:SetSize(175, 20)
				DruidMana:SetPoint('LEFT', self.ap, 'LEFT', 0, 0)
				DruidMana:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\otherbar_filling')
				DruidMana:SetStatusBarColor(0.4,0.4,0.9)
				DruidMana:EnableMouse(true)
				local ManaVal = DruidMana:CreateFontString(nil, 'HIGHLIGHT')
				ManaVal:SetPoint('CENTER', DruidMana, 'CENTER' , 0, -2)
				ManaVal:SetFont('Interface\\Addons\\oUF_Gvv\\fonts\\menomonia.ttf', 14, 'THINOUTLINE')
				ManaVal:SetTextColor(1.0, 1.0, 1.0)
				ManaVal:SetJustifyH('CENTER')
				self:Tag(ManaVal, '[curmana]')
				local Background = DruidMana:CreateTexture(nil, 'BACKGROUND')
				Background:SetAllPoints(DruidMana)
				Background:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\castbar_back')
				self.AdditionalPower = DruidMana
				self.AdditionalPower.bg = Background
			end
			
			-- local ClassIcons = {}
			local ClassPower = {}
			for index = 1, 10 do
				local Bar = CreateFrame('StatusBar', nil, self)
		
				Bar:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\classicon')
				Bar:SetSize(20, 20)
				Bar:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 25, 2)
		
				ClassPower[index] = Bar
			end
			-- for index = 1, 5 do
			-- 	local Icon = self:CreateTexture(nil, 'BACKGROUND')
			-- 	Icon:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\classicon')
			-- 	Icon:SetSize(20, 20)
			-- 	Icon:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 25, 2)
			-- 	ClassIcons[index] = Icon
			-- end
			-- self.ClassPower = ClassIcons
			self.ClassPower = ClassPower
	
			-- if playerclass == 'WARLOCK' then
			-- 	-- Just WARLOCK things --
			-- 	local DemonicFuryBar = CreateFrame('StatusBar', nil, self)
			-- 	DemonicFuryBar:SetPoint('LEFT', self.ap, 'LEFT', 0, 2)
			-- 	DemonicFuryBar:SetSize(180, 20)
			-- 	DemonicFuryBar:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\otherbar_filling')
			-- 	DemonicFuryBar:SetStatusBarColor(148/255, 130/255, 201/255)
				
			-- 	self.DemonicFury = DemonicFuryBar
				
			-- 	local BurningEmbers = {}
			-- 	for i = 1, 4 do
			-- 		local ember = CreateFrame('StatusBar', nil, self)
			-- 		ember:SetSize(40, 20)
			-- 		ember:SetPoint('LEFT', self.ap, 'LEFT', (i - 1) * 45, 2)
			-- 		ember:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\otherbar_filling')
			-- 		ember:SetStatusBarColor(1, 138/255, 0)
			-- 		BurningEmbers[i] = ember
			-- 	end
				
			-- 	self.BurningEmbers = BurningEmbers
			-- end
		elseif playerclass == 'ROGUE' then
			local ClassIcons = {}
			for index = 1, 10 do
				local Icon = self:CreateTexture(nil, 'BACKGROUND')
				Icon:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\combopoint')
				Icon:SetSize(20, 20)
				Icon:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 25 - 10, 2)
				ClassIcons[index] = Icon
			end
			self.ClassPower = ClassIcons
		elseif playerclass == 'DRUID' then --hate this class particularly
			
			-- USELESS MANA BAR --
			local DruidMana = CreateFrame('StatusBar', nil, self)
			DruidMana:SetSize(175, 20)
			DruidMana:SetPoint('LEFT', self.ap, 'LEFT', 0, 0)
			DruidMana:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\otherbar_filling')
			DruidMana:SetStatusBarColor(0.4,0.4,0.9)
			DruidMana:EnableMouse(true)
			local ManaVal = DruidMana:CreateFontString(nil, 'HIGHLIGHT')
			ManaVal:SetPoint('CENTER', DruidMana, 'CENTER' , 0, -2)
			ManaVal:SetFont('Interface\\Addons\\oUF_Gvv\\fonts\\menomonia.ttf', 14, 'THINOUTLINE')
			ManaVal:SetTextColor(1.0, 1.0, 1.0)
			ManaVal:SetJustifyH('CENTER')
			self:Tag(ManaVal, '[curmana]')
			local Background = DruidMana:CreateTexture(nil, 'BACKGROUND')
			Background:SetAllPoints(DruidMana)
			Background:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\castbar_back')
			self.AdditionalPower = DruidMana
			self.AdditionalPower.bg = Background
			
			-- TEEMO BAR --
			local Mushrooms = {}
			for index = 1, MAX_TOTEMS do
				local Mushroom = CreateFrame('Button', nil, self)
				Mushroom:SetSize(20, 20)
				Mushroom:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 25, 22)

				local Icon = Mushroom:CreateTexture(nil, 'OVERLAY')
				Icon:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\classicon')
				Icon:SetVertexColor(1.0,1.0,0.5)
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
				local Rune = CreateFrame('StatusBar', nil, self)
				Rune:SetSize(20, 20)
				Rune:SetPoint('LEFT', self.ap, 'LEFT', (index - 1) * 25, 2)
				Rune:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\classicon')
				Runes[index] = Rune
			end
			self.Runes = Runes
		end
		
	end
	
	-- Castbar. Maybe Quartz is better?--
	
	if (unit == 'player' or unit == 'target') and ns.C.showCastbar then
		local Castbar = CreateFrame('StatusBar', nil, self)
		
		if unit == 'player' then
			Castbar:SetSize(220, 20)
			Castbar:SetPoint('BOTTOM', self, 'TOP', 0, 100)
		elseif unit == 'target' then
			Castbar:SetSize(235, 15)
			Castbar:SetPoint('TOP', self.tcover, 'BOTTOM', 10, -35)
		end
		Castbar:SetStatusBarTexture('Interface\\Addons\\oUF_Gvv\\textures\\castbar_filling')

		local Background = Castbar:CreateTexture(nil, 'BACKGROUND')
		Background:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\castbar_back')
		Background:SetAllPoints(Castbar)

		local Spark = Castbar:CreateTexture(nil, 'OVERLAY')
		Spark:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\castbar_spark')
		if unit == 'player' then
			Spark:SetSize(20, 20)
		elseif unit == 'target' then
			Spark:SetSize(15, 15)
		end
		
		Spark:SetBlendMode('ADD')
		Spark:SetPoint('CENTER', Castbar:GetStatusBarTexture(), 'RIGHT', 0, 0)

		local Time = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
		Time:SetPoint('RIGHT', Castbar)

		local Icon = Castbar:CreateTexture(nil, 'OVERLAY')
		if unit == 'player' then
			Icon:SetSize(20, 20)
		elseif unit == 'target' then
			Icon:SetSize(15, 15)
		end
		Icon:SetPoint('TOPRIGHT', Castbar, 'TOPLEFT')
		Icon:SetAlpha(0.75)
		
		local Text = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
		Text:SetPoint('LEFT', Icon, 'RIGHT', 5, 0)

		local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
		Shield:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\castbar_shield')
		if unit == 'player' then
			Shield:SetSize(32, 32)
			Shield:SetAlpha(0)
		elseif unit == 'target' then
			Shield:SetSize(24, 24)
			Shield:SetAlpha(0.75)
		end
		Shield:SetPoint('CENTER', Icon)
		

		local SafeZone = Castbar:CreateTexture(nil, 'OVERLAY')
		SafeZone:SetColorTexture(0.8,0.2,0.2,0.5)

		self.Castbar = Castbar
		self.Castbar.bg = Background
		self.Castbar.Spark = Spark
		self.Castbar.Time = Time
		self.Castbar.Text = Text
		self.Castbar.Icon = Icon
		self.Castbar.SafeZone = SafeZone
		self.Castbar.Shield = Shield
		
		if (unit == 'target' and (not ns.C.showTarget)) then
			self.Castbar:Hide()
		end
	end
	
	--Resting Icon for player frame--
	if unit == 'player' and ns.C.showPlayer then
		local Resting = self:CreateTexture(nil, 'OVERLAY')
		Resting:SetSize(32, 32)
		Resting:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
		self.RestingIndicator = Resting
	end

	-- Bloody screen effect --
	if unit == 'player' and ns.C.screenEffect then
		local rh = GetScreenHeight()
		self.bse = CreateFrame('Frame', nil, UIParent)
		self.bse:SetFrameStrata('BACKGROUND')
		self.bse:SetFrameLevel(0)
		local bse = {
			['TOP'] = {rw, 64},
			['BOTTOM'] = {rw, 64},
			['LEFT'] = {64, rh},
			['RIGHT'] = {64, rh}
		}
		for k, v in pairs(bse) do
			local t = self.bse:CreateTexture(nil, 'BACKGROUND')
			t:SetTexture('Interface\\Addons\\oUF_Gvv\\textures\\bse_' .. k)
			t:SetSize(v[1],v[2])
			t:SetPoint(k, UIParent)
		end
		self.bse:SetAlpha(0)
	end

	-- Execution Indicator --
	if ns.C.showLowHealth then
		local playerspec = 0
		if GetSpecialization() then
			playerspec = GetSpecializationInfo(GetSpecialization())
		end
		local lhperc = {
			[0] = 0,
			[71] = 20,
			[72] = 20,
			[258] = 20
		}
		ns.C.ei = lhperc[playerspec] or 0
	else
		ns.C.ei = 0
	end
	
	return self
end

oUF:Factory(function(self)

	if string.sub(GetAddOnMetadata("oUF", "Version"), 1, 4) ~= "12.0" then
		print(ns.L['|cFFFF0000[oUF_Gvv]|r This version of oUF_Gvv has only been tested with oUF 12.0.x, if it breaks, check your oUF core version first.']) 
	end

	oUF:RegisterStyle('Gvv', Gvv_Style)
	oUF:SetActiveStyle('Gvv')

	if ns.C.showPlayer then
	local player = self:Spawn('player', 'oUF_Gvv_Player')
	player:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 20)
	
	local pet = self:Spawn('pet', 'oUF_Gvv_Pet')
	pet:SetPoint('RIGHT', player, 'LEFT', 0, 25)
	end
	
	if ns.C.showTarget then
		local target = self:Spawn('target', 'oUF_Gvv_Target')
		target:SetPoint('TOP', UIParent, 'TOP', 0, -70)
		
		local targettarget = self:Spawn('targettarget', 'oUF_Gvv_TargetTarget')
		targettarget:SetPoint('TOP', UIParent, 'TOP', 270, -82)
	end
	
	if ns.C.showFocus then
		local focus = self:Spawn('focus', 'oUF_Gvv_Focus')
		focus:SetPoint('TOP', UIParent, 'TOP', 270, -140)
		
		local focustarget = self:Spawn('focustarget', 'oUF_Gvv_FocusTarget')
		focustarget:SetPoint('TOP', focus, 'BOTTOM', 20, -10)
	end
	
	if ns.C.showParty then
		local party = oUF:SpawnHeader('oUF_Gvv_Party', nil, 'party',
			'oUF-initialConfigFunction', [[
				self:SetWidth(100)
				self:SetHeight(65)
			]],
			'showParty', true,
			'yOffset', -30)
		party:SetPoint('TOPLEFT', UIParent,'TOPLEFT', 0, -115)
	end
	
	-- Hide blizz boss frames --
	for i = 1, 4 do
		local frame = _G['Boss'..i..'TargetFrame']
		frame:UnregisterAllEvents()
		frame:Hide()
		frame.Show = function () end
	end	
	
end)
