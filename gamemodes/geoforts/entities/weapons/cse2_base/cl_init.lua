include('shared.lua')

if not CSE_SNIPERCORNER then
    CSE_SNIPERCORNER = surface.GetTextureID("gui/sniper_corner")
end

hook.Add("HUDPaintBackground", "CSE2", function()
    local self = LocalPlayer():GetActiveWeapon()

    if self and self:IsWeapon() and self:GetNWInt("csi") > 1 then
        surface.SetDrawColor(0, 0, 0, 255)
        local w = ScrW()
        local h = ScrH()

        if w > h then
            local xc = math.floor(w / 2)
            local yc = math.floor(h / 2)
            local yq = math.floor(h / 4)
            local bw = xc - yc
            surface.DrawRect(0, 0, bw, h)
            surface.DrawRect(w - bw, 0, bw, h)
            surface.SetTexture(CSE_SNIPERCORNER)
            surface.DrawTexturedRectRotated(bw + yq, yq, yc, yc, 0)
            surface.DrawTexturedRectRotated(bw + yq, h - yq, yc, yc, 90)
            surface.DrawTexturedRectRotated(w - bw - yq, h - yq, yc, yc, 180)
            surface.DrawTexturedRectRotated(w - bw - yq, yq, yc, yc, 270)
        end
    end
end)

function SWEP:PrintWeaponInfo(x, y, alpha)
    if self.DrawWeaponInfoBox == false then return end

    if not self.InfoMarkup then
        local str
        local title_color = "<color=230,230,230,255>"
        local text_color = "<color=150,150,150,255>"
        str = "<font=HudSelectionText>"

        if self.Author ~= "" then
            str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n"
        end

        if self.Contact ~= "" then
            str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n"
        end

        if self.Purpose ~= "" then
            str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n"
        end

        if self.Instructions ~= "" then
            str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n"
        end

        str = str .. "</font>"
        self.InfoMarkup = markup.Parse(str, 250)
    end

    surface.SetDrawColor(60, 60, 60, alpha)
    surface.SetTexture(self.SpeechBubbleLid)
    surface.DrawTexturedRect(x, y - 64 - 5, 128, 64)
    draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(60, 60, 60, alpha))
    self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
    draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2, y + tall * 0.2, Color(255, 210, 0, 255), TEXT_ALIGN_CENTER)

    local fmlist = {"semi", "burst", "auto", "pump"}

    local fmlistn = {"Semi-Automatic", "Burst", "Fully-Automatic", "Pump"}

    local fmlisti = {
        semi = 1,
        burst = 2,
        auto = 3,
        pump = 4
    }

    local label = fmlistn[fmlisti[self.firemode]]
    draw.SimpleText(label, "Trebuchet24", x + 8, y + tall - 8 - 16 - 24, Color(255, 210, 0, 255), TEXT_ALIGN_LEFT)
    draw.SimpleText(self.Cartridge or "", "Trebuchet24", x + 8, y + tall - 8 - 16 - 24 - 24, Color(255, 210, 0, 255), TEXT_ALIGN_LEFT)

    if self.Primary and self.Primary.ClipSize then
        draw.SimpleText(self:Clip1() .. "/" .. self.Primary.ClipSize, "Trebuchet24", x + wide - 8, y + tall - 8 - 16 - 24, Color(255, 210, 0, 255), TEXT_ALIGN_RIGHT)

        if self.Primary.Ammo then
            draw.SimpleText(LocalPlayer():GetAmmoCount(self.Primary.Ammo) or "", "Trebuchet24", x + wide - 8, y + tall - 8 - 16 - 24 - 24, Color(255, 210, 0, 255), TEXT_ALIGN_RIGHT)
        end
    end

    self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
end

function SWEP:TranslateFOV(current_fov)
    return current_fov
end