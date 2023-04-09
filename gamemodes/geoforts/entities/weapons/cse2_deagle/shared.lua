SWEP.Manufacturer = "Israel Weapon Industries"
SWEP.Cartridge = ".50AE"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "Desert Eagle"
    SWEP.Instructions = ""
    SWEP.Slot = 1
    SWEP.SlotPos = 0
    SWEP.IconLetter = "f"
    killicon.AddFont("cse2_deagle", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_DEagle.Single")
SWEP.Primary.Recoil = 3
SWEP.Primary.Unrecoil = 5
SWEP.Primary.Damage = 21
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 14
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--Firemode configuration
SWEP.IronPos = Vector(5.15, -2, 2.65)
SWEP.IronAng = Vector(.3, 0, 0)
SWEP.IronIdle = 1 --Reduce model "hop" from incorrect firing animation
SWEP.ViewModelFlip = true
SWEP.firemode = "semi"

SWEP.Data = {
    semi = {
        Delay = .12,
        Cone = .01,
        ConeZoom = .008,
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