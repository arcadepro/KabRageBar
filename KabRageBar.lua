-- change bar width and height here
local width = 120
local height = 26

-- change xpos and ypos here to the position relative to center of screen

-- a negative xpos goes left, a positive xpos goes right
-- a negative ypos goes down, a positive ypos goes up
local xpos = 0
local ypos = -184

-- there's no need to change anything below this line

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

--print(class, r,g,b)
--if class == "WARRIOR" then

local f = CreateFrame("Frame","KabRageBar",UIParent)
f:SetFrameStrata("LOW")
f:EnableMouse(false)
f:EnableMouseWheel(false)

f:SetBackdrop( { bgFile="Interface\\ChatFrame\\ChatFrameBackground",
edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=false,tileSize=16,
edgeSize=16,insets={left=3,right=3,top=3,bottom=3}} )
f:SetBackdropColor(0.1,0.1,0.1)
f:SetBackdropBorderColor(0.2,0.2,0.2)

f:SetSize(width,height)
f:SetPoint("CENTER",xpos,ypos)

f.bar = f:CreateTexture(nil,"BACKGROUND",nil,1)
f.bar:SetHeight(f:GetHeight()-6)
f.bar:SetPoint("LEFT",3,0)
f.bar:SetTexture("Interface\\TargetingFrame\\BarFill2")
f.bar:SetWidth(0)
f.bar:SetVertexColor(r,g,b)
f.bar:Hide()

--f.text = f:CreateFontString(nil,"ARTWORK","NumberFont_Outline_Med")
--f.text = f:CreateFontString(nil,"ARTWORK", "Game13Font")
f.text = f:CreateFontString(nil,"ARTWORK")
f.text:SetPoint("CENTER")
f.text:SetFont("FONTS\\FRIZQT__.TTF", 13, "OUTLINE")
--f.text:SetJustifyH("CENTER")
--f.text:SetShadowOffset(1, -1)
f.text:Show()

f.elapsed = 0.133

local function clearbar()
	f.bar:SetWidth(0)
	f.text:SetText(format("%d",(0)))
	f:SetAlpha(0)
	--f.bar:Hide()
end

local function updatecolor()
--print("lol")
		if class == "DRUID" then
			local form = GetShapeshiftFormID()
			if form == 1 then
				--print("catform")
				r,g,b = 1,1,0
			elseif form == 5 then
				--print("bearform")
				r,g,b = 1,0,0
			else
				r,g,b = 0,0,1
			end
				--[[ 		if form == 2 then print("treeform") end
					if form == 3 then print("travelform") end
					if form == 31 then print("moonkinform") end
					if form == 36 then print("treantform") end
					if form == 27 then print("flightform") end
					if form == nil then print("humanoid") end
				--]]
		end
end


f:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed - elapsed
	if self.elapsed > 0 then return end
	self.elapsed = 0.133

	local power = UnitPower("player")
	local maxPower = UnitPowerMax("player")

	if power == 0 then
		f.text:SetText(format("%d",0))
		--f:SetAlpha(0)
		f.bar:Hide()
	elseif power == maxPower and showcapped == true then
		f.bar:SetVertexColor(1,1,1) --white
		f.bar:SetWidth(power*(width-6)/maxPower)
		f.text:SetText(format("%d",power))
		--f:SetAlpha(1)
		f.bar:Show()
	else
		f.bar:SetVertexColor(r,g,b)
		f.bar:SetWidth(power*(width-6)/maxPower)
		f.text:SetText(format("%d",power))
		--f:SetAlpha(1)
		f.bar:Show()
	end
end)

f:SetScript("OnEvent",updatecolor)
--f:RegisterUnitEvent("UNIT_POWER_FREQUENT","player")
f:RegisterUnitEvent("UNIT_DISPLAYPOWER","player")
--f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
--f:RegisterEvent("PLAYER_REGEN_ENABLED")
--f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_LOGIN")
f:Show()
