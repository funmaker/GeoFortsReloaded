--BLOCK SPAWNER
--Version 1.0
--Written by Night-Eagle
include('shared.lua')

function ENT:Initialize()
    self.color = team.GetColor(self.Entity:GetSkin())
    self.color.a = 255
    self.multiplier = .25
    self.last = CurTime() + math.random(0, 100) / 100
    self.x1 = -.7 / self.multiplier
    self.x2 = .7 / self.multiplier
    self.y1 = .7 / self.multiplier
    self.y2 = -.7 / self.multiplier
    self.z = -.5
    self.x = self.x1 / .05
    self.y = -self.y1 / .05
    self.x0 = self.x + (self.x2 / .05) - self.x * 2
    self.y0 = self.y + (-self.y2 / .05) - self.y * 2
    self.w = (self.x2 / .05) - self.x
    self.h = math.abs((self.y2 / .05) + self.y)
end

--"
function ENT:OnRemove()
end

function ENT:Draw()
    if LocalPlayer():GetNetworkedInt("gfRound") == 3 then
        local color = self.color
        self.Entity:DrawModel()
        local ang = self.Entity:GetAngles()
        local rot = Vector(0, 90, 0)
        --ang:RotateAroundAxis(ang:Right(), 	rot.x)
        ang:RotateAroundAxis(ang:Up(), rot.y)
        --ang:RotateAroundAxis(ang:Forward(), rot.z)
        local pos = self.Entity:GetPos() + (self.Entity:GetUp() * self.z)
        cam.Start3D2D(pos, ang, .25)
        surface.SetDrawColor(color.r, color.g, color.b, 50)
        surface.DrawRect(self.x, self.y, self.w, self.h)
        draw.DrawText("Spawn Point\nQualify Mode\n\nTag the flag and\nreturn here.", "Trebuchet18", self.x + 1, self.y, Color(255, 255, 255, 255))
        cam.End3D2D()
    end
end