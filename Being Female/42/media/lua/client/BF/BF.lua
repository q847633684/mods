local ____lualib = require('lualib_bundle')
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____Lactation = require('BF/components/Lactation')
local Lactation = ____Lactation.Lactation
local ____Womb = require('BF/components/Womb')
local Womb = ____Womb.Womb
local ____BFUI = require('BF/components/BFUI')
local BFUI = ____BFUI.BFUI
local ____Pregnancy = require('BF/components/Pregnancy')
local Pregnancy = ____Pregnancy.Pregnancy
local ____ContextMenu = require('BF/components/ContextMenu')
local ContextMenu = ____ContextMenu.ContextMenu
local ____Animation = require('BF/components/Animation')
local Animation = ____Animation.Animation
local ____SnapshotStore = require('BF/components/network/SnapshotStore')
local SnapshotStore = ____SnapshotStore.SnapshotStore
local ____SyncCoordinator = require('BF/components/network/SyncCoordinator')
local SyncCoordinator = ____SyncCoordinator.SyncCoordinator
local ____SyncPublisher = require('BF/components/network/SyncPublisher')
local SyncPublisher = ____SyncPublisher.SyncPublisher
local ____PregnancyPublisher = require('BF/components/network/PregnancyPublisher')
local PregnancyPublisher = ____PregnancyPublisher.PregnancyPublisher
local ____BirthPublisher = require('BF/components/network/BirthPublisher')
local BirthPublisher = ____BirthPublisher.BirthPublisher
local ____WombPublisher = require('BF/components/network/WombPublisher')
local WombPublisher = ____WombPublisher.WombPublisher
local ____RecipeSnapshotReceiver = require('BF/components/network/RecipeSnapshotReceiver')
local RecipeSnapshotReceiver = ____RecipeSnapshotReceiver.RecipeSnapshotReceiver
local ____LactationPublisher = require('BF/components/network/LactationPublisher')
local LactationPublisher = ____LactationPublisher.LactationPublisher
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local isClient = ____pipewrench.isClient
local ____BFEvents = require('BF/BFEvents')
local installBFEvents = ____BFEvents.installBFEvents
local ____CondomPublisher = require('BF/components/network/CondomPublisher')
local CondomPublisher = ____CondomPublisher.CondomPublisher
local ____AnimationRegistry = require('BF/components/AnimationRegistry')
local animationRegistry = ____AnimationRegistry.animationRegistry
installBFEvents()
animationRegistry:install()
--- Whether this Lua context is a multiplayer client that requires command synchronization.
local multiplayerClient = type(isClient) == "function" and isClient()
--- Read-only client mirror of the latest acknowledged authoritative snapshot.
____exports.snapshots = __TS__New(SnapshotStore)
--- Publishes complete reversible Lactation simulation.
____exports.lactationPublisher = __TS__New(LactationPublisher, ____exports.snapshots)
____exports.lactation = __TS__New(Lactation, multiplayerClient and ____exports.snapshots or nil, multiplayerClient and ____exports.lactationPublisher or nil)
--- Client publisher for reversible menstrual-cycle progression.
____exports.wombPublisher = __TS__New(WombPublisher, ____exports.snapshots)
--- Requests server-authoritative replacement of exact used condom items.
____exports.condomPublisher = __TS__New(CondomPublisher)
____exports.womb = __TS__New(Womb, multiplayerClient and ____exports.wombPublisher or nil, multiplayerClient and ____exports.snapshots or nil, multiplayerClient and ____exports.condomPublisher or nil)
--- Applies server-authoritative recipe mutation acknowledgements.
____exports.recipeSnapshots = __TS__New(RecipeSnapshotReceiver, ____exports.snapshots)
--- Client request publisher and response correlator.
____exports.syncPublisher = __TS__New(SyncPublisher, ____exports.snapshots)
--- Debug Pregnancy intent publisher and response correlator.
____exports.pregnancyPublisher = __TS__New(PregnancyPublisher, ____exports.snapshots)
--- Client request publisher for server-owned birth operation allocation.
____exports.birthPublisher = __TS__New(BirthPublisher, ____exports.snapshots)
____exports.pregnancy = __TS__New(Pregnancy, multiplayerClient and ____exports.pregnancyPublisher or nil, multiplayerClient and ____exports.snapshots or nil, multiplayerClient and ____exports.birthPublisher or nil)
____exports.animation = __TS__New(Animation, ____exports.womb)
--- Singleton registration point for client synchronization events.
____exports.syncCoordinator = multiplayerClient and __TS__New(SyncCoordinator, {commandReceivers = {
    ____exports.syncPublisher,
    ____exports.pregnancyPublisher,
    ____exports.birthPublisher,
    ____exports.wombPublisher,
    ____exports.lactationPublisher,
    ____exports.recipeSnapshots
}, sessionResettables = {
    ____exports.snapshots,
    ____exports.syncPublisher,
    ____exports.pregnancyPublisher,
    ____exports.birthPublisher,
    ____exports.wombPublisher,
    ____exports.lactationPublisher
}, minutePublishers = {____exports.syncPublisher, ____exports.birthPublisher}}) or nil
____exports.UI = __TS__New(BFUI, {lactation = ____exports.lactation, pregnancy = ____exports.pregnancy, womb = ____exports.womb})
____exports.contextMenu = __TS__New(ContextMenu, {lactation = ____exports.lactation, pregnancy = ____exports.pregnancy, womb = ____exports.womb, options = {}})
return ____exports
