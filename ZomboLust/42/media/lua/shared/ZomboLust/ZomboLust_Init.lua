--- File: ZomboLust/42/media/lua/shared/ZomboLust/ZomboLust_Init.lua
--- Initialization of ZomboLust animation configurations and alternatives
--- @author BlaBla 2025

print("[ZomboLust LOADING] ZomboLust_Init.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire/ZomboDesire_Init" -- Ensure framework is ready
require "ZomboLust_Main"               -- Initialize ZomboLust namespace

-- =================================
-- ZomboLust Animation Alternatives
-- =================================
-- Every animation prefix follows the same naming scheme:
--   <Actor>_ZomboLust_<ZType>_<Direction>_<Pose>_<Suffix>_Alt
-- where Actor is Kate or Bob, ZType is ZM0 (Male Zombie) or ZF0 (Female Zombie),
-- Direction is Front or Back, and Pose is the character's posture:
-- either a freestanding base pose (varies per phase below, no prop involved)
-- or one of the 5 standard prop-interaction poses:
--   Le = Leaning over     (e.g. leaning over a railing)
--   Ly = Lying on         (e.g. lying on a bed)
--   Os = On stair         (on a staircase)
--   Sa = Standing against (e.g. standing against a wall)
--   So = Sitting on       (e.g. sitting on a chair)
-- Based on existing AnimSets in ZomboLust/media/AnimSets/player/actions/ and in ZomboLust/media/AnimSets/zombie/bumped/

--- Registers "altCount" alternatives for both playable actors (Kate, Bob),
--- for the freestanding base pose and each of the 5 standard prop-interaction poses
--- (Le/Ly/Os/Sa/So - see the legend above), for one ZType/Direction/suffix combination.
--- Example: registerLustAlts("ZM0", "Front", "GrabbingStanding", "Begin", 3) registers all 12
--- Kate_/Bob_ZomboLust_ZM0_Front_{GrabbingStanding,Le,Ly,Os,Sa,So}_Begin_Alt prefixes.
--- @param zType string -- "ZM0" or "ZF0"
--- @param direction string -- "Front" or "Back"
--- @param basePose string -- freestanding base pose name (no prop), e.g. "GrabbingStanding", "StandingGroggy"
--- @param suffix string -- animation suffix, e.g. "Begin", "End_S", "End", "End_Vag"
--- @param altCount number
local function registerLustAlts(zType, direction, basePose, suffix, altCount)
    local poses = { basePose, "Le", "Ly", "Os", "Sa", "So" }
    for _, pose in ipairs(poses) do
        for _, actor in ipairs({ "Kate", "Bob" }) do
            ZomboDesire.registerAnimationAlts(
                actor .. "_ZomboLust_" .. zType .. "_" .. direction .. "_" .. pose .. "_" .. suffix .. "_Alt",
                altCount)
        end
    end
end

-- Number of alternatives for Lust Begin (3 for now)
local lustBeginAltCount = 3

-- ZM0
registerLustAlts("ZM0", "Front", "GrabbingStanding", "Begin", lustBeginAltCount)
registerLustAlts("ZM0", "Back", "GrabbingStanding", "Begin", lustBeginAltCount)

-- ZF0
registerLustAlts("ZF0", "Front", "GrabbingStanding", "Begin", lustBeginAltCount)
registerLustAlts("ZF0", "Back", "GrabbingStanding", "Begin", lustBeginAltCount)


-- Number of alternatives for Lust End Shy (1 for now)
local lustEndShyAltCount = 1

-- ZM0
registerLustAlts("ZM0", "Front", "StandingGroggy", "End_S", lustEndShyAltCount)
registerLustAlts("ZM0", "Back", "StandingGroggy", "End_S", lustEndShyAltCount)

-- ZF0
registerLustAlts("ZF0", "Front", "StandingGroggy", "End_S", lustEndShyAltCount)
registerLustAlts("ZF0", "Back", "StandingGroggy", "End_S", lustEndShyAltCount)


-- Number of alternatives for Lust End
-- ZM0
local lustEndZM0FrontAltCount = 3
-- ZM0 Front - Alt 1 = Ejaculation in the mouth - Layer sperm mouth
-- ZM0 Front - Alt 2 = Ejaculation on the face - Layer sperm face
-- ZM0 Front - Alt 3 = Ejaculation on the chest - Layer sperm chest + front leg
-- Next batch : Alt 4 = Ejaculation in the mouth + Alt 5 = Ejaculation on the face + Alt 6 = Ejaculation on the chest
registerLustAlts("ZM0", "Front", "StandingGroggy", "End", lustEndZM0FrontAltCount)

local lustEndZM0BackAltCount = 2
-- ZM0 Back - Alt 1 = Ejaculation in the ass - Layer sperm buttock + back leg
-- ZM0 Back - Alt 2 = Ejaculation on the back - Layer sperm back + back leg
-- Next batch : Alt 3 = Ejaculation in the ass + Alt 4 = Ejaculation on the back
registerLustAlts("ZM0", "Back", "StandingGroggy", "End", lustEndZM0BackAltCount)

local lustEndZM0VaginaFrontAltCount = 1
-- Vagina Front - Alt 1 = Ejaculation in the vagina - Layer sperm front leg
-- Next batch : Alt 2 = Ejaculation in the vagina
registerLustAlts("ZM0", "Front", "StandingGroggy", "End_Vag", lustEndZM0VaginaFrontAltCount)

local lustEndZM0VaginaBackAltCount = 1
-- Vagina Back - Alt 1 = Ejaculation in the vagina - Layer sperm back leg
-- Next batch : Alt 2 = Ejaculation in the vagina
registerLustAlts("ZM0", "Back", "StandingGroggy", "End_Vag", lustEndZM0VaginaBackAltCount)


-- ZF0
local lustEndZF0FrontAltCount = 3
-- ZF0 Front - Alt 1 = Squirt in the mouth - Layer sperm mouth
-- ZF0 Front - Alt 2 = Squirt on the face - Layer sperm face
-- ZF0 Front - Alt 3 = Squirt on the chest - Layer sperm chest + front leg
-- Next batch : Alt 4 = Squirt in the mouth + Alt 5 = Squirt on the face + Alt 6 = Squirt on the chest
registerLustAlts("ZF0", "Front", "StandingGroggy", "End", lustEndZF0FrontAltCount)

local lustEndZF0BackAltCount = 1
-- ZF0 Back - Alt 1 = Squirt on the back – Layer sperm back + leg behind
-- Next batch : Alt 2 = Squirt on the back
registerLustAlts("ZF0", "Back", "StandingGroggy", "End", lustEndZF0BackAltCount)
