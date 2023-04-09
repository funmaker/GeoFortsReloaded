SWEP.Manufacturer = "Steyr"
SWEP.Cartridge = "5.56x45mm NATO"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "AUG A1"
    SWEP.Instructions = "Hold use and right-click to change firemodes."
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "e"
    killicon.AddFont("cse2_aug", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_aug.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_AUG.Single")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Unrecoil = 9
SWEP.Primary.Damage = 19
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Ammo = "smg1"
--Firemode configuration
SWEP.IronPos = Vector(5.99, -3, .985)
SWEP.IronAng = Vector(.4801, 3.01, 51.2999)
SWEP.ViewModelFlip = true
SWEP.firemode = "auto"

SWEP.Data = {
    semi = {
        Delay = .09,
        Cone = .01,
        ConeZoom = .006,
    },
    auto = {
        Delay = .09,
        Cone = .012,
        ConeZoom = 0.008,
    },
    zoom = {
        [1] = {
            fov = 70,
        },
        [2] = {
            fov = 45,
        },
    },
}

--End of configuration
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"