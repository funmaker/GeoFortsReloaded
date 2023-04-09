AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.OnBuild = {}
ENT.OnQualify = {}
ENT.OnFight = {}

function ENT:KeyValue(key, value)
    if key == "OnBuild" or key == "OnQualify" or key == "OnFight" then
        local value = string.gsub(value, ",,", ", ,")
        table.insert(self[key], string.Explode(",", value))
    end
    --OnBuild	divider,Enable,,0,-1
    --OnFight	divider,Disable,,0,-1
end