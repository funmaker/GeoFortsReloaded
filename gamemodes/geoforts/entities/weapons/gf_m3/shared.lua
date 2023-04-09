if CLIENT then
    SWEP.Author = "CSE - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "CSE M3"
    SWEP.Instructions = ""
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "k"
    killicon.AddFont("gf_m3", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "gf_base_s"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.HoldType = "shotgun"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_M3.Single")
SWEP.Primary.Recoil = 4
SWEP.Primary.Unrecoil = 100
SWEP.Primary.Damage = 4
SWEP.Primary.NumShots = 15
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 8
SWEP.Primary.Delay = 0.06 --Don't use this, use the tables below!
SWEP.Primary.DefaultClip = 8 --Always set this 1 higher than what you want.
SWEP.Primary.Automatic = true --Don't use this, use the tables below!
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--Firemode configuration
SWEP.IronSightsPos = Vector(5.73, -2, 3.375)
SWEP.IronSightsAng = Vector(0.001, .05, 0.001)
SWEP.data = {}
SWEP.mode = "semi" --The starting firemode
SWEP.data.newclip = false --Do not change this
SWEP.data.semi = {}
SWEP.data.semi.label = "Pump"
SWEP.data.semi.Delay = .875
SWEP.data.semi.Cone = 0.07
SWEP.data.semi.ConeZoom = 0.06

--End of configuration
function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    --self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    self.Weapon:SetNextPrimaryFire(CurTime() + self.data[self.mode].Delay)
    self.Weapon:EmitSound(self.Primary.Sound)
    self:TakePrimaryAmmo(1)
    self.Owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))

    if self.Owner:GetFOV() == 90 then
        --self:ShootBullet( 1, 1, self.data[self.mode].Cone )
        self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].Cone)
    else
        --self:ShootBullet( 1, 1, self.data[self.mode].ConeZoom )
        self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].ConeZoom)
    end
end

--The following code is by Garry
function SWEP:Reload()
    if self.Weapon:GetNetworkedBool("reloading", true) then return end

    if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
        self.Weapon:SetNetworkedBool("reloading", true)
        self.Weapon:SetVar("reloadtimer", CurTime() + 0.3)
        self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
    end

    if self.Owner:GetFOV() ~= 90 then
        self.Owner:SetFOV(self.data.zoomfov, .3)
        self:SetIronsights(false)
    end
end

function SWEP:Think()
    if SinglePlayer() then
        self.data.singleplayer(self)
    end

    if self.Weapon:GetNetworkedBool("reloading", false) then
        if self.Weapon:GetVar("reloadtimer", 0) < CurTime() then
            if self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
                self.Weapon:SetNetworkedBool("reloading", false)

                return
            end

            self.Weapon:SetVar("reloadtimer", CurTime() + 0.3)
            self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
            self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
            self.Weapon:SetClip1(self.Weapon:Clip1() + 1)

            if self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
                self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
                self.Weapon:SetNextPrimaryFire(CurTime() + self.data[self.mode].Delay)
            else
                self.Weapon:SetNextPrimaryFire(CurTime() + .27)
            end
        end
    end
end