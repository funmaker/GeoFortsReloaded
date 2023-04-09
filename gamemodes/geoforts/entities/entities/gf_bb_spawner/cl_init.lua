--BLOCK SPAWNER
--Version 1.0
--Written by Night-Eagle
include('shared.lua')

function ENT:Initialize()
    Sound("buttons/combine_button7.wav")

    self.blocks = {
        {1, 1, 16, 32},
        {18, 1, 16, 16},
        {35, 1, 48, 16},
        {84, 1, 27, 38},
        {56, 18, 27, 19},
    }

    self.specials = {"Scoreboard", "Timer", "Supply",}

    self.lastspawn = 0
    self.color = team.GetColor(self.Entity:GetSkin())
    self.color.a = 255
    self.multiplier = .25
    self.x1 = -.7 / self.multiplier
    self.x2 = .7 / self.multiplier
    self.y1 = 1.1 / self.multiplier
    self.y2 = .2 / self.multiplier
    self.z = 44.5
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
    local color = self.color
    local round = LocalPlayer():GetNWInt("gfRound")
    local timeleft = 0

    if round ~= 2 then
        if round == 4 then
            round = "Fight"
        elseif round == 3 then
            round = "Qualify"
        elseif round == 1 then
            round = "Preround"
        else
            round = "Block Spawner"
        end

        timeleft = string.ToMinutesSecondsMilliseconds(math.max(LocalPlayer():GetNWFloat("gfTime") - CurTime(), 0))
    end

    self.Entity:DrawModel()
    local ang = self.Entity:GetAngles()
    local rot = Vector(-90, 90, 0)
    ang:RotateAroundAxis(ang:Right(), rot.x)
    ang:RotateAroundAxis(ang:Up(), rot.y)
    ang:RotateAroundAxis(ang:Forward(), rot.z)
    local pos = self.Entity:GetPos() + (self.Entity:GetForward() * self.z)
    local onscreen, cx, cy

    --Camera
    do
        local trace = {}
        trace.start = LocalPlayer():GetShootPos()
        trace.endpos = LocalPlayer():GetAimVector() * 128 + trace.start
        trace.filter = LocalPlayer()
        local trace = util.TraceLine(trace)
        if trace.Entity == self.Entity then end --control = true
        local pos = self.Entity:WorldToLocal(trace.HitPos)
        cx = math.Round(pos.y * 4 - self.x - 1)
        cy = math.Round(pos.z * -4 - self.y - 1.4)

        if trace.Entity == self.Entity and cx > -1 and cy > -1 and cx < 112 and cy <= 71 and pos.x > self.z - .7 and pos.x < self.z then
            onscreen = true
        else
            if self.special ~= 2 then
                self.special = false
            end
        end
    end

    cam.Start3D2D(pos, ang, .25)

    if round == 2 then
        local timDisp = math.max(math.Round((self.spawndelay - (CurTime() - self.lastspawn)) * 10), 0)

        if not self.cleared then
            timDisp = "Blocked"
        elseif timDisp == 0 then
            timDisp = "Ready"
        end

        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(self.x, self.y, self.w, self.h)
        draw.DrawText("Block Spawner", "Trebuchet18", self.x + 4, self.y + self.h - 18, Color(255, 255, 255, 255))
        draw.DrawText(timDisp, "Trebuchet18", self.x + 4, self.y + self.h - 36, Color(255, 255, 255, 255))
        surface.SetDrawColor(color.r, color.g, color.b, 255)

        if not self.special then
            for k, v in pairs(self.blocks) do
                if onscreen and cx >= v[1] and cx < v[1] + v[3] and cy >= v[2] and cy < v[2] + v[4] then
                    surface.SetDrawColor(150, 150, 150, 255)
                    surface.DrawRect(self.x + v[1], self.y + v[2], v[3], v[4])
                    surface.SetDrawColor(color.r, color.g, color.b, 255)

                    if LocalPlayer():KeyDown(IN_USE) and self.spawndelay - (CurTime() - self.lastspawn) < 0 then
                        RunConsoleCommand("bbspawn", k)
                        self.lastspawn = CurTime()
                    end
                else
                    surface.DrawRect(self.x + v[1], self.y + v[2], v[3], v[4])
                end
            end

            local v = {self.w - 10, self.h - 12, 9, 11,}

            if onscreen and cx >= v[1] and cx < v[1] + v[3] and cy >= v[2] and cy < v[2] + v[4] then
                surface.SetDrawColor(150, 150, 150, 255)
                surface.DrawRect(self.x + v[1], self.y + v[2], v[3], v[4])
                surface.SetDrawColor(color.r, color.g, color.b, 255)

                if LocalPlayer():KeyDown(IN_USE) then
                    self.special = 1
                end
            else
                surface.DrawRect(self.x + v[1], self.y + v[2], v[3], v[4])
            end

            draw.DrawText("S", "Trebuchet18", self.x + v[1] + 1, self.y + v[2] - 3, Color(255, 255, 255, 255))
        else
            for k, v in pairs(self.specials) do
                local c = {1, -11 + k * 13, self.w - 2, 11}

                if onscreen and cx >= c[1] and cx < c[1] + c[3] and cy >= c[2] and cy < c[2] + c[4] then
                    surface.SetDrawColor(150, 150, 150, 255)
                    surface.DrawRect(self.x + c[1], self.y + c[2], c[3], c[4])
                    surface.SetDrawColor(color.r, color.g, color.b, 255)

                    if LocalPlayer():KeyDown(IN_USE) and self.spawndelay - (CurTime() - self.lastspawn) < 0 then
                        RunConsoleCommand("bbspawn", k + 5)
                        self.lastspawn = CurTime()
                    end
                else
                    surface.DrawRect(self.x + c[1], self.y + c[2], c[3], c[4])
                end

                draw.DrawText(v, "Trebuchet18", self.x + c[1] + 1, self.y + c[2] - 3, Color(255, 255, 255, 255))
            end
        end

        if onscreen then
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawRect(self.x + cx, self.y + cy, 1, 1) --Mouse
        end
    else
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(self.x, self.y, self.w, self.h)
        draw.DrawText(round .. "\n" .. timeleft, "Trebuchet24", self.x + self.w * .5, self.y + 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    cam.End3D2D()
    local ang = self.Entity:GetAngles()
    local rot = Vector(90, -90, 0)
    ang:RotateAroundAxis(ang:Right(), rot.x)
    ang:RotateAroundAxis(ang:Up(), rot.y)
    ang:RotateAroundAxis(ang:Forward(), rot.z)
    local pos = self.Entity:GetPos() + (self.Entity:GetForward() * -self.z)
    local onscreen, cx, cy = nil, nil, nil

    --Camera
    do
        local trace = {}
        trace.start = LocalPlayer():GetShootPos()
        trace.endpos = LocalPlayer():GetAimVector() * 128 + trace.start
        trace.filter = LocalPlayer()
        local trace = util.TraceLine(trace)
        if trace.Entity == self.Entity then end --control = true
        local pos = self.Entity:WorldToLocal(trace.HitPos)
        cx = math.Round(pos.y * -4 - self.x - .3)
        cy = math.Round(pos.z * -4 - self.y - 1)

        if trace.Entity == self.Entity and cx > -1 and cy > -1 and cx < 112 and cy <= 71 and -pos.x > self.z - .7 and -pos.x < self.z then
            onscreen = true
        else
            if self.special ~= 1 then
                self.special = false
            end
        end
    end

    cam.Start3D2D(pos, ang, .25)

    if round == 2 then
        local timDisp = math.max(math.Round((self.spawndelay - (CurTime() - self.lastspawn)) * 10), 0)

        if not self.cleared then
            timDisp = "Blocked"
        elseif timDisp == 0 then
            timDisp = "Ready"
        end

        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(self.x, self.y, self.w, self.h)
        draw.DrawText("Block Spawner", "Trebuchet18", self.x + 4, self.y + self.h - 18, Color(255, 255, 255, 255))
        draw.DrawText(timDisp, "Trebuchet18", self.x + 4, self.y + self.h - 36, Color(255, 255, 255, 255))
        surface.SetDrawColor(color.r, color.g, color.b, 255)

        if not self.special then
            for k, v in pairs(self.blocks) do
                if onscreen and cx >= v[1] and cx < v[1] + v[3] and cy >= v[2] and cy < v[2] + v[4] then
                    surface.SetDrawColor(150, 150, 150, 255)
                    surface.DrawRect(self.x + v[1], self.y + v[2], v[3], v[4])
                    surface.SetDrawColor(color.r, color.g, color.b, 255)

                    if LocalPlayer():KeyDown(IN_USE) and self.spawndelay - (CurTime() - self.lastspawn) < 0 then
                        RunConsoleCommand("bbspawn", k)
                        self.lastspawn = CurTime()
                    end
                else
                    surface.DrawRect(self.x + v[1], self.y + v[2], v[3], v[4])
                end
            end

            local v = {self.w - 8, self.h - 12, 7, 11,}

            if onscreen and cx >= v[1] and cx < v[1] + v[3] and cy >= v[2] and cy < v[2] + v[4] then
                surface.SetDrawColor(150, 150, 150, 255)
                surface.DrawRect(self.x + v[1], self.y + v[2], v[3], v[4])
                surface.SetDrawColor(color.r, color.g, color.b, 255)

                if LocalPlayer():KeyDown(IN_USE) then
                    self.special = 2
                end
            else
                surface.DrawRect(self.x + v[1], self.y + v[2], v[3], v[4])
            end

            draw.DrawText("S", "Trebuchet18", self.x + v[1] + 1, self.y + v[2] - 3, Color(255, 255, 255, 255))
        else
            for k, v in pairs(self.specials) do
                local c = {1, -11 + k * 13, self.w - 2, 11}

                if onscreen and cx >= c[1] and cx < c[1] + c[3] and cy >= c[2] and cy < c[2] + c[4] then
                    surface.SetDrawColor(150, 150, 150, 255)
                    surface.DrawRect(self.x + c[1], self.y + c[2], c[3], c[4])
                    surface.SetDrawColor(color.r, color.g, color.b, 255)

                    if LocalPlayer():KeyDown(IN_USE) and self.spawndelay - (CurTime() - self.lastspawn) < 0 then
                        RunConsoleCommand("bbspawn", k + 5)
                        self.lastspawn = CurTime()
                    end
                else
                    surface.DrawRect(self.x + c[1], self.y + c[2], c[3], c[4])
                end

                draw.DrawText(v, "Trebuchet18", self.x + c[1] + 1, self.y + c[2] - 3, Color(255, 255, 255, 255))
            end
        end

        if onscreen then
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawRect(self.x + cx, self.y + cy, 1, 1) --Mouse
        end
    else
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(self.x, self.y, self.w, self.h)
        draw.DrawText(round .. "\n" .. timeleft, "Trebuchet24", self.x + self.w * .5, self.y + 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    cam.End3D2D()
end

function ENT:Think()
    local trace = {}
    trace.start = self.Entity:GetPos() + self.Entity:GetUp() * 32
    trace.endpos = self.Entity:GetUp() * 68 + trace.start
    trace.filter = self.Entity
    local trace = util.TraceLine(trace)
    self.cleared = not trace.Hit
end