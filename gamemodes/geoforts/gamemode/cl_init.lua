Sound("weapons/ump45/ump45_boltslap.wav")
Sound("weapons/fiveseven/fiveseven_slideback.wav")
Sound("weapons/p228/p228_sliderelease.wav")
local GM = GM or gmod.GetGamemode()

function surface.MyCreateFont(font, size, weight, underline, antialias, name)
    surface.CreateFont(name, {
        font = font,
        size = size,
        weight = weight,
        underline = underline,
        antialias = antialias,
    })
end

surface.MyCreateFont("csd", 40, 400, false, true, "weaponSelect")
surface.MyCreateFont("csd", 150, 400, false, true, "supply")
GM.geof = {}
GM.geof.const = {}
GM.geof.const.respawninterval = 3

GM.geof.rounds = {"Preround", "Build", "Qualify", "Fight",}

GM.huddata = {}
GM.logogui = [[
	"imgLogo"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"imgLogo"
		"xpos"		"80"
		"ypos"		"32"
		"wide"		"128"
		"tall"		"128"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"image"		"../buildingblocks/logo"
		"scaleImage"	"1"
	}

]]
GM.whitegui = [[
"hud.res"
{
	"whitegui"
	{
		"ControlName"		"Frame"
		"fieldName"		"eInv"
		"xpos"		"475"
		"ypos"		"355"
		"zpos"		"290"
		"wide"		"400"
		"tall"		"66"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"settitlebarvisible"		"1"
		"title"		"%TITLE%"
		"sizable"		"1"
	}
	"frame_topGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_topGrip"
		"xpos"		"8"
		"ypos"		"0"
		"wide"		"384"
		"tall"		"5"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_bottomGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_bottomGrip"
		"xpos"		"8"
		"ypos"		"61"
		"wide"		"374"
		"tall"		"5"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_leftGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_leftGrip"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"5"
		"tall"		"66"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_rightGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_rightGrip"
		"xpos"		"395"
		"ypos"		"0"
		"wide"		"5"
		"tall"		"66"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_tlGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_tlGrip"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"8"
		"tall"		"8"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_trGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_trGrip"
		"xpos"		"392"
		"ypos"		"0"
		"wide"		"8"
		"tall"		"8"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_blGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_blGrip"
		"xpos"		"0"
		"ypos"		"58"
		"wide"		"8"
		"tall"		"8"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_brGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_brGrip"
		"xpos"		"382"
		"ypos"		"48"
		"wide"		"18"
		"tall"		"18"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_caption"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_caption"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"390"
		"tall"		"23"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
	}

]]

function GM.genwhitegui(caption, img)
    if not img then
        return string.gsub(gmod.GetGamemode().whitegui .. "}", "%%TITLE%%", caption)
    else
        return string.gsub(gmod.GetGamemode().whitegui .. gmod.GetGamemode().logogui .. "}", "%%TITLE%%", caption)
    end
end

include('shared.lua')
include('cl_hud.lua')
include('cl_targetid.lua')
include('cl_scoreboard.lua')
include('cl_deathnotice.lua')

function GM:Initialize()
    surface.MyCreateFont("coolvetica", 128, 400, false, false, "ScoreL")
    surface.MyCreateFont("coolvetica", 64, 400, false, false, "ScoreM")
    surface.MyCreateFont("coolvetica", 32, 400, false, false, "ScoreS")
end

function GM:InitPostEntity()
end

function GM:Think()
    --eHUD
    self.huddata.gmRound = self.geof.rounds[LocalPlayer():GetNWInt("gfRound")]
    self.huddata.gmTime = math.max(LocalPlayer():GetNWFloat("gfTime") - CurTime(), 0)
    --LocalPlayer():GetNetworkedBool("gfo"..iteam)
end

function GM:GetTeamColor(ent)
    local team = TEAM_UNASSIGNED

    if ent.Team then
        team = ent:Team()
    end

    return GAMEMODE:GetTeamNumColor(team)
end

function GM:PostProcessPermitted(str)
    return true
end

