SWEP.Manufacturer = "Benelli"
SWEP.Cartridge = "12 Gauge" --Yes, it isn't a cartridge

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "M1014"
    SWEP.Instructions = ""
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "B"
    killicon.AddFont("cse2_m1014", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_XM1014.Single")
SWEP.Primary.Recoil = 4
SWEP.Primary.Unrecoil = 100
SWEP.Primary.Damage = 3.3
SWEP.Primary.NumShots = 12
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 14
SWEP.Primary.Ammo = "buckshot"
--Firemode configuration
SWEP.IronPos = Vector(5.16, -3.5, 2.155)
SWEP.IronAng = Vector(.001, .75, .001)
SWEP.ViewModelFlip = true
SWEP.firemode = "semi"
SWEP.shotgunreloadstart = .6
SWEP.shotgunreloadfinish = .35
SWEP.shotgunreload = .5

SWEP.Data = {
    semi = {
        Delay = .2,
        Cone = .06,
        ConeZoom = .055,
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