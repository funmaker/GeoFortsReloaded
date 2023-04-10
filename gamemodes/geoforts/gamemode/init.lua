--TODO:
--IMPORTANT:
--When first attempting to select spawn, fetch the currently spectated entity and get the index of it and increment from that
--SVARS
--Coefficient updates on client
--	Namely: Player spawn interval GM.geof.const.respawninterval
--Vote to reset flag
--Time until spawn HUD variable
--ABUSE:BLOCKS GO THROUGH DIVIDER
--SUPPORT:Scoreboard displays inactive teams
--SUPPORT:Make sure inacitve teams do not show on teamselect
--OPTIONAL:Team switch limit notification
--OPTIONAL:4head,1.25chest,.75arms,.5legs
--OPTIONAL:Grenades
--OPTIONAL:Knife
--WHAT:Dropped flag pickup
--UNTESTED:Remove bodyque time on qualify
--UNTESTED:Kill player's qualify tag when switching teams
--DONE:Fix menus
--DON'T:Armory
--DON'T:Improve MP5
--DON'T:Improve M4
--DON'T:Nuke shotgun
--DONE:Fix VGUI graphics
--DONE:ABUSE:NEXTROUND COMMAND
--DONE:Ammo
--DONE:Health
--DONE:Weapon switch font
--DONE:Kill Icons
--DONE:Freeze blocks on qualify
--DONE:Players look in same direction as spawn point
--DONE:Flag is not pick-up-able if no players/no qualify
--DONE:Disallow rotating build walls
--DONE:Remove friendly fire
--DONE:Qualify round skip
--DONE:Guns!
--DONE:Resource file
--DONE:Spawnpoint queue
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sweps.lua")
AddCSLuaFile("models.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_deathnotice.lua")
include("shared.lua")
GM.UniqueID = {}
GM.bodyque = {}
GM.bodyqueent = {}
GM.bodyqueblockers = {}
GM.geof = {}

--	1	Pre
--	2	Build
--	3	Qualify
--	4	Fight
GM.geof.rounds = {
    {
        time = 90,
        wall = 0,
        respawn = 1,
        weapons = 2
    },
    --Pre
    {
        time = 300,
        wall = 1,
        respawn = 1,
        weapons = 1
    },
    --Build
    {
        time = 60,
        wall = 1,
        respawn = 0,
        weapons = 0
    },
    --Qualify
    {
        time = 300,
        wall = 0,
        respawn = 1,
        weapons = 2
    },
}

--Fight
--(Duplicity Initialize)
GM.geof.round = {
    cur = 1,
    time = CurTime() + GM.geof.rounds[1].time
}

GM.geof.players = {}
GM.geof.teams = {}
GM.geof.nextbodyque = CurTime() + 1
--Cosntants
GM.geof.const = {}
GM.geof.const.flagautoreturn = 30
GM.geof.const.respawntime = 10
GM.geof.const.respawninterval = 3
GM.geof.const.respawnblockingmax = 1
GM.geof.const.nocappenalty = .5
GM.geof.const.allowmultiteamswitch = true

function GM:Initialize()
    --(Duplicity Declarations)
    self.geof.round = {
        cur = 1,
        time = CurTime() + self.geof.rounds[1].time
    }

    for i = 1, 4 do
        self.geof.teams[i] = {
            score = 0,
            qualify = 1,
        }
    end
end

function GM:InitPostEntity()
    local spawns = ents.FindByClass("gf_playerspawn")
    self.geof.spawns = {}

    for k, v in pairs(spawns) do
        if not self.geof.spawns[v:GetSkin()] then
            self.geof.spawns[v:GetSkin()] = {}
            self.geof.teams[v:GetSkin()].open = true
        end

        table.insert(self.geof.spawns[v:GetSkin()], v)

        self.bodyqueent[v] = {
            list = {},
            next = 0,
        }
    end

    local spawns = ents.FindByClass("gf_qualifyspawn")
    cexec = ents.FindByName("gfbb")
    self.geof.qspawns = {}

    for k, v in pairs(spawns) do
        if not self.geof.qspawns[v:GetSkin()] then
            self.geof.qspawns[v:GetSkin()] = {}
        end

        table.insert(self.geof.qspawns[v:GetSkin()], v)
        v:PhysicsInit(SOLID_NONE)
        v:SetMoveType(MOVETYPE_NONE)
        v:SetSolid(SOLID_NONE)
        v:SetCollisionGroup(COLLISION_GROUP_NONE)
    end

    self.geof.flags = {}
    local spawns = ents.FindByClass("gf_flag")
    self.geof.flags = {}

    for k, v in pairs(spawns) do
        local team = v:GetTable().team

        if not self.geof.flags[team] then
            self.geof.flags[team] = {}
        end

        table.insert(self.geof.flags[team], v)
    end

    --Network (Duplicity Think) (Duplicity PlayerInitialSpawn) //FIXME
    for k, pl in pairs(player.GetAll()) do
        if pl:IsValid() and pl:IsConnected() then
            pl:SetNWInt("gfRound", self.geof.round.cur)
            pl:SetNWFloat("gfTime", self.geof.round.time)

            for iteam, team in pairs(self.geof.teams) do
                if #self.geof.spawns[iteam] > 0 then
                    pl:SetNetworkedInt("gf" .. iteam, team.score)
                    pl:SetNetworkedFloat("gfm" .. iteam, team.qualify)
                    pl:SetNetworkedBool("gfo" .. iteam, team.open)
                end
            end
        end
    end
end

function ccgf_nextround(pl, cmd, args)
    if (not (IsEntity(pl) and pl:IsPlayer())) or pl:IsAdmin() then
        local self = gmod.GetGamemode()
        self.geof.round.time = 0
    end
end

concommand.Add("gf_nextround", ccgf_nextround)

function ccgf_extendround(pl, cmd, args)
    if (not (IsEntity(pl) and pl:IsPlayer())) or pl:IsAdmin() then
        local self = gmod.GetGamemode()
        local time = tonumber(args[1])

        if time then
            self.geof.round.time = self.geof.round.time + time

            if self.geof.round.time >= CurTime() + 3600 then
                self.geof.round.time = CurTime() + 3599
            end

            for k, pl in pairs(player.GetAll()) do
                if pl:IsValid() and pl:IsConnected() then
                    pl:SetNWInt("gfRound", self.geof.round.cur)
                    pl:SetNWFloat("gfTime", self.geof.round.time)

                    for iteam, team in pairs(self.geof.teams) do
                        if #self.geof.spawns[iteam] > 0 then
                            pl:SetNetworkedInt("gf" .. iteam, team.score)
                            pl:SetNetworkedFloat("gfm" .. iteam, team.qualify)
                            pl:SetNetworkedBool("gfo" .. iteam, team.open)
                        end
                    end
                end
            end
        end
    end
