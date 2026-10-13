local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local ____exports = {}
____exports.BFTraitsEnum = BFTraitsEnum or ({})
____exports.BFTraitsEnum.INFERTILE = "bf:infertile"
____exports.BFTraitsEnum.FERTILE = "bf:fertile"
____exports.BFTraitsEnum.HYPERFERTILE = "bf:hyperfertile"
____exports.BFTraitsEnum.PREGNANCY = "bf:pregnancy"
____exports.BFTraitsEnum.DAIRY_COW = "bf:dairycow"
____exports.BFTraitsEnum.STRONG_MENSTRUAL_CRAMPS = "bf:strongmenstrualcramps"
____exports.BFTraitsEnum.NO_MENSTRUAL_CRAMPS = "bf:nomenstrualcramps"
____exports.CyclePhaseEnum = CyclePhaseEnum or ({})
____exports.CyclePhaseEnum.RECOVERY = "Recovery"
____exports.CyclePhaseEnum.MENSTRUATION = "Menstruation"
____exports.CyclePhaseEnum.FOLLICULAR = "Follicular"
____exports.CyclePhaseEnum.OVULATION = "Ovulation"
____exports.CyclePhaseEnum.LUTEAL = "Luteal"
____exports.CyclePhaseEnum.PREGNANT = "Pregnant"
____exports.BFEventsEnum = BFEventsEnum or ({})
____exports.BFEventsEnum.PREGNANCY_UPDATE = "BFPregnancyUpdate"
____exports.BFEventsEnum.LACTATION_UPDATE = "BFLactationUpdate"
____exports.BFEventsEnum.WOMB_UPDATE = "BFWombUpdate"
____exports.BFEventsEnum.INTERCOURSE = "BFIntercourse"
____exports.BFEventsEnum.MENSTRUAL_EFFECTS = "BFMenstrualEffects"
____exports.BFEventsEnum.PREGNANCY_START = "BFPregnancyStart"
____exports.BFEventsEnum.PREGNANCY_STOP = "BFPregnancyStop"
____exports.BFEventsEnum.PREGNANCY_LABOR = "BFPregnancyLabor"
____exports.BFEventsEnum.ANIMATION_START = "BFWombAnimationStart"
____exports.BFEventsEnum.ANIMATION_UPDATE = "BFWombAnimationUpdate"
____exports.BFEventsEnum.ANIMATION_STOP = "BFWombAnimationStop"
____exports.BFEventsEnum.IMAGE = "BFWombImage"
____exports.ITEMS = ITEMS or ({})
____exports.ITEMS.CONDOM = "BF.Condom"
____exports.ITEMS.CONDOM_BOX = "BF.CondomBox"
____exports.ITEMS.CONDOM_USED = "BF.CondomUsed"
____exports.ITEMS.LACTAID = "BF.Lactaid"
____exports.ITEMS.CONTRACEPTIVE = "BF.Contraceptive"
____exports.ITEMS.VAGINAL_DOUCHE = "BF.VaginalDouche"
____exports.ITEMS.BREAST_PUMP = "BF.BreastPump"
____exports.ITEMS.BABY = "BF.Baby"
____exports.Fluids = {HUMAN_MILK = "HumanMilk", SEMEN = "Semen"}
____exports.MODS = MODS or ({})
____exports.MODS.ZOMBOLUST = "ZomboLust"
____exports.MODS.MOODLE_FRAMEWORK = "MoodleFramework"
____exports.BFAnimations = BFAnimations or ({})
____exports.BFAnimations.TAKE_PILLS = "BF.TakePills"
____exports.BFAnimations.BIRTH = "BF.Birth"
____exports.BFAnimations.PUMP_MILK = "BF.PumpMilk"
____exports.BFAnimations.CLEAN_SELF = "BF.CleanSelf"
--- Project Zomboid command module used by all BF network messages.
____exports.BF_NETWORK_MODULE = "BF"
--- Current version of the BF request/response envelope.
____exports.BF_PROTOCOL_SCHEMA_VERSION = 1
--- Current version of the persisted authoritative BF state shape.
____exports.BF_STATE_SCHEMA_VERSION = 1
--- Player ModData key containing the server-owned authoritative root.
____exports.BF_STATE_MOD_DATA_KEY = "BF.State"
--- Commands supported by the initial BF state-synchronization transport.
____exports.BFNetworkCommand = BFNetworkCommand or ({})
____exports.BFNetworkCommand.SYNC_STATE_REQUEST = "SyncStateRequest"
____exports.BFNetworkCommand.SYNC_STATE_RESPONSE = "SyncStateResponse"
____exports.BFNetworkCommand.SET_PREGNANCY_STATE_REQUEST = "SetPregnancyStateRequest"
____exports.BFNetworkCommand.SET_PREGNANCY_STATE_RESPONSE = "SetPregnancyStateResponse"
____exports.BFNetworkCommand.PUBLISH_PREGNANCY_STATE_REQUEST = "PublishPregnancyStateRequest"
____exports.BFNetworkCommand.PUBLISH_PREGNANCY_STATE_RESPONSE = "PublishPregnancyStateResponse"
____exports.BFNetworkCommand.ALLOCATE_BIRTH_REQUEST = "AllocateBirthRequest"
____exports.BFNetworkCommand.ALLOCATE_BIRTH_RESPONSE = "AllocateBirthResponse"
____exports.BFNetworkCommand.COMPLETE_BIRTH_REQUEST = "CompleteBirthRequest"
____exports.BFNetworkCommand.COMPLETE_BIRTH_RESPONSE = "CompleteBirthResponse"
____exports.BFNetworkCommand.CONVERT_CONDOM_REQUEST = "ConvertCondomRequest"
____exports.BFNetworkCommand.PUBLISH_WOMB_STATE_REQUEST = "PublishWombStateRequest"
____exports.BFNetworkCommand.PUBLISH_WOMB_STATE_RESPONSE = "PublishWombStateResponse"
____exports.BFNetworkCommand.PUBLISH_LACTATION_STATE_REQUEST = "PublishLactationStateRequest"
____exports.BFNetworkCommand.PUBLISH_LACTATION_STATE_RESPONSE = "PublishLactationStateResponse"
____exports.BFNetworkCommand.RECIPE_STATE_RESPONSE = "RecipeStateResponse"
--- Outcomes returned by the server for a BF sync request.
____exports.BFSyncStatus = BFSyncStatus or ({})
____exports.BFSyncStatus.OK = "OK"
____exports.BFSyncStatus.INVALID_REQUEST = "INVALID_REQUEST"
____exports.BFSyncStatus.UNSUPPORTED_SCHEMA = "UNSUPPORTED_SCHEMA"
____exports.BFSyncStatus.UNSUPPORTED_DATA_SCHEMA = "UNSUPPORTED_DATA_SCHEMA"
____exports.BFSyncStatus.FORBIDDEN = "FORBIDDEN"
return ____exports
