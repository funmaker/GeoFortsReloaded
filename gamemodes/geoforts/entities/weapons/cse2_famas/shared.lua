SWEP.Manufacturer = "Nexter"
SWEP.Cartridge = "5.56x45mm NATO"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "FAMAS"
    SWEP.Instructions = "Hold use and right-click to change firemodes."
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "t"
    killicon.AddFont("cse2_famas", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_FAMAS.Single")
SWEP.Primary.Recoil = 1.3
SWEP.Primary.Unrecoil = 6.4
SWEP.Primary.Damage = 20
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Ammo = "smg1"
--Firemode configuration
SWEP.IronPos = Vector(-4, -3, 1)
SWEP.IronAng = Vector(3, .5, 4)
SWEP.ViewModelFlip = false
SWEP.firemode = "auto"

SWEP.Data = {
    semi = {
        Delay = .09,
        Cone = .008,
        ConeZoom = .006,
    },
    burst = {
        Delay = .3,
        Cone = .025,
        ConeZoom = .018,
        BurstDelay = .063,
        Shots = 3,
    },
    auto = {
        Delay = .067,
        Cone = .035,
        ConeZoom = 0.026,
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