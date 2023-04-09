local GM = GM or gmod.GetGamemode()
--GM.tex_gradient = surface.GetTextureID("gui/gradient")
GM.tex_logo = surface.GetTextureID("buildingblocks/logo")

function GM:HUDPaint()
    surface.SetDrawColor(0, 0, 0, 100)
    surface.SetFont("Trebuchet24")
    local tc = team.GetColor(LocalPlayer():Team())
    tc.a = 255
    local round = tostring(self.geof.rounds[LocalPlayer():GetNWInt("gfRound")])
    local timeleft = LocalPlayer():GetNWFloat("gfTime") - CurTime()
    timeleft = string.Trim(string.FormattedTime(timeleft, "%2i:%02i"))
    local out = round .. " - " .. timeleft
    local sizex = surface.GetTextSize(out)
    --Flag
    local flag = LocalPlayer():GetNWInt("gfflag")

    if flag ~= 0 then
        surface.SetTexture(self.tex_logo)
        local tc = team.GetColor(flag)
        surface.SetDrawColor(tc.r, tc.g, tc.b, 128)
        surface.DrawTexturedRect(32 + sizex - 16, 32 + 24 - 16, 64, 64)
    end

    --Timer
    draw.RoundedBox(8, 32, 32, sizex + 16, 24 + 16, Color(0, 0, 0, 64))
    surface.SetDrawColor(tc.r, tc.g, tc.b, 100)
    surface.DrawRect(32 + 8, 32 + 24 + 8, sizex, 2)
    draw.DrawText(out, "Trebuchet24", 32 + 8, 32 + 8, Color(255, 255, 255, 255), 0)
    local time = LocalPlayer():GetNWFloat("gfbtime") - CurTime()

    if time > 0 then
        local out = "(" .. string.format("%.2f", time) .. ")"
        local sizex = math.ceil(surface.GetTextSize(out) / 2) * 2 + 16
        draw.RoundedBox(8, ScrW() * .5 - sizex * .5, ScrH() - 32 - 24 - 16, sizex, 24 + 16, Color(0, 0, 0, 64))
        draw.DrawText(out, "Trebuchet24", ScrW() * .5, ScrH() - 32 - 24 - 8, Color(255, 255, 255, 255), 1)
    elseif LocalPlayer():GetNWBool("gfss") then
        local sizex = math.ceil(surface.GetTextSize("Select a Spawn Point") / 2) * 2 + 16
        draw.RoundedBox(8, ScrW() * .5 - sizex * .5, ScrH() - 32 - 24 - 16, sizex, 48 + 16, Color(0, 0, 0, 64))
        draw.DrawText("Select a Spawn Point", "Trebuchet24", ScrW() * .5, ScrH() - 32 - 24 - 8, Color(255, 255, 255, 255), 1)
        local timeleft = LocalPlayer():GetNWFloat("gfsst") - CurTime()

        if timeleft > 0 then
            timeleft = string.format("%0.2f", timeleft)
            draw.DrawText(timeleft, "Trebuchet24", ScrW() * .5, ScrH() - 32 - 8, Color(255, 255, 255, 255), 1)
        elseif CurTime() % 1 > .5 then
            draw.DrawText("Click to Spawn", "Trebuchet24", ScrW() * .5, ScrH() - 32 - 8, Color(255, 255, 255, 255), 1)
        end
    end

    --Qualify
    if LocalPlayer():GetNWInt("gfRound") == 3 then
        local teams = -1

        for iteam = 1, 4 do
            teams = teams + 1
        end

        draw.RoundedBox(8, 32, 80, 40 + teams * 16 + 16, 256 + 16, Color(0, 0, 0, 64))

        if teams > 0 then
            local dat = self.qHUDdata
            local qx = 32 + 8 + 40
            local timeleft = LocalPlayer():GetNWFloat("gfTime") - CurTime()

            for k, v in pairs(dat.team) do
                if k ~= LocalPlayer():Team() then
                    if type(v) == "number" then
                        local col = team.GetColor(k)
                        col.a = 255
                        --draw.DrawText(v,"Trebuchet24",qx+8,80+8,col,1)
                        surface.SetDrawColor(col)
                        local y = 1 - (timeleft / dat.length)

                        if v > 0 then
                            y = 1 - ((v - 0.5) * 2)
                        elseif LocalPlayer():GetNWInt("gfRound") ~= 3 then
                            --Not necessary...
                            y = 1
                        end

                        y = y * 256
                        surface.DrawRect(qx + 4, 80 + 8 + y, 8, 256 - y)
                        qx = qx + 16
                    end
                else
                    local y = 1 - (timeleft / dat.length)

                    if v > 0 then
                        y = 1 - ((v - 0.5) * 2)
                    elseif LocalPlayer():GetNWInt("gfRound") ~= 3 then
                        --Not necessary...
                        y = 1
                    end

                    local p = math.Round((1 - y) * 50) + 50
                    y = y * 256
                    surface.SetDrawColor(tc.r, tc.g, tc.b, 255)
                    surface.DrawRect(32 + 8 + 16, 80 + 8 + y, 20, 256 - y)
                    surface.SetDrawColor(255, 255, 255, 255)
                    --draw.DrawText("F\ni\nr\ne\np\no\nw\ne\nr","Trebuchet24",32+8+8,80+8,Color(255,255,255,255),1)
                    draw.DrawText(tostring(p) .. "%", "Trebuchet24", 32 + 8, 80 + 256 + 8 - 24, Color(255, 255, 255, 255), 0)
                end
            end
        end
    end

    --Death notice
    self:DrawDeathNotice(0.85, 0.04)
    --TargetID
    local trace = util.TraceLine(util.GetPlayerTrace(LocalPlayer(), LocalPlayer():GetAimVector()))
    if not trace.Hit then return end
    if not trace.HitNonWorld then return end
    local text = "ERROR"
    local font = "Trebuchet24"

    if trace.Entity:IsPlayer() then
        text = trace.Entity:Nick()
    else
        return
    end

    surface.SetFont(font)
    local w, h = surface.GetTextSize(text)
    local x, y = ScrW() / 2, ScrH() / 2
    x = x - w / 2
    y = y + 30
    draw.SimpleText(text, font, x + 1, y + 1, Color(0, 0, 0, 120))
    draw.SimpleText(text, font, x + 2, y + 2, Color(0, 0, 0, 50))
    draw.SimpleText(text, font, x, y, team.GetColor(trace.Entity:Team()))
    y = y + h + 5
    local text = trace.Entity:Health() .. "%"
    local font = "TargetIDSmall"
    surface.SetFont(font)
    local w, h = surface.GetTextSize(text)
    local x = ScrW() / 2 - w / 2
    draw.SimpleText(text, font, x + 1, y + 1, Color(0, 0, 0, 120))
    draw.SimpleText(text, font, x + 2, y + 2, Color(0, 0, 0, 50))
    draw.SimpleText(text, font, x, y, team.GetColor(trace.Entity:Team()))
end

GM.qHUDdata = {
    length = 0, --WATCH FOR DIVISION BY 0
    team = {},
}

--How ironic, we have to send the message to the server and retrieve it again using efficient means to waste bandwidth.
function GM.QualifyHook(um)
    local self = gmod.GetGamemode()
    local len = um:ReadFloat()
    local teamd = {}

    for iteam = 1, 4 do
        if LocalPlayer():GetNetworkedBool("gfo" .. iteam) then
            teamd[iteam] = um:ReadFloat()
        end
    end

    self.qHUDdata = {
        length = len,
        team = teamd,
    }
end

usermessage.Hook("gfqhk", GM.QualifyHook)