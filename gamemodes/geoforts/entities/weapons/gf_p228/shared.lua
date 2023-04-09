if CLIENT then
    SWEP.Author = "CSE - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "CSE P228"
    SWEP.Instructions = ""
    SWEP.Slot = 1
    SWEP.SlotPos = 0
    SWEP.IconLetter = "a"
    killicon.AddFont("gf_p228", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "gf_base_s"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_P228.Single")
SWEP.Primary.Recoil = 1.25
SWEP.Primary.Unrecoil = 4
SWEP.Primary.Damage = 13
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 13
SWEP.Primary.Delay = 0.06 --Don't use this, use the tables below!
SWEP.Primary.DefaultClip = 13 --Always set this 1 higher than what you want.
SWEP.Primary.Automatic = true --Don't use this, use the tables below!
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--Firemode configuration
SWEP.IronSightsPos = Vector(4.76, -2, 2.955)
SWEP.IronSightsAng = Vector(-.6, 0, 0)
SWEP.data = {}
SWEP.mode = "semi" --The starting firemode
SWEP.data.newclip = false --Do not change this
SWEP.data.semi = {}
SWEP.data.semi.Delay = .12
SWEP.data.semi.Cone = 0.0125
SWEP.data.semi.ConeZoom = 0.01
--End of configuration