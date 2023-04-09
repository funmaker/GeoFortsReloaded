SWEP.Manufacturer = "Benelli"
SWEP.Cartridge = "12 Gauge" --Yes, it isn't a cartridge

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "M3 Super 90"
    SWEP.Instructions = ""
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "k"
    killicon.AddFont("cse2_m3", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_M3.Single")
SWEP.Primary.Recoil = 4
SWEP.Primary.Unrecoil = 100
SWEP.Primary.Damage = 3.5
SWEP.Primary.NumShots = 12
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Ammo = "buckshot"
--Firemode configuration
SWEP.IronPos = Vector(5.73, -2, 3.375)
SWEP.IronAng = Vector(.001, .0385, .001)
SWEP.ViewModelFlip = true
SWEP.firemode = "semi"
SWEP.shotgunreloadstart = .25 --These values will default to SWEP.shotgunreload...
SWEP.shotgunreloadfinish = .75 --...so they can be left nil
SWEP.shotgunreload = .5

SWEP.Data = {
    semi = {
        Delay = .875,
        Cone = .07,
        ConeZoom = .06,
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