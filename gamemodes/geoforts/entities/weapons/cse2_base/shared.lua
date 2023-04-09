Sound("weapons/ClipEmpty_Rifle.wav")
Sound("weapons/smg1/switch_single.wav")
Sound("weapons/smg1/switch_burst.wav")

--TODO: Allow use of scope on completely empty sniper rifles
--TODO: Decide on ROLL after PITCH and YAW, SEE: GIMBAL LOCK
---TODO: Copy table recursively to prevent inter-SWEP interference (MAY BE NON-ISSUE)
--TODO: Fix de-ironsight on 0 ammo without AMMODELAY delay
--TODO: Concommands and cvars to disable use+right to switch firemode and use+left to silence
--TODO: Cvars for crosshair color
--TODO: Accessor functions, specifically for sound and silencer status
if SERVER then
    AddCSLuaFile("shared.lua")
    AddCSLuaFile("cl_init.lua")
    SWEP.Weight = 5
    SWEP.AutoSwitchTo = false
    SWEP.AutoSwitchFrom = false
end

if CLIENT then
    SWEP.DrawAmmo = true
    SWEP.DrawCrosshair = true
    --SWEP.ViewModelFOV		= 82
    SWEP.ViewModelFlip = true
    SWEP.CSMuzzleFlashes = true
    SWEP.ViewModelFlip = false
    surface.MyCreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
    surface.MyCreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end

for k, v in pairs{
    Author = "Night-Eagle",
    Contact = "sedhdi@gmail.com",
    Purpose = "",
    Instructions = "",
    Category = "CSE2",
    ViewModelFOV = 70,
    ViewModelFlip = false,
    ViewModel = "models/weapons/v_pistol.mdl",
    WorldModel = "models/weapons/w_357.mdl",
    Spawnable = false,
    AdminSpawnable = false,
    Primary = {
        Sound = Sound("Weapon_AK47.Single"),
        SoundSilenced = Sound("Weapon_M4A1.Silenced"),
        SoundUnsilenced = nil, --Leave this nil
        Recoil = 0,
        Unrecoil = 0,
        Damage = 0,
        NumShots = 0,
        Cone = 0,
        Delay = 1,
        ClipSize = -1,
        DefaultClip = -1,
        Automatic = false,
        Ammo = "none",
    }, --These do not seem to be added
    Secondary = {
        ClipSize = -1,
        DefaultClip = -1,
        Automatic = false,
        Ammo = "none",
    },
    Data = {
        silencer = nil --nil for no silencer or duration of time for attaching/detaching silencer
        
    },
    --firemode = nil, --If you override the animation table, override both sets of animations, not just one!
    anims = {
        {ACT_VM_IDLE, ACT_VM_DRYFIRE, ACT_VM_PRIMARYATTACK, ACT_VM_RELOAD, ACT_VM_DRAW, ACT_SHOTGUN_RELOAD_START, ACT_SHOTGUN_RELOAD_FINISH,},
        {ACT_VM_IDLE_SILENCED, ACT_VM_DRYFIRE_SILENCED, ACT_VM_PRIMARYATTACK_SILENCED, ACT_VM_RELOAD_SILENCED, ACT_VM_DRAW_SILENCED, ACT_SHOTGUN_RELOAD_START, ACT_SHOTGUN_RELOAD_FINISH,},
    },
    --animset = 1 for unsilenced at start, 2 for silenced at start
    animset = 1,
} do
    -- semi,burst,auto,pump
    -- reload types: one shot, incremental
    --Add data! TODO: Use table.Copy() or use recursion
    if type(v) ~= table or type(SWEP[k]) ~= table then
        if not SWEP[k] then
            SWEP[k] = v
        end
    else
        for i, o in pairs(v) do
            SWEP[k][i] = v
        end
    end
end

