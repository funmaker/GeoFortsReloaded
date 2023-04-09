AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self.Entity:SetModel("models/weapons/w_eq_smokegrenade.mdl")
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

local exp

function ENT:Think()
    if self.timer < CurTime() then
        local pos = self.Entity:GetPos()
        self.Entity:EmitSound(Sound("BaseSmokeEffect.Sound"))
        exp = ents.Create("env_smoketrail")
        exp:SetKeyValue("startsize", "40000")
        exp:SetKeyValue("endsize", "128")
        exp:SetKeyValue("spawnradius", "128")
        exp:SetKeyValue("minspeed", "1")
        exp:SetKeyValue("maxspeed", "2")
        exp:SetKeyValue("startcolor", "240 240 240")
        exp:SetKeyValue("endcolor", "240 240 240")
        exp:SetKeyValue("opacity", ".8")
        exp:SetKeyValue("spawnrate", "20")
        exp:SetKeyValue("lifetime", "5")
        exp:SetPos(pos)
        exp:SetParent(self.Entity)
        exp:Spawn()
        exp:Fire("kill", "", 20)
        self.Entity:Fire("kill", "", 20)
        self.timer = CurTime() + 25
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