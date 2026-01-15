-- focus frame part, disgustingly vibe-code duplicated from target frame and oh-so-many bugs hand-corrected


--========================================================
-- Focus Frame Styling (Retail)
--========================================================

local function FocusFrameLayout(forceNormalTexture)
	if not FocusFrame or not FocusFrame:IsShown() then return end

	local unit = "focus"
	local classification = UnitClassification(unit)

	local healthBar = FocusFrame.healthbar
	local manaBar   = FocusFrame.manabar
	local name      = FocusFrame.name
	local levelText = FocusFrame.levelText
	local texture   = FocusFrameTextureFrameTexture
	
	
	FocusFrameBackground:Hide()
	FocusFrameNameBackground:Hide()

	if not (healthBar and manaBar and name) then return end

	-- Name color
	if UnitIsCivilian(unit) then
		name:SetTextColor(1, 0, 0)
	else
		name:SetTextColor(1, 0.82, 0)
	end

	-- Name positioning
	name:ClearAllPoints()
	name:SetPoint("LEFT", FocusFrame, "LEFT", 30, 36)
	name:SetSize(65, 10)

	-- Health bar
	healthBar:ClearAllPoints()
	healthBar:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 22, -28)
	healthBar:SetSize(120, 26)

	if healthBar.LeftText then
		healthBar.LeftText:SetPoint("LEFT", healthBar, "LEFT", 5, 0)
	end
	if healthBar.RightText then
		healthBar.RightText:SetPoint("RIGHT", healthBar, "RIGHT", -3, 0)
	end
	if healthBar.TextString then
		healthBar.TextString:SetPoint("CENTER", healthBar, "CENTER", 0, 0)
	end

	-- Mana bar
	manaBar:ClearAllPoints()
	manaBar:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 22, -55)
	manaBar:SetHeight(12)

	if manaBar.LeftText then
		manaBar.LeftText:SetPoint("LEFT", manaBar, "LEFT", 5, 0)
	end
	if manaBar.RightText then
		manaBar.RightText:SetPoint("RIGHT", manaBar, "RIGHT", -3, 0)
	end
	if manaBar.TextString then
		manaBar.TextString:SetPoint("CENTER", manaBar, "CENTER", 0, 0)
	end

	-- Statusbar texture
	if cfg.whoaTexture then
		healthBar:SetStatusBarTexture(
			"Interface\\AddOns\\whoaThickFrames_Classic\\media\\statusbar\\whoa"
		)
	end
end

--========================================================
-- Focus Frame Texture Selector
--========================================================
local function FocusFrameTextureSelector(forceNormalTexture)
	if not FocusFrameTextureFrameTexture then return end

	local unit = "focus"
	local classification = UnitClassification(unit)

	local path = "Interface\\AddOns\\whoaThickFrames_Classic\\media\\light\\"
	if cfg.darkFrames then
		path = "Interface\\AddOns\\whoaThickFrames_Classic\\media\\dark\\"
	end

	if forceNormalTexture then
		FocusFrameTextureFrameTexture:SetTexture(path.."UI-TargetingFrame")
	elseif classification == "minus" then
		FocusFrameTextureFrameTexture:SetTexture(path.."UI-TargetingFrame-Minus")
	elseif classification == "worldboss" or classification == "elite" then
		FocusFrameTextureFrameTexture:SetTexture(path.."UI-TargetingFrame-Elite")
	elseif classification == "rareelite" then
		FocusFrameTextureFrameTexture:SetTexture(path.."UI-TargetingFrame-Rare-Elite")
	elseif classification == "rare" then
		FocusFrameTextureFrameTexture:SetTexture(path.."UI-TargetingFrame-Rare")
	else
		FocusFrameTextureFrameTexture:SetTexture(path.."UI-TargetingFrame")
	end
end

--========================================================
-- Event-driven updates (Retail replacement for hooks)
--========================================================
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_FOCUS_CHANGED")
f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("UNIT_POWER_UPDATE")
f:RegisterEvent("UNIT_CLASSIFICATION_CHANGED")

f:SetScript("OnEvent", function(_, event, unit)
	if unit and unit ~= "focus" and event ~= "PLAYER_FOCUS_CHANGED" then return end

	FocusFrameLayout()
	FocusFrameTextureSelector()
end)

--========================================================
-- Apply on show (frame creation / reload)
--========================================================
FocusFrame:HookScript("OnShow", function()
	FocusFrameLayout()
	FocusFrameTextureSelector()
end)
