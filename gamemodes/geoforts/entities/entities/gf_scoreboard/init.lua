AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:OnRemove()
end

function ENT:Initialize()
    self.Entity:SetModel("models/buildingblocks/2d_1_2.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(true)
        phys:Wake()
    end
end

function ENT:Use()
end

function ENT:Think()
end

function ENT:UpdateTransmitState()
    return TRANSMIT_PVS
end