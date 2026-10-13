local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__Number = ____lualib.__TS__Number
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getActivatedMods = ____pipewrench.getActivatedMods
local getModFileReader = ____pipewrench.getModFileReader
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____Utils = require('BF/Utils')
local createArray = ____Utils.createArray
--- External identifiers for the animation families BF can trigger.
____exports.ANIMATIONS = ANIMATIONS or ({})
____exports.ANIMATIONS.INTERCOURSE = "intercourse"
____exports.ANIMATIONS.BIRTH = "birth"
____exports.ANIMATIONS.FERTILIZATION = "fertilization"
local MANIFEST_DIRECTORY = "media/BF/animations"
local DEFAULT_IMAGE_PATH = "media/ui/animation"
local MAX_FRAME_COUNT = 10000
local MAX_LOOP_COUNT = 1000
local MANIFEST_KEYS = {
    "version",
    "name",
    "category",
    "frameCount",
    "steps",
    "loop",
    "fullness",
    "pregnancy",
    "condom",
    "path"
}
--- Owns built-in and virtual-filesystem-resolved external animation definitions.
____exports.AnimationRegistry = __TS__Class()
local AnimationRegistry = ____exports.AnimationRegistry
AnimationRegistry.Type = "AnimationRegistry"
__PW__BaseClassExtends(AnimationRegistry)
function AnimationRegistry.prototype.____constructor(self)
    self.animations = {[____exports.ANIMATIONS.INTERCOURSE] = {}, [____exports.ANIMATIONS.BIRTH] = {}, [____exports.ANIMATIONS.FERTILIZATION] = {}}
    self.installed = false
end
function AnimationRegistry.prototype.install(self)
    if self.installed then
        return
    end
    self.installed = true
    Events.onGameStart:addListener(function() return self:reload() end)