SWEP.sys = {
    next = 0, --Next available shot/burst volley
    bnext = 0, --Burst next shot
    bleft = 0, --Burst shots left
    sights = 0, --Ironsight/scope status
    lastsights = 0, --Last ironsight/scope status
    silencer = false, --Silencer attached
    lastsilencer = false, --Last silencer
    lshotironidle = 0, --Last primary fire for forced idle animation
    deployironidle = false, --Timer to allow deploy animation
    invokereload = false, --Starts the reload process when true
    terminatereloading = false, --Stops the shotgun-style reloading process
    sreloading = false, --Currently shotgun-style reloading
    
}

if CLIENT then
    SWEP.sys.clneedsreload = false
end

--[sic]
if SERVER then
    function SWEP:Silencer(state)
        --This function can be called as such:
        --SWEP:Silencer()		//Toggle
        --SWEP:Silencer(true)	//Ensure attached
        --SWEP:Silencer(false)	//Ensure detached
        --Do not attempt to attach/detach a silencer without this function.
        local curstate = self.sys.silencer
        if state == curstate or (not self.Data.silencer) or not self:CanFire(nil, true) then return end --If we're (already SIL/UNSIL or unable to SIL) and the situation is appropriate (Clip override)
        self.sys.silencer = not curstate
        --Set the animation set
        self.animset = curstate and 1 or 2

        --Run attach animation + set sounds
        if curstate then
            self.Weapon:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
            self.Primary.Sound = self.Primary.SoundUnsilenced
        else
            self.Weapon:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
            self.Primary.Sound = self.Primary.SoundSilenced
        end

        --Wait
        self.sys.next = CurTime() + self.Data.silencer
        --self.Weapon:SetNextPrimaryFire(CurTime()+2)
        self:SetNWBool("si", self.sys.silencer)
    end
elseif CLIENT then
    --[sic]
    function SWEP:Silencer()
        --This function is called on think for the client
        local curstate = self.sys.silencer
        if curstate == self:GetNWBool("si") then return end
        self.sys.silencer = not curstate
        --Set the animation set
        self.animset = curstate and 1 or 2

        --Run attach animation + set sounds
        if curstate then
            self.Weapon:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
            self.Primary.Sound = self.Primary.SoundUnsilenced
        else
            self.Weapon:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
            self.Primary.Sound = self.Primary.SoundSilenced
        end

        --Wait
        self.sys.next = CurTime() + self.Data.silencer
    end
end

--[sic]
function SWEP:Sights(mode)
    if self.sys.sights == mode then return end
    local IRONTIME = .225

    --0 - Disable
    --1 - Ironsights
    --2 - Scope
    --3 - Zoom Scope
    --Passing self seems to be redundant since this is local...
    local actions = {
        function(self)
            --Ironsights
            if self.sys.deployironidle and self.sys.deployironidle < CurTime() then
                self.Weapon:SendWeaponAnim(self.anims[self.animset][1])
                self.sys.deployironidle = false
            end

            self.Csight = true
            self:SetNWBool("cs", true)
            self:SetNWInt("csi", 1)
            self.Owner:SetFOV(self.Data.zoom and self.Data.zoom[1] and self.Data.zoom[1].fov or 70, IRONTIME)
        end,
        function(self)
            --Scope 2x
            self.Csight = false
            self:SetNWBool("cs", false)
            self:SetNWInt("csi", 2)
            self.Owner:SetFOV(self.Data.zoom and self.Data.zoom[2] and self.Data.zoom[2].fov or 45, IRONTIME)
            self.Weapon:EmitSound("weapons/zoom.wav")
        end,
        function(self)
            --Scope 8x
            self.Csight = false
            self:SetNWBool("cs", false)
            self:SetNWInt("csi", 3)
            self.Owner:SetFOV(self.Data.zoom and self.Data.zoom[3] and self.Data.zoom[3].fov or 11.25, IRONTIME)
            self.Weapon:EmitSound("weapons/zoom.wav")
        end,
    }

    actions[0] = function(self)
        --Disable
        self.Csight = false
        self:SetNWBool("cs", false)
        self:SetNWInt("csi", 0)
        self.Owner:SetFOV(90, IRONTIME)

        if self.sys.lastsights > 1 then
            self.Weapon:EmitSound("weapons/zoom.wav")
        end
    end

    if actions[mode] then
        actions[mode](self)
        self.sys.sights = mode
    else
        Msg("CSE2 Not-Fatal Error! Ironsights mode ", mode, " not available! Weapon ", tostring(self.PrintName), "\n")
    end

    self.sys.lastsights = self.sys.sights
