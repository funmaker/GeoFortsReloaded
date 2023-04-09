--BLOCK SPAWNER
--Version 1.0
--Written by Night-Eagle
include('shared.lua')

function ENT:Initialize()
    self.color = team.GetColor(self.Entity:GetSkin())
    self.color.a = 255
    self.logo = surface.GetTextureID("buildingblocks/logowhite")

    self.score = {0, 0, 0, 0}

    self.multiplier = .25
    self.last = CurTime() + math.random(1, 100) / 100
    self.x1 = -.9 / self.multiplier
    self.x2 = .9 / self.multiplier
    self.y1 = 1.9 / self.multiplier
    self.y2 = -1.9 / self.multiplier
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
    local rot = Vector(90, 90, 0)
    ang:RotateAroundAxis(ang:Right(), rot.x)
    ang:RotateAroundAxis(ang:Up(), rot.y)
    --ang:RotateAroundAxis(ang:Forward(), rot.z)
    local pos = self.Entity:GetPos() + (self.Entity:GetForward() * self.z)
    cam.Start3D2D(pos, ang, .25)
    surface.SetDrawColor(color.r, color.g, color.b, 50)
    surface.DrawRect(self.x, self.y, self.w, self.h)
    draw.DrawText("Game Standings", "Trebuchet24", self.x + 2, self.y, Color(255, 255, 255, 255))
    surface.SetDrawColor(color.r, color.g, color.b, 255)
    surface.SetTexture(self.logo)
    surface.DrawTexturedRect(self.x + self.w * .5 - 48, self.y + 24, 96, 96)
    local i = 0

    for iteam = 1, 4 do
        if iteam == self.Entity:GetSkin() then
            draw.DrawText(self.score[iteam], "ScoreL", self.x + self.w * .5, self.y + 16, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        else
            i = i + 1
            local color = team.GetColor(iteam)
            surface.SetDrawColor(color.r, color.g, color.b, 255)
            surface.DrawTexturedRect(self.x + self.w * .5 - 32, self.y + 50 + i * 64, 64, 64)
            draw.DrawText(self.score[iteam], "ScoreM", self.x + self.w * .5, self.y + 54 + i * 64, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    cam.End3D2D()
end

function ENT:Think()
    self.color = team.GetColor(self.Entity:GetSkin())

    if self.Entity:GetSkin() ~= 0 then
        function self:Think()
            if self.last < CurTime() then
                for iteam = 1, 4 do
                    self.score[iteam] = tostring(LocalPlayer():GetNetworkedInt("gf" .. iteam))
                end

                self.last = CurTime() + 1.5
            end
        end
    end
end