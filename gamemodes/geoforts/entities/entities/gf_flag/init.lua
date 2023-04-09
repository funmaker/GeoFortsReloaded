AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:OnRemove()
end

function ENT:KeyValue(key, value)
    if key == "TeamNum" then
        local val = tonumber(value)

        if val >= 1 and val <= 4 then
            self.team = val
            local color = team.GetColor(val)
            self.Entity:SetRenderMode(RENDERMODE_TRANSTEXTURE)
            self.Entity:SetColor(Color(color.r, color.g, color.b, 255))
        end
    end
end

function ENT:Initialize()
    self.Entity:SetModel("models/roller_spikes.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(false)
    end
end

function ENT:Use()
end

function ENT:resetposang()
    if self.startpos and self.startang then
        self.Entity:SetPos(self.startpos)
        self.Entity:SetAngles(self.startang)
    end
end

function ENT:Think()
    if not (self.startpos and self.startang) then
        self.startpos = self.Entity:GetPos()
        self.startang = self.Entity:GetAngles()

        function self:Think()
            if self.timer and self.timer < CurTime() then
                self.timer = nil
                self:GoHome()
            end
        end
    end

    if self.timer and self.timer < CurTime() then
        self.timer = nil
        self:GoHome()
    end
end

function ENT:UpdateTransmitState()
    return TRANSMIT_PVS
end

function ENT:GoHome()
    if self.lastpos and self.lastang then
        local pl = self.Entity:GetParent()

        if pl and pl:IsPlayer() then
            pl:SetNWInt("gfflag", 0)
        end

        self.Entity:SetParent()
        self.Entity:SetPos(self.lastpos)
        self.Entity:SetAngles(self.lastang)
        self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        local phys = self.Entity:GetPhysicsObject()

        if phys:IsValid() then
            phys:EnableMotion(false)
        end

        self.home = 1
        self.timer = nil
    end
end

function ENT:GoPlayerGrab(pl)
    self.Entity:SetPos(pl:GetPos() + Vector(0, 0, 84))
    self.Entity:SetParent(pl)
    self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(false)
    end

    self.home = 0
    self.timer = nil
end

function ENT:GoPlayerDrop()
    self.Entity:SetParent()
    self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(true)
        phys:Wake()
    end

    self.Entity:SetPos(self.Entity:GetPos() - Vector(0, 0, 28))
    self.home = -1
    self.timer = CurTime() + gmod.GetGamemode().geof.const.flagautoreturn
end