end

function SWEP:NextSights()
    if self.Data.zoom then
        self.sys.lastsights = self.sys.sights
        local mode
        local done = false

        for i = 0, 4 do
            mode = self.sys.sights + 1 + i

            if mode > 3 then
                mode = mode - 4
            end

            if mode == 0 or self.Data.zoom[mode] then break end
        end

        self:Sights(mode)
    end
end

function SWEP:Reload()
    if self:Clip1() < self.Primary.ClipSize and not self.sys.invokereload then
        self.sys.invokereload = true

        if CLIENT then
            self.sys.clneedsreload = false --This fixes double reload syndrome
        end
    end
end

function SWEP:ActualReload()
    --TODO: Duplicate check exists (shotgun loading)
    if self:Clip1() >= self.Primary.ClipSize then
        self.sys.invokereload = false

        return
    end

    --This fixes double reload syndrome
    if CLIENT and (not self.shotgunreload) and not self.sys.clneedsreload then
        self.sys.invokereload = false

        return
    end

    self.sys.lshotironidle = 0 --Disables IronIdle from overriding our animation
    self.sys.invokereload = false

    if not self.shotgunreload then
        self.sys.clneedsreload = false
        self.Weapon:DefaultReload(self.anims[self.animset][4])
    elseif self:Clip1() < self.Primary.ClipSize and not self.sys.sreloading then
        self.sys.next = CurTime() + (self.shotgunreloadstart or self.shotgunreload)
        self.sys.sreloading = 2
        self.Weapon:SendWeaponAnim(self.anims[self.animset][6])
    end

    if self.firemode == "auto" then
        self.Primary.Automatic = true
    end

    self:Sights(0)
end

function SWEP:Deploy()
    if SERVER then
        local fmlisti = {
            semi = 1,
            burst = 2,
            auto = 3,
            pump = 4
        }

        self:SetNWInt("fm", fmlisti[self.firemode])
        self.Weapon:SendWeaponAnim(self.anims[self.animset][5])
        self.sys.lshotironidle = 0
        self.sys.deployironidle = CurTime() + 1
    end

    if CLIENT then
        if self:Clip1() >= self.Primary.ClipSize then
            self.sys.clneedsreload = false
        else
            self.sys.clneedsreload = true
        end
    end

    if self.firemode == "auto" then
        self.Primary.Automatic = true
    end

    return true
end

function SWEP:Holster(weapon_to_swap_to)
    self.sys.bleft = 0
    self.sys.bnext = 0
    self.sys.invokereload = false

    if self.sys.sreloading then
        self.sys.terminatereloading = true
    end

    self:Sights(0)

    return true
end

function SWEP:CanFire(burst, clip)
    --Burst override for use with burst firemode
    --Clip override for use with
    --Invalid firemode or to early for next shot (or volley for burst override)
    if (not self.firemode) or ((not burst) and self.sys.next > CurTime()) then
        return false
    elseif self:Clip1() > 0 or clip then
        return true
    else --At least 1 ammo or clip override is true
        return false
    end
end

function SWEP:CanPrimaryAttack()
    return self:CanFire()
end

