--- File: ZomboLust Lewd Models/42/media/lua/shared/TimedActions/ISWashYourself_override.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

--- Finalizes the washing action by removing dirt and blood, consuming water, and refreshing the character's appearance
function ISWashYourself:complete()
    local BloodBodyPartType = BloodBodyPartType
    local fromIndex = BloodBodyPartType.FromIndex
    local maxParts = BloodBodyPartType.MAX:index()
    local visual = self.character:getHumanVisual()
    local waterUsed = 0
    for i=1,maxParts do
        local part = fromIndex(i-1)
        if self:washPart(visual, part) then
            waterUsed = waterUsed + 1
            -- using soap provides a modest happiness boost
            if self.soaps then
                self.character:getStats():remove(CharacterStat.UNHAPPINESS, 2);
            end
            if waterUsed >= self.sink:getFluidAmount() then
                break
            end
        end
    end

    -- remove makeup
    if SandboxVars.SPNCharCustom.WashMakeup then
        self:removeAllMakeup()
    end

    sendHumanVisual(self.character);

    if instanceof(self.sink, "IsoWorldInventoryObject") then
        self.sink:useFluid(waterUsed)
    else
        if self.sink:useFluid(waterUsed) > 0 then
            self.sink:transmitModData()
        end
    end	

    -- have to add this so that blood on faces is updated
    -- triggerEvent("OnClothingUpdated", self.character)

    -- IMPORTANT: This require must remain INSIDE the function. 
    -- Since this file is in 'shared', moving it to the top would cause a loading error 
    -- on the client side because the 'server' folder is not accessible during the boot phase.
    local FaceManager_Server = require("CharacterCustomisation/FaceManager_Server")
    FaceManager_Server.SyncBlood(self.character)

    return true
end

-- function ISWashYourself:perform()
-- 	self:stopSound()
-- 	self.character:resetModelNextFrame();
-- 	triggerEvent("OnClothingUpdated", self.character)
-- 	-- needed to remove from queue / start next.
-- 	ISBaseTimedAction.perform(self);
-- end
