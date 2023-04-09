if CLIENT then
    SWEP.Author = "CSE - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "CSE M4"
    SWEP.Instructions = "Hold use and right-click to change firemodes or left-click to attach silencer."
    SWEP.Slot = 2
    SWEP.SlotPos = 0
    SWEP.IconLetter = "w"
    killicon.AddFont("gf_m4", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.Base = "gf_base_abs"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.HoldType = "ar2"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_M4A1.Single")
SWEP.Primary.Recoil = 1.25
SWEP.Primary.Unrecoil = 8
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 31
SWEP.Primary.Delay = 0.06 --Don't use this, use the tables below!
SWEP.Primary.DefaultClip = 31 --Always set this 1 higher than what you want.
SWEP.Primary.Automatic = true --Don't use this, use the tables below!
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--Firemode configuration
SWEP.IronSightsPos = Vector(5.9, -6, 1)
SWEP.IronSightsAng = Vector(3, 1.3, 4)
SWEP.IronSightsPosUnSil = Vector(5.9, -6, 1)
SWEP.IronSightsAngUnSil = Vector(3, 1.3, 4)
SWEP.IronSightsPosSil = Vector(6, -6, 1)
SWEP.IronSightsAngSil = Vector(3, 2.75, 4)
SWEP.data = {}
SWEP.mode = "auto" --The starting firemode
SWEP.data.newclip = false --Do not change this
SWEP.data.semi = {}
SWEP.data.semi.Delay = .09
SWEP.data.semi.Cone = 0.014
SWEP.data.semi.ConeZoom = 0.001
SWEP.data.burst = {}
SWEP.data.burst.Delay = .3
SWEP.data.burst.Cone = 0.017
SWEP.data.burst.ConeZoom = 0.013
SWEP.data.burst.BurstDelay = .063
SWEP.data.burst.Shots = 3
SWEP.data.burst.Counter = 0
SWEP.data.burst.Timer = 0
SWEP.data.auto = {}
SWEP.data.auto.Delay = .086
SWEP.data.auto.Cone = 0.018
SWEP.data.auto.ConeZoom = 0.014

--End of configuration
function SWEP:Think()
    if SinglePlayer() then
        self.data.singleplayer(self)
    end

    if self.mode == "burst" then
        if self.data.burst.Timer + self.data.burst.BurstDelay < CurTime() then
            if self.data.burst.Counter > 0 then
                self.data.burst.Counter = self.data.burst.Counter - 1
                self.data.burst.Timer = CurTime()

                if self:CanPrimaryAttack() then
                    self.Weapon:EmitSound(self.Primary.Sound)

                    if self.Owner:GetFOV() == 90 then
                        --self:ShootBullet( 1, 1, self.data[self.mode].Cone )
                        self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].Cone)
                    else
                        --self:ShootBullet( 1, 1, self.data[self.mode].ConeZoom )
                        self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].ConeZoom)
                    end

                    self:TakePrimaryAmmo(1)

                    if CLIENT then
                        self.xhair.loss = self.xhair.loss + self.Primary.Recoil
                    end
                end
            end
        end
    end

    if self.data.newclip then
        if self.data.newclip == 0 then
            self.data.newclip = false

            if self:Ammo1() > self.Primary.ClipSize - 1 then
                if self.data.oldclip == 0 then
                    self.Weapon:SetClip1(self.Weapon:Clip1() - 1)

                    if SERVER then
                        self.Owner:GiveAmmo(1, self.Primary.Ammo, true)
                    end
                end
            end
        else
            self.data.newclip = self.data.newclip - 1
        end
    end

    if self.deployed then
        if self.deployed == 0 then
            if self.data.silenced then
                self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
            else
                self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
            end

            self.deployed = false
            self.Weapon:SetNextPrimaryFire(CurTime() + .001)
        else
            self.deployed = self.deployed - 1
        end
    end
end

function SWEP:PrimaryAttack()
    if not self.Owner:KeyDown(IN_USE) then
        if (not self:CanPrimaryAttack()) or self.data.newclip then
            if self.data.silenced then
                self.Weapon:SendWeaponAnim(ACT_VM_DRYFIRE_SILENCED)
            else
                self.Weapon:SendWeaponAnim(ACT_VM_DRYFIRE)
            end

            return
        end

        if CLIENT then
            self.xhair.loss = self.xhair.loss + self.Primary.Recoil
        end

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

        if self.mode == "burst" then
            self.data.burst.Timer = CurTime()
            self.data.burst.Counter = self.data.burst.Shots - 1
        end
    else
        if self.data.silenced then
            self.Weapon:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
            self.Primary.Sound = Sound("Weapon_M4A1.Single")
            self.data.silenced = false
            self.IronSightsPos = self.IronSightsPosUnSil
            self.IronSightsAng = self.IronSightsAngUnSil
        else
            self.Weapon:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
            self.Primary.Sound = Sound("Weapon_M4A1.Silenced")
            self.data.silenced = true
            self.IronSightsPos = self.IronSightsPosSil
            self.IronSightsAng = self.IronSightsAngSil
        end

        self.Weapon:SetNextPrimaryFire(CurTime() + 2)
    end
end

function SWEP:Reload()
    self:SetIronsights(false)

    if SERVER and self.Owner:GetFOV() ~= 90 then
        self.Owner:SetFOV(90, .3)
    end

    self.data.oldclip = self.Weapon:Clip1()

    if self.data.silenced then
        self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED)
    else
        self.Weapon:DefaultReload(ACT_VM_RELOAD)
    end

    self.data.newclip = 1
end

function SWEP:Deploy()
    self:SetIronsights(false)
    self.deployed = 2

    if SERVER then
        if self.mode == "auto" then
            self.Weapon:SetNetworkedInt("csef", 1)
        elseif self.mode == "burst" then
            self.Weapon:SetNetworkedInt("csef", 2)
        elseif self.mode == "semi" then
            self.Weapon:SetNetworkedInt("csef", 3)
        end
    end

    return true
end

function SWEP:ShootEffects()
    if self.data.silenced then
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
    else
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        self.Owner:MuzzleFlash()
    end

    self.Owner:SetAnimation(PLAYER_ATTACK1) -- 3rd Person Animation
end