function GM:ShowHelp()
    --HELP PANEL
    if self.helpFrame and self.helpFrame:IsVisible() then
        self.helpFrame:Remove()
        self.helpFrame = nil
    else
        local cpw, cph = 600, 600

        if self.helpFrame then
            self.helpFrame:Remove()
        end

        local frame = vgui.Create("DFrame")
        self.helpFrame = frame
        frame:SetName("HELPFRM")
        frame:SetTitle("Help")
        frame:SetSize(cpw, cph)
        frame:Center()
        frame:MakePopup()

        local labels = {"Summary", "Preround", "Build", "Qualify", "Fight", "Tips"}

        local texts = {
[[Welcome to Geoforts!

Objective:
Build a fort to protect the flag, fight the enemy to capture the enemy flag.

Do not wall in your own flag as being unable to access your own flag will result in the halving of your weapons' damage rates! (Accessibility is determined by the Qualify round.) In the qualify round, you must extract your team's flag from your base to prove that it is reachable.

F2 - Change Teams
F3 - Change Loadout
F4 - Vote]],

[[Preround

This round is only activated when the server has just been started. There are no rules at this time - just shoot around while you wait for players to join.]],

[[Build Round

- Spawn Points and Block Spawners are moveable. To get building blocks, look for your Block Spawner, highlight a rectangle on one of the side screens, and press your use key.
- To get special building blocks, press the [S] button to activate a submenu. You may spawn Timer boards, Scoreboards, and Armories this way.
- To delete a block, throw it out of the map.

Notice:
If a Spawn Point is obstructed by building blocks, it will delete the offending block(s) when a player spawns.
If a Spawn Point is in an invalid location, it will be teleported to where it was when the map started when a player attempts to spawn to that point.]],

[[Qualify Round

Tag your flag (Rollermine) and bring it back to the center spawn point. A distinct sound will be played once you have tagged the flag and another when you tag the center spawn point again.
The longer you take, the less damage your weapons will do - damage will be cut in half by default if you fail to qualify, and you will not be able to pick up enemy flags.]],

[[Fight Round

- If you passed the Qualify Round, you will be able to capture enemy flags. Tag an enemy team's flag and bring it back to your flag to score points.
- You may use the flag to pick it up. This is sometimes easier than touching it.
- When you are carrying a flag (Rollermine model), it will appear above your head. To see if you are carrying a flag or not, simply look up.
- To change your weapon loadout, press your Spare 1 key (F3 by default).
- Note when spawning, you may cycle to your desired spawn point with your movement keys.
- To get more ammo, make use of the armories you place in build mode, accessed by the [S] menu of the Block Spawner.]],

[[Building Tips

- Spread your spawn points out. You can cycle to any of them easily and minimize travel time.
- Protect your spawn points from enemy camping. Nothing stops the enemy from spawn killing other than a well-built base.
- Make the flag easy to access, but hard to leave with. Note that if it is impossible to leave with the flag, you will not be able to qualify and consequently will not be able to capture flags. As an added penalty, your weapons will do much less damage.
- Coordinate with your allies in construction! If you build without any contact, you may easily end up with a poorly designed fort!
- Do not build against the build wall! The enemy will find it much easier to make a ramp to jump over your wall than you will be able to counter said ramp; don't waste precious build time.]]
}

        local label = vgui.Create("DLabel", self.helpFrame, "txt")
        label:SetPos(8 + 64 + 8, 32)
        label:SetSize(cpw - 64 - 16 - 8, cph - 16 - 32)
        label:SetWrap(true)
        label:SetFont("Trebuchet24")
        label:SetContentAlignment(7)
        label:SetText(texts[1])

        for i = 1, #labels do
            local button = vgui.Create("DButton", self.helpFrame, "btn" .. i)
            button:SetPos(8, 32 + (i - 1) * 32)
            button:SetSize(64, 24)
            button:SetText(labels[i])

            function button:DoClick()
                label:SetText(texts[i])
            end
        end
    end
end

function GM:ShowTeam()
    --TEAM PANEL
    if self.teamsFrame and self.teamsFrame:IsVisible() then
        self.teamsFrame:Remove()
        self.teamsFrame = nil
    else
        local cpw, cph = 216, 168

        if self.teamsFrame then
            self.teamsFrame:Remove()
        end

        local frame = vgui.Create("DFrame")
        self.teamsFrame = frame
        -- self.teamsFrame.frame:LoadControlsFromString(self.genwhitegui("Team Select",true))
        frame:SetName("TEAMFRM")
        frame:SetTitle("Choose Team")
        frame:SetSize(cpw, cph)
        frame:Center()
        frame:MakePopup()

        i = 0
        for iteam = 1, 4 do
            if LocalPlayer():GetNetworkedBool("gfo" .. iteam) then
                i = i + 1
                local button = vgui.Create("DButton", self.teamsFrame, "btn1" .. i)
                button:SetPos(8, 32 + (i - 1) * 32)
                button:SetSize(200, 24)
                button:SetText(team.GetName(iteam))

                function button:DoClick()
                    LocalPlayer():ConCommand("gfteam " .. iteam .. "\n")

                    if frame:IsVisible() then
                        frame:Remove()
                    end
                end
            end
        end
    end
end

--[[function GM:ShowSpare1()
	//EQUIPMENT PANEL
	if self.equipmentFrame and self.equipmentFrame.frame:IsVisible() then
		self.equipmentFrame.frame:Remove()
		self.equipmentFrame = nil
	else
		local cpw,cph = 216,256
		local columns = 2
		columns = columns * 3
		
		if self.equipmentFrame then
			self.equipmentFrame.frame:Remove()
		end
		self.equipmentFrame = {}
		self.equipmentFrame.start = 1
		
		self.equipmentFrame.frame = vgui.Create("DFrame")
		self.equipmentFrame.frame:SetName("whitegui")
		-- self.equipmentFrame.frame:LoadControlsFromString(self.genwhitegui("Equipment"))
		self.equipmentFrame.frame:SetName("EQUIPFRM")
		self.equipmentFrame.frame:SetSize(cpw,cph)
		self.equipmentFrame.frame:SetPos((ScrW() - cpw)*.5,(ScrH() - cph)*.5)
		
		local sel1 = LocalPlayer():GetNetworkedString("gfPrimary")
		local sel2 = LocalPlayer():GetNetworkedString("gfSecondary")
		
		if sel1 == "" then
			sel1 = self.wep.pri[1]
		end
		if sel2 == "" then
			sel2 = self.wep.sec[1]
		end
		
		sel1 = weapons.Get(sel1)
		sel2 = weapons.Get(sel2)
		
		if sel1 then
			sel1 = sel1.IconLetter or ""
		end
		if sel2 then
			sel2 = sel2.IconLetter or ""
		end
		
		local primary = sel1
		local secondary = sel2
		
		self.equipmentFrame.lblPrimary = vgui.Create("DLabel",self.equipmentFrame.frame,"lblPrimary")
		self.equipmentFrame.lblPrimary:SetPos(8,26)
		self.equipmentFrame.lblPrimary:SetSize(cpw-16,24)
		self.equipmentFrame.lblPrimary:SetText("Primary")
		self.equipmentFrame.btnActPrimary = vgui.Create("DButton",self.equipmentFrame.frame,"btnActPrimary")
		self.equipmentFrame.btnActPrimary:SetPos(8,50)
		self.equipmentFrame.btnActPrimary:SetSize(64,50)
		self.equipmentFrame.btnActPrimary:SetFont("weaponSelect")
		self.equipmentFrame.btnActPrimary:SetText(primary)
		self.equipmentFrame.btnActPrimary:SetCommand("pri")
		
		self.equipmentFrame.lblSecondary = vgui.Create("DLabel",self.equipmentFrame.frame,"lblSecondary")
		self.equipmentFrame.lblSecondary:SetPos(8,100)
		self.equipmentFrame.lblSecondary:SetSize(cpw-16,24)
		self.equipmentFrame.lblSecondary:SetText("Secondary")
		self.equipmentFrame.btnActSecondary = vgui.Create("DButton",self.equipmentFrame.frame,"btnActSecondary")
		self.equipmentFrame.btnActSecondary:SetPos(8,124)
		self.equipmentFrame.btnActSecondary:SetSize(64,50)
		self.equipmentFrame.btnActSecondary:SetFont("weaponSelect")
		self.equipmentFrame.btnActSecondary:SetText(secondary)
		self.equipmentFrame.btnActSecondary:SetCommand("sec")
		
		self.equipmentFrame.btnApply = vgui.Create("DButton",self.equipmentFrame.frame,"btnApply")
		self.equipmentFrame.btnApply:SetPos(8,cph-32)
		self.equipmentFrame.btnApply:SetSize(cpw*.5-16,24)
		self.equipmentFrame.btnApply:SetText("Refresh")
		self.equipmentFrame.btnApply:SetCommand("Refresh")
		
		for i = 1, columns do
			self.equipmentFrame["btnSel"..i] = vgui.Create("DButton",self.equipmentFrame.frame,"btnSel"..i)
			self.equipmentFrame["btnSel"..i]:SetPos(78+( math.floor((i-1)/3) )*64,50+50*((i-1)%3))
			self.equipmentFrame["btnSel"..i]:SetSize(64,50)
			self.equipmentFrame["btnSel"..i]:SetFont("weaponSelect")
			self.equipmentFrame["btnSel"..i]:SetText(i)
			self.equipmentFrame["btnSel"..i]:SetCommand(i)
			self.equipmentFrame["btnSel"..i]:SetVisible(false)
		end
		self.equipmentFrame.btnSelPrev = vgui.Create("DButton",self.equipmentFrame.frame,"btnSelPrev")
		self.equipmentFrame.btnSelPrev:SetPos(78,200)
		self.equipmentFrame.btnSelPrev:SetSize(64,16)
		self.equipmentFrame.btnSelPrev:SetText("Previous")
		self.equipmentFrame.btnSelPrev:SetCommand("Prev")
		self.equipmentFrame.btnSelPrev:SetVisible(false)
		
		self.equipmentFrame.btnSelNext = vgui.Create("DButton",self.equipmentFrame.frame,"btnSelNext")
		self.equipmentFrame.btnSelNext:SetPos(78+64*(columns/3-1),200)
		self.equipmentFrame.btnSelNext:SetSize(64,16)
		self.equipmentFrame.btnSelNext:SetText("Next")
		self.equipmentFrame.btnSelNext:SetCommand("Next")
		self.equipmentFrame.btnSelNext:SetVisible(false)
		
		function self.equipmentFrame.frame:ActionSignal(key,value)
			local self = gmod.GetGamemode()
			local draw
			if key == "pri" or key == "sec" then
				self.equipmentFrame.mode = key
				self.equipmentFrame.start = 1
				
				draw = true
			end
			if key == "Next" then
				if self.equipmentFrame.btnSelNext:IsVisible() then
					self.equipmentFrame.start = self.equipmentFrame.start + columns
				end
				
				draw = true
			elseif key == "Prev" then
				if self.equipmentFrame.btnSelPrev:IsVisible() then
					self.equipmentFrame.start = self.equipmentFrame.start - columns
				end
				
				draw = true
			end
			if tonumber(key) then
				local key = tonumber(key)
				LocalPlayer():ConCommand("gf"..self.equipmentFrame.mode.." "..self.wep[self.equipmentFrame.mode][key+self.equipmentFrame.start-1])
				
				timer.Create("gfEquipRefresh",.1,1,self.equipmentFrame.frame.ActionSignal,nil,"Refresh")
			end
			if key == "Refresh" then
				draw = true
			end
			
			if draw then
				for i = 1, columns do
					local weapon = self.wep[self.equipmentFrame.mode][i+self.equipmentFrame.start-1]
					local icon
					if weapon then
						icon = weapons.Get(weapon).IconLetter
					end
					if icon then
						self.equipmentFrame["btnSel"..i]:SetVisible(true)
						self.equipmentFrame["btnSel"..i]:SetText(icon)
					else
						self.equipmentFrame["btnSel"..i]:SetVisible(false)
					end
				end
				if self.equipmentFrame.start > 1 then
					self.equipmentFrame.btnSelPrev:SetVisible(true)
				else
					self.equipmentFrame.btnSelPrev:SetVisible(false)
				end
				if #self.wep[self.equipmentFrame.mode] - self.equipmentFrame.start + 1 > columns then
					self.equipmentFrame.btnSelNext:SetVisible(true)
				else
					self.equipmentFrame.btnSelNext:SetVisible(false)
				end
				
				local primary = weapons.Get(LocalPlayer():GetNetworkedString("gfPrimary")).IconLetter
				local secondary = weapons.Get(LocalPlayer():GetNetworkedString("gfSecondary")).IconLetter
				self.equipmentFrame.btnActPrimary:SetText(primary)
				self.equipmentFrame.btnActSecondary:SetText(secondary)
			end
		end
		
		self.equipmentFrame.frame:SetVisible(true)
	end
end]]

function GM:ShowSpare1()
    --EQUIPMENT PANEL
    if self.equipmentFrame and self.equipmentFrame:IsVisible() then
        self.equipmentFrame:Remove()
        self.equipmentFrame = nil
    else
        local cpw, cph = 1024, 512

        if ScrW() <= 1152 then
            cpw = 512
        elseif ScrW() <= 1280 then
            cpw = 512 + 128
        end

        local columns = 2
        columns = columns * 3

        if self.equipmentFrame then
            self.equipmentFrame:Remove()
        end

        local frame = vgui.Create("DFrame")
        self.equipmentFrame = frame
        frame:SetName("EQUIPFRM")
        frame:SetTitle("Equipment")
        frame:SetSize(cpw, cph)
        frame:Center()
        frame:MakePopup()

        local gfwp = vgui.Create("gfweaponpanel", frame, "gfwp")
        gfwp:SetPos(8, 32)
        gfwp:SetSize(cpw - 8 - 8, cph - 32 - 8)
    end
end

function GM:ShowSpare2()
    --VOTE PANEL
    if self.voteFrame and self.voteFrame:IsVisible() then
        self.voteFrame:Remove()
        self.voteFrame = nil
    else
        local cpw, cph = 192, 32 * 4 + 32 + 8

        if self.voteFrame then
            self.voteFrame:Remove()
        end

        local frame = vgui.Create("DFrame")
        self.voteFrame = frame
        frame:SetName("VOTEFRM")
        frame:SetTitle("Vote")
        frame:SetSize(cpw, cph)
        frame:Center()
        frame:MakePopup()

        local labels = {"Next Round", "Extend Round 5m", "Restart Map", "Reset Flag Position"}
        local commands = {"gf_vote_nextround", "gf_vote_extend", "gf_vote_restartmap", "gf_teamvote_resetflag"}

        for i = 1, #labels do
            local button = vgui.Create("DButton", self.voteFrame, "btn1" .. i)
            button:SetPos(8, 32 + (i - 1) * 32)
            button:SetSize(cpw - 16, 24)
            button:SetText(labels[i])

            function button:DoClick()
                LocalPlayer():ConCommand(commands[i])
                frame:Remove()
            end
        end
    end
end

--How ironic, we have to send the message to the server and retrieve it again using efficient means to waste bandwidth.
function GM.ShowHook(um)
    local self = gmod.GetGamemode()
    local opt = um:ReadShort()

    if opt == 1 then
        self:ShowHelp()
    elseif opt == 2 then
        self:ShowTeam()
    elseif opt == 3 then
        self:ShowSpare1()
    elseif opt == 4 then
        self:ShowSpare2()
    end
end

usermessage.Hook("gfopt", GM.ShowHook)

--Panel
GM.gfweaponpanel = {
    Init = function(self)
        self:GetParent():GetTable().m = {
            x = 0,
            y = 0,
        }
    end,
    Paint = function(self)
        local d = self:GetParent():GetTable()
        local m = d.m

        local c = {
            [1] = Color(0, 0, 0, 50),
            [2] = Color(50, 100, 255, 100),
            [3] = Color(255, 0, 0, 100),
            [4] = Color(0, 255, 0, 100),
        }

        --DEBUG CURSOR
        if false then
            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(m.x, m.y, 16, 8)
            surface.SetFont("Trebuchet18")
            draw.RoundedBox(4, m.x + 16, m.y, surface.GetTextSize(tostring(m.debug)) + 16, 24, Color(0, 0, 0, 100))
            draw.DrawText(tostring(m.debug), "Trebuchet18", m.x + 16 + 8, m.y + 4, Color(255, 255, 255, 255), 0)
        end
    end,
    OnCursorMoved = function(self, x, y)
        self:GetParent():GetTable().m.x = x
        self:GetParent():GetTable().m.y = y
    end,
    OnCursorExited = function(self)
        self:GetParent():GetTable().m.x = 0
        self:GetParent():GetTable().m.y = 0
        self:GetParent():GetTable().m.c = 0
        self:GetParent():GetTable().m.f = 0
    end,
    OnMousePressed = function(self, mc)
        self:GetParent():GetTable().m.c = 1
        self:GetParent():GetTable().m.f = 0
    end,
    OnMouseReleased = function(self, mc)
        self:GetParent():GetTable().m.c = -1
    end,
}

vgui.Register("gfweaponpanel", GM.gfweaponpanel)

--Panel
GM.gfweaponpanel = {
    Init = function(self)
        local GM = gmod.GetGamemode()

        self:GetParent():GetTable().m = {
            x = 0,
            y = 0,
        }

        if not ClientsideModel then return end
        local sel1class = LocalPlayer():GetNetworkedString("gfPrimary")
        local sel2class = LocalPlayer():GetNetworkedString("gfSecondary")

        if sel1class == "" then
            sel1class = GM.wep.pri[1]
        end

        if sel2class == "" then
            sel2class = GM.wep.sec[1]
        end

        local sel1 = weapons.Get(sel1class)
        local sel2 = weapons.Get(sel2class)

        self.wpPrimary = {
            ent = ClientsideModel(sel1.WorldModel),
            classname = sel1class,
            examine = 0,
            shift = 0,
            shiftfrom = 0,
            modesel = 0,
            type = "pri",
        }

        self.wpPrimary.ent:SetNoDraw(true)

        self.wpSecondary = {
            ent = ClientsideModel(sel2.WorldModel),
            classname = sel2class,
            examine = 0,
            shift = 0,
            shiftfrom = 0,
            modesel = 0,
            type = "sec",
        }

        self.wpSecondary.ent:SetNoDraw(true)
        self.wpPriCache = {}

        for k, v in pairs(GM.wep.pri) do
            if v ~= sel1class then
                table.insert(self.wpPriCache, {
                    ent = ClientsideModel(weapons.Get(v).WorldModel, RENDER_GROUP_OPAQUE_ENTITY),
                    classname = v,
                    examine = 0,
                    shift = 0,
                    shiftfrom = 0,
                    modesel = 0,
                    type = "pri",
                })

                self.wpPriCache[#self.wpPriCache].ent:SetNoDraw(true)
            end
        end

        self.mode = "pri"
        self.scrmax = nil --Reset in case of resolution change
        self.lastsel = 0
        self.lastmodesel = 0
    end,
    Paint = function(self)
        local GM = gmod.GetGamemode()
        local d = self:GetParent():GetTable()
        local m = d.m

        local calcscroll = function()
            --Scrolling
            self.scrmax = math.floor(self:GetWide() / 40)
            self.scrind = 1
            self.scrmaxmod = 0
            --Msg(self.scrmax," is the max from",self:GetWide(),"/40\n")
            --if ScrW() < 1152 then
            self.scrmax = self.scrmax - 1
        end

        --end
        if not self.scrmax then
            calcscroll()
        end

        local c = {
            [1] = Color(0, 0, 0, 50),
            [2] = Color(50, 100, 255, 100),
            [3] = Color(255, 0, 0, 100),
            [4] = Color(0, 255, 0, 100),
        }

        --Draw weapon
        local drawweapon

        --Since we can't draw "off" the screen, we have to compromise
        if ScrW() < 1152 then
            --Width and height is always (256,90) horizontally
            drawweapon = function(ent, x, y, ang, mode)
                cam.IgnoreZ(true)
                render.SuppressEngineLighting(true)
                local vCamPos = Vector(12, 64, 0)
                local fFOV = 50
                local x = (x or 0) - 128 + 128
                local y = (y or 0) - 210 + 128

                if mode then
                    vCamPos.x = -12
                    x = x + 140
                end

                local ax, ay = self:LocalToScreen(x, y)

                local sbox = {0, 0, 256, 90}

                surface.SetDrawColor(0, 0, 255, 10)
                --surface.DrawRect(sbox[1]+x+128,sbox[2]+256+y-46,sbox[3],sbox[4])
                --surface.DrawRect(x,y,256,256)
                cam.Start3D(vCamPos, Angle(0, 270, 0), fFOV, ax, ay, 256, 256)
                render.SetLightingOrigin(ent:GetPos())
                ent:SetAngles(ang or Angle(0, 0, 0))
                ent:DrawModel()
                cam.End3D()
                render.SuppressEngineLighting(false)
                cam.IgnoreZ(false)
            end
        else
            --Width and height is always (256,90) horizontally
            drawweapon = function(ent, x, y, ang)
                cam.IgnoreZ(true)
                render.SuppressEngineLighting(true)
                local vCamPos = Vector(12, 128, 0)
                local fFOV = 50
                local x = (x or 0) - 128
                local y = (y or 0) - 210
                local ax, ay = self:LocalToScreen(x, y)

                local sbox = {0, 0, 256, 90}

                --surface.SetDrawColor(0,0,i/#self.Ents*255,255)
                --surface.DrawRect(sbox[1]+x+128,sbox[2]+256+y-46,sbox[3],sbox[4])
                cam.Start3D(vCamPos, Angle(0, 270, 0), fFOV, ax, ay, 512, 512)
                render.SetLightingOrigin(ent:GetPos())
                ent:SetAngles(ang or Angle(0, 0, 0))
                ent:DrawModel()
                cam.End3D()
                render.SuppressEngineLighting(false)
                cam.IgnoreZ(false)
            end
        end

        --Calculate limbo
        local wpcalclimbospeed = function(dat, time)
            dat.spd = {}
            dat.spd.x = (dat.pos.x - dat.dpos.x) / time
            dat.spd.y = (dat.pos.y - dat.dpos.y) / time
            dat.spd.ap = (dat.ang.p - dat.dang.p) / time
            dat.spd.ay = (dat.ang.y - dat.dang.y) / time
            dat.spd.ar = (dat.ang.r - dat.dang.r) / time
            dat.timeleft = time
        end

        local wpmoveto = function(dat, pos, ang, time, callback)
            dat.dpos = pos
            dat.dang = ang
            dat.callback = callback or dat.callback or function() end
            wpcalclimbospeed(dat, time)
        end

        --Draw test model
        self.ltime = self.ltime or RealTime()
        local delta = RealTime() - self.ltime
        self.ltime = RealTime()
        local curmodesel = 0

        if self.wpPrimary then
            --256,90
            if m.x > 0 and m.x < 256 and m.y > 0 and m.y < 90 then
                curmodesel = 1

                if self.lastmodesel ~= 1 then
                    surface.PlaySound("weapons/fiveseven/fiveseven_slideback.wav")
                end

                self.wpPrimary.modesel = math.Approach(self.wpPrimary.modesel, 1, delta * 5)

                if m.c == 1 then
                    m.c = 2

                    m.f = {"modeselpri"}
                elseif m.c == -1 and type(m.f) == "table" and m.f[1] == "modeselpri" then
                    m.c = 0
                    m.f = 0
                    --Load secondary weapons into the cache
                    self.wpPriCache = {}

                    for k, v in pairs(GM.wep.pri) do
                        if v ~= self.wpPrimary.classname then
                            table.insert(self.wpPriCache, {
                                ent = ClientsideModel(weapons.Get(v).WorldModel, RENDER_GROUP_OPAQUE_ENTITY),
                                classname = v,
                                examine = 0,
                                shift = 0,
                                shiftfrom = 0,
                                modesel = 0,
                                type = "pri",
                            })

                            self.wpPriCache[#self.wpPriCache].ent:SetNoDraw(true)
                        end
                    end

                    calcscroll()
                    self.mode = "pri"
                end
            else
                self.wpPrimary.modesel = math.Approach(self.wpPrimary.modesel, 0, delta)
            end

            drawweapon(self.wpPrimary.ent, 0, 0, Angle(0, 0, 0) + self.wpPrimary.modesel * Angle(0, 45, 0))
        end

        if self.wpSecondary then
            if m.x > 0 and m.x < 256 and m.y > 90 and m.y < 180 then
                curmodesel = 2

                if self.lastmodesel ~= 2 then
                    surface.PlaySound("weapons/fiveseven/fiveseven_slideback.wav")
                end

                self.wpSecondary.modesel = math.Approach(self.wpSecondary.modesel, 1, delta * 5)

                if m.c == 1 then
                    m.c = 2

                    m.f = {"modeselsec"}
                elseif m.c == -1 and type(m.f) == "table" and m.f[1] == "modeselsec" then
                    m.c = 0
                    m.f = 0
                    --Load secondary weapons into the cache
                    self.wpPriCache = {}

                    for k, v in pairs(GM.wep.sec) do
                        if v ~= self.wpSecondary.classname then
                            table.insert(self.wpPriCache, {
                                ent = ClientsideModel(weapons.Get(v).WorldModel, RENDER_GROUP_OPAQUE_ENTITY),
                                classname = v,
                                examine = 0,
                                shift = 0,
                                shiftfrom = 0,
                                modesel = 0,
                                type = "sec",
                            })

                            self.wpPriCache[#self.wpPriCache].ent:SetNoDraw(true)
                        end
                    end

                    calcscroll()
                    self.mode = "sec"
                end
            else
                self.wpSecondary.modesel = math.Approach(self.wpSecondary.modesel, 0, delta)
            end

            drawweapon(self.wpSecondary.ent, 0, 90, Angle(0, 0, 0) + self.wpSecondary.modesel * Angle(0, 45, 0))
        end

        self.lastmodesel = curmodesel

        if not self.limbo then
            self.limbo = {}
        end

        local selected = 0
        local examineoff = Angle(-90, -90, 90) - Angle(-45, -90, 45)
        local bmin = self.scrind
        local bmax = math.min(#self.wpPriCache, self.scrind + self.scrmax - 1 + self.scrmaxmod)

        if m.y > self:GetTall() - 256 and m.y < self:GetTall() - 32 then
            selected = math.floor(m.x / 40) + self.scrind - 1
        end

        --Scroll bar
        local viewcolor = Color(0, 0, 0, 127)

        if m.y > self:GetTall() - 28 and m.y < self:GetTall() - 4 then
            viewcolor = Color(0, 0, 255, 127)

            if m.c == 1 then
                m.f = {"scroll", m.x, self.scrind}

                m.c = 2
            elseif m.c == 2 and type(m.f) == "table" and m.f[1] == "scroll" then
                viewcolor = Color(255, 0, 0, 127)
                self.scrind = math.Clamp(m.f[3] + math.Round(math.Round(m.x - m.f[2]) / ((1 / (#self.wpPriCache - self.scrmaxmod)) * (self:GetWide() - 8))), 1, math.max(#self.wpPriCache - self.scrmax, 0) + 1)
            end
        end

        local vieww = (self.scrmax / math.max(#self.wpPriCache - self.scrmaxmod, 1)) * (self:GetWide() - 8)
        local viewx = ((self.scrind - 1) / (#self.wpPriCache - self.scrmaxmod)) * (self:GetWide() - 8)
        draw.RoundedBox(4, 0, self:GetTall() - 32, self:GetWide(), 32, Color(0, 0, 0, 127))
        draw.RoundedBox(4, 0 + 4 + viewx, self:GetTall() - 32 + 4, vieww, 32 - 8, viewcolor)

        for i = bmin, bmax do
            local examine = examineoff * self.wpPriCache[i].examine

            --Examine angle is	Angle(-90,-90,90)
            --Examine
            if selected ~= i then
                local dat = self.wpPriCache[i]

                if dat.examine > 0 then
                    dat.examine = dat.examine + delta * -1
                end

                if dat.examine < 0 then
                    dat.examine = 0
                end
            elseif self.wpPrimary and self.wpSecondary then
                --Do not examine if a weapon is being exchanged
                local dat = self.wpPriCache[i]

                if dat.examine < 1 then
                    dat.examine = dat.examine + delta * 3
                end

                if dat.examine > 1 then
                    dat.examine = 1
                end

                if self.lastsel ~= selected then
                    self.lastsel = selected
                    surface.PlaySound("weapons/fiveseven/fiveseven_slideback.wav")
                end
            end

            --Shift
            local shift = 0

            if true or self.wpPriCache[i].shift ~= 0 then
                self.wpPriCache[i].shift = math.Approach(self.wpPriCache[i].shift, 0, delta * 3)
                shift = self.wpPriCache[i].shiftfrom - self.wpPriCache[i].shift
            end

            --Draw
            drawweapon(self.wpPriCache[i].ent, (i - self.scrind) * 40 - 128 - 20 + (shift * 40), self:GetTall() - 256 + 32 + 90, Angle(-45, -90, 45) + examine, true)
            --surface.SetDrawColor(0,0,255,63)
            --surface.DrawRect(0,256,self:GetWide(),self:GetTall()-256)
            --surface.DrawRect(35+40*(selected-1),256,40,self:GetTall()-256)
        end

        if selected > bmax then
            selected = 0
            self.lastsel = 0
        elseif selected < self.scrind then
            selected = 0
            self.lastsel = 0
        end

        --Do the limbo!
        for k, v in pairs(self.limbo) do
            v.pos.x = math.Approach(v.pos.x, v.dpos.x, delta * v.spd.x)
            v.pos.y = math.Approach(v.pos.y, v.dpos.y, delta * v.spd.y)
            v.ang.p = math.Approach(v.ang.p, v.dang.p, delta * v.spd.ap)
            v.ang.y = math.Approach(v.ang.y, v.dang.y, delta * v.spd.ay)
            v.ang.r = math.Approach(v.ang.r, v.dang.r, delta * v.spd.ar)
            v.timeleft = math.Approach(v.timeleft, 0, delta)
            drawweapon(v.ent, v.pos.x, v.pos.y, v.ang)

            if v.timeleft == 0 and v.callback then
                v.callback(self, v)
                v.callback = nil
            end
        end

        --Clicks
        if selected > 0 and self.wpPrimary and self.wpSecondary then
            if m.c == 1 then
                m.f = {"selpri", selected}

                m.c = 2
            elseif m.c == -1 and type(m.f) == "table" and m.f[1] == "selpri" and m.f[2] == selected then
                local dat = table.remove(self.wpPriCache, selected)
                m.f = 0
                m.c = 0

                --Shift the remaining weapons
                for i = selected, #self.wpPriCache do
                    self.wpPriCache[i].shift = self.wpPriCache[i].shift - 1
                    self.wpPriCache[i].shiftfrom = self.wpPriCache[i].shiftfrom + 0 --Since the element has been removed...
                end

                --Place the weapon in limbo
                local shift = -1 * dat.shift * 40
                local examine = examineoff * dat.examine

                dat.pos = {
                    x = (selected - self.scrind) * 40 - 128 - 20 + shift,
                    y = self:GetTall() - 256 + 32 + 90,
                }

                dat.ang = Angle(-45, -90, 45) + examine

                dat.callback = function(self, dat)
                    --Replace the inventory slot
                    if dat.type == "pri" then
                        self.wpPrimary = dat
                    elseif dat.type == "sec" then
                        self.wpSecondary = dat
                    end
                end

                if self.mode == "pri" then
                    surface.PlaySound("weapons/ump45/ump45_boltslap.wav")
                elseif self.mode == "sec" then
                    surface.PlaySound("weapons/p228/p228_sliderelease.wav")
                end

                self.scrmaxmod = self.scrmaxmod - 1
                RunConsoleCommand("gf" .. self.mode, dat.classname)
                dat.modesel = 0

                if dat.type == "pri" then
                    wpmoveto(dat, {
                        x = 0,
                        y = 0
                    }, Angle(0, 0, 0), .3)
                elseif dat.type == "sec" then
                    wpmoveto(dat, {
                        x = 0,
                        y = 90
                    }, Angle(0, 0, 0), .3)
                end

                table.insert(self.limbo, dat)
                --Shift the primary weapon into the table
                local i = 0

                for k, v in pairs(GM.wep[self.mode]) do
                    if v ~= dat.classname then
                        i = i + 1
                    end

                    if (dat.type == "pri" and self.wpPrimary and v == self.wpPrimary.classname) or (dat.type == "sec" and self.wpSecondary and v == self.wpSecondary.classname) then
                        --Place into limbo
                        local dat1

                        if dat.type == "pri" then
                            dat1 = self.wpPrimary
                            self.wpPrimary = nil

                            dat1.pos = {
                                x = 0,
                                y = 0
                            }
                        elseif dat.type == "sec" then
                            dat1 = self.wpSecondary
                            self.wpSecondary = nil

                            dat1.pos = {
                                x = 0,
                                y = 90
                            }
                        end

                        dat1.ang = Angle(0, 0, 0) + dat1.modesel * Angle(0, 45, 0)
                        dat1.slot = i

                        dat1.callback = function(self, dat)
                            for i = dat.slot, #self.wpPriCache do
                                self.wpPriCache[i].shift = self.wpPriCache[i].shift - 0
                                self.wpPriCache[i].shiftfrom = self.wpPriCache[i].shiftfrom - 1
                            end

                            table.insert(self.wpPriCache, dat.slot, dat)

                            for i, o in pairs(self.limbo) do
                                if o == dat then
                                    table.remove(self.limbo, i)
                                end
                            end

                            self.scrmaxmod = self.scrmaxmod + 1
                        end

                        wpmoveto(dat1, {
                            x = (i - self.scrind) * 40 - 128 - 20,
                            y = self:GetTall() - 256 + 32 + 90,
                        }, Angle(-45, -90, 45), .3)

                        table.insert(self.limbo, dat1)

                        --Shift remaining weapons
                        for j = i, #self.wpPriCache do
                            self.wpPriCache[j].shift = self.wpPriCache[j].shift + 1
                            self.wpPriCache[j].shiftfrom = self.wpPriCache[j].shiftfrom + 1
                        end

                        break
                    end
                end
            end
        end

        if m.c == -1 then
            m.c = 0
            m.f = 0
        end

        --DEBUG CURSOR
        if false then
            local debug = "(" .. m.x .. "," .. m.y .. "): " .. tostring(m.debug)
            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(m.x, m.y, 16, 8)
            surface.SetFont("Trebuchet18")
            draw.RoundedBox(4, m.x + 16, m.y, surface.GetTextSize(tostring(debug)) + 16, 24, Color(0, 0, 0, 100))
            draw.DrawText(tostring(debug), "Trebuchet18", m.x + 16 + 8, m.y + 4, Color(255, 255, 255, 255), 0)
        end
    end,
    OnCursorMoved = function(self, x, y)
        self:GetParent():GetTable().m.x = x
        self:GetParent():GetTable().m.y = y
    end,
    OnCursorExited = function(self)
        self:GetParent():GetTable().m.x = -1
        self:GetParent():GetTable().m.y = -1
        self:GetParent():GetTable().m.c = 0
        self:GetParent():GetTable().m.f = 0
    end,
    OnMousePressed = function(self, mc)
        self:GetParent():GetTable().m.c = 1
        self:GetParent():GetTable().m.f = 0
    end,
    OnMouseReleased = function(self, mc)
        self:GetParent():GetTable().m.c = -1
    end,
    OnMouseWheeled = function(self, delta)
        if delta > 0 then
            self.scrind = math.Clamp(self.scrind + 1, 1, math.max(#self.wpPriCache - self.scrmax, 0) + 1)
        else
            self.scrind = math.Clamp(self.scrind - 1, 1, math.max(#self.wpPriCache - self.scrmax, 0) + 1)
        end
    end,
}

vgui.Register("gfweaponpanel", GM.gfweaponpanel)