end

concommand.Add("gf_extendround", ccgf_extendround)

function GM:Think()
    for k, pl in pairs(player.GetAll()) do
        if pl:IsValid() and pl:IsConnected() then
            local plid = pl:UniqueID()

            if self.geof.players[plid] then
                if pl:Team() ~= self.geof.players[plid].team then
                    self:ClosePlayer(pl)
                    self:OpenPlayer(pl)
                end
            end
        end
    end

    local ready

    if self.geof.nextbodyque < CurTime() then
        --Bodyque checks
        for pl, time in pairs(self.bodyque) do
            if time < CurTime() then end --TODO: Kill this code --self:PlayerRealSpawn(pl)
        end

        for ent, v in pairs(self.bodyqueent) do
            if v.next < CurTime() and #v.list > 0 then
                local pl = table.remove(v.list, 1)
                v.next = CurTime() + self.geof.const.respawninterval

                if not self:PlayerRealSpawn(pl, ent) then
                    table.insert(v.list, 1, pl)
                end

                local out = tostring(v.next) .. " "

                for i, o in pairs(v.list) do
                    out = out .. tostring(o:EntIndex())
                end

                ent:SetNWString("gfSL", out)
            end
        end

        self.geof.nextbodyque = CurTime() + 1

        --Qualify round checks
        if self.geof.round.cur == 3 then
            ready = true

            for iteam = 1, 4 do
                local c1 = self.geof.teams[iteam].qualify
                local c2 = team.NumPlayers(iteam)
                local c3 = #self.geof.spawns[iteam]

                if (c1 ~= 0) or (c2 == 0) or (c3 == 0) then
                else
                    ready = false
                end
            end
        end
    end

    if self.geof.round.time < CurTime() or ready then
        --Change the round
        self.geof.round.cur = self.geof.round.cur + 1

        if self.geof.round.cur > 4 then
            self.geof.round.cur = 2
        end

        self.geof.round.time = CurTime() + self.geof.rounds[self.geof.round.cur].time

        --FIXME: WARNING: Requies 1 gf_gametimer to work properly
        for k, v in pairs(ents.FindByClass("gf_gametimer")) do
            local action

            if self.geof.round.cur == 2 then
                action = "OnBuild"

                for team, team in pairs(self.geof.flags) do
                    for flag, flag in pairs(team) do
                        local ent = flag:GetTable()
                        flag:GetPhysicsObject():EnableMotion(false)
                        flag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                        ent:GoHome()
                    end
                end

                for k, v in pairs(ents.FindByClass("gf_qualifyspawn")) do
                    v:PhysicsInit(SOLID_NONE)
                    v:SetMoveType(MOVETYPE_NONE)
                    v:SetSolid(SOLID_NONE)
                    v:SetCollisionGroup(COLLISION_GROUP_NONE)
                end
            elseif self.geof.round.cur == 3 then
                action = "OnQualify"

                for team, team in pairs(self.geof.flags) do
                    for flag, flag in pairs(team) do
                        flag:GetPhysicsObject():EnableMotion(false)
                        flag:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                    end
                end

                for k, pl in pairs(player.GetAll()) do
                    if pl:IsValid() and pl:IsConnected() then
                        plid = self.UniqueID[pl] --FIXME

                        if plid then
                            self.geof.players[plid].qflag = false
                        end
                    end
                end

                for iteam = 1, 4 do
                    self.geof.teams[iteam].qualify = 0
                end

                --Send QUALIFY HUD data DUPLICATE
                local FILTER = RecipientFilter()
                FILTER:AddAllPlayers()
                umsg.Start("gfqhk", FILTER)
                umsg.Float(self.geof.rounds[3].time) --FIXME: Send constants prior

                for iteam = 1, 4 do
                    umsg.Float(self.geof.teams[iteam].qualify)
                end

                umsg.End()

                for k, v in pairs(ents.FindByClass("gf_qualifyspawn")) do
                    v:PhysicsInit(SOLID_VPHYSICS)
                    v:SetMoveType(MOVETYPE_NONE)
                    v:SetSolid(SOLID_VPHYSICS)
                    v:SetCollisionGroup(COLLISION_GROUP_NONE)
                end

                local tofreeze = ents.FindByName("gfbb")

                for k, v in pairs(ents.FindByClass("gf_playerspawn")) do
                    table.insert(tofreeze, v)
                end

                for k, v in pairs(ents.FindByClass("gf_scoreboard")) do
                    table.insert(tofreeze, v)
                end

                for k, v in pairs(ents.FindByClass("gf_timeboard")) do
                    table.insert(tofreeze, v)
                end

                for k, v in pairs(ents.FindByClass("gf_bb_spawner")) do
                    table.insert(tofreeze, v)
                end

                for k, v in pairs(tofreeze) do
                    local phys = v:GetPhysicsObject()

                    if phys:IsValid() then
                        phys:EnableMotion(false)
                    end
                end
            elseif self.geof.round.cur == 4 then
                action = "OnFight"

                for iteam, vteam in pairs(self.geof.flags) do
                    for flag, flag in pairs(vteam) do
                        local ent = flag:GetTable()
                        ent.lastpos = flag:GetPos()
                        ent.lastang = flag:GetAngles()
                        --if team.GetNum(iteam) ~= 0 and self.geof.teams[iteam].qualify ~= 0 then
                        flag:GetPhysicsObject():EnableMotion(false)
                        flag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                        --else
                        --FIXME DISABLE THE FLAG!!!
                        --end
                    end
                end

                for k, ent in pairs(ents.FindByName("gfbb")) do
                    local phys = ent:GetPhysicsObject()

                    if phys:IsValid() then
                        phys:EnableMotion(false)
                    end
                end

                for k, v in pairs(ents.FindByClass("gf_qualifyspawn")) do
                    v:PhysicsInit(SOLID_NONE)
                    v:SetMoveType(MOVETYPE_NONE)
                    v:SetSolid(SOLID_NONE)
                    v:SetCollisionGroup(COLLISION_GROUP_NONE)
                end

                for iteam = 1, 4 do
                    if self.geof.teams[iteam].qualify and self.geof.teams[iteam].qualify == 0 then
                        self.geof.teams[iteam].qualify = self.geof.const.nocappenalty
                    end
                end
            end

            if action then
                local act = v:GetTable()[action] or {}

                for k, out in pairs(act) do
                    out[5] = tonumber(out[5])

                    for ent, ent in pairs(ents.FindByName(out[1])) do
                        ent:Fire(out[2], out[3], out[4])
                    end

                    if out[5] > 0 then
                        v:GetTable()[action][k][5] = v:GetTable()[action][k][5] - 1
                    elseif out[5] == 0 then
                        v:GetTable()[action][k] = nil
                    end
                end
            end
        end

        for k, v in pairs(ents.FindByClass("gf_playerspawn")) do
            v:SetAngles(Angle(0, v:GetAngles().y, 0))
        end

        for k, pl in pairs(player.GetAll()) do
            if pl:IsValid() and pl:IsConnected() then
                local plid = pl:UniqueID()
                self.geof.players[plid].switched = nil
                --Network (Duplicity Initialize)
                pl:SetNWInt("gfRound", self.geof.round.cur)
                pl:SetNWFloat("gfTime", self.geof.round.time)

                for iteam, team in pairs(self.geof.teams) do
                    if #self.geof.spawns[iteam] > 0 then
                        pl:SetNetworkedInt("gf" .. iteam, team.score)
                        pl:SetNetworkedFloat("gfm" .. iteam, team.qualify)
                        pl:SetNetworkedBool("gfo" .. iteam, team.open)
                    end
                end

                --Round
                self:ClosePlayer(pl)
                pl:StripAmmo()
                pl:StripWeapons()
                pl:Spawn()

                if self.geof.round.cur == 3 then
                    pl:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                elseif self.geof.round.cur == 4 then
                    pl:SetCollisionGroup(COLLISION_GROUP_PLAYER)
                end

                self.bodyque[pl] = 0
            end
        end
    end
