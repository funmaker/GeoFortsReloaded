--BLOCK SPAWNER
--Version 1.0
--Written by Night-Eagle
include('shared.lua')

function ENT:Initialize()
    self.color = team.GetColor(self.Entity:GetSkin())
    self.color.a = 255
    self.logo = surface.GetTextureID("buildingblocks/logowhite")

    self.rounds = {"Preround", "Build", "Qualify", "Fight",}

    self.multiplier = .25
    self.last = CurTime() + math.random(1, 100) / 100
    self.x1 = -1.9 / self.multiplier
    self.x2 = 1.9 / self.multiplier
    self.y1 = .9 / self.multiplier
    self.y2 = -.9 / self.multiplier
    self.z = -1.6
    self.x = self.x1 / .05
    self.y = -self.y1 / .05
    self.x0 = self.x + (self.x2 / .05) - self.x * 2
    self.y0 = self.y + (-self.y2 / .05) - self.y * 2
    self.w = (self.x2 / .05) - self.x
    self.h = math.abs((self.y2 / .05) + self.y)
end

function ENT:OnRemove()
end

function ENT:Draw()
    local color = self.color
    self.Entity:DrawModel()
    local ang = self.Entity:GetAngles()
    local rot = Vector(90, 0, 0)
    ang:RotateAroundAxis(ang:Right(), rot.x)
    --ang:RotateAroundAxis(ang:Up(), 		rot.y)
    --ang:RotateAroundAxis(ang:Forward(), rot.z)
    local pos = self.Entity:GetPos() + (self.Entity:GetForward() * self.z)
    cam.Start3D2D(pos, ang, .25)
    surface.SetDrawColor(color.r, color.g, color.b, 50)
    surface.DrawRect(self.x, self.y, self.w, self.h)
    surface.SetDrawColor(color.r, color.g, color.b, 255)
    surface.SetTexture(self.logo)
    surface.DrawTexturedRect(self.x + self.w * .5 - 48, self.y + self.h * .5 - 48, 96, 96)
    draw.DrawText(tostring(self.rounds[LocalPlayer():GetNetworkedInt("gfRound")]), "ScoreM", self.x + self.w * .5, self.y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    draw.DrawText(string.ToMinutesSeconds(LocalPlayer():GetNWFloat("gfTime") - CurTime(), 0), "ScoreL", self.x + self.w * .5, self.y + 32, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function ENT:Think()
    self.color = team.GetColor(self.Entity:GetSkin())

    if self.Entity:GetSkin() ~= 0 then
        function self:Think()
        end
    end
end