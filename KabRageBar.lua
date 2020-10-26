local width = 108
local height = 25
local state = 1
local xpos = 0
local ypos = -155
local covenant = "none" -- (none,nec,ven,kyr,fae)
local border = "classic" -- (classic, shadowlands)

---

if border == "shadowlands" then
	bgPath = "Interface\\Tooltips\\UI-Tooltip-Background-Maw"
	edgePath = "Interface\\Tooltips\\UI-Tooltip-Border-Maw"
	ypos = -154
else
	bgPath = "Interface\\Tooltips\\UI-Tooltip-Background"
	edgePath = "Interface\\Tooltips\\UI-Tooltip-Border"
	ypos = -155
end

if covenant == "nec" then
	bdr,bdg,bdb,bda = 0.7,0.9,0.7,1	--border r,g,b,a
	bkr,bkg,bkb,bka = 0.2,0.4,0.2,1	--background r,g,b,a
elseif covenant == "ven" then
	bdr,bdg,bdb,bda = 1.0,0.5,0.4,1
	bkr,bkg,bkb,bka = 0.2,0.1,0.1,1
elseif covenant == "kyr" then
	bdr,bdg,bdb,bda = 0.7,0.8,1.0,1
	bkr,bkg,bkb,bka = 0.3,0.4,0.9,1
elseif covenant == "fae" then
	bdr,bdg,bdb,bda = 0.6,0.5,0.9,1
	bkr,bkg,bkb,bka = 0.3,0.1,0.3,1
else
	bdr,bdg,bdb,bda = 0.15,0.15,0.15,1
	bkr,bkg,bkb,bka = 0.15,0.15,0.15,1
end

local r,g,b = 0,0,1 -- blue default
local _,class = UnitClass("player")
local showcapped = false

-- https://wow.gamepedia.com/Power_colors
-- https://wow.gamepedia.com/Class_colors

if class == "DEATHKNIGHT" then r,g,b = 0,0.82,1 end
--if class == "DEMONHUNTER" then r,g,b = 1,0.61,0 end -- veng
if class == "DEMONHUNTER" then r,g,b = 0.788,0.259,0.992 end -- havoc
-- if class == "DRUID" then  r,g,b = 1,0,0 end -- guardian
if class == "DRUID" then  r,g,b = 0,0,1 end -- resto,moonkin
--if class == "DRUID" then  r,g,b = 1,1,0 end -- feral
if class == "HUNTER" then r,g,b = 1,0.5,0.25 end
--if class == "MAGE" then r,g,b = 0,0,1 end
if class == "MONK" then r,g,b = 1,1,0 end
--if class == "PALADIN" then r,g,b = 0,0,1 end
--if class == "PRIEST" then r,g,b = 0.4,0,0.8 end --shadow
--if class == "PRIEST" then r,g,b = 0,0,1 end
if class == "ROGUE" then  r,g,b = 1,1,0 end
--if class == "SHAMAN" then r,g,b = 0,0.50,1 end -- enhance
--if class == "SHAMAN" then r,g,b = 0,0,1 end -- elem,resto
--if class == "WARLOCK" then r,g,b = 0,0,1 end
if class == "WARRIOR" then r,g,b = 1,0,0 end

local f = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
--f:SetFrameStrata("LOW")
f:EnableMouse(false)
f:EnableMouseWheel(false)
f:SetSize(width,height)
f:SetPoint("CENTER",xpos,ypos)

f:SetBackdrop({ bgFile=bgPath,
				edgeFile=edgePath,
				tile=false,
				edgeSize=16,
				insets={left=3,right=3,top=3,bottom=3}})

f:SetBackdropColor(bkr,bkg,bkb,bka)
f:SetBackdropBorderColor(bdr,bdg,bdb,bda)

f.bar = f:CreateTexture(nil,"BACKGROUND",nil,1)
f.bar:SetAlpha(0)
f.bar:SetWidth(0)
f.bar:SetHeight(f:GetHeight()-6)
f.bar:SetPoint("LEFT",3,0)
f.bar:SetTexture("Interface\\TargetingFrame\\BarFill2")
f.bar:SetVertexColor(r,g,b)

--f.text = f:CreateFontString(nil,"ARTWORK","NumberFont_Outline_Med")
--f.text = f:CreateFontString(nil,"ARTWORK", "Game13Font")
f.text = f:CreateFontString(nil,"ARTWORK")
f.text:SetPoint("CENTER")
f.text:SetFont("FONTS\\FRIZQT__.TTF", 12, "OUTLINE")
f.text:Show()

f.elapsed = 0.10

local function vehicleHider()
	if OverrideActionBar:IsShown() then f:SetAlpha(0) else f:SetAlpha(1) end
end

local function hideFrame()
	f:SetAlpha(0)
	state = 0
end

local function showFrame()
	if OverrideActionBar:IsShown() then return end
    f:SetAlpha(1)
	state = 1
end

f:SetScript("OnEvent", function(self, event, name, ...)
	if event == "UPDATE_OVERRIDE_ACTIONBAR" then
		C_Timer.After(1.5, vehicleHider)
	end
	if event == "CINEMATIC_START" then
		C_Timer.After(0.5, hideFrame)
	end
	if event == "CINEMATIC_STOP" then
		C_Timer.After(1.5, showFrame)
	end
end)

f:SetScript("OnUpdate", function(self, elapsed)
	if state == 0 then return end
	self.elapsed = self.elapsed - elapsed
	if self.elapsed > 0 then return end
	self.elapsed = 0.10
	local power = UnitPower("player")
	local maxPower = UnitPowerMax("player")

	if power == 0 then
		f.text:SetText(format("%d",0))
		f.bar:SetAlpha(0)
	elseif power == maxPower and showcapped == true then
		f.bar:SetVertexColor(1,1,1) --white
		f.bar:SetWidth(power*(width-6)/maxPower)
		f.text:SetText(format("%d",power))
		f.bar:SetAlpha(1)
	else
		f.bar:SetVertexColor(r,g,b)
		f.bar:SetWidth(power*(width-6)/maxPower)
		f.text:SetText(format("%d",power))
		f.bar:SetAlpha(1)
	end
end)

PlayerFrame:HookScript('OnHide', hideFrame)
PlayerFrame:HookScript('OnShow', showFrame)
--f:RegisterUnitEvent("UNIT_DISPLAYPOWER","player")
--f:RegisterEvent("PLAYER_DEAD")
--f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
--f:RegisterEvent("PLAY_MOVIE")
f:RegisterEvent("CINEMATIC_START")
f:RegisterEvent("CINEMATIC_STOP")