end

--Called when an entity has a keyvalue set, Returning a string it will override the value
function GM:EntityKeyValue(ent, key, value)
end

function GM:DoPlayerDeath(pl, attacker, dmginfo)
    pl:CreateRagdoll()

    if pl:IsPlayer() and self.geof.round.cur == 4 then
        if attacker:IsPlayer() then
            if attacker:Team() ~= pl:Team() then
                pl:AddDeaths(1)
                attacker:AddFrags(1)
            else
                attacker:AddFrags(-1)
            end
        end
    end
end

function GM:EntityTakeDamage(ent, inflictor, attacker, amount)
end

--[[Hostname check function
local LastHostnameCheck = 0
local function HostnameThink()
	// Check every 30 seconds
	if (LastHostnameCheck > CurTime()) then return end
	LastHostnameCheck = CurTime() + 30
	
	SetGlobalString("ServerName", GetConVarString("hostname"))

end
hook.Add("Think", "HostnameThink", HostnameThink)
]]
--"Qualify interaction
function GM:QualifyTag(pl, ent)
    local plid = pl:UniqueID()

    if self.geof.players[plid].qflag and self.geof.teams[pl:Team()].qualify == 0 then
        self.geof.teams[pl:Team()].qualify = ((self.geof.round.time - CurTime()) / (self.geof.rounds[3].time * 2)) + .5
        self.geof.players[plid].qflag = false
        ent:EmitSound(Sound("ambient/energy/weld" .. math.random(1, 2) .. ".wav"))
        pl:SetNWInt("gfflag", 0)
        --Send QUALIFY HUD data DUPLICATE
        local FILTER = RecipientFilter()
        FILTER:AddAllPlayers()
        umsg.Start("gfqhk", FILTER)
        umsg.Float(self.geof.rounds[3].time) --FIXME: Send constants prior

        for iteam = 1, 4 do
            umsg.Float(self.geof.teams[iteam].qualify)
        end

        umsg.End()
    end
end

--"Flag interaction
function GM.ccgftag(pl, cmd, args)
    local self = gmod.GetGamemode()

    if pl:Alive() and self.geof.teams[pl:Team()].qualify ~= self.geof.const.nocappenalty then
        if self.geof.round.cur == 4 or self.geof.round.cur == 3 then
            local ent = ents.GetByIndex(tonumber(args[1]))

            if ent and ent:GetTable().home ~= 0 and self.geof.teams[ent:GetTable().team].qualify ~= self.geof.const.nocappenalty and team.NumPlayers(ent:GetTable().team) > 0 then
                local plpos = pl:GetPos() + Vector(0, 0, 36)
                local entpos = ent:GetPos()

                --This makes the trace start from the closest possible position
                if entpos.z + 36 >= plpos.z then
                    if entpos.z - 36 <= plpos.z then
                        plpos.z = entpos.z --This lets us hit the entity whether we are standing on it or headbutting it
                    else
                        plpos.z = plpos.z + 36
                    end
                else
                    plpos.z = plpos.z - 36
                end

                if (plpos - ent:GetPos()):Length() <= 16 then
                    self:flagtag(pl, ent)
                end
            end
        end
    end
end

concommand.Add("gftag", GM.ccgftag)

--Executed fight and qualify
function GM:flagtag(pl, flag)
    --MULTIFLAG //FIXME
    local plid = pl:UniqueID()
    flag:EmitSound(Sound("items/battery_pickup.wav"))

    --Fight
    if self.geof.round.cur == 4 then
        if (not self.geof.players[plid].flag) and flag:GetTable().team ~= pl:Team() then
            self.geof.players[plid].flag = flag
            flag:GoPlayerGrab(pl)
            pl:SetNWInt("gfflag", flag:GetTable().team)
        elseif self.geof.players[plid].flag and flag:GetTable().team == pl:Team() then
            self.geof.players[plid].flag:GoHome()
            --Score! (The team module is corrupt, so we have to use our own scoring system.)
            self.geof.teams[pl:Team()].score = self.geof.teams[pl:Team()].score + 1
            self.geof.teams[self.geof.players[plid].flag:GetTable().team].score = self.geof.teams[self.geof.players[plid].flag:GetTable().team].score - 1
            self.geof.players[plid].flag = nil

            for k, pl in pairs(player.GetAll()) do
                if pl:IsValid() and pl:IsConnected() then
                    for iteam, team in pairs(self.geof.teams) do
                        if #self.geof.spawns[iteam] > 0 then
                            pl:SetNetworkedInt("gf" .. iteam, team.score)
                            pl:SetNetworkedFloat("gfm" .. iteam, team.qualify)
                            pl:SetNetworkedBool("gfo" .. iteam, team.open)
                        end
                    end
                end
            end
        elseif flag:GetTable().team == pl:Team() then
            flag:GoHome()
        end
    elseif self.geof.round.cur == 3 then
        --Qualify
        local plid = pl:UniqueID()
        self.geof.players[plid].qflag = true
        pl:SetNWInt("gfflag", flag:GetTable().team)
    end
end

--"Player interaction
function GM:PhysgunPickup(pl, ent)
    if ent:GetName() == "gfbb" or ent:GetClass() == "gf_playerspawn" or ent:GetClass() == "gf_bb_spawner" or ent:GetClass() == "gf_scoreboard" or ent:GetClass() == "gf_timeboard" or ent:GetClass() == "gf_flag" then
        return true
    else
        return
    end
end

