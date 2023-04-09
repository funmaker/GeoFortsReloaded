if CLIENT then
    SWEP.Author = "CSE - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "CSE MP5"
    SWEP.Instructions = "Hold use and right-click to change firemodes."
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "x"
    killicon.AddFont("gf_mp5", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "gf_base_abs"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Recoil = 1
SWEP.Primary.Unrecoil = 5
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 31
SWEP.Primary.Delay = 0.06 --Don't use this, use the tables below!
SWEP.Primary.DefaultClip = 31 --Always set this 1 higher than what you want.
SWEP.Primary.Automatic = true --Don't use this, use the tables below!
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--Firemode configuration
SWEP.IronSightsPos = Vector(4.72, -2, 1.86)
SWEP.IronSightsAng = Vector(1.2, -.15, 0)
SWEP.data = {}
SWEP.mode = "auto" --The starting firemode
SWEP.data.newclip = false --Do not change this
SWEP.data.semi = {}
SWEP.data.semi.Delay = .09
SWEP.data.semi.Cone = 0.013
SWEP.data.semi.ConeZoom = 0.009
SWEP.data.burst = {}
SWEP.data.burst.Delay = .3
SWEP.data.burst.Cone = 0.015
SWEP.data.burst.ConeZoom = 0.013
SWEP.data.burst.BurstDelay = .063
SWEP.data.burst.Shots = 3
SWEP.data.burst.Counter = 0
SWEP.data.burst.Timer = 0
SWEP.data.auto = {}
SWEP.data.auto.Delay = .09
SWEP.data.auto.Cone = 0.015
SWEP.data.auto.ConeZoom = 0.013
--End of configuration