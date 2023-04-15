AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/items/item_item_crate.mdl")
    self:PrecacheGibs()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysWake()
    phys = self:GetPhysicsObject()
    phys:SetMass(0.)
    phys:AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)

    self.landed = false
end

function ENT:GravGunPunt()
    return false
end

function ENT:PhysicsCollide(col, collider)
    if self.landed then return end

    self.landed = true
    self:SetNWBool("landed", true)
    self:SetHealth(30)
    self:GetPhysicsObject():SetMass(50)
end

local DROPS = {
    { prob = 1, model = "models/props_c17/oildrum001_explosive.mdl" },
    { prob = 1, class = "gf_throwable", model = "models/props_junk/sawblade001a.mdl" },
    { prob = 1, class = "gf_throwable", model = "models/props_junk/harpoon002a.mdl" },
}

local DROPS_PROB_SUM = 0
for _, v in ipairs(DROPS) do DROPS_PROB_SUM = DROPS_PROB_SUM + v.prob end

function ENT:OnTakeDamage( dmginfo )
    if !self.landed then return end

    local newHealth = self:Health() - dmginfo:GetDamage()

    if newHealth <= 0 then
        self:GibBreakClient(dmginfo:GetDamageForce())
        self:Remove()

        local dropRand = math.Rand(0, DROPS_PROB_SUM)
        local drop

        for _, v in ipairs(DROPS) do
            if v.prob >= dropRand then
                drop = v
                break
            else
                dropRand = dropRand - v.prob
            end
        end

        if !drop then return end

        local dropEnt = ents.Create(drop.class || "prop_physics")
        dropEnt:SetPos(self:GetPos() + Vector(0, 0, 10))
        if drop.model then dropEnt:SetModel(drop.model) end
        dropEnt:Spawn()

        -- local gm = gmod.GetGamemode()
        -- if gm.AddRoundEntity then gm:AddRoundEntity(dropEnt) end
    else
        self:SetHealth(newHealth)
    end

    return dmginfo:GetDamage()
end

local MAX_SPEED = 5

function ENT:Think()
    if self.landed then return end

    local physObj = self:GetPhysicsObject();
    local velocity = physObj:GetVelocity()

    -- if velocity:Length() > MAX_SPEED then
    --     physObj:SetVelocity(velocity:GetNormalized() * MAX_SPEED)
    -- end
end
