SWEP.Manufacturer = "SIG"
SWEP.Cartridge = "5.56x45mm NATO"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "SG 552"
    SWEP.Instructions = "Hold use and right-click to change firemodes."
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "A"
    killicon.AddFont("cse2_sg552", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel = "models/weapons/w_rif_sg552.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_SG552.Single")
SWEP.Primary.Recoil = 1.6
SWEP.Primary.Unrecoil = 7
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Ammo = "smg1"
--Firemode configuration
SWEP.IronPos = Vector(4, -2.5, 3.76)
SWEP.IronAng = Vector(2.5, -2, -15)
SWEP.ViewModelFlip = true
SWEP.firemode = "auto"

SWEP.Data = {
    semi = {
        Delay = .077,
        Cone = .011,
        ConeZoom = .007,
    },
    auto = {
        Delay = .077,
        Cone = .0141,
        ConeZoom = 0.011,
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