function GM:OnPhysgunFreeze(weapon, phys, ent, pl)
    if type(ent) == "Entity" and ent:GetClass() == "gf_playerspawn" then
        ent:SetAngles(Angle(0, ent:GetAngles().y, 0))
    end

    phys:EnableMotion(false)
end

function GM.ccbbspawn(pl, cmd, args)
    local self = gmod.GetGamemode()

    local blocks = {
        {"models/buildingblocks/3d_1_2.mdl", Angle(0, 0, 0)},
        {"models/buildingblocks/3d_1_1.mdl", Angle(0, 0, 0)},
        {"models/buildingblocks/2d_1_8.mdl", Angle(90, 90, 0)},
        {"models/buildingblocks/2d_2_3.mdl", Angle(90, 0, 0)},
        {"models/buildingblocks/2d_1_2.mdl", Angle(90, 90, 0)},
        {"gf_scoreboard", Angle(90, 90, 0)},
        {"gf_timeboard", Angle(90, 90, 0)},
        {"gf_supply", Angle(90, 90, 0)},
    }

    if self.geof.round.cur == 2 and pl:Team() > 0 and pl:Team() <= 4 then
        local id = pl:UniqueID()
        local ent

        --local acc = -1
        for k, entity in pairs(ents.FindByClass("gf_bb_spawner")) do
            --block spawner range constant
            if (pl:GetShootPos() - entity:GetPos()):Length() < 600 then
                local ang = (entity:GetPos() - pl:GetShootPos()):GetNormalized():DotProduct(pl:GetAimVector())

                --if ang > acc then
                if (ent and (pl:GetShootPos() - entity:GetPos()):Length() < (pl:GetShootPos() - ent:GetPos()):Length()) or (not ent) then
                    ent = entity
                    --acc = ang
                end
                --end
            end
        end

        if ent then
            local self = ent:GetTable()

            if not self.timer[id] or self.timer[id] < CurTime() - self.spawndelay then
                self.timer[id] = CurTime()

                if blocks[tonumber(args[1])] then
                    local trace = {}
                    trace.start = self.Entity:GetPos() + self.Entity:GetUp() * 32
                    trace.endpos = self.Entity:GetUp() * 68 + trace.start
                    trace.filter = self.Entity
                    local trace = util.TraceLine(trace)

                    if not trace.Hit then
                        local bb

                        if string.find(blocks[tonumber(args[1])][1], ".mdl", nil, true) then
                            bb = ents.Create("prop_physics")
                            bb:SetModel(blocks[tonumber(args[1])][1])
                            bb:SetPos(self.Entity:GetPos() + self.Entity:GetUp() * 64)
                            bb:SetAngles(self.Entity:GetAngles() + blocks[tonumber(args[1])][2])
                            bb:SetSkin(pl:Team())
                            bb:SetName("gfbb")
                            bb:Spawn()
                        else
                            bb = ents.Create(blocks[tonumber(args[1])][1])
                            bb:SetPos(self.Entity:GetPos() + self.Entity:GetUp() * 64)
                            bb:SetAngles(self.Entity:GetAngles() + blocks[tonumber(args[1])][2])
                            bb:SetSkin(pl:Team())
                            bb:SetName("gfbb")
                            bb:Spawn()
                        end

                        local tabref = bb:GetTable()
                        local gm = gmod.GetGamemode()
                        local uid = tabref.geouid

                        if not uid then
                            tabref.geouid = gm.geof.enthist_n
                            uid = gm.geof.enthist_n
                            gm.geof.enthist_n = gm.geof.enthist_n + 1
                        end

                        local histref = gm.geof.enthist[uid]

                        if not histref then
                            gm.geof.enthist[uid] = {}
                            histref = gm.geof.enthist[uid]
                        end

                        histref.spawninfo = {
                            Entity = ent,
                            owner = pl:UniqueID(),
                            time = CurTime(),
                        }

                        self.Entity:EmitSound(Sound("buttons/combine_button7.wav"))
                    end
                end
            end
        end
    end
end

concommand.Add("bbspawn", GM.ccbbspawn)

function GM.ccgfa(pl, cmd, args)
    local gm = gmod.GetGamemode()
    local ent = ents.GetByIndex(args[2])
    local type = tonumber(args[1])
    if (not ent) or (not type) then return end

    if ent:IsValid() and (pl:GetShootPos() - ent:GetPos()):Length() < 96 then
        ent:GetTable().leeches[pl] = type
    end
end

concommand.Add("gfa", GM.ccgfa)

function GM:PlayerShouldTakeDamage(victim, attacker)
    if attacker:IsValid() and attacker:IsPlayer() and (victim:Team() == attacker:Team() and server_settings.Bool("mp_friendlyfire") == false) then
        return false
    else
        return true
    end
end

--"Help, team, spares
function GM:ShowHelp(pl)
    umsg.Start("gfopt", pl)
    umsg.Short(1)
    umsg.End()
end

function GM:ShowTeam(pl)
    umsg.Start("gfopt", pl)
    umsg.Short(2)
    umsg.End()
end

function GM:ShowSpare1(pl)
    umsg.Start("gfopt", pl)
    umsg.Short(3)
    umsg.End()
end

function GM:ShowSpare2(pl)
    umsg.Start("gfopt", pl)
    umsg.Short(4)
    umsg.End()
end

--"TeamSelect
function GM.selectteam(pl, cmd, args)
    local plid = pl:UniqueID()
    local self = gmod.GetGamemode()
    local newteam = tonumber(args[1])

    if newteam then
        if newteam > 0 and newteam <= 4 then
            local plid = pl:UniqueID()

            if self.geof.teams[newteam].open then
                if (not self.geof.players[plid].switched) or self.geof.const.allowmultiteamswitch then
                    self.geof.players[plid].switched = true
                    self.geof.players[plid].team = newteam
                    self.geof.players[plid].qflag = nil
                    pl:SetTeam(newteam)
                    self:ClosePlayer(pl)
                    pl:Spawn()
                elseif self.geof.players[plid].switched then
                    pl:ChatPrint("You have already changed teams this round.")
                end
            end
        end
    end
end

concommand.Add("gfteam", GM.selectteam)

--"Weapon Select
function GM.selectweapon(pl, cmd, args)
    local plid = pl:UniqueID()
    local self = gmod.GetGamemode()
    local key

    if cmd == "gfpri" then
        key = "pri"
    elseif cmd == "gfsec" then
        key = "sec"
    end

    for k, v in pairs(self.wep[key]) do
        if v == args[1] then
            self.geof.players[plid][key] = args[1]
            break
        end
    end

    pl:SetNetworkedString("gfPrimary", self.geof.players[plid].pri)
    pl:SetNetworkedString("gfSecondary", self.geof.players[plid].sec)
end

