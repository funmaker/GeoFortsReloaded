SWEP.Manufacturer = "Accuracy International"
SWEP.Cartridge = "7.62x51mm NATO"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "Arctic Warfare Magnum"
    SWEP.Instructions = ""
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "r"
    killicon.AddFont("cse2_awp", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.HoldType = "ar2"
SWEP.Weight = 15
SWEP.Primary.Sound = Sound("Weapon_AWP.Single")
SWEP.Primary.Recoil = 9
SWEP.Primary.Unrecoil = 3.5
SWEP.Primary.Damage = 100
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Ammo = "smg1"
--Firemode configuration
SWEP.ViewModelFlip = true
SWEP.firemode = "semi"

SWEP.Data = {
    semi = {
        Delay = 1.2,
        Cone = .01,
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