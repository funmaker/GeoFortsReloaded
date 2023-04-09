SWEP.Manufacturer = "Israel Military Industries"
SWEP.Cartridge = "5.56x45mm NATO"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "Galil"
    SWEP.Instructions = "Hold use and right-click to change firemodes."
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "v"
    killicon.AddFont("cse2_galil", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_Galil.Single")
SWEP.Primary.Recoil = 1.25
SWEP.Primary.Unrecoil = 7.75
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 70
SWEP.Primary.Ammo = "smg1"
--Firemode configuration
SWEP.IronPos = Vector(-5.15, -3, 2.165)
SWEP.IronAng = Vector(.2, .04, 0)
SWEP.ViewModelFlip = false
SWEP.firemode = "auto"

SWEP.Data = {
    semi = {
        Delay = .092,
        Cone = .012,
        ConeZoom = .009,
    },
    auto = {
        Delay = .092,
        Cone = .017,
        ConeZoom = 0.014,
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