concommand.Add("gfpri", GM.selectweapon)
concommand.Add("gfsec", GM.selectweapon)

--"Voting system
GM.votedat = {
    gf_vote_extend = {
        chat = "extend the round by five minutes",
        fraction = .51,
        timeout = 60,
        action = function()
            --game.ConsoleCommand("gf_extendround 300\n")
            local self = gmod.GetGamemode()
            local time = 300

            if time then
                self.geof.round.time = self.geof.round.time + time

                if self.geof.round.time >= CurTime() + 3600 then
                    self.geof.round.time = CurTime() + 3599
                end

                for k, pl in pairs(player.GetAll()) do
                    if pl:IsValid() and pl:IsConnected() then
                        pl:SetNWInt("gfRound", self.geof.round.cur)
                        pl:SetNWFloat("gfTime", self.geof.round.time)

                        for iteam, team in pairs(self.geof.teams) do
                            if #self.geof.spawns[iteam] > 0 then
                                pl:SetNetworkedInt("gf" .. iteam, team.score)
                                pl:SetNetworkedFloat("gfm" .. iteam, team.qualify)
                                pl:SetNetworkedBool("gfo" .. iteam, team.open)
                            end
                        end
                    end
                end
            end
        end,
        yays = 0,
        voted = {},
    },
    gf_vote_nextround = {
        chat = "skip the timer",
        fraction = .51,
        timeout = 60,
        action = function()
            --game.ConsoleCommand("gf_nextround\n")
            local self = gmod.GetGamemode()
            self.geof.round.time = 0
        end,
        yays = 0,
        voted = {},
    },
    gf_vote_restartmap = {
        chat = "restart the map",
        fraction = .6,
        timeout = 60,
        action = function()
            game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
        end,
        yays = 0,
        voted = {},
    },
    gf_teamvote_resetflag = {
        team = true,
        rounds = {
            [2] = true,
        },
        chat = "reset .TEAM flag position",
        fraction = .5,
        timeout = 60,
        action = function(teama)
            local self = gmod.GetGamemode()

            for k, v in pairs(self.geof.flags[teama]) do
                for i, o in pairs(player.GetAll()) do
                    o:ChatPrint("Reset flag " .. tostring(v:EntIndex()))
                end

                v:resetposang()
            end
        end,
        yays = 0,
        voted = {},
    },
}

