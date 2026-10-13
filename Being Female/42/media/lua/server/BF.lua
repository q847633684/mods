local ____lualib = require('lualib_bundle')
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____CommandHandler = require('components/CommandHandler')
local CommandHandler = ____CommandHandler.CommandHandler
--- Singleton command handler for the server Lua execution context.
____exports.commandHandler = __TS__New(CommandHandler)
Events.onClientCommand:addListener(function(module, command, player, args) return ____exports.commandHandler:onClientCommand(module, command, player, args) end)
return ____exports
