AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

--[[---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------]]
function ENT:Initialize()
    local Radius = 4
    self.AttachedEntity = ents.Create("prop_dynamic")
    self.AttachedEntity:SetModel(self.Entity:GetModel())
    self.AttachedEntity:SetPos(self.Entity:GetPos())
    self.AttachedEntity:Spawn()
    self.AttachedEntity:SetParent(self.Entity)
    self.AttachedEntity:DrawShadow(false)
    self.Entity:DeleteOnRemove(self.AttachedEntity)
    self.Entity:SetModel("models/props_junk/watermelon01.mdl")
    -- Don't use the model's physics - create a sphere instead
    self.Entity:PhysicsInitSphere(Radius, "metal_bouncy")
    -- Set up our physics object here
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:EnableGravity(false)
        phys:EnableDrag(false)
    end

    -- Set collision bounds exactly
    self.Entity:SetCollisionBounds(Vector(-Radius, -Radius, -Radius), Vector(Radius, Radius, Radius))
    self.Entity:DrawShadow(false)
    self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

--[[---------------------------------------------------------
   Name: PhysicsUpdate
---------------------------------------------------------]]
function ENT:PhysicsUpdate(physobj)
    -- Don't do anything if the player isn't holding us
    if not self.Entity:IsPlayerHolding() and not self.Entity:GetTable().IsConstrained then
        physobj:SetVelocity(Vector(0, 0, 0))
        physobj:Sleep()
    end
end

include('shared.lua')