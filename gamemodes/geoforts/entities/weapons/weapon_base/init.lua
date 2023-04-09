AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
SWEP.Weight = 5 -- Decides whether we should switch from/to this
SWEP.AutoSwitchTo = true -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom = true -- Auto switch from if you pick up a better weapon
local ActIndex = {}
ActIndex["pistol"] = ACT_HL2MP_IDLE_PISTOL
ActIndex["smg"] = ACT_HL2MP_IDLE_SMG1
ActIndex["grenade"] = ACT_HL2MP_IDLE_GRENADE
ActIndex["ar2"] = ACT_HL2MP_IDLE_AR2
ActIndex["shotgun"] = ACT_HL2MP_IDLE_SHOTGUN
ActIndex["rpg"] = ACT_HL2MP_IDLE_RPG
ActIndex["physgun"] = ACT_HL2MP_IDLE_PHYSGUN
ActIndex["crossbow"] = ACT_HL2MP_IDLE_CROSSBOW
ActIndex["melee"] = ACT_HL2MP_IDLE_MELEE
ActIndex["slam"] = ACT_HL2MP_IDLE_SLAM
ActIndex["normal"] = ACT_HL2MP_IDLE

function SWEP:SetWeaponHoldType(t)
    local index = ActIndex[t]

    if index == nil then
        Msg("SWEP:SetWeaponHoldType - ActIndex[ \"" .. t .. "\" ] isn't set!\n")

        return
    end

    self.ActivityTranslate = {}
    self.ActivityTranslate[ACT_HL2MP_IDLE] = index
    self.ActivityTranslate[ACT_HL2MP_RUN] = index + 1
    self.ActivityTranslate[ACT_HL2MP_IDLE_CROUCH] = index + 2
    self.ActivityTranslate[ACT_HL2MP_WALK_CROUCH] = index + 3
    self.ActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK] = index + 4
    self.ActivityTranslate[ACT_HL2MP_GESTURE_RELOAD] = index + 5
    self.ActivityTranslate[ACT_HL2MP_JUMP] = index + 6
    self.ActivityTranslate[ACT_RANGE_ATTACK1] = index + 7
end

-- Default hold pos is the pistol
SWEP:SetWeaponHoldType("pistol")

--[[---------------------------------------------------------
   Name: weapon:TranslateActivity( )
   Desc: Translate a player's Activity into a weapon's activity
		 So for example, ACT_HL2MP_RUN becomes ACT_HL2MP_RUN_PISTOL
		 Depending on how you want the player to be holding the weapon
---------------------------------------------------------]]
function SWEP:TranslateActivity(act)
    if self.ActivityTranslate[act] ~= nil then return self.ActivityTranslate[act] end

    return -1
end

--[[---------------------------------------------------------
   Name: OnRestore
   Desc: The game has just been reloaded. This is usually the right place
		to call the GetNetworked* functions to restore the script's values.
---------------------------------------------------------]]
function SWEP:OnRestore()
end

--[[---------------------------------------------------------
   Name: AcceptInput
   Desc: Accepts input, return true to override/accept input
---------------------------------------------------------]]
function SWEP:AcceptInput(name, activator, caller)
    return false
end

--[[---------------------------------------------------------
   Name: KeyValue
   Desc: Called when a keyvalue is added to us
---------------------------------------------------------]]
function SWEP:KeyValue(key, value)
end

--[[---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------]]
function SWEP:OnRemove()
end