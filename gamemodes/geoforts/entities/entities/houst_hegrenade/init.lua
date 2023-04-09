AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self.Entity:SetModel("models/weapons/w_eq_fraggrenade.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    self.Entity:DrawShadow(false)
    -- Don't collide with the player
    self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    self.timer = CurTime() + 3
end

function ENT:Think()
    if self.timer < CurTime() then
        local range = 512
        local damage = 0
        local pos = self.Entity:GetPos()
        --self.Entity:EmitSound(Sound("weapons/hegrenade/explode"..math.random(3,5)..".wav"))
        self.Entity:Remove()

        for i, pl in pairs(player.GetAll()) do
            local plp = pl:GetShootPos()

            if (plp - pos):Length() <= range then
                local trace = {}
                trace.start = plp
                trace.endpos = pos
                trace.filter = pl
                trace.mask = COLLISION_GROUP_PLAYER
                trace = util.TraceLine(trace)

                if trace.Fraction == 1 then
                    pl:TakeDamage(trace.Fraction * damage)
                end
            end
        end

        local exp = ents.Create("env_explosion")
        exp:SetKeyValue("spawnflags", 128)
        exp:SetPos(pos)
        exp:Spawn()
        exp:Fire("explode", "", 0)
        local exp = ents.Create("env_physexplosion")
        exp:SetKeyValue("magnitude", 150)
        exp:SetPos(pos)
        exp:Spawn()
        exp:Fire("explode", "", 0)
    end
end

--[[---------------------------------------------------------
   Name: OnTakeDamage
   Desc: Entity takes damage
---------------------------------------------------------]]
function ENT:OnTakeDamage(dmginfo)
end

--[[
	Msg( tostring(dmginfo) .. "\n" )
	Msg( "Inflictor:\t" .. tostring(dmginfo:GetInflictor()) .. "\n" )
	Msg( "Attacker:\t" .. tostring(dmginfo:GetAttacker()) .. "\n" )
	Msg( "Damage:\t" .. tostring(dmginfo:GetDamage()) .. "\n" )
	Msg( "Base Damage:\t" .. tostring(dmginfo:GetBaseDamage()) .. "\n" )
	Msg( "Force:\t" .. tostring(dmginfo:GetDamageForce()) .. "\n" )
	Msg( "Position:\t" .. tostring(dmginfo:GetDamagePosition()) .. "\n" )
	Msg( "Reported Pos:\t" .. tostring(dmginfo:GetReportedPosition()) .. "\n" )	// ??
]]
--[[---------------------------------------------------------
   Name: Use
---------------------------------------------------------]]
function ENT:Use(activator, caller, type, value)
end

--[[---------------------------------------------------------
   Name: StartTouch
---------------------------------------------------------]]
function ENT:StartTouch(entity)
end

--[[---------------------------------------------------------
   Name: EndTouch
---------------------------------------------------------]]
function ENT:EndTouch(entity)
end

--[[---------------------------------------------------------
   Name: Touch
---------------------------------------------------------]]
function ENT:Touch(entity)
end