--[[
	Magic. Do not touch. Thank you.
]]

local MSQ = LibStub("Masque", true)
if not MSQ then return end

-- Based on Masque default Blizzard skin.
-- Improved Blizzard skin. Thanks to Maul for the reference!
MSQ:AddSkin("oUF_Gvv", {
	Author = "Raka-loah",
	Version = "7.0.1",
	Masque_Version = 60201,
	Shape = "Square",
	Backdrop = {
		Width = 32,
		Height = 32,
		TexCoords = {0.2, 0.8, 0.2, 0.8},
		Texture = [[Interface\Buttons\UI-EmptySlot]],
	},
	Icon = {
		Width = 30,
		Height = 30,
		TexCoords = {0.07, 0.93, 0.07, 0.93},
	},
	Flash = {
		Width = 30,
		Height = 30,
		TexCoords = {0.2, 0.8, 0.2, 0.8},
		Texture = [[Interface\Buttons\UI-QuickslotRed]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	ChargeCooldown = {
		Width = 32,
		Height = 32,
	},
	Pushed = {
		Width = 34,
		Height = 34,
		Texture = [[Interface\Buttons\UI-Quickslot-Depress]],
	},
	Normal = {
		Width = 56,
		Height = 56,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-Quickslot2]],
		EmptyTexture = [[Interface\Buttons\UI-Quickslot]],
		EmptyColor = {1, 1, 1, 0.5},
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 31,
		Height = 31,
		BlendMode = "ADD",
		Texture = [[Interface\Buttons\CheckButtonHilight]],
	},
	Border = {
		Width = 60,
		Height = 60,
		OffsetX = 0.5,
		OffsetY = 0.5,
		BlendMode = "ADD",
		Texture = [[Interface\Buttons\UI-ActionButton-Border]],
	},
	Gloss = {
		Hide = true,
	},
	AutoCastable = {
		Width = 56,
		Height = 56,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 30,
		Height = 30,
		BlendMode = "ADD",
		Texture = [[Interface\Buttons\ButtonHilight-Square]],
	},
	Name = {
		Width = 32,
		Height = 10,
		OffsetY = 22,
		OffsetX = 1,
		JustifyH = "LEFT",
		JustifyV = "TOP",
	},
	Count = {
		Width = 32,
		Height = 10,
		OffsetX = -4,
		OffsetY = 20,
	},
	HotKey = {
		Width = 32,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "CENTER",
		OffsetX = 3,
		OffsetY = -24,
	},
	Duration = {
		Width = 36,
		Height = 10,
		OffsetY = -2,
	},
	Shine = {
		Width = 32,
		Height = 32,
		OffsetX = 0.5,
		OffsetY = -0.5
	},
})

-- Font fix
local LAB = LibStub("LibActionButton-1.0", true)
if LAB then
	-- Bartender4
	LAB.RegisterCallback("Masque_Gvv", "OnButtonCreated", function(_, self)
		local scale = self:GetParent():GetScale()
		local hotkey = _G[self:GetName() .. "HotKey"]
		local gwfont = "Interface\\Addons\\Masque_Gvv\\Fonts\\menomonia.ttf"
		if hotkey then
			hotkey:SetFont(gwfont, 9, "NONE")
			hotkey:SetTextColor(1, 1, 1, 1)
			self.hkbg = CreateFrame("Frame", nil, self)
			self.hkbg:SetAllPoints(self)
			self.hkbg:SetFrameLevel(2)
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
		local count = _G[self:GetName() .. "Count"]
		if count then
			local _, size = NumberFontNormal:GetFont()
			count:SetFont(gwfont, size, "OUTLINE")
		end
		local macro = _G[self:GetName() .. "Name"]
		if macro then
			local font, size = GameFontHighlight:GetFont()
			macro:SetFont(font, 8, "OUTLINE")
		end
	end)
end