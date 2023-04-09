SWEP.Manufacturer = "Heckler & Koch"
SWEP.Cartridge = ".45 ACP"

if CLIENT then
    SWEP.Author = "CSE2 - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "USP"
    SWEP.Instructions = "Hold use and left-click to attach silencer."
    SWEP.Slot = 1
    SWEP.SlotPos = 0
    SWEP.IconLetter = "y"
    killicon.AddFont("cse2_usp", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_USP.Single")
SWEP.Primary.SoundSilenced = Sound("Weapon_USP.SilencedShot")
SWEP.Primary.Recoil = 2.7
SWEP.Primary.Unrecoil = 8
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 13
SWEP.Primary.DefaultClip = 26
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--Firemode configuration
SWEP.IronPos = Vector(4.485, -2, 2.745)
SWEP.IronAng = Vector(-.2, -.025, 0)
SWEP.IronIdle = 1 --Reduce model "hop" from incorrect firing animation
SWEP.IronPosSil = Vector(4.485, -2, 2.745)
SWEP.IronAngSil = Vector(-.2, -.025, 0)
SWEP.IronIdleSil = 0
SWEP.ViewModelFlip = true
SWEP.firemode = "semi"

SWEP.Data = {
    semi = {
        Delay = .006,
        Cone = .006,
        ConeZoom = .004,
    },
    zoom = {
        [1] = {
            fov = 70,
        },
    },
    silencer = 3, --nil for no silencer or duration of time for attaching/detaching silencer
    
}

--End of configuration
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--DOCEND