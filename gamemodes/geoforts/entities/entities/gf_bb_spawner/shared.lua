--BLOCK SPAWNER
--Version 1.0
--Written by Night-Eagle
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "BBSpawner"
ENT.Author = "Night-Eagle"
ENT.Contact = "gmail sedhdi"
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.spawndelay = 2

function ENT:OnRemove()
    if CLIENT then
        self.screen:Remove()
    end
end

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide(data, phys)
end