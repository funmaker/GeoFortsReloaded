if SERVER then
    AddCSLuaFile("shared.lua")
    SWEP.Weight = 5
    SWEP.AutoSwitchTo = true
    SWEP.AutoSwitchFrom = true
end

if CLIENT then
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
    SWEP.ViewModelFOV = 70
    SWEP.ViewModelFlip = true
    SWEP.CSMuzzleFlashes = false
    SWEP.ViewModelFlip = false
    surface.MyCreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
    surface.MyCreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end

if CLIENT then
    SWEP.Author = "CSE - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "CSE Knife"
    SWEP.Instructions = ""
    SWEP.Slot = 0
    SWEP.SlotPos = 1
    SWEP.IconLetter = "j"
    SWEP.ViewModelFlip = false
    killicon.AddFont("cse_knife", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.HoldType = "melee"
SWEP.Primary.Sound = Sound("Weapon_Knife.Slash")
SWEP.Primary.Recoil = 0
SWEP.Primary.Unrecoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = .45
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Next = CurTime()
SWEP.Primed = 0

function SWEP:Reload()
    return false
end

function SWEP:Deploy()
    return true
end

function SWEP:Holster()
    self.Next = CurTime()
    self.Primed = 0

    return true
end

function SWEP:ShootEffects()
    self.Weapon:SendWeaponAnim(ACT_MELEE_ATTACK1) -- View model animation
    --self.Owner:MuzzleFlash()								// Crappy muzzle light
    self.Owner:SetAnimation(PLAYER_ATTACK1) -- 3rd Person Animation
end

function SWEP:PrimaryAttack()
    if self.Next < CurTime() and self.Primed == 0 then
        self.Next = CurTime() + self.Primary.Delay
        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
        self.Primed = 1
        local trace = {}
        trace.start = self.Owner:GetShootPos()
        trace.endpos = trace.start + (self.Owner:GetAimVector() * 84)
        trace.entity = self.Owner
        trace = util.TraceLine(trace)

        if trace.Fraction < 1 and (not trace.HitSky) then
            if trace.HitNonWorld and (trace.MatType == MAT_BLOODYFLESH or (trace.Entity:IsPlayer() and trace.Entity ~= self.Owner)) then
                self.Weapon:EmitSound(Sound("Weapon_Knife.Stab"))

                if trace.Entity:IsPlayer() then
                    if SERVER then
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

                        trace.Entity:TakeDamage(35 * multi)
                    end
                end
            else
                self.Weapon:EmitSound(Sound("Weapon_Knife.HitWall"))
                local phys = trace.Entity:GetPhysicsObject()

                if phys and trace.HitNonWorld and trace.Entity ~= self.Owner then
                    phys:ApplyForceCenter(self.Owner:GetAimVector() * 7500)
                    if SERVER then end --trace.Entity:TakePhysicsDamage(35) //There is no documentation on DamageInfo
                end
            end
        else
            self.Weapon:EmitSound(Sound("Weapon_Knife.Slash"))
        end
    end
end

function SWEP:SecondaryAttack()
    if self.Next < CurTime() and self.Primed == 0 then
        self.Next = CurTime() + 1.25
        self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
        self.Primed = 2
        local trace = {}
        trace.start = self.Owner:GetShootPos()
        trace.endpos = trace.start + (self.Owner:GetAimVector() * 72)
        trace.entity = self.Owner
        trace = util.TraceLine(trace)

        if trace.Fraction < 1 and (not trace.HitSky) then
            if trace.HitNonWorld and (trace.MatType == MAT_BLOODYFLESH or (trace.Entity:IsPlayer() and trace.Entity ~= self.Owner)) then
                self.Weapon:EmitSound(Sound("Weapon_Knife.Stab"))

                if trace.Entity:IsPlayer() then
                    if SERVER then
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

                        trace.Entity:TakeDamage(50 * multi)
                    end
                end
            else
                self.Weapon:EmitSound(Sound("Weapon_Knife.HitWall"))
                local phys = trace.Entity:GetPhysicsObject()

                if phys and trace.HitNonWorld and trace.Entity ~= self.Owner then
                    phys:ApplyForceCenter(self.Owner:GetAimVector() * 7500)
                    if SERVER then end --trace.Entity:TakePhysicsDamage(50)
                end
            end
        else
            self.Weapon:EmitSound(Sound("Weapon_Knife.Slash"))
        end
    end
end

function SWEP:Think()
    if self.Next < CurTime() then
        if self.Primed == 1 then
            --self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
            self.Primed = 0
            self.Next = CurTime() + .01
        elseif self.Primed == 2 and not self.Owner:KeyDown(IN_ATTACK) then
            --self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
            self.Primed = 0
            self.Next = CurTime() + .01
        end
    end
end

function SWEP:PrintWeaponInfo(x, y, alpha)
    --if ( self.DrawWeaponInfoBox == false ) then return end
    if self.InfoMarkup == nil then
        local str
        local title_color = "<color=230,230,230,255>"
        local text_color = "<color=150,150,150,255>"
        str = "<font=HudSelectionText>"

        if self.Author ~= "" then
            str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n"
        end

        if self.Contact ~= "" then
            str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n"
        end

        if self.Purpose ~= "" then
            str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n"
        end

        if self.Instructions ~= "" then
            str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n"
        end

        str = str .. "</font>"
        self.InfoMarkup = markup.Parse(str, 250)
    end

    surface.SetDrawColor(60, 60, 60, alpha)
    surface.SetTexture(self.SpeechBubbleLid)
    surface.DrawTexturedRect(x, y - 64 - 5, 128, 64)
    draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(60, 60, 60, alpha))
    self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
    draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2, y + tall * 0.2, Color(255, 210, 0, 255), TEXT_ALIGN_CENTER)
    -- try to fool them into thinking they're playing a Tony Hawks game
    --draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-14, 14), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
    --draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-9, 9), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
    self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
end