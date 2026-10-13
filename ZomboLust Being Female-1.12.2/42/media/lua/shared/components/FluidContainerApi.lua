local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Wrapper for inventory items that may expose a fluid container.
-- 
-- This helper centralizes the optional fluid-container API and
-- prevents duplicate `getFluidContainer` guard logic across code.
____exports.FluidContainerApi = __TS__Class()
local FluidContainerApi = ____exports.FluidContainerApi
FluidContainerApi.Type = "FluidContainerApi"
__PW__BaseClassExtends(FluidContainerApi)
function FluidContainerApi.prototype.____constructor(self, item)
    self.item = item
end
function FluidContainerApi.prototype.hasContainer(self)
    return self.container ~= nil
end
function FluidContainerApi.prototype.isFull(self)
    local ____opt_0 = self.container
    local ____temp_2 = ____opt_0 and ____opt_0:isFull()
    if ____temp_2 == nil then
        ____temp_2 = false
    end
    return ____temp_2
end
function FluidContainerApi.prototype.isEmpty(self)
    local ____opt_3 = self.container
    local ____temp_5 = ____opt_3 and ____opt_3:isEmpty()
    if ____temp_5 == nil then
        ____temp_5 = false
    end
    return ____temp_5
end
function FluidContainerApi.prototype.fill(self, fluid, amount)
    local container = self.container
    if not container then
        return 0
    end
    local addedFluid = math.min(
        container:getFreeCapacity(),
        amount or container:getCapacity()
    )
    if addedFluid <= 0 then
        return 0
    end
    container:addFluid(fluid, addedFluid)
    return addedFluid
end
function FluidContainerApi.prototype.clear(self, amount)
    if type(amount) == "number" then
        local ____opt_6 = self.container
        if ____opt_6 ~= nil then
            ____opt_6:removeFluid(amount)
        end
    end
    local ____opt_8 = self.container
    if ____opt_8 ~= nil then
        ____opt_8:removeFluid()
    end
end
__TS__SetDescriptor(
    FluidContainerApi.prototype,
    "container",
    {get = function(self)
        local ____this_11
        ____this_11 = self.item
        local ____opt_10 = ____this_11.getFluidContainer
        return ____opt_10 and ____opt_10(____this_11) or nil
    end},
    true
)
__TS__SetDescriptor(
    FluidContainerApi.prototype,
    "amount",
    {get = function(self)
        local ____opt_12 = self.container
        return ____opt_12 and ____opt_12:getAmount() or 0
    end},
    true
)
__TS__SetDescriptor(
    FluidContainerApi.prototype,
    "primaryFluid",
    {get = function(self)
        local ____opt_14 = self.container
        if ____opt_14 ~= nil then
            local ____opt_15 = self.container
            local ____opt_17 = self.container
            ____opt_14 = tostring(____opt_17 and ____opt_17:getPrimaryFluid())
        end
        return ____opt_14 or nil
    end},
    true
)
return ____exports
