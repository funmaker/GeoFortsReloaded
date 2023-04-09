SWEP.Manufacturer = "SIG"
SWEP.Cartridge = ".357 SIG"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "P228"
    SWEP.Instructions = ""
    SWEP.Slot = 1
    SWEP.SlotPos = 0
    SWEP.IconLetter = "a"
    killicon.AddFont("cse2_p228", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_P228.Single")
SWEP.Primary.Recoil = 1.25
SWEP.Primary.Unrecoil = 4
SWEP.Primary.Damage = 13
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 13
SWEP.Primary.DefaultClip = 26
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--Firemode configuration
SWEP.IronPos = Vector(4.76, -2, 2.955)
SWEP.IronAng = Vector(-.6, 0, 0)
SWEP.IronIdle = 1 --Reduce model "hop" from incorrect firing animation
SWEP.ViewModelFlip = true
SWEP.firemode = "semi"

SWEP.Data = {
    semi = {
        Delay = .12,
        Cone = .0125,
        ConeZoom = .01,
    },
    zoom = {
        [1] = {
            fov = 70,
        },
    },
}

--End of configuration
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--DOCEND