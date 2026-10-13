--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/CharacterCreation/CC_OnGenderOrSkintoneChanged.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
require("CharacterCustomisation/CharacterCreation/CC_UpdateCharacterPreview")

    -- --------------------------------------------------
    --   RESET LISTS WHEN SKINTONE OR GENDER IS CHANGED
    -- --------------------------------------------------
local originalOnGenderSelected = CharacterCreationMain.onGenderSelected
--- Extends vanilla CharacterCreationMain.onGenderSelected to refresh customisation
function CharacterCreationMain.onGenderSelected(self, combo)
    ---@cast self any
    originalOnGenderSelected(self, combo);

    self:refreshCustomisationWindow()
end

local originalonSkinColorPicked = CharacterCreationMain.onSkinColorPicked
--- Extends vanilla CharacterCreationMain.onSkinColorPicked to refresh customisation
function CharacterCreationMain.onSkinColorPicked(self, color, mouseUp)
    ---@cast self any
    originalonSkinColorPicked(self, color, mouseUp);

    self:refreshCustomisationWindow()
end
