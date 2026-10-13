local ____lualib = require('lualib_bundle')
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Initial lactation balance values shared by simulation and authoritative recipes.
____exports.LACTATION_BALANCE = {
    BASE_RATE_MIN = 0.00035,
    BASE_RATE_MAX = 0.0007,
    STIMULATION_PER_LITER_REMOVED = 1.25,
    LACTAID_STIMULATION = 0.25,
    MAX_STIMULATION = 0.5,
    STIMULATION_DECAY_PER_HOUR = 0.025,
    DAIRY_COW_FACTOR = 1.25,
    COST_PER_LITER = {
        calories = 640,
        carbohydrates = 32,
        lipids = 32,
        proteins = 16,
        thirst = 0.2
    }
}
--- Clamps persisted or calculated recent-demand stimulation to its supported range.
____exports.clampStimulation = function(value) return math.min(
    ____exports.LACTATION_BALANCE.MAX_STIMULATION,
    math.max(0, value)
) end
--- Returns the production factor for the player's current thirst value.
____exports.hydrationFactor = function(thirst) return math.max(
    0.25,
    1 - 0.75 * math.max(0, thirst)
) end
--- Returns the production factor for the player's current hunger value.
____exports.hungerFactor = function(hunger) return math.max(
    0.5,
    1 - 0.5 * math.max(0, hunger)
) end
--- Adds recent-demand stimulation for milk actually removed from the character.
____exports.addRemovalStimulation = function(current, removedLiters) return ____exports.clampStimulation(____exports.clampStimulation(current) + math.max(0, removedLiters) * ____exports.LACTATION_BALANCE.STIMULATION_PER_LITER_REMOVED) end
--- Adds the deterministic stimulation supplied by Lactaid.
____exports.addLactaidStimulation = function(current) return ____exports.clampStimulation(____exports.clampStimulation(current) + ____exports.LACTATION_BALANCE.LACTAID_STIMULATION) end
--- Decays recent-demand stimulation for elapsed game time.
____exports.decayStimulation = function(current, elapsedMinutes) return ____exports.clampStimulation(____exports.clampStimulation(current) - math.max(0, elapsedMinutes) / 60 * ____exports.LACTATION_BALANCE.STIMULATION_DECAY_PER_HOUR) end
--- Calculates the active duration, applying Dairy Cow exactly once.
____exports.lactationDuration = function(baseHours, hasDairyCow) return math.max(0, baseHours) * (hasDairyCow and ____exports.LACTATION_BALANCE.DAIRY_COW_FACTOR or 1) end
--- Calculates requested milk production before breast-capacity clamping.
____exports.requestedProduction = function(____bindingPattern0)
    local hunger
    local thirst
    local hasDairyCow
    local stimulation
    local elapsedMinutes
    local baseRatePerMinute
    baseRatePerMinute = ____bindingPattern0.baseRatePerMinute
    elapsedMinutes = ____bindingPattern0.elapsedMinutes
    stimulation = ____bindingPattern0.stimulation
    hasDairyCow = ____bindingPattern0.hasDairyCow
    thirst = ____bindingPattern0.thirst
    hunger = ____bindingPattern0.hunger
    return math.max(0, baseRatePerMinute) * math.max(0, elapsedMinutes) * (1 + ____exports.clampStimulation(stimulation)) * (hasDairyCow and ____exports.LACTATION_BALANCE.DAIRY_COW_FACTOR or 1) * ____exports.hydrationFactor(thirst) * ____exports.hungerFactor(hunger)
end
--- Calculates proportional metabolic costs for milk actually produced.
____exports.metabolicCostFor = function(producedLiters)
    local liters = math.max(0, producedLiters)
    return {
        calories = liters * ____exports.LACTATION_BALANCE.COST_PER_LITER.calories,
        carbohydrates = liters * ____exports.LACTATION_BALANCE.COST_PER_LITER.carbohydrates,
        lipids = liters * ____exports.LACTATION_BALANCE.COST_PER_LITER.lipids,
        proteins = liters * ____exports.LACTATION_BALANCE.COST_PER_LITER.proteins,
        thirst = liters * ____exports.LACTATION_BALANCE.COST_PER_LITER.thirst
    }
end
--- Removes milk, adds demand from the actual removal, and optionally refreshes duration.
____exports.applyMilkRemoval = function(state, requestedLiters, refreshedDuration)
    local removed = math.min(
        math.max(0, requestedLiters),
        state.milkAmount
    )
    return __TS__ObjectAssign(
        {},
        state,
        {
            milkAmount = state.milkAmount - removed,
            expiration = removed > 0 and refreshedDuration ~= nil and refreshedDuration or state.expiration,
            multiplier = ____exports.addRemovalStimulation(state.multiplier, removed)
        }
    )
end
return ____exports