function SWEP:PrimaryAttack()
    if self.sys.sreloading then
        self.sys.terminatereloading = true

        return
    end

    self.sys.lshotironidle = 0 --Disables IronIdle from overriding our animation

    if self.Owner:KeyDown(IN_USE) then
        self:Silencer()
    else
        if not self:CanFire() then
            if self:Clip1() == 0 then
                self.Weapon:EmitSound("weapons/ClipEmpty_Rifle.wav")
                self.Weapon:SendWeaponAnim(self.anims[self.animset][2]) --Makes a muzzleflash for some reason
                self.Primary.Automatic = false
            end

            return
        end

        self.Weapon:EmitSound(self.Primary.Sound)
        self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0)
        self.sys.lshotironidle = CurTime()
        self.sys.deployironidle = false
        self.sys.clneedsreload = true
        self:TakePrimaryAmmo(1)
        --self.Owner:ViewPunch(Angle(-1,0,0))
        self.sys.next = CurTime() + self.Data[self.firemode].Delay

        if self.firemode == "burst" then
            self.sys.bleft = self.Data.burst.Shots - 1
            self.sys.bnext = CurTime() + self.Data.burst.BurstDelay
        end
    end
end

local fmlist = {"semi", "burst", "auto", "pump"}

local fmlistn = {"Semi-Automatic", "Burst", "Fully-Automatic", "Pump"}

local fmlisti = {
    semi = 1,
    burst = 2,
    auto = 3,
    pump = 4
}

local fmlistf = {
    semi = function(self)
        self.Primary.Automatic = false
        self.Weapon:EmitSound("weapons/smg1/switch_single.wav")
    end,
    burst = function(self)
        self.Primary.Automatic = false
        self.Weapon:EmitSound("weapons/smg1/switch_single.wav")
    end,
    auto = function(self)
        self.Primary.Automatic = true
        self.Weapon:EmitSound("weapons/smg1/switch_burst.wav")
    end,
    pump = function(self)
        self.Primary.Automatic = false
    end,
}

function SWEP:SecondaryAttack()
    if self.sys.sreloading then
        self.sys.terminatereloading = true

        return
    end

    if not self:CanFire(false, true) then return end

    if not self.Owner:KeyDown(IN_USE) then
        --WARNING: Secondary ammo usage will be hindered
        if self:Clip1() > 0 then
            self:NextSights()
        end
    else
        local done

        for i = 0, 3 do
            if not done then
                local next = fmlisti[self.firemode] + 1 + i

                if next > 4 then
                    next = next - 4
                end

                if self.Data[fmlist[next]] then
                    done = true

                    if SERVER then
                        self.firemode = fmlist[next]
                    end

                    self.sys.next = math.max(self.sys.next, CurTime()) + .02
                end
            end
        end

        if SERVER then
            fmlistf[self.firemode](self)
            self:SetNWInt("fm", fmlisti[self.firemode])
        end
    end
end

function SWEP:Initialize()
    if SERVER then
        fmlistf[self.firemode](self)
    end

    if self.Primary.SoundSilenced then
        self.Primary.SoundUnsilenced = self.Primary.Sound
    end
end

function SWEP:Think()
    if self.sys.deployironidle and self.sys.deployironidle < CurTime() then
        self.sys.deployironidle = false
        self.Weapon:SendWeaponAnim(self.anims[self.animset][1])
    end

    if self.sys.invokereload and self:CanFire(nil, true) then
        self:ActualReload()
    end

    if self.sys.sreloading and self.sys.next < CurTime() then
        local cammo = self:Clip1()

        if self.sys.sreloading == 1 then
            cammo = cammo + 1
        end

        self:SetClip1(cammo)

        if cammo >= self.Primary.ClipSize then
            if cammo > self.Primary.ClipSize then
                self:SetClip1(self.Primary.ClipSize)
            end

            self.sys.clneedsreload = false
            self.sys.sreloading = 0
        end

        if self.sys.sreloading > 0 and (self:Clip1() == 0 or not self.sys.terminatereloading) then
            self.sys.sreloading = 1
            self.sys.next = CurTime() + self.shotgunreload
            self.Weapon:SendWeaponAnim(self.anims[self.animset][4])
        else
            self.Weapon:SendWeaponAnim(self.anims[self.animset][7])
            self.sys.next = CurTime() + (self.shotgunreloadfinish or self.shotgunreload)
            self.sys.terminatereloading = false
            self.sys.sreloading = false
        end
    end

    if CLIENT then
        if self.lfm ~= self:GetNWInt("fm") then
            self.firemode = fmlist[self:GetNWInt("fm")] or self.firemode
            fmlistf[self.firemode](self)
            self.lfm = self:GetNWInt("fm")
        end

        self:Silencer()
    else
        --WARNING: Secondary ammo usage will be hindered
        if self:Clip1() == 0 then
            self:Sights(0)
        end

        --Ironidle //TODO: Make client-side
        if self.IronIdle and self.sys.lshotironidle > 1 and self:CanFire() then
            local delay = self.silencer and (self.IronIdleSil or -1) or (self.IronIdle or -1)

            if delay >= 0 and self.sys.lshotironidle + delay < CurTime() then
                self.sys.lshotironidle = 0

                if self.sys.sights == 1 then
                    self.Weapon:SendWeaponAnim(self.anims[self.animset][1])
                end
            end
        end
    end

    if self.firemode then
        if self.firemode == "burst" then
            if self.sys.bleft > 0 and self.sys.bnext < CurTime() then
                self.sys.bleft = self.sys.bleft - 1
                self.sys.bnext = CurTime() + self.Data.burst.BurstDelay

                if self:CanFire(true) then
                    self.Weapon:EmitSound(self.Primary.Sound)
                    self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0)
                    self:TakePrimaryAmmo(1)
                end
            end
        end
    end
