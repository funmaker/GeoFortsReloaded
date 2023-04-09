if SERVER then
    AddCSLuaFile("shared.lua")
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

if CLIENT then
    SWEP.Author = "CSE - Night-Eagle"
    SWEP.Contact = "gmail sedhdi"
    SWEP.Purpose = ""
    SWEP.Instructions = ""
    SWEP.PrintName = "CSE Flashbang"
    SWEP.Instructions = ""
    SWEP.Slot = 3
    SWEP.SlotPos = 0
    SWEP.IconLetter = "P"
    SWEP.ViewModelFlip = true
    killicon.AddFont("cse_flashbang", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255)) --FLASHBANG KILLS ARE THE SEX
end

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.ViewModel = "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"
SWEP.HoldType = "grenade"
SWEP.Primary.Sound = Sound("Default.PullPin_Grenade")
SWEP.Primary.Recoil = 0
SWEP.Primary.Unrecoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
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
    self.Weapon:SendWeaponAnim(ACT_VM_THROW) -- View model animation
    --self.Owner:MuzzleFlash()								// Crappy muzzle light
    self.Owner:SetAnimation(PLAYER_ATTACK1) -- 3rd Person Animation
end

function SWEP:PrimaryAttack()
    if self.Next < CurTime() and self.Primed == 0 then
        self.Next = CurTime() + self.Primary.Delay
        self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
        self.Primed = 1
        --self.Weapon:EmitSound(self.Primary.Sound)
    end
end

function SWEP:Think()
    if self.Next < CurTime() then
        if self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK) then
            self.Weapon:SendWeaponAnim(ACT_VM_THROW)
            self.Primed = 2
            self.Next = CurTime() + .3
        elseif self.Primed == 2 then
            self.Primed = 0
            self.Next = CurTime() + self.Primary.Delay

            if SERVER then
                local ent = ents.Create("houst_flashgrenade")
                ent:SetPos(self.Owner:GetShootPos())
                ent:SetAngles(Vector(1, 0, 0))
                ent:Spawn()
                local phys = ent:GetPhysicsObject()
                phys:SetVelocity(self.Owner:GetAimVector() * 1000)
                phys:AddAngleVelocity(Vector(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000)))
                local class = "cse_flashbang"
                local userid = self.Owner:UniqueID()
                local gm = gmod.GetGamemode()
                gm.houst[userid].inventory[class] = gm.houst[userid].inventory[class] - 1

                if gm.houst[userid].inventory[class] <= 0 then
                    self.Owner:StripWeapon(class)
                end

                self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
            end
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