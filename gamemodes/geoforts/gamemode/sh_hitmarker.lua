AddCSLuaFile()

if SERVER then
    resource.AddFile("sound/hitmarker.wav")

    util.AddNetworkString("hitmarker")

    function GM:EntityTakeDamage(target, dmginfo)
        if not target:IsPlayer() then return end

        local attacker = dmginfo:GetAttacker()
        if not attacker:IsPlayer() then return end

        local damage = dmginfo:GetDamage()

        -- Play global sound if killed using a lot of damage (e.g. AWP)
        if(damage > 70 and target:Health() - damage <= 0) then
            target:EmitSound("physics/body/body_medium_break3.wav", 511, 80, 1, CHAN_AUTO, nil, 26)
        end

        net.Start("hitmarker")
            net.WriteEntity(target)
            net.WriteInt(damage, 16) 
        net.Send(attacker)
    end
end

if CLIENT then
    local nextHitmarkerHide = 0

    net.Receive("hitmarker", function()
        local ply = net.ReadEntity()
        local damage = net.ReadInt(16)

        nextHitmarkerHide = RealTime() + 0.1

        LocalPlayer():EmitSound("hitmarker.wav", SNDLVL_NONE, 100, 1, CHAN_STATIC)
        if(damage > 80) then
            LocalPlayer():EmitSound("physics/body/body_medium_break3.wav", SNDLVL_NONE, 90 + math.random() * 30, 1, CHAN_STATIC)
        end
    end)

    hook.Add("HUDPaint", "HitmarkerDraw", function()
        if nextHitmarkerHide < RealTime() then return end

        local w, h = ScrW(), ScrH()
        local x, y = w / 2, h / 2

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawLine(x - 10, y - 10, x - 5, y - 5)
        surface.DrawLine(x + 10, y - 10, x + 5, y - 5)
        surface.DrawLine(x - 10, y + 10, x - 5, y + 5)
        surface.DrawLine(x + 10, y + 10, x + 5, y + 5)
    end)
end
