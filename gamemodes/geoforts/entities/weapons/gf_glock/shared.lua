if CLIENT then
    SWEP.Author = "CSE - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "CSE Glock 18"
    SWEP.Instructions = "Hold use and right-click to change firemodes."
    SWEP.Slot = 1
    SWEP.SlotPos = 0
    SWEP.IconLetter = "c"
    killicon.AddFont("gf_glock", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "gf_base_bs"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_Glock.Single")
SWEP.Primary.Recoil = 2
SWEP.Primary.Unrecoil = 6
SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 18
SWEP.Primary.Delay = 0.06 --Don't use this, use the tables below!
SWEP.Primary.DefaultClip = 18 --Always set this 1 higher than what you want.
SWEP.Primary.Automatic = true --Don't use this, use the tables below!
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--Firemode configuration
SWEP.IronSightsPos = Vector(4.34, -2, 2.8)
SWEP.IronSightsAng = Vector(.74, 0, 0)
SWEP.data = {}
SWEP.mode = "semi" --The starting firemode
SWEP.data.newclip = false --Do not change this
SWEP.data.semi = {}
SWEP.data.semi.Delay = .1
SWEP.data.semi.Cone = 0.011
SWEP.data.semi.ConeZoom = 0.008
SWEP.data.burst = {}
SWEP.data.burst.Delay = .34
SWEP.data.burst.Cone = 0.02
SWEP.data.burst.ConeZoom = 0.017
SWEP.data.burst.BurstDelay = .05
SWEP.data.burst.Shots = 3
SWEP.data.burst.Counter = 0
SWEP.data.burst.Timer = 0
--End of configuration