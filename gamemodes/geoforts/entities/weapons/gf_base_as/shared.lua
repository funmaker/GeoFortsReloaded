if SERVER then
    AddCSLuaFile("shared.lua")
    SWEP.Weight = 5
    SWEP.AutoSwitchTo = false
    SWEP.AutoSwitchFrom = false
end

if CLIENT then
    SWEP.DrawAmmo = true
    SWEP.DrawCrosshair = false
    SWEP.ViewModelFOV = 82
    SWEP.ViewModelFlip = true
    SWEP.CSMuzzleFlashes = true
    surface.MyCreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
    surface.MyCreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end

SWEP.Base = "cse2_base"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = 0.15
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.data = {}
SWEP.data.semi = {}
SWEP.data.auto = {}
SWEP.data.zoomfov = 70
SWEP.data.snipefov = 0
SWEP.data.semi.label = "="
SWEP.data.auto.label = "====="

function SWEP.data.semi.Init(self)
    self.Primary.Automatic = false
    self.Weapon:EmitSound("weapons/smg1/switch_single.wav")
end

function SWEP.data.auto.Init(self)
    self.Primary.Automatic = true
    self.Weapon:EmitSound("weapons/smg1/switch_burst.wav")
end

function SWEP:Initialize()
    self.data.sync = true

    if SERVER then
        self:SetWeaponHoldType(self.HoldType)
    end
end

function SWEP:Think()
    if SinglePlayer() then
        self.data.singleplayer(self)
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
end

function SWEP:PrimaryAttack()
    if (not self:CanPrimaryAttack()) or self.data.newclip then return end
    local multi

    if SERVER then
        multi = gmod.GetGamemode().geof.teams[self.Owner:Team()].qualify
    else
        multi = LocalPlayer():GetNetworkedFloat("gfm" .. self.Owner:Team())
    end

    if CLIENT then
        self.xhair.loss = self.xhair.loss + self.Primary.Recoil
    end

    --self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    self.Weapon:SetNextPrimaryFire(CurTime() + self.data[self.mode].Delay)
    self.Weapon:EmitSound(self.Primary.Sound)
    self:TakePrimaryAmmo(1)
    self.Owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))

    if self.Owner:GetFOV() == 90 then
        --self:ShootBullet( 1, 1, self.data[self.mode].Cone )
        self:CSShootBullet(self.Primary.Damage * multi, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].Cone)
    else
        --self:ShootBullet( 1, 1, self.data[self.mode].ConeZoom )
        self:CSShootBullet(self.Primary.Damage * multi, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].ConeZoom)
    end
end

function SWEP:SecondaryAttack()
    if self.Owner:KeyDown(IN_USE) then
        if self.mode == "semi" then
            self.mode = "auto"
        else
            self.mode = "semi"
        end

        self.data[self.mode].Init(self)

        if self.mode == "auto" then
            self.Weapon:SetNetworkedInt("csef", 1)
        elseif self.mode == "semi" then
            self.Weapon:SetNetworkedInt("csef", 3)
        end
    elseif SERVER then
        if self.Owner:GetFOV() == 90 then
            self.Owner:SetFOV(self.data.zoomfov, .3)
            self.ironsights = true
        elseif self.Owner:GetFOV() == self.data.zoomfov and self.data.snipefov > 0 then
            self.Owner:SetFOV(self.data.snipefov, .3)
            self.ironsights = false
        else
            self.Owner:SetFOV(90, .3)
            self.ironsights = false
        end

        self:SetIronsights(self.ironsights)
    end
end