end
function AnimationRegistry.prototype.reload(self)
    local definitions = {}
    local candidatePaths = self:discoverManifestPaths()
    for ____, candidate in ipairs(candidatePaths) do
        local parsed = self:readManifest(candidate)
        if parsed then
            definitions[string.lower(candidate.path)] = parsed
        end
    end
    self:clear()
    local manifestPaths = __TS__ArraySort(
        __TS__ObjectKeys(definitions),
        function(____, left, right)
            local leftKey = self:manifestSortKey(left)
            local rightKey = self:manifestSortKey(right)
            if leftKey < rightKey then
                return -1
            end
            if leftKey > rightKey then
                return 1
            end
            return 0
        end
    )
    for ____, manifestPath in ipairs(manifestPaths) do
        local definition = definitions[manifestPath]
        local ____self_animations_definition_category_0 = self.animations[definition.category]
        ____self_animations_definition_category_0[#____self_animations_definition_category_0 + 1] = definition.setting
    end
    print(("[BF][AnimationRegistry] loaded " .. tostring(#__TS__ObjectKeys(definitions))) .. " manifests")
end
function AnimationRegistry.prototype.get(self, category)
    return self.animations[category]
end
function AnimationRegistry.prototype.clear(self)
    __TS__ArraySplice(self.animations[____exports.ANIMATIONS.INTERCOURSE], 0)
    __TS__ArraySplice(self.animations[____exports.ANIMATIONS.BIRTH], 0)
    __TS__ArraySplice(self.animations[____exports.ANIMATIONS.FERTILIZATION], 0)
end
function AnimationRegistry.prototype.manifestPath(self, filename)
    return (MANIFEST_DIRECTORY .. "/") .. filename
end
function AnimationRegistry.prototype.manifestSortKey(self, manifestPath)
    return __TS__StringEndsWith(manifestPath, ".txt") and __TS__StringSubstring(manifestPath, 0, #manifestPath - 4) .. "!.txt" or manifestPath
end
function AnimationRegistry.prototype.discoverManifestPaths(self)
    local paths = {}
    do
        local function ____catch(____error)
            print("[BF][AnimationRegistry] manifest discovery failed: " .. tostring(____error))
        end
        local ____try, ____hasReturned = pcall(function()
            local mods = getActivatedMods()
            do
                local modIndex = 0
                while modIndex < mods:size() do
                    do
                        local __continue22
                        repeat
                            local filenames = listFilesInModDirectory(
                                mods:get(modIndex),
                                MANIFEST_DIRECTORY
                            )
                            if not filenames then
                                __continue22 = true
                                break
                            end
                            do
                                local fileIndex = 0
                                while fileIndex < filenames:size() do
                                    do
                                        local __continue25
                                        repeat
                                            local filename = tostring(filenames:get(fileIndex))
                                            if not __TS__StringEndsWith(
                                                string.lower(filename),
                                                ".txt"
                                            ) then
                                                __continue25 = true
                                                break
                                            end
                                            local path = self:manifestPath(filename)
                                            paths[string.lower(path)] = {
                                                path = path,
                                                ownerModId = mods:get(modIndex)
                                            }
                                            __continue25 = true
                                        until true
                                        if not __continue25 then
                                            break
                                        end
                                    end
                                    fileIndex = fileIndex + 1
                                end
                            end
                            __continue22 = true
                        until true
                        if not __continue22 then
                            break
                        end
                    end
                    modIndex = modIndex + 1
                end
            end
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
    end
    return __TS__ArrayMap(
        __TS__ArraySort(__TS__ObjectKeys(paths)),
        function(____, path) return paths[path] end
    )
end
function AnimationRegistry.prototype.readManifest(self, candidate)
    local reader
    do
        local function ____catch(____error)
            print((((("[BF][AnimationRegistry] rejected " .. candidate.path) .. " from ") .. candidate.ownerModId) .. ": ") .. tostring(____error))
            return true, nil
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            reader = getModFileReader(candidate.ownerModId, candidate.path, false)
            local values = {}
            local rawLine = reader:readLine()
            while rawLine ~= nil do
                local line = __TS__StringTrim(rawLine)
                if #line > 0 and not __TS__StringStartsWith(line, "#") and not __TS__StringStartsWith(line, ";") then
                    local separator = (string.find(line, "=", nil, true) or 0) - 1
                    if separator <= 0 then
                        error(
                            __TS__New(Error, "invalid line: " .. line),
                            0
                        )
                    end
                    local key = __TS__StringTrim(__TS__StringSubstring(line, 0, separator))
                    if values[key] ~= nil then
                        error(
                            __TS__New(Error, "duplicate key: " .. key),
                            0
                        )
                    end
                    values[key] = __TS__StringTrim(__TS__StringSubstring(line, separator + 1, #line))
                end
                rawLine = reader:readLine()
            end
            return true, self:normalizeManifest(values)
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        do
            if reader then
                reader:close()
            end
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
end
function AnimationRegistry.prototype.normalizeManifest(self, values)
    for ____, key in ipairs(__TS__ObjectKeys(values)) do
        if not __TS__ArrayIncludes(MANIFEST_KEYS, key) then
            error(
                __TS__New(Error, "unknown key: " .. key),
                0
            )
        end
    end
    if values.version ~= "1" then
        error(
            __TS__New(Error, "version must be 1"),
            0
        )
    end
    if values.name == nil or not self:containsOnly(values.name, "abcdefghijklmnopqrstuvwxyz0123456789_-") then
        error(
            __TS__New(Error, "name must be a lowercase folder slug"),
            0
        )
    end
    local category = values.category
    if not __TS__ArrayIncludes(
        __TS__ObjectValues(____exports.ANIMATIONS),
        category
    ) then
        error(
            __TS__New(Error, "invalid category"),
            0
        )
    end
    local steps = self:parseSteps(values)
    local loop = self:parseInteger(values.loop or "1", "loop", 1, MAX_LOOP_COUNT)
    local path = values.path or DEFAULT_IMAGE_PATH
    if not __TS__StringStartsWith(path, "media/ui/") or __TS__StringIncludes(path, "..") or not self:containsOnly(path, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_./-") then
        error(
            __TS__New(Error, "path must be a safe relative media/ui path"),
            0
        )
    end
    local fullnessSupport = values.fullness ~= nil and __TS__ArrayMap(
        __TS__StringSplit(values.fullness, ","),
        function(____, value) return __TS__StringTrim(value) end
    ) or nil
    local ____opt_1 = fullnessSupport
    if ____opt_1 and __TS__ArraySome(
        fullnessSupport,
        function(____, value) return value ~= "full" and value ~= "empty" end
    ) then
        error(
            __TS__New(Error, "fullness must contain only full and/or empty"),
            0
        )
    end
    if category ~= ____exports.ANIMATIONS.INTERCOURSE and fullnessSupport then
        error(
            __TS__New(Error, "fullness is only valid for intercourse animations"),
            0
        )
    end
    if category ~= ____exports.ANIMATIONS.INTERCOURSE and (values.pregnancy ~= nil or values.condom ~= nil) then
        error(
            __TS__New(Error, "pregnancy and condom are only valid for intercourse animations"),
            0
        )
    end
    local setting = {
        name = values.name,
        steps = steps,
        loop = loop,
        path = path,
        fullnessSupport = fullnessSupport,
        birth = category == ____exports.ANIMATIONS.BIRTH or nil,
        fertilization = category == ____exports.ANIMATIONS.FERTILIZATION or nil
    }
    if category == ____exports.ANIMATIONS.INTERCOURSE then
        setting.pregnancy = self:parseOptionalBoolean(values.pregnancy, "pregnancy")
        setting.condom = self:parseOptionalBoolean(values.condom, "condom")
    end
    return {category = category, setting = setting}
end
function AnimationRegistry.prototype.parseSteps(self, values)
    if values.steps ~= nil and values.frameCount ~= nil then
        error(
            __TS__New(Error, "use steps or frameCount, not both"),
            0
        )
    end
    if values.frameCount ~= nil then
        return createArray(self:parseInteger(values.frameCount, "frameCount", 1, MAX_FRAME_COUNT))
    end
    if values.steps == nil then
        error(
            __TS__New(Error, "steps or frameCount is required"),
            0
        )
    end
    local steps = __TS__ArrayMap(
        __TS__StringSplit(values.steps, ","),
        function(____, value) return self:parseInteger(
            __TS__StringTrim(value),
            "steps",
            0,
            MAX_FRAME_COUNT - 1
        ) end
    )
    if #steps == 0 or #steps > MAX_FRAME_COUNT then
        error(
            __TS__New(
                Error,
                ("steps must contain 1-" .. tostring(MAX_FRAME_COUNT)) .. " entries"
            ),
            0
        )
    end
    return steps
end
function AnimationRegistry.prototype.parseInteger(self, value, key, minimum, maximum)
    if not self:containsOnly(value, "0123456789") then
        error(
            __TS__New(Error, key .. " must be an integer"),
            0
        )
    end
    local parsed = __TS__Number(value)
    if parsed < minimum or parsed > maximum then
        error(
            __TS__New(
                Error,
                (((key .. " must be between ") .. tostring(minimum)) .. " and ") .. tostring(maximum)
            ),
            0
        )
    end
    return parsed
end
function AnimationRegistry.prototype.parseOptionalBoolean(self, value, key)
    if value == nil then
        return nil
    end
    if value == "true" then
        return true
    end
    if value == "false" then
        return false
    end
    error(
        __TS__New(Error, key .. " must be true or false"),
        0
    )
end
function AnimationRegistry.prototype.containsOnly(self, value, allowed)
    if #value == 0 then
        return false
    end
    do
        local index = 0
        while index < #value do
            if not __TS__StringIncludes(
                allowed,
                __TS__StringCharAt(value, index)
            ) then
                return false
            end
            index = index + 1
        end
    end
    return true
end
--- Shared client registry used by animation playback and manifest loading.
____exports.animationRegistry = __TS__New(____exports.AnimationRegistry)
return ____exports
