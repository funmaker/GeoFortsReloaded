EFFECT.Mat = Material("effects/tool_tracer")

--[[---------------------------------------------------------
   Init( data table )
---------------------------------------------------------]]
function EFFECT:Init(data)
    self.Position = data:GetStart()
    self.WeaponEnt = data:GetEntity()
    self.Attachment = data:GetAttachment()
    -- Keep the start and end pos - we're going to interpolate between them
    self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
    self.EndPos = data:GetOrigin()
    -- This determines a bounding box - if the box is on screen we get drawn
    -- You pass the 2 corners of the bounding box
    -- It doesn't matter what order you pass them in - I sort them for you in the engine
    -- We want to draw from start to origin
    -- These Vectors are in entity space
    self.Entity:SetCollisionBounds(self.StartPos - self.EndPos, Vector(0, 0, 0))
    self.Alpha = 255
end

--[[---------------------------------------------------------
   THINK
---------------------------------------------------------]]
function EFFECT:Think()
    self.Alpha = self.Alpha - 2000 * FrameTime()
    if self.Alpha < 0 then return false end

    return true
end

--[[---------------------------------------------------------
   Draw the effect
---------------------------------------------------------]]
function EFFECT:Render()
    local texcoord = math.Rand(0, 1)
    self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
    self.Length = (self.StartPos - self.EndPos):Length()
    render.SetMaterial(self.Mat)

    for i = 0, 3 do
        render.DrawBeam(self.StartPos, self.EndPos, 8, texcoord, texcoord + self.Length / 128, Color(255, 255, 255, self.Alpha)) -- Start -- End -- Width -- Start tex coord -- End tex coord -- Color (optional)
    end
end