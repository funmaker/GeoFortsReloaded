if SERVER then
    AddCSLuaFile("shared.lua")
    AddCSLuaFile("cl_init.lua")
    SWEP.Weight = 5
    SWEP.AutoSwitchTo = true
    SWEP.AutoSwitchFrom = true
end

if CLIENT then
    SWEP.DrawAmmo = true
    SWEP.DrawCrosshair = false
    SWEP.ViewModelFOV = 82
    SWEP.ViewModelFlip = true
    SWEP.CSMuzzleFlashes = true
    SWEP.ViewModelFlip = false
    surface.MyCreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
    surface.MyCreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Unrecoil = 4
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

if SERVER then
    SWEP.xhair = {}
    SWEP.xhair.time = CurTime()
    SWEP.xhair.loss = 0
end

SWEP.data = {}
SWEP.data.auto = {}
SWEP.data.zoomfov = 70
SWEP.data.snipefov = 0

function SWEP:Reload()
    self:SetIronsights(false)

    if self.sniping then
        self.sniping = false
    end

    if SERVER and self.Owner:GetFOV() ~= 90 then
        self.Owner:SetFOV(90, .3)
    end

    self.data.oldclip = self.Weapon:Clip1()
    self.Weapon:DefaultReload(ACT_VM_RELOAD)
    self.data.newclip = 1
end

function SWEP:Deploy()
    self:SetIronsights(false)

    if self.sniping then
        self.sniping = false
    end

    if SERVER then
        if self.mode == "auto" then
            self.Weapon:SetNetworkedInt("csef", 1)
        elseif self.mode == "burst" then
            self.Weapon:SetNetworkedInt("csef", 2)
        elseif self.mode == "semi" then
            self.Weapon:SetNetworkedInt("csef", 3)
        end
    end

    self.data[self.mode].Init(self)

    return true
end

function SWEP:CSShootBullet(dmg, recoil, numbul, cone)
    numbul = numbul or 1
    cone = cone or 0.01
    local bullet = {}
    bullet.Num = numbul
    bullet.Src = self.Owner:GetShootPos() -- Source
    bullet.Dir = self.Owner:GetAimVector() -- Dir of bullet

    if numbul == 1 then
        bullet.Spread = Vector(cone, cone, 0) * self.xhair.loss -- Aim Cone

        if self.Owner:Crouching() then
            bullet.Spread = bullet.Spread * .95
        end

        if not self.Owner:IsOnGround() then
            bullet.Spread = Vector(cone, cone, 0) * 20
        end
    else
        bullet.Spread = Vector(cone, cone, 0) -- Aim Cone
    end

    bullet.Tracer = 4 -- Show a tracer on every x bullets 
    bullet.Force = 5 -- Amount of force to give to phys objects
    bullet.Damage = dmg
    self.Owner:FireBullets(bullet)
    self:ShootEffects()

    --[[ CUSTOM RECOIL !
	if ( (SinglePlayer() && SERVER) || ( !SinglePlayer() && CLIENT ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end]]
    if SERVER then
        self.xhair.loss = self.xhair.loss + self.Primary.Recoil

        if self.xhair.loss > 0 then
            self.xhair.loss = self.xhair.loss - (self.Primary.Unrecoil * (CurTime() - self.xhair.time))

            if self.Owner:Crouching() then
                self.xhair.loss = self.xhair.loss * .975
            end

            if not self.Owner:IsOnGround() then
                self.xhair.loss = 20
            end
        end

        if self.xhair.loss <= 0 then
            self.xhair.loss = 0.01
        end

        if self.xhair.loss > 20 then
            self.xhair.loss = 20
        end

        self.xhair.time = CurTime()
    end
end

--[[
	local multi = 1
	if trace.HitGroup == HITGROUP_HEAD then
		multi = 2
	elseif trace.HitGroup == HITGROUP_CHEST then
		multi = 1.0
	elseif trace.HitGroup == HITGROUP_STOMACH then
		multi = 1.5
	elseif trace.HitGroup >= 4 and trace.HitGroup <= 7 then
		multi = .75
	elseif trace.HitGroup == HITGROUP_GEAR then
		mutli = .5
	end
	trace.Entity:TakeDamage(35*multi)
	
function SWEP:ShootBullet( damage, num_bullets, aimcone )
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )		// Aim Cone
	bullet.Tracer	= 5									// Show a tracer on every x bullets 
	bullet.Force	= 1									// Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	self.Owner:FireBullets( bullet )
	
	self:ShootEffects()
	
end]]
function SWEP:ShootEffects()
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) -- View model animation
    self.Owner:MuzzleFlash() -- Crappy muzzle light
    self.Owner:SetAnimation(PLAYER_ATTACK1) -- 3rd Person Animation
end

if SinglePlayer() then
    function SWEP.data.singleplayer(self)
        if SinglePlayer() then
            if SERVER then
                if self.xhair.loss > 0 then
                    self.xhair.loss = self.xhair.loss - (self.Primary.Unrecoil * (CurTime() - self.xhair.time))

                    if self.Owner:Crouching() then
                        self.xhair.loss = self.xhair.loss * .975
                    end

                    if not self.Owner:IsOnGround() then
                        self.xhair.loss = 20
                    end
                end

                if self.xhair.loss <= 0 then
                    self.xhair.loss = 0.01
                end

                if self.xhair.loss > 20 then
                    self.xhair.loss = 20
                end

                self.xhair.time = CurTime()
                self.Weapon:SetNetworkedInt("csefl", self.xhair.loss)
            else
                self.xhair.loss = self.Weapon:GetNetworkedInt("csefl")
            end
        end
    end
end

--Garry's code below
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
local IRONSIGHT_TIME = 0.25

function SWEP:GetViewModelPosition(pos, ang)
    if not self.IronSightsPos then return pos, ang end
    local bIron = self.Weapon:GetNetworkedBool("Ironsights")

    if bIron ~= self.bLastIron then
        self.bLastIron = bIron
        self.fIronTime = CurTime()
    end

    local fIronTime = self.fIronTime or 0
    if not bIron and fIronTime < CurTime() - IRONSIGHT_TIME then return pos, ang end
    local Mul = 1.0

    if fIronTime > CurTime() - IRONSIGHT_TIME then
        Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

        if not bIron then
            Mul = 1 - Mul
        end
    end

    local Offset = self.IronSightsPos

    if self.IronSightsAng then
        ang = ang * 1
        ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
        ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
        ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
    end

    local Right = ang:Right()
    local Up = ang:Up()
    local Forward = ang:Forward()
    pos = pos + Offset.x * Right * Mul
    pos = pos + Offset.y * Forward * Mul
    pos = pos + Offset.z * Up * Mul

    return pos, ang
end

function SWEP:SetIronsights(b)
    if self.Weapon:GetNetworkedBool("Ironsights") == b then return end
    self.Weapon:SetNetworkedBool("Ironsights", b)
end