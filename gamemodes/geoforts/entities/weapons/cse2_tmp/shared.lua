SWEP.Manufacturer = "Steyr"
SWEP.Cartridge = "9x19mm Parabellum"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "TMP"
    SWEP.Instructions = "Hold use and right-click to change firemodes."
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "d"
    killicon.AddFont("cse2_tmp", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_TMP.Single")
SWEP.Primary.Recoil = .3
SWEP.Primary.Unrecoil = 5
SWEP.Primary.Damage = 11
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Ammo = "smg1"
--Firemode configuration
SWEP.IronPos = Vector(5.23, -2, 2.55)
SWEP.IronAng = Vector(.6, -.05, 0)
SWEP.IronIdle = 1
SWEP.ViewModelFlip = true
SWEP.firemode = "auto"

SWEP.Data = {
    semi = {
        Delay = .04,
        Cone = 0.03,
        ConeZoom = 0.025,
    },
    auto = {
        Delay = .04,
        Cone = 0.035,
        ConeZoom = 0.03,
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