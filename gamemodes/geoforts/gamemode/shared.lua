GM.Name = "GeoForts"
GM.Author = "Night-Eagle"
GM.Email = "gmail sedhdi"
GM.Website = ""
SinglePlayer = game.SinglePlayer
team.SetUp(1, "Blue", Color(0, 0, 255, 100))
team.SetUp(2, "Yellow", Color(255, 255, 0, 100))
team.SetUp(3, "Green", Color(0, 255, 0, 100))
team.SetUp(4, "Red", Color(255, 0, 0, 100))

function GM:PlayerConnect(name, address, steamid)
end

function GM:PhysgunPickup(ply, ent)
    -- Don't pick up players
    if ent:GetClass() == "player" then return false end

    return true
end

function GM:PhysgunDrop(ply, ent)
end

--Text to show in the server browser
function GM:GetGameDescription()
    return self.Name
end

function GM:Saved()
end

function GM:Restored()
end

function GM:GetPlayerModels(team)
    return self.pmodels[team]
end

function GM:SetRandomPlayerModel(pl)
    local team = pl:Team()

    if team > 0 and team <= 5 then
        models = self:GetPlayerModels(team)
        pl:SetModel(models[math.random(1, #models)])
    end
end

-- Debug NoClip
--[[
function GM:PlayerNoClip( ply, desiredNoClipState )
	if ( desiredNoClipState ) then
		print( ply:Name() .. " wants to enter noclip." )
	else
		print( ply:Name() .. " wants to leave noclip." )
	end
    return true
end
]]

include("sweps.lua")
include("models.lua")
include("sh_hitmarker.lua")