end

function SWEP:ShootBullet(dmg, recoil, numbul, cone)
    numbul = numbul or 1
    cone = cone or 0

    if self.sys.sights == 0 then
        cone = cone + self.Data[self.firemode].Cone
    else
        cone = cone + self.Data[self.firemode].ConeZoom
    end

    local bullet = {
        Num = numbul,
        Src = self.Owner:GetShootPos(),
        Dir = self.Owner:GetAimVector(),
        Spread = Vector(cone, cone, 0),
        Tracer = 4,
        Force = 5,
        Damage = dmg,
    }

    self.Owner:FireBullets(bullet)
    self:ShootEffects()
end

function SWEP:ShootEffects()
    self.Weapon:SendWeaponAnim(self.anims[self.animset][3])
    self.Owner:MuzzleFlash()
    self.Owner:SetAnimation(PLAYER_ATTACK1)
end

SWEP.Ctime = 0 --Start time?
SWEP.Mtime = 0 --Firmode switch bump start
SWEP.Atime = nil --Out of ammo reference time
local IRONTIME = .225
local MODETIME = .1
local AMMOTIME = .3
local AMMODELAY = .5

function SWEP:GetViewModelPosition(Apos, Aang)
    --self.IronPos = csipos
    --self.IronAng = csiang
    local flip = self.ViewModelFlip and 1 or -1

    if self:GetNWInt("csi") > 1 then
        Aang:RotateAroundAxis(Aang:Up(), 180)

        return Apos, Aang
    end

    local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
    --local Tpos = Vector(0,0,0)
    --local Tang = Angle(0,0,0)
    --Ironsights
    self.Csight = self:GetNWBool("cs")

    if self.Clastsight ~= self.Csight then
        if self.Ctime + IRONTIME > CurTime() then
            self.Ctime = CurTime() - (IRONTIME - (CurTime() - self.Ctime))
        else
            self.Ctime = CurTime()
        end
    end

    self.Clastsight = self.Csight

    if self.Csight then
        local rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
        local m = math.Clamp((CurTime() - self.Ctime) / IRONTIME, 0, 1)
        Aang:RotateAroundAxis(rx, self.IronAng.x * m)
        Aang:RotateAroundAxis(rz, self.IronAng.y * m)
        Aang:RotateAroundAxis(ry, self.IronAng.z * m)
        local rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
        Apos = Apos + rx * self.IronPos.x * m
        Apos = Apos + ry * self.IronPos.y * m
        Apos = Apos + rz * self.IronPos.z * m
    elseif self.IronAng and self.Ctime < CurTime() + IRONTIME then
        local rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
        local m = 1 - math.Clamp((CurTime() - self.Ctime) / IRONTIME, 0, 1)
        Aang:RotateAroundAxis(rx, self.IronAng.x * m)
        Aang:RotateAroundAxis(rz, self.IronAng.y * m)
        Aang:RotateAroundAxis(ry, self.IronAng.z * m)
        local rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
        Apos = Apos + rx * self.IronPos.x * m
        Apos = Apos + ry * self.IronPos.y * m
        Apos = Apos + rz * self.IronPos.z * m
    end

    --Firemode switch bump
    self.Mmode = self:GetNWInt("fm")

    if self.Mlastmode ~= self.Mmode then
        self.Mtime = CurTime()
    end

    self.Mlastmode = self.Mmode

    if self.Mtime + MODETIME * 2 > CurTime() then
        local m = math.Clamp((CurTime() - self.Mtime) / MODETIME, 0, 2)

        if m > 1 then
            m = 2 - m
        end

        local rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
        Aang:RotateAroundAxis(rx, -1 * m)
        Aang:RotateAroundAxis(rz, -1 * m * flip)
        Aang:RotateAroundAxis(ry, -3 * m * flip)

        if self.firemode == "auto" then
            Aang:RotateAroundAxis(rz, -3 * m * flip)
            Aang:RotateAroundAxis(ry, -6 * m * flip)
            rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
            Apos = Apos + rx * -1.8 * m * flip
        else
            rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
        end

        Apos = Apos + rx * -.6 * m * flip
        Apos = Apos + ry * 0 * m
        Apos = Apos + rz * .1 * m
    end

    --Out of ammo
    self.Acount = self:Clip1()

    if self.Acount == 0 then
        if self.Alastcount ~= self.Acount then
            self.Atime = CurTime()
            self.Arev = false
        end
    elseif self.Atime and not self.Arev then
        self.Atime = CurTime()
        self.Arev = true
    end

    self.Alastcount = self.Acount

    if self.Atime then
        local delay = self.Arev and 0 or AMMODELAY

        if self.Atime + delay + AMMOTIME > CurTime() then
            local m = math.Clamp((CurTime() - self.Atime - delay) / AMMOTIME, 0, 1)

            if self.Arev then
                m = 1 - m
            end

            local rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
            Aang:RotateAroundAxis(rx, -15 * m)
            Aang:RotateAroundAxis(rz, -30 * m * flip)
            Aang:RotateAroundAxis(ry, 8 * m * flip)
            local rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
            Apos = Apos + rx * 0 * m
            Apos = Apos + ry * -2 * m
            Apos = Apos + rz * 0 * m
        elseif not self.Arev then
            local rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
            Aang:RotateAroundAxis(rx, -15)
            Aang:RotateAroundAxis(rz, -30 * flip)
            Aang:RotateAroundAxis(ry, 8 * flip)
            local rx, ry, rz = Aang:Right(), Aang:Forward(), Aang:Up()
            Apos = Apos + rx * 0
            Apos = Apos + ry * -2
            Apos = Apos + rz * 0
        end
    end

    return Apos, Aang
end
/*
csipos = VectorVector(4.72,-2,1.86)
csiang = Vector(1.2,-.15,0)
concommand.Add("cseiron",function(pl,cmd,arg)
	local actions = {
		function()
			csipos.x = csipos.x + arg[2]
		end,
		function()
			csipos.y = csipos.y + arg[2]
		end,
		function()
			csipos.z = csipos.z + arg[2]
		end,
		function()
			csiang.x = csiang.x + arg[2]
		end,
		function()
			csiang.y = csiang.y + arg[2]
		end,
		function()
			csiang.z = csiang.z + arg[2]
		end,
	}
	actions[arg[1]]()
end)
*/
/*
if self:Clip1() == 0 then
		Tang = Angle(
			-LocalPlayer():EyeAngles().p+15+LocalPlayer():EyeAngles().p*math.cos(math.rad(30)),
			-30,
			-LocalPlayer():EyeAngles().r-LocalPlayer():EyeAngles().p*math.sin(math.rad(30)))
		Tpos = pos+LocalPlayer():EyeAngles():Right()*-2
	else
*/