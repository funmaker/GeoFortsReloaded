SWEP.Manufacturer = "Steyr"
SWEP.Cartridge = "7.62x51mm NATO"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "Scout"
    SWEP.Instructions = ""
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "n"
    killicon.AddFont("cse2_scout", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"
SWEP.HoldType = "ar2"
SWEP.Weight = 15
SWEP.Primary.Sound = Sound("Weapon_Scout.Single")
SWEP.Primary.Recoil = 8
SWEP.Primary.Unrecoil = 8
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Ammo = "smg1"
--Firemode configuration
SWEP.ViewModelFlip = true
SWEP.firemode = "semi"

SWEP.Data = {
    semi = {
        Delay = 1.2,
        Cone = .005,
        ConeZoom = .001,
    },
    zoom = {
        [2] = {
            fov = 45,
        },
        [3] = {
            fov = 11.25,
        },
    },
}

--End of configuration
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"