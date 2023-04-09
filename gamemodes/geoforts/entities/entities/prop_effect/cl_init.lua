ENT.Spawnable = false
ENT.AdminSpawnable = false

--[[---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------]]
function ENT:Initialize()
    self.GripMaterial = Material("sprites/grip")
    local Radius = 4
    self.Entity:SetCollisionBounds(Vector(-Radius, -Radius, -Radius), Vector(Radius, Radius, Radius))
end

--[[---------------------------------------------------------
   Name: Draw
---------------------------------------------------------]]
function ENT:Draw()
    -- Don't draw the grip if there's no chance of us picking it up
    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()
    if not wep:IsValid() then return end
    local weapon_name = wep:GetClass()
    local tool_mode = GetConVarString("gmod_toolmode")
    if weapon_name ~= "weapon_physgun" and weapon_name ~= "weapon_physcannon" and weapon_name ~= "gmod_tool" then return end
    render.SetMaterial(self.GripMaterial)
    render.DrawSprite(self.Entity:GetPos(), 16, 16, color_white)
end

include('shared.lua')