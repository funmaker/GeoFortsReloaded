SWEP.Manufacturer = "Heckler & Koch"
SWEP.Cartridge = ".45 ACP"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "UMP"
    SWEP.Instructions = "Hold use and right-click to change firemodes."
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "q"
    killicon.AddFont("cse2_ump", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_UMP45.Single")
SWEP.Primary.Recoil = 2.75
SWEP.Primary.Unrecoil = 9
SWEP.Primary.Damage = 27
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Ammo = "smg1"
--Firemode configuration
SWEP.IronPos = Vector(7.31, -2, 3.285)
SWEP.IronAng = Vector(-1.4, .245, 2)
SWEP.ViewModelFlip = true
SWEP.firemode = "auto"

SWEP.Data = {
    semi = {
        Delay = .15,
        Cone = .012,
        ConeZoom = .007,
    },
    burst = {
        Delay = .3,
        Cone = .015,
        ConeZoom = .013,
        BurstDelay = .063,
        Shots = 2,
    },
    auto = {
        Delay = .15,
        Cone = .016,
        ConeZoom = .009,
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