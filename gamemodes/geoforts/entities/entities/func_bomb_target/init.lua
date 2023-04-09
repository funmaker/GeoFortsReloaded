ENT.Base = "base_brush"
ENT.Type = "brush"

--[[---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------]]
function ENT:Initialize()
end

--[[---------------------------------------------------------
   Name: StartTouch
---------------------------------------------------------]]
function ENT:StartTouch(entity)
    if entity:IsPlayer() then
        if SERVER then
            local self = gmod.GetGamemode()
            local userid = entity:UniqueID()

            if self.houst[userid].Bombzone == 0 then
                entity:SetNetworkedBool("houstbomb", true)
            end

            self.houst[userid].Bombzone = self.houst[userid].Bombzone + 1
        end
    end
end

--[[---------------------------------------------------------
   Name: EndTouch
---------------------------------------------------------]]
function ENT:EndTouch(entity)
    if entity:IsPlayer() then
        if SERVER then
            local self = gmod.GetGamemode()
            local userid = entity:UniqueID()
            self.houst[userid].Bombzone = self.houst[userid].Bombzone - 1

            if self.houst[userid].Bombzone < 0 then
                self.houst[userid].Bombzone = 0
            end

            if self.houst[userid].Bombzone == 0 then
                entity:SetNetworkedBool("houstbomb", false)
            end
        end
    end
end

--[[---------------------------------------------------------
   Name: Touch
---------------------------------------------------------]]
function ENT:Touch(entity)
end

--[[---------------------------------------------------------
   Name: PassesTriggerFilters
   Desc: Return true if this object should trigger us
---------------------------------------------------------]]
function ENT:PassesTriggerFilters(entity)
    return true
end

--[[---------------------------------------------------------
   Name: KeyValue
   Desc: Called when a keyvalue is added to us
---------------------------------------------------------]]
function ENT:KeyValue(key, value)
end

--[[---------------------------------------------------------
   Name: Think
   Desc: Entity's think function. 
---------------------------------------------------------]]
function ENT:Think()
end

--[[---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------]]
function ENT:OnRemove()
end