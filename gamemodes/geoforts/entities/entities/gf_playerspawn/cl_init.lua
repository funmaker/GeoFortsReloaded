--BLOCK SPAWNER
--Version 1.0
--Written by Night-Eagle
include('shared.lua')

function ENT:Initialize()
    self.color = team.GetColor(self.Entity:GetSkin())
    self.color.a = 255
    self.cleared = "POLLING"
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
    local color = self.warn or self.color
    self.Entity:DrawModel()
    local ang = self.Entity:GetAngles()
    local rot = Vector(0, 90, 0)
    --ang:RotateAroundAxis(ang:Right(), 	rot.x)
    ang:RotateAroundAxis(ang:Up(), rot.y)
    --ang:RotateAroundAxis(ang:Forward(), rot.z)
    local pos = self.Entity:GetPos() + (self.Entity:GetUp() * self.z)
    --[[
	TODO: Kill code
	local spawntime = self.Entity:GetNWFloat("gfSpT")
	local spawnname = self.Entity:GetNWString("gfSpN")
	if spawntime > CurTime() then
		spawntime = string.format("%.1f",spawntime - CurTime())
		self.cleared = "Spawning soldier\n" .. spawnname .. "\n" .. spawntime
	end
	]]
    local indat = self.Entity:GetNWString("gfSL")

    if indat ~= "" then
        local space = string.find(indat, " ", 1, true)

        if space then
            --Msg(string.format("%.2f",CurTime())," indat: ",indat,"\n")
            local num = tonumber(string.Left(indat, space - 1)) or 0
            local str = string.sub(indat, space + 1)
            plist = {}

            for i = 1, #str do
                local padd = tonumber(string.sub(str, i, i))

                if padd then
                    padd = player.GetByID(padd)

                    if padd:IsPlayer() then
                        padd = string.Left(tostring(padd:GetName()), 22)
                        table.insert(plist, padd)
                    end
                end
            end

            local interval = gmod.GetGamemode().geof.const.respawninterval
            local changed = false
            local i = 0

            for k, plname in pairs(plist) do
                i = i + 1

                if #plist == 5 or i < 5 then
                    local time = num + interval * (k - 1)
                    local changedhere = false

                    if time > CurTime() then
                        if not changed then
                            changed = true
                            self.cleared = ""
                        end

                        self.cleared = self.cleared .. "(" .. string.format("%.1f", time - CurTime()) .. ") " .. plname .. "\n"
                    elseif interval + time > CurTime() then
                        if not changed then
                            self.cleared = ""
                        end

                        self.cleared = self.cleared .. "(OK) " .. plname .. "\n"
                    end
                    --This should only happen when lagging out or the last player in queue has spawned.
                else
                    self.cleared = self.cleared .. tostring(#plist) .. " units queued..."
                    break
                end
            end
        end
    end

    cam.Start3D2D(pos, ang, .25)
    surface.SetDrawColor(color.r, color.g, color.b, 50)
    surface.DrawRect(self.x, self.y, self.w, self.h)
    draw.DrawText("Spawn Point\n" .. self.cleared, "Trebuchet18", self.x + 1, self.y, Color(255, 255, 255, 255))
    cam.End3D2D()
end

function ENT:Think()
    if self.last < CurTime() then
        self.last = CurTime() + 1
        local trace = {}
        trace.start = self.Entity:GetPos() + self.Entity:GetUp() * 8
        trace.endpos = self.Entity:GetUp() * 72 + trace.start
        trace.mask = MASK_PLAYERSOLID
        trace.filter = self.Entity
        local trace = util.TraceLine(trace)
        local trace = util.QuickTrace(self.Entity:GetPos() + self.Entity:GetUp(), self.Entity:GetUp() * 80)
        self.cleared = not trace.Hit

        if not self.cleared then
            if type(trace.Entity) == "Player" then
                self.cleared = "WAITING TO CLEAR"
                self.Entity:EmitSound("buttons/combine_button3.wav")
            else
                self.cleared = "ERROR:\nNON-ORGANIC\nBLOCKAGE"
                self.Entity:EmitSound("buttons/combine_button1.wav")
                PrintTable(trace)
            end

            self.warn = Color(255, 255, 255, 100)
        else
            local spawntime = self.Entity:GetNWFloat("gfSpT")
            local spawnname = self.Entity:GetNWString("gfSpN")

            if spawntime > CurTime() then
                spawntime = string.format("%.1f", spawntime - CurTime())
                self.cleared = "Spawning soldier\n" .. spawnname .. "\n" .. spawntime
            else
                self.cleared = "Ready"
                self.warn = nil
            end
        end
    end
end