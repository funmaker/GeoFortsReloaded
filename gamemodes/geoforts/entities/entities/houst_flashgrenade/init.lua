AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self.Entity:SetModel("models/weapons/w_eq_flashbang.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    self.Entity:DrawShadow(false)
    -- Don't collide with the player
    self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:Sleep()
    end

    self.timer = CurTime() + 3
end

function ENT:Think()
    if self.timer < CurTime() then
        local range = 1028
        local pos = self.Entity:GetPos()
        self.Entity:EmitSound(Sound("Flashbang.Explode"))
        self.Entity:Remove()

        for i, pl in pairs(player.GetAll()) do
            local plp = pl:GetShootPos()
            local pla = pl:GetAimVector()

            if (plp - pos):Length() <= range then
                local trace = {}
                trace.start = plp
                trace.endpos = pos
                trace.filter = pl
                trace.mask = COLLISION_GROUP_PLAYER
                trace = util.TraceLine(trace)

                if trace.Fraction == 1 then
                    local dot = -(plp - pos):Normalize():DotProduct(pla)

                    if dot <= .35 then
                        dot = .35
                    end

                    dot = dot * ((range - (plp - pos):Length()) / range)
                    local gm = gmod.GetGamemode()
                    local userid = pl:UniqueID()
                    local cur = gm.houst[userid].flashed
                    local cur = cur + dot

                    if cur > 1 then
                        cur = 1
                    end

                    gm.houst[userid].flashed = cur

                    if cur == gm.houst[userid].lastflashed then
                        cur = -cur
                    end

                    pl:SetNetworkedFloat("flashed", cur)
                    gm.houst[userid].lastflashed = cur
                end
            end
        end

        local exp = ents.Create("env_explosion")
        exp:SetKeyValue("spawnflags", 1 + 4 + 8 + 64 + 128 + 256)
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