function GM.vote(pl, cmd, args)
    local self = gmod.GetGamemode()

    if pl:IsValid() and pl:IsPlayer() and self.votedat[cmd] then
        local plid = pl:UniqueID()
        local name = tostring(pl:Name())
        local tabref = self.votedat[cmd]
        local isteam = tabref.team

        if not ((not tabref.rounds) or tabref.rounds[self.geof.round.cur]) then
            pl:ChatPrint("This voting option is not valid for this round.")

            return
        end

        local teama

        if not isteam then
            tabref.needed = tabref.needed or math.ceil(tabref.fraction * #player.GetAll())
        else
            teama = pl:Team()

            if teama < 1 or teama > 4 then
                pl:ChatPrint("You are not on a valid team for this voting option.")

                return
            end

            if not tabref[teama] then
                tabref[teama] = {
                    needed = math.Round(tabref.fraction * team.NumPlayers(teama)),
                    yays = 0,
                    voted = {},
                }
            end
        end

        if not isteam then
            if tabref.yays == 0 then
                timer.Create(cmd, tabref.timeout, 1, function(tabref)
                    msg = "Vote to " .. tabref.chat .. " failed with " .. tabref.yays .. "/" .. tabref.needed .. " votes."
                    tabref.yays = 0
                    tabref.needed = nil
                    tabref.voted = {}
                end, tabref)
            end
        else
            if tabref[teama].yays == 0 then
                timer.Create(cmd .. teama, tabref.timeout, 1, function(tabref, teama)
                    msg = "Vote to " .. string.gsub(tabref.chat, ".TEAM", team.GetName(teama)) .. " failed with " .. tabref[teama].yays .. "/" .. tabref[teama].needed .. " votes."
                    tabref[teama] = nil
                end, tabref, teama)
            end
        end

        if not isteam then
            if not tabref.voted[plid] then
                tabref.yays = tabref.yays + 1
                tabref.voted[plid] = true
                local msg

                if tabref.yays >= tabref.needed then
                    timer.Destroy(cmd)

                    if tabref.yays > 1 then
                        msg = "Vote to " .. tabref.chat .. " passed with " .. tabref.yays .. " votes."
                    else
                        msg = "Vote to " .. tabref.chat .. " passed with " .. tabref.yays .. " vote."
                    end

                    tabref.action()
                    tabref.yays = 0
                    tabref.needed = nil
                    tabref.voted = {}
                else
                    msg = name .. " voted to " .. tabref.chat .. ". (" .. tabref.yays .. "/" .. tabref.needed .. ")"
                end

                for k, v in pairs(player.GetAll()) do
                    v:ChatPrint(msg)
                    v:ChatPrint("Press F4 to open the vote menu.")
                end
            else
                pl:ChatPrint("You have already voted to " .. tabref.chat .. ".")
            end
        else
            if not tabref[teama].voted[plid] then
                tabref[teama].yays = tabref[teama].yays + 1
                tabref[teama].voted[plid] = true
                local msg

                if tabref[teama].yays >= tabref[teama].needed then
                    timer.Destroy(cmd .. teama)

                    if tabref[teama].yays > 1 then
                        msg = "Vote to " .. string.gsub(tabref.chat, ".TEAM", team.GetName(teama)) .. " passed with " .. tabref[teama].yays .. " votes."
                    else
                        msg = "Vote to " .. string.gsub(tabref.chat, ".TEAM", team.GetName(teama)) .. " passed with " .. tabref[teama].yays .. " vote."
                    end

                    tabref.action(teama)
                    tabref[teama] = nil
                else
                    msg = name .. " voted to " .. string.gsub(tabref.chat, ".TEAM", team.GetName(teama)) .. ". (" .. tabref[teama].yays .. "/" .. tabref[teama].needed .. ")"
                end

                for k, v in pairs(team.GetPlayers(teama)) do
                    v:ChatPrint(msg)
                    v:ChatPrint("Press F4 to open the vote menu.")
                end
            else
                pl:ChatPrint("You have already voted to " .. string.gsub(tabref.chat, ".TEAM", team.GetName(teama)) .. ".")
            end
        end
    end
end

concommand.Add("gf_vote_extend", GM.vote)
concommand.Add("gf_vote_nextround", GM.vote)
concommand.Add("gf_vote_restartmap", GM.vote)
concommand.Add("gf_teamvote_resetflag", GM.vote)

--"Players
function GM:ClosePlayer(pl, quit)
    local plid

    if pl:IsValid() then
        plid = pl:UniqueID()
    else
        plid = self.UniqueID[pl]
    end

    local flag = self.geof.players[plid].flag

    if flag then
        flag = flag:GetTable()

        if flag.home == 0 then
            flag:GoPlayerDrop()

            if pl:IsPlayer() then
                pl:SetNWInt("gfflag", 0)
            end
        end

        self.geof.players[plid].flag = nil
    end

    if quit then
        self.geof.players[plid] = nil
    else
        pl:SetNetworkedString("gfPrimary", self.geof.players[plid].pri)
        pl:SetNetworkedString("gfSecondary", self.geof.players[plid].sec)
    end
end

function GM:OpenPlayer(pl)
    local plid = pl:UniqueID()

    --Player history initialization
    local hist = {
        moveowned = {},
        moveother = {},
    }

    if type(self.geof.players[plid]) == "table" then
        hist = self.geof.players[plid].hist
    end

    self.geof.players[plid] = {
        spawn = nil,
        spawni = nil,
        flag = nil,
        team = pl:Team(),
        pri = "cse2_mp5",
        sec = "cse2_p228",
        hist = hist,
    }

    pl:SetNWInt("gfflag", 0)
    pl:SetNetworkedString("gfPrimary", self.geof.players[plid].pri)
    pl:SetNetworkedString("gfSecondary", self.geof.players[plid].sec)

    --Duplicity Network	
    for iteam, team in pairs(self.geof.teams) do
        if #self.geof.spawns[iteam] > 0 then
            pl:SetNetworkedInt("gf" .. iteam, team.score)
            pl:SetNetworkedFloat("gfm" .. iteam, team.qualify)
            pl:SetNetworkedBool("gfo" .. iteam, team.open)
        end
    end
end

function GM:PlayerDisconnected(pl)
    self:ClosePlayer(pl, true)
end

function GM.hookPlayerDeath(victim, weapon, killer)
    local self = gmod.GetGamemode()
    self:ClosePlayer(victim)
end

hook.Add("PlayerDeath", "GM:hookPlayerDeath", GM.hookPlayerDeath)

function GM:PlayerInitialSpawn(pl)
    pl:SetNWInt("gfRound", self.geof.round.cur)
    pl:SetNWFloat("gfTime", self.geof.round.time)
    pl:SetTeam(1) --FIXME
    self.UniqueID[pl] = pl:UniqueID()
    self:OpenPlayer(pl)
end

function GM:PlayerSetModel(pl)
    pl:SetModel("models/player/Kleiner.mdl")
    self:SetRandomPlayerModel(pl)
end

function GM:PlayerRealSpawn(pl, prefspawn)
    local plid = pl:UniqueID()
    --TODO: Make this a function
    self.geof.players[plid].selectspawn = false
    pl:SetNWBool("gfss", false)
    local spawn = prefspawn or self:PlayerSelectSpawn(pl)
    local trace = {}
    trace.start = spawn:GetPos() + spawn:GetUp() * 16
    trace.endpos = spawn:GetUp() * 72 + trace.start
    trace.filter = spawn
    local trace = util.TraceLine(trace)

    if not trace.Hit then
        self.bodyque[pl] = nil
        pl:UnSpectate()
        self.geof.players[plid].spawnskip = true
        self:SetRandomPlayerModel(pl)
        pl:Spawn()
        pl:SetPos(spawn:GetPos() + Vector(0, 0, 16))
        pl:SetEyeAngles(Angle(0, spawn:GetAngles().y, 0))

        if self.geof.rounds[self.geof.round.cur].weapons == 2 then
            local priClass = self.geof.players[plid].pri
            local secClass = self.geof.players[plid].sec
            local primary = weapons.Get(priClass)
            local secondary = weapons.Get(secClass)
            pl:Give(priClass)
            pl:Give(secClass)
            pl:SetAmmo(primary.Primary.DefaultClip, primary.Primary.Ammo)
            pl:SetAmmo(secondary.Primary.DefaultClip, secondary.Primary.Ammo)
        elseif self.geof.rounds[self.geof.round.cur].weapons == 1 then
            pl:Give("weapon_crowbar")
            pl:Give("weapon_physcannon")
            pl:Give("weapon_physgun")
        end

        local cl_defaultweapon = pl:GetInfo("cl_defaultweapon")

        if pl:HasWeapon(cl_defaultweapon) then
            pl:SelectWeapon(cl_defaultweapon)
        end

        return true
    else
        local result = false
        local ent = trace.Entity

        if not self.bodyqueblockers[ent] then
            self.bodyqueblockers[ent] = 0
        end

        self.bodyqueblockers[ent] = self.bodyqueblockers[ent] + 1

        --This constant controls how many times an object is allowed to block a spawnpoint
        if self.bodyqueblockers[ent] >= self.geof.const.respawnblockingmax then
            if ent:GetClass() == "player" then
                --ent:Kill()
                self:PlayerSpawn(ent, prefspawn) --Spectate the AFK player
                --TODO: Notify the player that he was blocking a spawn point
            elseif ent:GetName() == "gfbb" or ent:GetClass() == "gf_scoreboard" or ent:GetClass() == "gf_timeboard" then
                ent:Remove()
            elseif ent:GetClass() == "gf_bb_spawner" then
                ent:Spawn()
                local phys = v:GetPhysicsObject()

                if phys:IsValid() then
                    phys:EnableMotion(false)
                end
            else
                spawn:resetposang()
            end

            result = self:PlayerRealSpawn(pl, prefspawn)
        end

        return result or false
    end

    --TODO: Kill this code // Only clear after 5 seconds of failure
    self.geof.players[plid].spawn = nil
end

function GM:PlayerSpawn(pl, prefspawn)
    local plid

    if pl:IsValid() then
        plid = pl:UniqueID()
    else
        plid = self.UniqueID[pl]
    end

    if not self.geof.players[plid].spawnskip then
        pl:SetPos(pl:GetPos() + Vector(0, 0, 16))

        if self.geof.round.cur ~= 3 then
            pl:StripAmmo()
            pl:StripWeapons()
            pl:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            pl:Spectate(OBS_MODE_CHASE)
            pl:SpectateEntity(self:PlayerSelectSpawn(pl, prefspawn))
            pl:SetRenderMode(RENDERMODE_TRANSTEXTURE)
            pl:SetColor(Color(255, 255, 255, 100))
            --TODO: Make this a function
            self.geof.players[plid].selectspawn = true
            pl:SetNWBool("gfss", true)
            pl:SetNWFloat("gfsst", CurTime() + self.geof.const.respawntime)
            self.bodyque[pl] = CurTime() + self.geof.const.respawntime
        end

        if self.geof.round.cur == 3 then
            pl:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        end

        if self.bodyqueblockers[pl] then
            self.bodyqueblockers[pl] = nil
        end
    else
        pl:SetRenderMode(RENDERMODE_NORMAL)
        pl:SetColor(Color(255, 255, 255, 255))
        self.geof.players[plid].spawnskip = nil
    end
end

function GM:PlayerSelectSpawn(pl)
    local plid = pl:UniqueID()
    local select

    if type(self.geof.players[plid]) == "table" then
        if self.geof.round.cur ~= 3 then
            select = self.geof.players[plid].spawn
        end
    else
        self:OpenPlayer(pl) --It is important that the player is opened here
    end

    if not (select and select:IsValid()) then
        local spawns

        if self.geof.round.cur ~= 3 then
            spawns = self.geof.spawns[pl:Team()]
        else
            spawns = self.geof.qspawns[pl:Team()]
        end

        if not spawns then
            spawns = ents.FindByClass("info_player_start")
        end

        local selectn = math.random(#spawns)
        select = spawns[selectn]
        self.geof.players[plid].spawni = selectn
        --[[ TODO: Kill this code
		if select:GetClass() == "gf_playerspawn" then
			select:SetNWFloat("gfSpT",CurTime()+self.geof.const.respawntime)
			select:SetNWString("gfSpN",string.sub(tostring(pl:GetName()),1,22))
		end
		]]
    end

    self.geof.players[plid].spawn = select

    return select
end

function GM:PlayerLoadout(pl)
end

function GM:PlayerDeath(pl, inflictor, killer)
    local plid = pl:UniqueID()

    if type(self.geof.players[plid]) ~= "table" then
        self:OpenPlayer(pl)
    end

    self.geof.players[plid].birthtime = CurTime() + 3
    pl:SetNWFloat("gfbtime", CurTime() + 3)

    --Base code
    -- Convert the inflictor to the weapon that they're holding if we can.
    -- This can be right or wrong with NPCs since combine can be holding a 
    -- pistol but kill you by hitting you with their arm.
    if inflictor and inflictor == killer and (inflictor:IsPlayer() or inflictor:IsNPC()) then
        inflictor = inflictor:GetActiveWeapon()

        if not inflictor or inflictor == NULL then
            inflictor = killer
        end
    end

    if killer == pl then
        umsg.Start("PlayerKilledSelf")
        umsg.Entity(pl)
        umsg.End()
        MsgAll(killer:Nick() .. " suicided!\n")

        return
    end

    if killer:IsPlayer() then
        umsg.Start("PlayerKilledByPlayer")
        umsg.Entity(pl)
        umsg.String(inflictor:GetClass())
        umsg.Entity(killer)
        umsg.End()
        MsgAll(killer:Nick() .. " killed " .. pl:Nick() .. " using " .. inflictor:GetClass() .. "\n")

        return
    end

    umsg.Start("PlayerKilled")
    umsg.Entity(pl)
    umsg.String(inflictor:GetClass())
    umsg.String(killer:GetClass())
    umsg.End()
    MsgAll(pl:Nick() .. " was killed by " .. killer:GetClass() .. "\n")
end

function GM:PlayerDeathThink(pl)
    local plid = pl:UniqueID()

    if type(self.geof.players[plid]) ~= "table" then
        self:OpenPlayer(pl)
    end

    time = tonumber(self.geof.players[plid].birthtime) or 0

    if time < CurTime() then
        pl:Spawn()
    end
end

--TODO: Remove this
SUICIDE_HEALTH = 1000
AIMBOT_OFFSET = Vector(0, 0, -45000)

--"Keypresses
function GM:KeyPress(pl, key)
    plid = pl:UniqueID()

    if self.geof.players[plid].selectspawn then
        local spawni = self.geof.players[plid].spawni
        local spawns = self.geof.spawns[pl:Team()]

        if #spawns > 0 then
            if (not spawni) or (spawni > #spawns) then
                spawni = 1
            end

            if key == IN_MOVELEFT or key == IN_FORWARD then
                spawni = spawni + 1

                if spawni > #spawns then
                    spawni = 1
                end
            elseif key == IN_MOVERIGHT or key == IN_BACK or key == IN_JUMP then
                spawni = spawni - 1

                if spawni < 1 then
                    spawni = #spawns
                end
            elseif key == IN_ATTACK then
                if self.bodyque[pl] and self.bodyque[pl] < CurTime() then
                    --self:PlayerRealSpawn(pl,spawns[spawni])
                    tabref = self.bodyqueent[spawns[spawni]]
                    table.insert(tabref.list, pl)
                    --TODO: Make this a function
                    self.geof.players[plid].selectspawn = false
                    pl:SetNWBool("gfss", false)
                    --Send pre-data here
                end
            end
        end

        self.geof.players[plid].spawni = spawni
        pl:SpectateEntity(spawns[spawni])
    end
end

function GM:KeyRelease(pl, key)
end

--"Player Management
GM.geof.enthist = {}
GM.geof.enthist_n = 1

hook.Add("PhysgunPickup", "Gamemode_GeoForts", function(pl, ent)
    local validents = {
        prop_physics = true,
        gf_bb_spawner = true,
        gf_flag = true,
        gf_gametimer = true,
        gf_playerspawn = true,
        gf_qualifyspawn = true,
        gf_scoreboard = true,
        gf_supply = true,
        gf_timeboard = true,
    }

    if ent:GetClass() ~= "player" and validents[ent:GetClass()] then
        --Store the player's unfreeze
        local self = gmod.GetGamemode()
        local plid = pl:UniqueID()
        local hist = self.geof.players[plid].hist
        local tabref = ent:GetTable()
        local uid = tabref.geouid

        if not uid then
            tabref.geouid = self.geof.enthist_n
            uid = self.geof.enthist_n
            self.geof.enthist_n = self.geof.enthist_n + 1
        end

        local histref = self.geof.enthist[uid]

        if not histref then
            self.geof.enthist[uid] = {
                spawninfo = {
                    Entity = ent,
                },
            }

            histref = self.geof.enthist[uid]
        end

        table.insert(histref, {
            player = pl,
            pos = ent:GetPos(),
            ang = ent:EyeAngles(),
            time = CurTime(),
        })

        --Store player behavior
        --histref.spawninfo.owner
        --hist.moveowned
        --hist.moveother
        if histref.spawninfo.owner == plid then
            table.insert(hist.moveowned, 1, {
                time = CurTime(),
                ent = uid,
            })
        else
            table.insert(hist.moveother, 1, {
                time = CurTime(),
                ent = uid,
            })
        end

        --Evaluate the player
        local precasts = {}

        local castlimits = {3, 3.2, 3.5, 3.2, 3.1, 3.0, 2.8, 2.7, 2.6, 2.4, 2.1, 1.9, 1.8, 1.7, 1.6,}

        local si = 1

        for i = si, table.getn(castlimits) do
            precasts[i] = 0
        end

        for k, v in ipairs(hist.moveother) do
            if v.time < CurTime() - #castlimits then
                break
            else
                for i = si, table.getn(castlimits) do
                    if v.time > CurTime() - i then
                        precasts[i] = precasts[i] + 1
                    else
                        si = i + 1
                    end
                end
            end
        end

        for i, limit in ipairs(castlimits) do
            --Msg(i,":",string.format("%.1f",limit),":",string.format("%.2f",precasts[i] / i),"\t",pl:Nick(),"\n")
            if precasts[i] / i > limit then
                --Initiate player trial
                for k, v in pairs(player.GetAll()) do
                    local msg = "Player " .. tostring(pl:Nick()) .. " has broken the " .. limit .. " props per second limit after " .. i .. " second"

                    if i == 1 then
                        msg = msg .. "."
                    else
                        msg = msg .. "s."
                    end

                    v:ChatPrint(msg)
                    local append = file.Read("geoforts/gf_castlimit.txt")
                    append = tostring(append or "") .. tostring(i .. ":" .. string.format("%.1f", limit) .. ":" .. string.format("%.2f", precasts[i] / i) .. "\t" .. tostring(pl:Nick())) .. "\n"
                    file.Write("geoforts/gf_castlimit.txt", append)
                end

                break
            end
        end
    end

    return
end)

-- Armor Fix
hudaf = {}

function hudarmorfixThink()
    for k, pl in pairs(player.GetAll()) do
        if pl:IsValid() and pl:IsConnected() then
            local userid = pl:UniqueID()

            if pl:Armor() ~= hudaf[userid] then
                pl:SetNetworkedInt("armor", pl:Armor())
                hudaf[userid] = pl:Armor()
            end
        end
    end
end

hook.Add("Think", "hudarmorfixThink", hudarmorfixThink)

hook.Add("Initialize", "geoforts_resources", function()
    resource.AddFile("materials/buildingblocks/metal_1.vmt")
    resource.AddFile("materials/buildingblocks/metal_1.vtf")
    resource.AddFile("materials/buildingblocks/metal_1_0.vmt")
    resource.AddFile("materials/buildingblocks/metal_1_0.vtf")
    resource.AddFile("materials/buildingblocks/metal_1_1.vmt")
    resource.AddFile("materials/buildingblocks/metal_1_1.vtf")
    resource.AddFile("materials/buildingblocks/metal_1_2.vmt")
    resource.AddFile("materials/buildingblocks/metal_1_2.vtf")
    resource.AddFile("materials/buildingblocks/metal_1_3.vmt")
    resource.AddFile("materials/buildingblocks/metal_1_3.vtf")
    resource.AddFile("materials/buildingblocks/metal_1_4.vmt")
    resource.AddFile("materials/buildingblocks/metal_1_4.vtf")
    resource.AddFile("materials/buildingblocks/logowhite.vmt")
    resource.AddFile("materials/buildingblocks/logowhite.vtf")
    resource.AddFile("materials/buildingblocks/logo.vmt")
    resource.AddFile("materials/buildingblocks/logo.vtf")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_0.vmt")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_0.vtf")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_1.vmt")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_1.vtf")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_2.vmt")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_2.vtf")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_3.vmt")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_3.vtf")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_4.vmt")
    resource.AddFile("materials/models/buildingblocks/metal_logo_1_4.vtf")
    resource.AddFile("models/buildingblocks/2d_1_2.dx80.vtx")
    resource.AddFile("models/buildingblocks/2d_1_2.dx90.vtx")
    resource.AddFile("models/buildingblocks/2d_1_2.mdl")
    resource.AddFile("models/buildingblocks/2d_1_2.phy")
    resource.AddFile("models/buildingblocks/2d_1_2.sw.vtx")
    resource.AddFile("models/buildingblocks/2d_1_2.vvd")
    resource.AddFile("models/buildingblocks/2d_1_8.dx80.vtx")
    resource.AddFile("models/buildingblocks/2d_1_8.dx90.vtx")
    resource.AddFile("models/buildingblocks/2d_1_8.mdl")
    resource.AddFile("models/buildingblocks/2d_1_8.phy")
    resource.AddFile("models/buildingblocks/2d_1_8.sw.vtx")
    resource.AddFile("models/buildingblocks/2d_1_8.vvd")
    resource.AddFile("models/buildingblocks/2d_2_3.dx80.vtx")
    resource.AddFile("models/buildingblocks/2d_2_3.dx90.vtx")
    resource.AddFile("models/buildingblocks/2d_2_3.mdl")
    resource.AddFile("models/buildingblocks/2d_2_3.phy")
    resource.AddFile("models/buildingblocks/2d_2_3.sw.vtx")
    resource.AddFile("models/buildingblocks/2d_2_3.vvd")
    resource.AddFile("models/buildingblocks/3d_1_1.dx80.vtx")
    resource.AddFile("models/buildingblocks/3d_1_1.dx90.vtx")
    resource.AddFile("models/buildingblocks/3d_1_1.mdl")
    resource.AddFile("models/buildingblocks/3d_1_1.phy")
    resource.AddFile("models/buildingblocks/3d_1_1.sw.vtx")
    resource.AddFile("models/buildingblocks/3d_1_1.vvd")
    resource.AddFile("models/buildingblocks/3d_1_2.dx80.vtx")
    resource.AddFile("models/buildingblocks/3d_1_2.dx90.vtx")
    resource.AddFile("models/buildingblocks/3d_1_2.mdl")
    resource.AddFile("models/buildingblocks/3d_1_2.phy")
    resource.AddFile("models/buildingblocks/3d_1_2.sw.vtx")
    resource.AddFile("models/buildingblocks/3d_1_2.vvd")
    resource.AddFile("models/buildingblocks/blockspawn_1.dx80.vtx")
    resource.AddFile("models/buildingblocks/blockspawn_1.dx90.vtx")
    resource.AddFile("models/buildingblocks/blockspawn_1.mdl")
    resource.AddFile("models/buildingblocks/blockspawn_1.phy")
    resource.AddFile("models/buildingblocks/blockspawn_1.sw.vtx")
    resource.AddFile("models/buildingblocks/blockspawn_1.vvd")
    resource.AddFile("models/buildingblocks/playerspawn_1.dx80.vtx")
    resource.AddFile("models/buildingblocks/playerspawn_1.dx90.vtx")
    resource.AddFile("models/buildingblocks/playerspawn_1.mdl")
    resource.AddFile("models/buildingblocks/playerspawn_1.phy")
    resource.AddFile("models/buildingblocks/playerspawn_1.sw.vtx")
    resource.AddFile("models/buildingblocks/playerspawn_1.vvd")
end)