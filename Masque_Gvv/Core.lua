local LAB = LibStub("LibActionButton-1.0", true)
if LAB then
	-- Bartender4
	LAB.RegisterCallback("Masque_Gvv", "OnButtonCreated", function(_, self)
		local scale = self:GetParent():GetScale()
		local hotkey = _G[self:GetName() .. "HotKey"]

		if hotkey then
			self.hkbg = CreateFrame("Frame", nil, self)
			self.hkbg:SetAllPoints(self)
			self.hkbg:SetFrameLevel(6)
			local t = self.hkbg:CreateTexture(nil, "ARTWORK")
			t:SetTexture("Interface\\Addons\\Masque_Gvv\\Textures\\hotkey_bg")
			t:SetPoint("CENTER", hotkey, "CENTER", 0, 0)
			t:SetSize(16, 16)
			hooksecurefunc(hotkey, "Hide", function(self)
						local button = self:GetParent()
						button.hkbg:Hide()
						end)
			hooksecurefunc(hotkey, "Show", function(self)
						local button = self:GetParent()
						button.hkbg:Show()
						end)

		end
	end)

	LAB.RegisterCallback("Masque_Gvv", "OnButtonUpdate", function(_, self)
		local scale = self:GetParent():GetScale()
		local hotkey = _G[self:GetName() .. "HotKey"]

		local gwfont = "Interface\\Addons\\Masque_Gvv\\Fonts\\menomonia.ttf"
		if hotkey then
			hotkey:ClearAllPoints()
			hotkey:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
			hotkey:SetJustifyH("CENTER")
			hotkey:SetFont(gwfont, 12, "")
			hotkey:SetTextColor(1, 1, 1, 1)
		end
		local count = _G[self:GetName() .. "Count"]
		if count then
			local _, size = NumberFontNormal:GetFont()
			count:ClearAllPoints()
			count:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -5)
			count:SetJustifyH("RIGHT")
			count:SetFont(gwfont, size + 2, "OUTLINE")
		end
		local macro = _G[self:GetName() .. "Name"]
		if macro then
			local font, size = GameFontHighlight:GetFont()
			macro:ClearAllPoints()
			macro:SetPoint("TOP", self, "TOP", 0, 0)
			macro:SetJustifyH("CENTER")
			macro:SetFont(font, 8, "OUTLINE")
		end
	end)
end