AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local SF_PHYSPROP_ENABLE_ON_PHYSCANNON = 0x000040
local SF_PHYSPROP_ALWAYS_PICK_UP = 0x100000

function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysWake()

    local physObj = self:GetPhysicsObject()
    physObj:AddGameFlag(FVPHYSICS_DMG_SLICE)

    self.uses = 5
    self.attacker = nil
    self.picked = false
    self.armed = false
    self.stuck = false
end

function ENT:UnStuck()
    if self.stuck then
        self.stuck = false
        local physObj = self:GetPhysicsObject()
        physObj:SetPos(self.safepos)
        physObj:SetAngles(self.safeang)
        physObj:EnableMotion(true)
        physObj:SetVelocity(Vector(0, 0, 0))
        physObj:SetVelocityInstantaneous(Vector(0, 0, 0))
        physObj:Wake()
        return false
    end
end

function ENT:GravGunPunt(ply)
    self.attacker = ply

    self:UnStuck()

    if self.picked then
        self.armed = true

        local physObj = self:GetPhysicsObject()
        local ang = physObj:GetAngles()
        timer.Simple(0, function()
            local vel = physObj:GetVelocity()
            physObj:SetAngles(ang)
            physObj:SetAngleVelocityInstantaneous(Vector(0, 0, 0))
            physObj:SetVelocityInstantaneous(vel)
        end)
    else
        self.armed = false
    end

    return true
end

function ENT:GravGunPickupAllowed(ply)
    if ply:KeyDown(IN_ATTACK2) then
        self:UnStuck()
    end
    return true
end

function ENT:GravGunOnDropped(ply)
    self.picked = false
end

function ENT:GravGunOnPickedUp(ply)
    self.picked = true
end

function ENT:GetPreferredCarryAngles(ply)
    return Angle(0, 0, 0)
end

function ENT:PhysicsCollide(col)
    -- PrintMessage(HUD_PRINTTALK, "Col "
    -- .. tostring(col.HitObject) .. " "
    -- .. tostring(col.HitEntity) .. " "
    -- .. tostring(col.HitSpeed) .. " "
    -- .. col.HitSpeed:Length() .. " "
    -- .. tostring(col.HitEntity:GetMoveType()) .. " "
    -- .. tostring(col.HitEntity:GetSolid()) .. " "
    -- .. tostring(col.HitObject:IsMotionEnabled()) .. " "
    -- .. tostring(col.HitEntity:IsValid())
    -- )

    if !self.armed or col.Speed < 1000 then return end

    if col.HitEntity:IsPlayer() or col.HitEntity:IsNPC() then
        self.uses = self.uses - 2

        self:EmitSound("ambient/machines/slicer" .. math.random(4) .. ".wav")

        local dmg = DamageInfo()
        dmg:SetDamage(col.HitEntity:Health())
        if self.attacker then
            dmg:SetAttacker(self.attacker)
        else
            dmg:SetAttacker(game.GetWorld())
        end
        dmg:SetDamageForce(col.OurOldAngularVelocity)
        dmg:SetDamagePosition(col.HitPos)
        dmg:SetDamageType(bit.bor(DMG_CRUSH, DMG_SLASH))
        dmg:SetInflictor(self)
        col.HitEntity:TakeDamageInfo(dmg)

        self:SetVelocity(col.OurOldVelocity)
        self:SetLocalAngularVelocity(col.OurOldAngularVelocity:Angle())
    elseif !col.HitEntity:IsValid() or !col.HitObject:IsMotionEnabled() or col.HitEntity:GetSolid() == SOLID_BSP then
        self.uses = self.uses - 1
        self.stuck = true
        self.armed = false

        self:EmitSound("physics/metal/sawblade_stick" .. math.random(3) .. ".wav")

        local physObj = self:GetPhysicsObject()
        self.safepos = physObj:GetPos()
        self.safeang = physObj:GetAngles()
        physObj:SetPos(physObj:GetPos() + col.OurOldVelocity:GetNormalized() * 10)
        physObj:EnableMotion(false)

        local spawnflags = self:GetSpawnFlags()
        self:SetKeyValue("spawnflags", bit.bor(spawnflags, SF_PHYSPROP_ENABLE_ON_PHYSCANNON, SF_PHYSPROP_ALWAYS_PICK_UP))
    end

    if self.uses <= 0 then
        self:EmitSound("physics/metal/metal_solid_impact_soft" .. math.random(3) .. ".wav")
        self:Remove()
    end
end
