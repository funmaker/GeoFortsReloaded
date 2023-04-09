--BLOCK SPAWNER
--Version 1.0
--Written by Night-Eagle
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)
    if not tr.Hit then return end
    local ent = ents.Create("gf_bb_spawner")
    ent:SetPos(tr.HitPos + (45 * tr.HitNormal))
    ent:Spawn()
    ent:Activate()
    -- RETURN THE ENTITY OR BE CHARGED OF THEFT

    return ent
end

function ENT:OnRemove()
end

function ENT:KeyValue(key, value)
    if key == "skin" then
        local val = tonumber(value)

        if val >= 0 and val <= 4 then
            self.team = val
        else
            self.team = 0
        end
    end
end

function ENT:Initialize()
    Sound("buttons/combine_button7.wav")
    self.Entity:SetModel("models/buildingblocks/blockspawn_1.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(false)
    end

    self.timer = {}
end

function ENT:resetposang()
    if self.startpos and self.startang then
        self.Entity:SetPos(self.startpos)
        self.Entity:SetAngles(self.startang)
    end
end

function ENT:Use()
end

function ENT:Think()
    if not (self.startpos and self.startang) then
        self.startpos = self.Entity:GetPos()
        self.startang = self.Entity:GetAngles()

        function self:Think()
        end
    end
end

function ENT:UpdateTransmitState()
    return TRANSMIT_PVS
end