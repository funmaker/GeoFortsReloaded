include('shared.lua')

function ENT:Initialize()
    self.chute = ClientsideModel("models/hunter/misc/shell2x2a.mdl")
	self.chute:SetParent(self)
	self.chute:SetPos(self:GetPos() + Vector(0, 0, 50))
	self.chute:SetMaterial("phoenix_storms/cigar")
    self.chute:SetColor(Color(255, 227, 163))
	self.chute:Spawn()
end

function ENT:OnRemove()
	if self.chute:IsValid() then self.chute:Remove() end
end


function ENT:Think()
	if self.chute:IsValid() and self:GetNWBool("landed", false) then
		self.chute:Remove()
		self.Think = nil
	end
end
