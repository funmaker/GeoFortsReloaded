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
            local team = self.Team
            local self = gmod.GetGamemode()
            local userid = entity:UniqueID()

            if entity:Team() == team then
                if self.houst[userid].Buyzone == 0 then
                    entity:SetNetworkedBool("houstbuy", true)
                end

                self.houst[userid].Buyzone = self.houst[userid].Buyzone + 1
            end
        end
    end
end

--[[---------------------------------------------------------
   Name: EndTouch
---------------------------------------------------------]]
function ENT:EndTouch(entity)
    if entity:IsPlayer() then
        if SERVER then
            local team = self.Team
            local self = gmod.GetGamemode()
            local userid = entity:UniqueID()

            if entity:Team() == team then
                self.houst[userid].Buyzone = self.houst[userid].Buyzone - 1

                if self.houst[userid].Buyzone < 0 then
                    self.houst[userid].Buyzone = 0
                end

                if self.houst[userid].Buyzone == 0 then
                    entity:SetNetworkedBool("houstbuy", false)
                end
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
    if key == "TeamNum" then
        if value == "3" then
            self.Team = 1
        elseif value == "2" then
            self.Team = 2
        else
            self.Team = 0
        end
    end
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