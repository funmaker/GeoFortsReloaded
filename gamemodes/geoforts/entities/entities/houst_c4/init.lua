AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self.Entity:SetModel("models/weapons/w_c4_planted.mdl")
    self.Entity:PhysicsInit(SOLID_NONE)
    self.Entity:SetMoveType(MOVETYPE_NONE)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    self.Entity:DrawShadow(false)
    -- Don't collide with the player
    --self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:Sleep()
    end

    self.timer = CurTime() + 30
    self.beeptime = 2.7
    self.nextbeep = CurTime() + self.beeptime
    local gm = gmod.GetGamemode()

    if gm.houst.timertype == 2 then
        for i, pl in pairs(player.GetAll()) do
            if pl:IsValid() then
                gm:houstImpulse(pl, 23)
            end
        end
    else
        self.Entity:Fire("kill", "", 0)
    end
end

local exp

function ENT:Think()
    local gm = gmod.GetGamemode()

    if self.nextbeep < CurTime() then
        local gm = gmod.GetGamemode()

        if gm.houst.timertype == 2 then
            self.beeptime = self.beeptime * .9
            self.nextbeep = CurTime() + self.beeptime
            self.Entity:EmitSound(Sound("c4.click", 1500))
        else
            self.Entity:Fire("kill", "", 0)
        end
    end

    if self.timer < CurTime() then
        local gm = gmod.GetGamemode()

        if gm.houst.timertype == 2 then
            local pos = self.Entity:GetPos()
            self.Entity:EmitSound(Sound("c4.explode"))
            local exp = ents.Create("env_explosion")
            exp:SetKeyValue("spawnflags", 128)
            exp:SetPos(pos)
            exp:Spawn()
            exp:Fire("explode", "", 0)
            local exp = ents.Create("env_physexplosion")
            exp:SetKeyValue("magnitude", 400)
            exp:SetPos(pos)
            exp:Spawn()
            exp:Fire("explode", "", 0)
            self.Entity:Fire("kill", "", 1)
            self.timer = CurTime() + 600

            for i, pl in pairs(player.GetAll()) do
                if pl:IsValid() then
                    gm:houstImpulse(pl, 22)
                end
            end

            gm:houstChangeRound()
        else
            self.Entity:Fire("kill", "", 0)
        end
    end

    if self.defusers and self.defusers ~= "defused" then
        for pl, v in pairs(self.defusers) do
            if v[3] and v[3] < CurTime() then
                self.defusers[pl] = nil
                gm:houstImpulse(pl, 26)
            end
        end
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
function ENT:AcceptInput(name, activator, caller)
    local userid

    if caller and tostring(caller) ~= "[NULL Entity]" and caller:IsPlayer() and caller:Team() == 1 then
        userid = caller:UniqueID()
    end

    if name == "Use" and userid and self.defusers ~= "defused" then
        local gm = gmod.GetGamemode()

        if gm.houst.timertype == 2 then
            if not self.defusers then
                self.defusers = {}
            end

            if not self.defusers[caller] then
                self.defusers[caller] = {10, CurTime()}

                gm:houstImpulse(caller, 25)
                self.Entity:EmitSound(Sound("c4.disarmstart"))
            end

            local timeleft = self.defusers[caller][1]
            local timelast = self.defusers[caller][2]
            local timedelta = CurTime() - timelast

            if timedelta < 1 then
                self.defusers[caller][1] = timeleft - timedelta
            else
                self.defusers[caller][1] = 10
                gm:houstImpulse(caller, 25)
                self.Entity:EmitSound(Sound("c4.disarmstart"))
            end

            self.defusers[caller][2] = CurTime()
            self.defusers[caller][3] = CurTime() + 1

            if self.defusers[caller][1] <= 0 then
                for i, pl in pairs(player.GetAll()) do
                    if pl:IsValid() then
                        gm:houstImpulse(pl, 24)
                        self.defusers = "defused"
                        self.Entity:Fire("kill", "", gm.houst.svars.posttime)
                        self.Entity:EmitSound(Sound("c4.disarmfinish"))
                    end
                end

                gm:houstChangeRound()
            end
        elseif self.defusers ~= "defused" then
            self.Entity:Fire("kill", "", 0)
        end
    end
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