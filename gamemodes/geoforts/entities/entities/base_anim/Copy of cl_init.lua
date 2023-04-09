ENT.Spawnable = true -- Is spawnable via GMOD's spawn menu
ENT.AdminSpawnable = true -- Is spawnable by admins

--[[---------------------------------------------------------
   Name: Draw
   Desc: Draw it!
---------------------------------------------------------]]
function ENT:Draw()
    self.Entity:DrawModel()
end

--[[---------------------------------------------------------
   Name: IsTranslucent
   Desc: Return whether object is translucent or opaque
---------------------------------------------------------]]
function ENT:IsTranslucent()
    return true
end

include('shared.lua')