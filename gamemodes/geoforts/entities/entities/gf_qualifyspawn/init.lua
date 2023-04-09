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
    self.Entity:SetModel("models/buildingblocks/playerspawn_1.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_NONE)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
end

function ENT:Use()
end

function ENT:Think()
end

function ENT:UpdateTransmitState()
    return TRANSMIT_PVS
end

function ENT:StartTouch(ent)
    if ent:IsPlayer() and ent:Team() >= 1 and ent:Team() <= 4 then
        gmod.GetGamemode():QualifyTag(ent, self.Entity)
    end
end