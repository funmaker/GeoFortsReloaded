AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:OnRemove()
end

function ENT:KeyValue(key, value)
    if key == "skin" then
        local val = tonumber(value)

        if val >= 1 and val <= 4 then
            self.team = val
        end
    end
end

function ENT:Initialize()
    self:SetModel("models/buildingblocks/playerspawn_1.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(false)
    end
end

function ENT:resetposang()
    if self.startpos and self.startang then
        self:SetPos(self.startpos)
        self:SetAngles(self.startang)
    end
end

function ENT:Use()
end

function ENT:Think()
    if not (self.startpos and self.startang) then
        self.startpos = self:GetPos()
        self.startang = self:GetAngles()
    end

    local trace = util.QuickTrace(self:GetPos() + self:GetUp(), self:GetUp() * 1)
    if trace.Hit then
        self:GetPhysicsObject():EnableMotion()
        self:ForcePlayerDrop(false)
        self:resetposang()
    end
end

function ENT:UpdateTransmitState()
    return TRANSMIT_PVS
end