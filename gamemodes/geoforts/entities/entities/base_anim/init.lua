AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

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

--[[---------------------------------------------------------
   Name: Simulate
   Desc: Controls/simulates the physics on the entity. 
	Officially the most complicated callback in the whole mod.
	 Returns 3 variables..
	 1. A SIM_ enum
	 2. A vector representing the linear acceleration/force
	 3. A vector represending the angular acceleration/force
	If you're doing nothing you can return SIM_NOTHING
	Note that you need to call ent:StartMotionController to tell the entity
		to start calling this function..
---------------------------------------------------------]]
function ENT:PhysicsSimulate(phys, deltatime)
    return SIM_NOTHING
end