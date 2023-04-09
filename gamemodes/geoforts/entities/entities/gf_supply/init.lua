AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:OnRemove()
end

function ENT:Initialize()
    self.Entity:SetModel("models/buildingblocks/2d_1_2.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(true)
        phys:Wake()
    end

    self.leeches = {}
end

function ENT:Use()
end

function ENT:Think()
    for pl, type in pairs(self.leeches) do
        if pl:Alive()
        and (pl:GetPos() - self.Entity:GetPos()):Length() < 96
        and pl:GetEyeTrace().Entity == self
        and pl:KeyDown( IN_USE ) then
            if type == 1 then
                if pl:Health() < 100 then
                    pl:SetHealth(pl:Health() + 1)
                elseif pl:Armor() < 100 then
                    pl:SetArmor(pl:Armor() + 1)
                else
                    self.leeches[pl] = nil
                end
            elseif type == 2 then
                if gmod.GetGamemode().geof.rounds[gmod.GetGamemode().geof.round.cur].weapons == 2 then
                    local primary = weapons.Get(gmod.GetGamemode().geof.players[plid].pri)
                    local secondary = weapons.Get(gmod.GetGamemode().geof.players[plid].sec)

                    if pl:GetAmmoCount(primary.Primary.Ammo) < primary.Primary.DefaultClip then
                        pl:GiveAmmo(1, primary.Primary.Ammo)
                    elseif pl:GetAmmoCount(secondary.Primary.Ammo) < secondary.Primary.DefaultClip then
                        pl:GiveAmmo(1, secondary.Primary.Ammo)
                    else
                        self.leeches[pl] = nil
                    end
                end
            end
        else
            self.leeches[pl] = nil
        end
    end
end

function ENT:UpdateTransmitState()
    return TRANSMIT_PVS
end