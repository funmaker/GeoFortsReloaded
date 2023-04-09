SWEP.Manufacturer = "FN Herstal"
SWEP.Cartridge = "5.7x28mm"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "Five-seveN"
    SWEP.Instructions = ""
    SWEP.Slot = 1
    SWEP.SlotPos = 0
    SWEP.IconLetter = "u"
    killicon.AddFont("cse2_fiveseven", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_FiveSeven.Single")
SWEP.Primary.Recoil = 1.2
SWEP.Primary.Unrecoil = 3.8
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 40
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--Firemode configuration
SWEP.IronPos = Vector(4.5, 3, 3.25)
SWEP.IronAng = Vector(-.23, -.105, 0)
SWEP.IronIdle = 0 --Reduce model "hop" from incorrect firing animation
SWEP.ViewModelFlip = true
SWEP.firemode = "semi"

SWEP.Data = {
    semi = {
        Delay = .12,
        Cone = .013,
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