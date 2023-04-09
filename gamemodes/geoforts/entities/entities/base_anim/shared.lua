ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Base Entity"
ENT.Author = "Hulk Hogan"
ENT.Contact = "hulkhogan@hotmail.com"
ENT.Purpose = "No purpose entered"
ENT.Instructions = "No instructions entered"

--[[---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------]]
function ENT:OnRemove()
end

--[[---------------------------------------------------------
   Name: PhysicsCollide
   Desc: Called when physics collides. The table contains 
			data on the collision
---------------------------------------------------------]]
function ENT:PhysicsCollide(data, physobj)
end

--[[---------------------------------------------------------
   Name: PhysicsUpdate
   Desc: Called to update the physics .. or something.
---------------------------------------------------------]]
function ENT:PhysicsUpdate(physobj)
end