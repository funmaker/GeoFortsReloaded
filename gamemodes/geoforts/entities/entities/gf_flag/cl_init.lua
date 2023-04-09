include('shared.lua')
ENT.last = CurTime() + math.random(1, 100) / 100

function ENT:Initialize()
    Sound("items/battery_pickup.wav")
end

function ENT:OnRemove()
end

function ENT:Draw()
    self.Entity:DrawModel()
end

function ENT:Think()
    --Let's ease server load by performing checks for it clientside
    if self.last < CurTime() and LocalPlayer():Alive() then
        local plpos = LocalPlayer():GetPos() + Vector(0, 0, 36)

        if (LocalPlayer():GetNWInt("gfRound") == 4 or LocalPlayer():GetNWInt("gfRound") == 3) and (plpos - self.Entity:GetPos()):Length() <= 35 then
            --The actual minimum distance is 35.8 units, but we need a deadzone to prevent a 1 second delay
            local entpos = self.Entity:GetPos()

            --This makes the trace start from the closest possible position
            if entpos.z + 36 >= plpos.z then
                if entpos.z - 36 <= plpos.z then
                    plpos.z = entpos.z --This lets us hit the entity whether we are standing on it or headbutting it
                else
                    plpos.z = plpos.z + 36
                end
            else
                plpos.z = plpos.z - 36
            end

            if (plpos - self.Entity:GetPos()):Length() <= 16 then
                self.last = CurTime() + 1
                LocalPlayer():ConCommand("gftag " .. self.Entity:EntIndex() .. "\n")
            end
        else
            self.last = CurTime() + .05
        end
    end
end