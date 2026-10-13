local Exports = {}
-- [LUA-PARTIAL:START]

--[lua/client/Blacksmith/ISUI/ISBlacksmithMenu.d.ts]
Exports.ISBlacksmithMenu = _G['ISBlacksmithMenu']

--[lua/client/Blacksmith/ISUI/ISFurnaceInfoWindow.d.ts]
Exports.ISFurnaceInfoWindow = _G['ISFurnaceInfoWindow']

--[lua/client/Blacksmith/TimedActions/ISAddCoalInFurnace.d.ts]
Exports.ISAddCoalInFurnace = _G['ISAddCoalInFurnace']

--[lua/client/Blacksmith/TimedActions/ISAddLogsInDrum.d.ts]
Exports.ISAddLogsInDrum = _G['ISAddLogsInDrum']

--[lua/client/Blacksmith/TimedActions/ISDrumLightFromKindle.d.ts]
Exports.ISDrumLightFromKindle = _G['ISDrumLightFromKindle']

--[lua/client/Blacksmith/TimedActions/ISDrumLightFromLiterature.d.ts]
Exports.ISDrumLightFromLiterature = _G['ISDrumLightFromLiterature']

--[lua/client/Blacksmith/TimedActions/ISDrumLightFromPetrol.d.ts]
Exports.ISDrumLightFromPetrol = _G['ISDrumLightFromPetrol']

--[lua/client/Blacksmith/TimedActions/ISEmptyDrum.d.ts]
Exports.ISEmptyDrum = _G['ISEmptyDrum']

--[lua/client/Blacksmith/TimedActions/ISFurnaceInfoAction.d.ts]
Exports.ISFurnaceInfoAction = _G['ISFurnaceInfoAction']

--[lua/client/Blacksmith/TimedActions/ISFurnaceLightFromKindle.d.ts]
Exports.ISFurnaceLightFromKindle = _G['ISFurnaceLightFromKindle']

--[lua/client/Blacksmith/TimedActions/ISFurnaceLightFromLiterature.d.ts]
Exports.ISFurnaceLightFromLiterature = _G['ISFurnaceLightFromLiterature']

--[lua/client/Blacksmith/TimedActions/ISFurnaceLightFromPetrol.d.ts]
Exports.ISFurnaceLightFromPetrol = _G['ISFurnaceLightFromPetrol']

--[lua/client/Blacksmith/TimedActions/ISPutOutFireDrum.d.ts]
Exports.ISPutOutFireDrum = _G['ISPutOutFireDrum']

--[lua/client/Blacksmith/TimedActions/ISRemoveCharcoal.d.ts]
Exports.ISRemoveCharcoal = _G['ISRemoveCharcoal']

--[lua/client/Blacksmith/TimedActions/ISRemoveDrum.d.ts]
Exports.ISRemoveDrum = _G['ISRemoveDrum']

--[lua/client/Blacksmith/TimedActions/ISStopFurnaceFire.d.ts]
Exports.ISStopFurnaceFire = _G['ISStopFurnaceFire']

--[lua/client/Blacksmith/TimedActions/ISUseBellows.d.ts]
Exports.ISUseBellows = _G['ISUseBellows']

--[lua/client/BuildingObjects/ISUI/ISBuildMenu.d.ts]
Exports.ISBuildMenu = _G['ISBuildMenu']

--[lua/client/BuildingObjects/ISUI/ISInventoryBuildMenu.d.ts]
Exports.ISInventoryBuildMenu = _G['ISInventoryBuildMenu']

--[lua/client/BuildingObjects/ISUI/ISPaintMenu.d.ts]
Exports.ISPaintMenu = _G['ISPaintMenu']

--[lua/client/BuildingObjects/TimedActions/ISBuildAction.d.ts]
Exports.ISBuildAction = _G['ISBuildAction']

--[lua/client/BuildingObjects/TimedActions/ISInsertLightSourceFuelAction.d.ts]
Exports.ISInsertLightSourceFuelAction = _G['ISInsertLightSourceFuelAction']

--[lua/client/BuildingObjects/TimedActions/ISMultiStageBuild.d.ts]
Exports.ISMultiStageBuild = _G['ISMultiStageBuild']

--[lua/client/BuildingObjects/TimedActions/ISPaintAction.d.ts]
Exports.ISPaintAction = _G['ISPaintAction']

--[lua/client/BuildingObjects/TimedActions/ISPaintSignAction.d.ts]
Exports.ISPaintSignAction = _G['ISPaintSignAction']

--[lua/client/BuildingObjects/TimedActions/ISPlasterAction.d.ts]
Exports.ISPlasterAction = _G['ISPlasterAction']

--[lua/client/BuildingObjects/TimedActions/ISRemoveLightSourceFuelAction.d.ts]
Exports.ISRemoveLightSourceFuelAction = _G['ISRemoveLightSourceFuelAction']

--[lua/client/BuildingObjects/TimedActions/ISShovelGround.d.ts]
Exports.ISShovelGround = _G['ISShovelGround']

--[lua/client/BuildingObjects/TimedActions/ISToggleLightSourceAction.d.ts]
Exports.ISToggleLightSourceAction = _G['ISToggleLightSourceAction']

--[lua/client/Camping/CCampfireGlobalObject.d.ts]
Exports.CCampfireGlobalObject = _G['CCampfireGlobalObject']

--[lua/client/Camping/CCampfireSystem.d.ts]
Exports.CCampfireSystem = _G['CCampfireSystem']

--[lua/client/Camping/ISUI/ISCampingInfoWindow.d.ts]
Exports.ISCampingInfoWindow = _G['ISCampingInfoWindow']

--[lua/client/Camping/ISUI/ISCampingMenu.d.ts]
Exports.ISCampingMenu = _G['ISCampingMenu']

--[lua/client/Camping/TimedActions/ISAddFuelAction.d.ts]
Exports.ISAddFuelAction = _G['ISAddFuelAction']

--[lua/client/Camping/TimedActions/ISAddTentAction.d.ts]
Exports.ISAddTentAction = _G['ISAddTentAction']

--[lua/client/Camping/TimedActions/ISLightFromKindle.d.ts]
Exports.ISLightFromKindle = _G['ISLightFromKindle']

--[lua/client/Camping/TimedActions/ISLightFromLiterature.d.ts]
Exports.ISLightFromLiterature = _G['ISLightFromLiterature']

--[lua/client/Camping/TimedActions/ISLightFromPetrol.d.ts]
Exports.ISLightFromPetrol = _G['ISLightFromPetrol']

--[lua/client/Camping/TimedActions/ISPlaceCampfireAction.d.ts]
Exports.ISPlaceCampfireAction = _G['ISPlaceCampfireAction']

--[lua/client/Camping/TimedActions/ISPutOutCampfireAction.d.ts]
Exports.ISPutOutCampfireAction = _G['ISPutOutCampfireAction']

--[lua/client/Camping/TimedActions/ISRemoveCampfireAction.d.ts]
Exports.ISRemoveCampfireAction = _G['ISRemoveCampfireAction']

--[lua/client/Camping/TimedActions/ISRemoveTentAction.d.ts]
Exports.ISRemoveTentAction = _G['ISRemoveTentAction']

--[lua/client/Camping/TimedActions/ISSleepInTentAction.d.ts]
Exports.ISSleepInTentAction = _G['ISSleepInTentAction']

--[lua/client/Chat/ISChat.d.ts]
Exports.ISChat = _G['ISChat']

--[lua/client/Context/ISContextManager.d.ts]
Exports.ISContextManager = _G['ISContextManager']

--[lua/client/Context/ISMenuContext.d.ts]
Exports.ISMenuContext = _G['ISMenuContext']

--[lua/client/Context/ISMenuContextBuild.d.ts]
Exports.ISMenuContextBuild = _G['ISMenuContextBuild']

--[lua/client/Context/ISMenuContextInventory.d.ts]
Exports.ISMenuContextInventory = _G['ISMenuContextInventory']

--[lua/client/Context/ISMenuContextWorld.d.ts]
Exports.ISMenuContextWorld = _G['ISMenuContextWorld']

--[lua/client/Context/ISMenuElement.d.ts]
Exports.ISMenuElement = _G['ISMenuElement']

--[lua/client/Context/World/TestMarkers.d.ts]
Exports.TestMarkers = _G['TestMarkers']

--[lua/client/DebugUIs/AdminContextMenu.d.ts]
Exports.AdminContextMenu = _G['AdminContextMenu']

--[lua/client/DebugUIs/AnimationClipViewer.d.ts]
Exports.AnimationClipViewer = _G['AnimationClipViewer']
Exports.AnimationClipViewer_ListBox = _G['AnimationClipViewer_ListBox']
Exports.AnimationClipViewer_OptionsPanel = _G['AnimationClipViewer_OptionsPanel']
Exports.AnimationClipViewer_Scene = _G['AnimationClipViewer_Scene']
Exports.AnimationClipViewer_Timeline = _G['AnimationClipViewer_Timeline']

--[lua/client/DebugUIs/AttachmentEditorUI.d.ts]
Exports.AttachmentEditorUI = _G['AttachmentEditorUI']
Exports.AttachmentEditorUI_EditAttachment = _G['AttachmentEditorUI_EditAttachment']
Exports.AttachmentEditorUI_EditPanel = _G['AttachmentEditorUI_EditPanel']
Exports.AttachmentEditorUI_ListBox = _G['AttachmentEditorUI_ListBox']
Exports.AttachmentEditorUI_Scene = _G['AttachmentEditorUI_Scene']
Exports.AttachmentEditorUI_SwitchView = _G['AttachmentEditorUI_SwitchView']
Exports.AttachmentEditorUI_WorldAttachmentPanel = _G['AttachmentEditorUI_WorldAttachmentPanel']

--[lua/client/DebugUIs/BrushTool/BrushToolChooseTileUI.d.ts]
Exports.BrushToolChooseTileUI = _G['BrushToolChooseTileUI']
Exports.BrushToolTilePickerList = _G['BrushToolTilePickerList']

--[lua/client/DebugUIs/BrushTool/BrushToolManager.d.ts]
Exports.BrushToolManager = _G['BrushToolManager']

--[lua/client/DebugUIs/BrushTool/FireBrushUI.d.ts]
Exports.FireBrushUI = _G['FireBrushUI']

--[lua/client/DebugUIs/DebugChunkState/DebugChunkState_ObjectPickerPanel.d.ts]
Exports.DebugChunkState_ObjectPickerPanel = _G['DebugChunkState_ObjectPickerPanel']

--[lua/client/DebugUIs/DebugChunkState/DebugChunkState_ObjectProperties.d.ts]
Exports.DebugChunkStateUI_ObjPropsHandler = _G['DebugChunkStateUI_ObjPropsHandler']
Exports.DebugChunkStateUI_ObjPropsPanel = _G['DebugChunkStateUI_ObjPropsPanel']

--[lua/client/DebugUIs/DebugChunkState/DebugChunkState_SquarePanel.d.ts]
Exports.DebugChunkStateUI_SquarePanel = _G['DebugChunkStateUI_SquarePanel']
Exports.DebugChunkStateUI_SquarePropsHandler = _G['DebugChunkStateUI_SquarePropsHandler']

--[lua/client/DebugUIs/DebugChunkState/DebugChunkState_Tools.d.ts]
Exports.DebugChunkStateUI_DragCameraTool = _G['DebugChunkStateUI_DragCameraTool']
Exports.DebugChunkStateUI_Tool = _G['DebugChunkStateUI_Tool']

--[lua/client/DebugUIs/DebugChunkState/DebugChunkState_VehicleStoryPanel.d.ts]
Exports.DebugChunkState_VehicleStoryPanel = _G['DebugChunkState_VehicleStoryPanel']

--[lua/client/DebugUIs/DebugChunkState/DebugChunkStateUI.d.ts]
Exports.DebugChunkStateUI = _G['DebugChunkStateUI']
Exports.DebugChunkStateUI_OptionsPanel = _G['DebugChunkStateUI_OptionsPanel']

--[lua/client/DebugUIs/DebugChunkState/ISSectionedPanel.d.ts]
Exports.ISSectionedPanel = _G['ISSectionedPanel']
Exports.ISSectionedPanel_Section = _G['ISSectionedPanel_Section']

--[lua/client/DebugUIs/DebugContextMenu.d.ts]
Exports.DebugContextMenu = _G['DebugContextMenu']

--[lua/client/DebugUIs/DebugErrorsWindow.d.ts]
Exports.DebugErrorsWindow = _G['DebugErrorsWindow']

--[lua/client/DebugUIs/DebuggerContextMenu.d.ts]
Exports.DebuggerContextMenu = _G['DebuggerContextMenu']

--[lua/client/DebugUIs/DebugGlobalObjectState/DebugGlobalObjectState_PropertiesPanel.d.ts]
Exports.DebugGlobalObjectState_BasePropertiesPanel = _G['DebugGlobalObjectState_BasePropertiesPanel']
Exports.DebugGlobalObjectState_GlobalObjectPanel = _G['DebugGlobalObjectState_GlobalObjectPanel']
Exports.DebugGlobalObjectState_IsoObjectPanel = _G['DebugGlobalObjectState_IsoObjectPanel']
Exports.DebugGlobalObjectState_PropertiesPanel = _G['DebugGlobalObjectState_PropertiesPanel']
Exports.DebugGlobalObjectState_SystemPanel = _G['DebugGlobalObjectState_SystemPanel']

--[lua/client/DebugUIs/DebugGlobalObjectState/DebugGlobalObjectState_Tools.d.ts]
Exports.DebugGlobalObjectStateUI_DragCameraTool = _G['DebugGlobalObjectStateUI_DragCameraTool']
Exports.DebugGlobalObjectStateUI_Tool = _G['DebugGlobalObjectStateUI_Tool']

--[lua/client/DebugUIs/DebugGlobalObjectState/DebugGlobalObjectStateUI.d.ts]
Exports.DebugGlobalObjectStateUI = _G['DebugGlobalObjectStateUI']

--[lua/client/DebugUIs/DebugLogSettings.d.ts]
Exports.DebugLogSettings = _G['DebugLogSettings']

--[lua/client/DebugUIs/DebugMenu/Anims/FloatArrayPlotter.d.ts]
Exports.FloatArrayPlotter = _G['FloatArrayPlotter']

--[lua/client/DebugUIs/DebugMenu/Anims/ISAnimDebugMonitor.d.ts]
Exports.ISAnimDebugMonitor = _G['ISAnimDebugMonitor']

--[lua/client/DebugUIs/DebugMenu/Anims/ISAnimLoggerOutput.d.ts]
Exports.ISAnimLoggerOutput = _G['ISAnimLoggerOutput']

--[lua/client/DebugUIs/DebugMenu/Base/ISDebugPanelBase.d.ts]
Exports.ISDebugPanelBase = _G['ISDebugPanelBase']

--[lua/client/DebugUIs/DebugMenu/Base/ISDebugSubPanelBase.d.ts]
Exports.ISDebugSubPanelBase = _G['ISDebugSubPanelBase']

--[lua/client/DebugUIs/DebugMenu/Climate/ClimateColorsDebug.d.ts]
Exports.ClimateColorsDebug = _G['ClimateColorsDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/ClimateControlDebug.d.ts]
Exports.ClimateControlDebug = _G['ClimateControlDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/ClimateDebug.d.ts]
Exports.ClimateDebug = _G['ClimateDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/ClimateOptionsDebug.d.ts]
Exports.ClimateOptionsDebug = _G['ClimateOptionsDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/ClimDebuggersPanel.d.ts]
Exports.ClimDebuggersPanel = _G['ClimDebuggersPanel']

--[lua/client/DebugUIs/DebugMenu/Climate/DailyValuesDebug.d.ts]
Exports.DailyValuesDebug = _G['DailyValuesDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/ForecasterDebug.d.ts]
Exports.ForecasterDebug = _G['ForecasterDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/NewFogDebug.d.ts]
Exports.NewFogDebug = _G['NewFogDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/PlayerClimateDebug.d.ts]
Exports.PlayerClimateDebug = _G['PlayerClimateDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/PopupColorEdit.d.ts]
Exports.PopupColorEdit = _G['PopupColorEdit']

--[lua/client/DebugUIs/DebugMenu/Climate/ThermoDebug.d.ts]
Exports.ThermoDebug = _G['ThermoDebug']
Exports.ThermoDebug = _G['ThermoDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/ThunderDebug.d.ts]
Exports.ThunderDebug = _G['ThunderDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/ValuePlotter.d.ts]
Exports.ValuePlotter = _G['ValuePlotter']

--[lua/client/DebugUIs/DebugMenu/Climate/WeatherFXDebug.d.ts]
Exports.WeatherFXDebug = _G['WeatherFXDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/WeatherPeriodDebug.d.ts]
Exports.WeatherPeriodDebug = _G['WeatherPeriodDebug']

--[lua/client/DebugUIs/DebugMenu/Climate/WindDebug.d.ts]
Exports.WindDebug = _G['WindDebug']

--[lua/client/DebugUIs/DebugMenu/General/ISCheatPanelUI.d.ts]
Exports.ISCheatPanelUI = _G['ISCheatPanelUI']

--[lua/client/DebugUIs/DebugMenu/General/ISDebugBlood.d.ts]
Exports.ISDebugBlood = _G['ISDebugBlood']

--[lua/client/DebugUIs/DebugMenu/General/ISGameDebugPanel.d.ts]
Exports.ISGameDebugPanel = _G['ISGameDebugPanel']

--[lua/client/DebugUIs/DebugMenu/General/ISGeneralCheats.d.ts]
Exports.ISGeneralCheats = _G['ISGeneralCheats']

--[lua/client/DebugUIs/DebugMenu/General/ISGeneralDebug.d.ts]
Exports.ISGeneralDebug = _G['ISGeneralDebug']

--[lua/client/DebugUIs/DebugMenu/General/ISSearchMode.d.ts]
Exports.ISSearchMode = _G['ISSearchMode']

--[lua/client/DebugUIs/DebugMenu/General/ISStatsAndBody.d.ts]
Exports.ISStatsAndBody = _G['ISStatsAndBody']

--[lua/client/DebugUIs/DebugMenu/GlobalModData/GlobalModData.d.ts]
Exports.GlobalModDataDebug = _G['GlobalModDataDebug']

--[lua/client/DebugUIs/DebugMenu/GlobalModData/GlobalModDataTest.d.ts]

--[lua/client/DebugUIs/DebugMenu/ISDebugMenu.d.ts]
Exports.ISDebugMenu = _G['ISDebugMenu']

--[lua/client/DebugUIs/DebugMenu/ISDebugUtils.d.ts]
Exports.ISDebugUtils = _G['ISDebugUtils']

--[lua/client/DebugUIs/DebugMenu/IsoRegions/IsoRegionDebug.d.ts]
Exports.IsoRegionDebug = _G['IsoRegionDebug']

--[lua/client/DebugUIs/DebugMenu/IsoRegions/IsoRegionDetails.d.ts]
Exports.IsoRegionDetails = _G['IsoRegionDetails']

--[lua/client/DebugUIs/DebugMenu/IsoRegions/IsoRegionLogWindow.d.ts]
Exports.IsoRegionLogWindow = _G['IsoRegionLogWindow']

--[lua/client/DebugUIs/DebugMenu/IsoRegions/IsoRegionsWindow.d.ts]
Exports.IsoRegionsWindow = _G['IsoRegionsWindow']

--[lua/client/DebugUIs/DebugMenu/Puddles/PuddlesControl.d.ts]
Exports.PuddlesControl = _G['PuddlesControl']

--[lua/client/DebugUIs/DebugMenu/Puddles/PuddlesPeriodDebug.d.ts]
Exports.PuddlesPeriodDebug = _G['PuddlesPeriodDebug']

--[lua/client/DebugUIs/DebugMenu/radio/RadioScriptDebugger.d.ts]
Exports.RadioScriptDebugger = _G['RadioScriptDebugger']

--[lua/client/DebugUIs/DebugMenu/radio/ZomboidRadioDebug.d.ts]
Exports.ZomboidRadioDebug = _G['ZomboidRadioDebug']

--[lua/client/DebugUIs/DebugMenu/Statistic/ISGameStatisticPanel.d.ts]
Exports.ISGameStatisticPanel = _G['ISGameStatisticPanel']

--[lua/client/DebugUIs/DebugMenu/Statistic/StatisticChart.d.ts]
Exports.StatisticChart = _G['StatisticChart']

--[lua/client/DebugUIs/DebugMenu/Statistic/StatisticChartDiskOperations.d.ts]
Exports.StatisticChartDiskOperations = _G['StatisticChartDiskOperations']

--[lua/client/DebugUIs/DebugMenu/Statistic/StatisticChartMemory.d.ts]
Exports.StatisticChartMemory = _G['StatisticChartMemory']

--[lua/client/DebugUIs/DebugMenu/Statistic/StatisticChartPackets.d.ts]
Exports.StatisticChartPackets = _G['StatisticChartPackets']

--[lua/client/DebugUIs/DebugMenu/Statistic/StatisticChartUpdatePeriod.d.ts]
Exports.StatisticChartUpdatePeriod = _G['StatisticChartUpdatePeriod']

--[lua/client/DebugUIs/DebugMenu/WorldFlares/WorldFlaresDebug.d.ts]
Exports.WorldFlaresDebug = _G['WorldFlaresDebug']

--[lua/client/DebugUIs/DebugOptionsWindow.d.ts]
Exports.DebugOptionsWindow = _G['DebugOptionsWindow']

--[lua/client/DebugUIs/DebugScenarios.d.ts]
Exports.DebugScenarios = _G['DebugScenarios']

--[lua/client/DebugUIs/DebugToolstrip.d.ts]
Exports.DebugToolstrip = _G['DebugToolstrip']

--[lua/client/DebugUIs/DeviceInspector.d.ts]
Exports.DeviceInspector = _G['DeviceInspector']

--[lua/client/DebugUIs/ISAttachedItemsUI.d.ts]
Exports.ISAttachedItemsUI = _G['ISAttachedItemsUI']

--[lua/client/DebugUIs/ISExtAnimListDebugUI.d.ts]
Exports.ISExtAnimListDebugUI = _G['ISExtAnimListDebugUI']

--[lua/client/DebugUIs/ISFastTeleportMove.d.ts]
Exports.ISFastTeleportMove = _G['ISFastTeleportMove']

--[lua/client/DebugUIs/ISLootStressTestUI.d.ts]
Exports.ISLootStreetTestUI = _G['ISLootStreetTestUI']

--[lua/client/DebugUIs/ISRemoveItemTool.d.ts]
Exports.ISRemoveItemTool = _G['ISRemoveItemTool']

--[lua/client/DebugUIs/ISRunningDebugUI.d.ts]
Exports.ISRunningDebugUI = _G['ISRunningDebugUI']

--[lua/client/DebugUIs/ISSpawnHordeUI.d.ts]
Exports.ISSpawnHordeUI = _G['ISSpawnHordeUI']

--[lua/client/DebugUIs/ISSpawnPointsEditor.d.ts]
Exports.ISSpawnPointsEditor = _G['ISSpawnPointsEditor']

--[lua/client/DebugUIs/ISSpawnVehicleUI.d.ts]
Exports.ISSpawnVehicleUI = _G['ISSpawnVehicleUI']

--[lua/client/DebugUIs/ISTeleportDebugUI.d.ts]
Exports.ISTeleportDebugUI = _G['ISTeleportDebugUI']

--[lua/client/DebugUIs/ISTilesPickerDebugUI.d.ts]
Exports.ISTilesPickerDebugUI = _G['ISTilesPickerDebugUI']
Exports.ISTilesPickerTilesList = _G['ISTilesPickerTilesList']

--[lua/client/DebugUIs/ISTriggerThunderUI.d.ts]
Exports.ISTriggerThunderUI = _G['ISTriggerThunderUI']

--[lua/client/DebugUIs/LuaDebugger.d.ts]
Exports.LuaDebugger = _G['LuaDebugger']

--[lua/client/DebugUIs/LuaDebugOutput.d.ts]
Exports.LuaDebugOutput = _G['LuaDebugOutput']

--[lua/client/DebugUIs/LuaFileBrowser.d.ts]
Exports.LuaFileBrowser = _G['LuaFileBrowser']
Exports.LuaFileBrowserList = _G['LuaFileBrowserList']

--[lua/client/DebugUIs/LuaThreadWindow.d.ts]
Exports.LuaThreadWindow = _G['LuaThreadWindow']

--[lua/client/DebugUIs/MPDebugger.d.ts]
Exports.MPDebugger = _G['MPDebugger']

--[lua/client/DebugUIs/ObjectViewer.d.ts]
Exports.ObjectViewer = _G['ObjectViewer']

--[lua/client/DebugUIs/SourceWindow.d.ts]
Exports.SourceWindow = _G['SourceWindow']

--[lua/client/DebugUIs/StashDebug.d.ts]
Exports.StashDebug = _G['StashDebug']

--[lua/client/DebugUIs/StreamMapWindow.d.ts]
Exports.StreamMapWindow = _G['StreamMapWindow']

--[lua/client/DebugUIs/TextureViewer.d.ts]
Exports.TextureWindow = _G['TextureWindow']

--[lua/client/DebugUIs/WatchWindow.d.ts]
Exports.WatchWindow = _G['WatchWindow']

--[lua/client/erosion/debug/DebugDemoTime.d.ts]

--[lua/client/erosion/debug/Point2D.d.ts]
Exports.Point2D = _G['Point2D']

--[lua/client/Farming/CFarmingSystem.d.ts]
Exports.CFarmingSystem = _G['CFarmingSystem']

--[lua/client/Farming/CPlantGlobalObject.d.ts]
Exports.CPlantGlobalObject = _G['CPlantGlobalObject']

--[lua/client/Farming/ISUI/ISFarmingInfo.d.ts]
Exports.ISFarmingInfo = _G['ISFarmingInfo']
Exports.disease = _G['disease']
Exports.disease_rgb = _G['disease_rgb']
Exports.fertilizer_rgb = _G['fertilizer_rgb']
Exports.health_rgb = _G['health_rgb']
Exports.nowateredsince_rgb = _G['nowateredsince_rgb']
Exports.title_rgb = _G['title_rgb']
Exports.water_rgb = _G['water_rgb']
Exports.waterbar_rgb = _G['waterbar_rgb']

--[lua/client/Farming/ISUI/ISFarmingMenu.d.ts]
Exports.ISFarmingMenu = _G['ISFarmingMenu']

--[lua/client/Farming/ISUI/ISFarmingWindow.d.ts]
Exports.ISFarmingWindow = _G['ISFarmingWindow']

--[lua/client/Farming/TimedActions/ISCureFliesAction.d.ts]
Exports.ISCureFliesAction = _G['ISCureFliesAction']

--[lua/client/Farming/TimedActions/ISCureMildewAction.d.ts]
Exports.ISCureMildewAction = _G['ISCureMildewAction']

--[lua/client/Farming/TimedActions/ISFertilizeAction.d.ts]
Exports.ISFertilizeAction = _G['ISFertilizeAction']

--[lua/client/Farming/TimedActions/ISHarvestPlantAction.d.ts]
Exports.ISHarvestPlantAction = _G['ISHarvestPlantAction']

--[lua/client/Farming/TimedActions/ISPlantInfoAction.d.ts]
Exports.ISPlantInfoAction = _G['ISPlantInfoAction']

--[lua/client/Farming/TimedActions/ISPlowAction.d.ts]
Exports.ISPlowAction = _G['ISPlowAction']

--[lua/client/Farming/TimedActions/ISSeedAction.d.ts]
Exports.ISSeedAction = _G['ISSeedAction']

--[lua/client/Farming/TimedActions/ISShovelAction.d.ts]
Exports.ISShovelAction = _G['ISShovelAction']

--[lua/client/Farming/TimedActions/ISWaterPlantAction.d.ts]
Exports.ISWaterPlantAction = _G['ISWaterPlantAction']

--[lua/client/Fishing/TimedActions/ISCheckFishingNetAction.d.ts]
Exports.ISCheckFishingNetAction = _G['ISCheckFishingNetAction']

--[lua/client/Fishing/TimedActions/ISFishingAction.d.ts]
Exports.ISFishingAction = _G['ISFishingAction']

--[lua/client/Foraging/forageClient.d.ts]
Exports.forageClient = _G['forageClient']
Exports.forageData = _G['forageData']

--[lua/client/Foraging/ISBaseIcon.d.ts]
Exports.ISBaseIcon = _G['ISBaseIcon']

--[lua/client/Foraging/ISForageAction.d.ts]
Exports.ISForageAction = _G['ISForageAction']

--[lua/client/Foraging/ISForageIcon.d.ts]
Exports.ISForageIcon = _G['ISForageIcon']

--[lua/client/Foraging/ISSearchManager.d.ts]
Exports.ISSearchManager = _G['ISSearchManager']

--[lua/client/Foraging/ISSearchWindow.d.ts]
Exports.ISSearchWindow = _G['ISSearchWindow']

--[lua/client/Foraging/ISWorldItemIcon.d.ts]
Exports.ISWorldItemIcon = _G['ISWorldItemIcon']

--[lua/client/Foraging/ISZoneDisplay.d.ts]
Exports.ISZoneDisplay = _G['ISZoneDisplay']

--[lua/client/Hotbar/ISHotbar.d.ts]
Exports.ISHotbar = _G['ISHotbar']

--[lua/client/ISUI/AdminPanel/ISAddNonPvpZoneUI.d.ts]
Exports.ISAddNonPvpZoneUI = _G['ISAddNonPvpZoneUI']

--[lua/client/ISUI/AdminPanel/ISAddSafeZoneUI.d.ts]
Exports.ISAddSafeZoneUI = _G['ISAddSafeZoneUI']

--[lua/client/ISUI/AdminPanel/ISAdminMessage.d.ts]
Exports.ISAdminMessage = _G['ISAdminMessage']

--[lua/client/ISUI/AdminPanel/ISAdminPanelUI.d.ts]
Exports.ISAdminPanelUI = _G['ISAdminPanelUI']

--[lua/client/ISUI/AdminPanel/ISAdminPowerUI.d.ts]
Exports.ISAdminPowerUI = _G['ISAdminPowerUI']

--[lua/client/ISUI/AdminPanel/ISAdminTicketsUI.d.ts]
Exports.ISAdminTicketsUI = _G['ISAdminTicketsUI']

--[lua/client/ISUI/AdminPanel/ISAdminWeather.d.ts]
Exports.ISAdminWeather = _G['ISAdminWeather']

--[lua/client/ISUI/AdminPanel/ISAdmPanelClimate.d.ts]
Exports.ISAdmPanelClimate = _G['ISAdmPanelClimate']

--[lua/client/ISUI/AdminPanel/ISAdmPanelWeather.d.ts]
Exports.ISAdmPanelWeather = _G['ISAdmPanelWeather']

--[lua/client/ISUI/AdminPanel/ISFactionsList.d.ts]
Exports.ISFactionsList = _G['ISFactionsList']

--[lua/client/ISUI/AdminPanel/ISItemEditorUI.d.ts]
Exports.ISItemEditorUI = _G['ISItemEditorUI']

--[lua/client/ISUI/AdminPanel/ISItemsListTable.d.ts]
Exports.ISItemsListTable = _G['ISItemsListTable']

--[lua/client/ISUI/AdminPanel/ISItemsListViewer.d.ts]
Exports.ISItemsListViewer = _G['ISItemsListViewer']

--[lua/client/ISUI/AdminPanel/ISMiniScoreboardUI.d.ts]
Exports.ISMiniScoreboardUI = _G['ISMiniScoreboardUI']

--[lua/client/ISUI/AdminPanel/ISPacketCounts.d.ts]
Exports.ISPacketCounts = _G['ISPacketCounts']
Exports.ISPacketCountsList = _G['ISPacketCountsList']

--[lua/client/ISUI/AdminPanel/ISPvpZonePanel.d.ts]
Exports.ISPvpZonePanel = _G['ISPvpZonePanel']

--[lua/client/ISUI/AdminPanel/ISSafehousesList.d.ts]
Exports.ISSafehousesList = _G['ISSafehousesList']

--[lua/client/ISUI/AdminPanel/ISServerOptions.d.ts]
Exports.ISServerOptions = _G['ISServerOptions']

--[lua/client/ISUI/AdminPanel/ISServerOptionsChange.d.ts]
Exports.ISServerOptionsChange = _G['ISServerOptionsChange']

--[lua/client/ISUI/AdminPanel/ISServerSandboxOptionsUI.d.ts]
Exports.ISServerSandboxOptionsUI = _G['ISServerSandboxOptionsUI']

--[lua/client/ISUI/AdminPanel/ISStatisticsUI.d.ts]
Exports.ISStatisticsUI = _G['ISStatisticsUI']

--[lua/client/ISUI/AdminPanel/ISWhitelistModifyRow.d.ts]
Exports.ISWhitelistModifyRow = _G['ISWhitelistModifyRow']

--[lua/client/ISUI/AdminPanel/ISWhitelistTable.d.ts]
Exports.ISWhitelistTable = _G['ISWhitelistTable']

--[lua/client/ISUI/AdminPanel/ISWhitelistViewer.d.ts]
Exports.ISWhitelistViewer = _G['ISWhitelistViewer']

--[lua/client/ISUI/AdminPanel/LootZed/ISLootZed.d.ts]
Exports.ISLootZed = _G['ISLootZed']

--[lua/client/ISUI/AdminPanel/LootZed/SpawnRateChecker.d.ts]
Exports.LootZedTool = _G['LootZedTool']

--[lua/client/ISUI/BodyParts/ISBodyPartPanel.d.ts]
Exports.ISBodyPartPanel = _G['ISBodyPartPanel']

--[lua/client/ISUI/Fireplace/ISKnob.d.ts]
Exports.ISKnob = _G['ISKnob']

--[lua/client/ISUI/Fireplace/ISMicrowaveUI.d.ts]
Exports.ISMicrowaveUI = _G['ISMicrowaveUI']

--[lua/client/ISUI/Fireplace/ISOvenUI.d.ts]
Exports.ISOvenUI = _G['ISOvenUI']

--[lua/client/ISUI/FPS.d.ts]
Exports.ISFPS = _G['ISFPS']

--[lua/client/ISUI/InterpolationPeriodDebug.d.ts]
Exports.InterpolationPeriodDebug = _G['InterpolationPeriodDebug']

--[lua/client/ISUI/InterpolationPlayerPeriodDebug.d.ts]
Exports.InterpolationPlayerPeriodDebug = _G['InterpolationPlayerPeriodDebug']

--[lua/client/ISUI/ISAlarmClockDialog.d.ts]
Exports.ISAlarmClockDialog = _G['ISAlarmClockDialog']

--[lua/client/ISUI/ISBackButtonWheel.d.ts]
Exports.ISBackButtonWheel = _G['ISBackButtonWheel']

--[lua/client/ISUI/ISBBQInfoWindow.d.ts]
Exports.ISBBQInfoWindow = _G['ISBBQInfoWindow']

--[lua/client/ISUI/ISBBQMenu.d.ts]
Exports.ISBBQMenu = _G['ISBBQMenu']

--[lua/client/ISUI/ISBombTimerDialog.d.ts]
Exports.ISBombTimerDialog = _G['ISBombTimerDialog']

--[lua/client/ISUI/ISButton.d.ts]
Exports.ISButton = _G['ISButton']

--[lua/client/ISUI/ISButtonPrompt.d.ts]
Exports.ISButtonPrompt = _G['ISButtonPrompt']

--[lua/client/ISUI/ISCollapsableModalRichText.d.ts]
Exports.ISCollapsableModalRichText = _G['ISCollapsableModalRichText']

--[lua/client/ISUI/ISCollapsableWindow.d.ts]
Exports.ISCollapsableWindow = _G['ISCollapsableWindow']

--[lua/client/ISUI/ISCollapsableWindowJoypad.d.ts]
Exports.ISCollapsableWindowJoypad = _G['ISCollapsableWindowJoypad']

--[lua/client/ISUI/ISColorPicker.d.ts]
Exports.ISColorPicker = _G['ISColorPicker']

--[lua/client/ISUI/ISComboBox.d.ts]
Exports.ISComboBox = _G['ISComboBox']
Exports.ISComboBoxEditor = _G['ISComboBoxEditor']
Exports.ISComboBoxPopup = _G['ISComboBoxPopup']

--[lua/client/ISUI/ISConfirmMonitorSettingsDialog.d.ts]
Exports.ISConfirmMonitorSettingsDialog = _G['ISConfirmMonitorSettingsDialog']

--[lua/client/ISUI/ISContextMenu.d.ts]
Exports.ISContextMenu = _G['ISContextMenu']

--[lua/client/ISUI/ISControllerTestPanel.d.ts]
Exports.ISControllerTestPanel = _G['ISControllerTestPanel']

--[lua/client/ISUI/ISCraftingCategoryUI.d.ts]
Exports.ISCraftingCategoryUI = _G['ISCraftingCategoryUI']

--[lua/client/ISUI/ISCraftingUI.d.ts]
Exports.ISCraftingUI = _G['ISCraftingUI']

--[lua/client/ISUI/ISDemoPopup.d.ts]
Exports.ISDemoPopup = _G['ISDemoPopup']

--[lua/client/ISUI/ISDigitalCode.d.ts]
Exports.ISDigitalCode = _G['ISDigitalCode']

--[lua/client/ISUI/ISDPadWheels.d.ts]
Exports.ISDPadWheels = _G['ISDPadWheels']

--[lua/client/ISUI/ISDuplicateKeybindDialog.d.ts]
Exports.ISDuplicateKeybindDialog = _G['ISDuplicateKeybindDialog']

--[lua/client/ISUI/ISEmoteRadialMenu.d.ts]
Exports.ISEmoteRadialMenu = _G['ISEmoteRadialMenu']

--[lua/client/ISUI/ISEquippedItem.d.ts]
Exports.ISEquippedItem = _G['ISEquippedItem']
Exports.ISMapPopup = _G['ISMapPopup']
Exports.ISMoveablesIconPopup = _G['ISMoveablesIconPopup']

--[lua/client/ISUI/ISFirearmRadialMenu.d.ts]
Exports.ISFirearmRadialMenu = _G['ISFirearmRadialMenu']

--[lua/client/ISUI/ISFireplaceInfoWindow.d.ts]
Exports.ISFireplaceInfoWindow = _G['ISFireplaceInfoWindow']

--[lua/client/ISUI/ISFireplaceMenu.d.ts]
Exports.ISFireplaceMenu = _G['ISFireplaceMenu']

--[lua/client/ISUI/ISFishingUI.d.ts]
Exports.ISFishingUI = _G['ISFishingUI']

--[lua/client/ISUI/ISFitnessUI.d.ts]
Exports.ISFitnessUI = _G['ISFitnessUI']

--[lua/client/ISUI/ISGameLoadingUI.d.ts]
Exports.ISGameLoadingUI = _G['ISGameLoadingUI']

--[lua/client/ISUI/ISGameSoundVolumeControl.d.ts]
Exports.ISGameSoundVolumeControl = _G['ISGameSoundVolumeControl']

--[lua/client/ISUI/ISGarmentUI.d.ts]
Exports.ISGarmentUI = _G['ISGarmentUI']

--[lua/client/ISUI/ISGeneratorInfoWindow.d.ts]
Exports.ISGeneratorInfoWindow = _G['ISGeneratorInfoWindow']

--[lua/client/ISUI/ISGradientBar.d.ts]
Exports.ISGradientBar = _G['ISGradientBar']

--[lua/client/ISUI/ISImage.d.ts]
Exports.ISImage = _G['ISImage']

--[lua/client/ISUI/ISInfoContainer.d.ts]
Exports.ISInfoContainer = _G['ISInfoContainer']

--[lua/client/ISUI/ISInventoryPage.d.ts]
Exports.ISInventoryPage = _G['ISInventoryPage']

--[lua/client/ISUI/ISInventoryPane.d.ts]
Exports.ISInventoryPane = _G['ISInventoryPane']
Exports.ISInventoryPaneDraggedItems = _G['ISInventoryPaneDraggedItems']

--[lua/client/ISUI/ISInventoryPaneContextMenu.d.ts]
Exports.ISInventoryPaneContextMenu = _G['ISInventoryPaneContextMenu']

--[lua/client/ISUI/ISJoystickButtonRadialMenu.d.ts]
Exports.ISJoystickButtonRadialMenu = _G['ISJoystickButtonRadialMenu']

--[lua/client/ISUI/ISLabel.d.ts]
Exports.ISLabel = _G['ISLabel']

--[lua/client/ISUI/ISLayoutManager.d.ts]
Exports.ISLayoutManager = _G['ISLayoutManager']

--[lua/client/ISUI/ISLcdBar.d.ts]
Exports.ISLcdBar = _G['ISLcdBar']

--[lua/client/ISUI/ISLightSourceRadialMenu.d.ts]
Exports.ISLightSourceRadialMenu = _G['ISLightSourceRadialMenu']

--[lua/client/ISUI/ISLiteratureUI.d.ts]
Exports.ISLiteratureList = _G['ISLiteratureList']
Exports.ISLiteratureMediaList = _G['ISLiteratureMediaList']
Exports.ISLiteratureUI = _G['ISLiteratureUI']

--[lua/client/ISUI/ISMakeUpUI.d.ts]
Exports.ISMakeUpUI = _G['ISMakeUpUI']

--[lua/client/ISUI/ISMegaVolumeControl.d.ts]
Exports.ISMegaVolumeControl = _G['ISMegaVolumeControl']

--[lua/client/ISUI/ISModalDialog.d.ts]
Exports.ISModalDialog = _G['ISModalDialog']

--[lua/client/ISUI/ISModalRichText.d.ts]
Exports.ISModalRichText = _G['ISModalRichText']

--[lua/client/ISUI/ISMouseDrag.d.ts]
Exports.ISMouseDrag = _G['ISMouseDrag']

--[lua/client/ISUI/ISMoveableInfoWindow.d.ts]
Exports.ISMoveableInfoWindow = _G['ISMoveableInfoWindow']

--[lua/client/ISUI/ISNewsUpdate.d.ts]
Exports.ISNewsUpdate = _G['ISNewsUpdate']

--[lua/client/ISUI/ISOnScreenKeyboard.d.ts]
Exports.ISOnScreenKeyboard = _G['ISOnScreenKeyboard']
Exports.OnScreenKeyboardEntry = _G['OnScreenKeyboardEntry']
Exports.OnScreenKeyboardPanel = _G['OnScreenKeyboardPanel']
Exports.OnScreenKeyboard = _G['OnScreenKeyboard']

--[lua/client/ISUI/ISOptionPanel.d.ts]
Exports.ISOptionPanel = _G['ISOptionPanel']

--[lua/client/ISUI/ISPanel.d.ts]
Exports.ISPanel = _G['ISPanel']

--[lua/client/ISUI/ISPanelJoypad.d.ts]
Exports.ISPanelJoypad = _G['ISPanelJoypad']

--[lua/client/ISUI/ISPauseModListUI.d.ts]
Exports.ISPauseModListUI = _G['ISPauseModListUI']
Exports.PauseBuggedModList = _G['PauseBuggedModList']

--[lua/client/ISUI/ISPostDeathUI.d.ts]
Exports.ISPostDeathUI = _G['ISPostDeathUI']

--[lua/client/ISUI/ISRadialMenu.d.ts]
Exports.ISRadialMenu = _G['ISRadialMenu']

--[lua/client/ISUI/ISRadialProgressBar.d.ts]
Exports.ISRadialProgressBar = _G['ISRadialProgressBar']

--[lua/client/ISUI/ISRadioButtons.d.ts]
Exports.ISRadioButtons = _G['ISRadioButtons']

--[lua/client/ISUI/ISRadioOption.d.ts]
Exports.ISRadioOption = _G['ISRadioOption']

--[lua/client/ISUI/ISRainPanel.d.ts]
Exports.ISRainPanel = _G['ISRainPanel']

--[lua/client/ISUI/ISRect.d.ts]
Exports.ISRect = _G['ISRect']

--[lua/client/ISUI/ISResizeableButton.d.ts]
Exports.ISResizableButton = _G['ISResizableButton']

--[lua/client/ISUI/ISResizeWidget.d.ts]
Exports.ISResizeWidget = _G['ISResizeWidget']

--[lua/client/ISUI/ISRichTextBox.d.ts]
Exports.ISRichTextBox = _G['ISRichTextBox']

--[lua/client/ISUI/ISRichTextPanel.d.ts]
Exports.ISRichTextPanel = _G['ISRichTextPanel']

--[lua/client/ISUI/ISSafetyUI.d.ts]
Exports.ISSafetyUI = _G['ISSafetyUI']

--[lua/client/ISUI/ISScavengeUI.d.ts]
Exports.ISScavengeUI = _G['ISScavengeUI']

--[lua/client/ISUI/ISScrollBar.d.ts]
Exports.ISScrollBar = _G['ISScrollBar']

--[lua/client/ISUI/ISScrollingListBox.d.ts]
Exports.ISScrollingListBox = _G['ISScrollingListBox']

--[lua/client/ISUI/ISServerDisconnectUI.d.ts]
Exports.ISServerDisconnectUI = _G['ISServerDisconnectUI']

--[lua/client/ISUI/ISServerSavingMessage.d.ts]
Exports.ISServerSavingMessage = _G['ISServerSavingMessage']

--[lua/client/ISUI/ISSetKeybindDialog.d.ts]
Exports.ISSetKeybindDialog = _G['ISSetKeybindDialog']

--[lua/client/ISUI/ISSleepDialog.d.ts]
Exports.ISSleepDialog = _G['ISSleepDialog']

--[lua/client/ISUI/ISSpinBox.d.ts]
Exports.ISSpinBox = _G['ISSpinBox']

--[lua/client/ISUI/ISTabPanel.d.ts]
Exports.ISTabPanel = _G['ISTabPanel']

--[lua/client/ISUI/ISTermsOfServiceUI.d.ts]
Exports.ISTermsOfServiceUI = _G['ISTermsOfServiceUI']

--[lua/client/ISUI/ISTextBox.d.ts]
Exports.ISTextBox = _G['ISTextBox']

--[lua/client/ISUI/ISTextEntryBox.d.ts]
Exports.ISTextEntryBox = _G['ISTextEntryBox']

--[lua/client/ISUI/ISTickBox.d.ts]
Exports.ISTickBox = _G['ISTickBox']

--[lua/client/ISUI/ISToolTip.d.ts]
Exports.ISToolTip = _G['ISToolTip']

--[lua/client/ISUI/ISToolTipInv.d.ts]
Exports.ISToolTipInv = _G['ISToolTipInv']

--[lua/client/ISUI/ISTradingUI.d.ts]
Exports.ISTradingUI = _G['ISTradingUI']

--[lua/client/ISUI/ISTradingUIHistorial.d.ts]
Exports.ISTradingUIHistorical = _G['ISTradingUIHistorical']

--[lua/client/ISUI/ISUI3DModel.d.ts]
Exports.ISUI3DModel = _G['ISUI3DModel']

--[lua/client/ISUI/ISUIElement.d.ts]
Exports.ISUIElement = _G['ISUIElement']

--[lua/client/ISUI/ISUIEmoteConfig.d.ts]
Exports.ISUIEmoteConfig = _G['ISUIEmoteConfig']

--[lua/client/ISUI/ISUIHandler.d.ts]
Exports.ISUIHandler = _G['ISUIHandler']

--[lua/client/ISUI/ISUIWriteJournal.d.ts]
Exports.ISUIWriteJournal = _G['ISUIWriteJournal']

--[lua/client/ISUI/ISVehicleConfirmBox.d.ts]
Exports.ISVehicleConfirmBox = _G['ISVehicleConfirmBox']
Exports.ISVehiclePartListBox = _G['ISVehiclePartListBox']

--[lua/client/ISUI/ISVolumeControl.d.ts]
Exports.ISVolumeControl = _G['ISVolumeControl']

--[lua/client/ISUI/ISVolumeIndicator.d.ts]
Exports.ISVolumeIndicator = _G['ISVolumeIndicator']

--[lua/client/ISUI/ISWindow.d.ts]
Exports.ISWindow = _G['ISWindow']

--[lua/client/ISUI/ISWorldObjectContextMenu.d.ts]
Exports.ISWorldObjectContextMenu = _G['ISWorldObjectContextMenu']

--[lua/client/ISUI/Maps/Editor/WorldMapEditor.d.ts]
Exports.WorldMapEditor = _G['WorldMapEditor']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorListBox.d.ts]
Exports.WorldMapEditorListBox = _G['WorldMapEditorListBox']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorLocationControl.d.ts]
Exports.WorldMapEditorLocationControl = _G['WorldMapEditorLocationControl']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorMode_Annotations.d.ts]
Exports.WorldMapEditorMode_Annotations = _G['WorldMapEditorMode_Annotations']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorMode_Bounds.d.ts]
Exports.WorldMapEditorMode_Bounds = _G['WorldMapEditorMode_Bounds']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorMode_DataFiles.d.ts]
Exports.WorldMapEditorMode_DataFiles = _G['WorldMapEditorMode_DataFiles']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorMode_Maps.d.ts]
Exports.WorldMapEditorMode_Maps = _G['WorldMapEditorMode_Maps']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorMode_Stashes.d.ts]
Exports.WorldMapEditorMode_Stashes = _G['WorldMapEditorMode_Stashes']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorMode_Style.d.ts]
Exports.WorldMapEditorMode_Style = _G['WorldMapEditorMode_Style']
Exports.WorldMapStyleEditor = _G['WorldMapStyleEditor']
Exports.WorldMapStyleEditor_ColorStopsPanel = _G['WorldMapStyleEditor_ColorStopsPanel']
Exports.WorldMapStyleEditor_FilterPanel = _G['WorldMapStyleEditor_FilterPanel']
Exports.WorldMapStyleEditor_PolygonLayerPanel = _G['WorldMapStyleEditor_PolygonLayerPanel']
Exports.WorldMapStyleEditor_TabPanel = _G['WorldMapStyleEditor_TabPanel']
Exports.WorldMapStyleEditor_TextureLayerPanel = _G['WorldMapStyleEditor_TextureLayerPanel']
Exports.WorldMapStyleEditor_TexturePanel = _G['WorldMapStyleEditor_TexturePanel']
Exports.WorldMapStyleEditor_TextureStopsPanel = _G['WorldMapStyleEditor_TextureStopsPanel']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorMode.d.ts]
Exports.WorldMapEditorMode = _G['WorldMapEditorMode']

--[lua/client/ISUI/Maps/Editor/WorldMapEditorResizer.d.ts]
Exports.WorldMapEditorResizer = _G['WorldMapEditorResizer']

--[lua/client/ISUI/Maps/ISMap.d.ts]
Exports.ISMap = _G['ISMap']
Exports.ISMapWrapper = _G['ISMapWrapper']

--[lua/client/ISUI/Maps/ISMapDefinitions.d.ts]
Exports.LootMaps = _G['LootMaps']
Exports.MapUtils = _G['MapUtils']

--[lua/client/ISUI/Maps/ISMiniMap.d.ts]
Exports.ISMiniMapInner = _G['ISMiniMapInner']
Exports.ISMiniMapOuter = _G['ISMiniMapOuter']
Exports.ISMiniMapTitleBar = _G['ISMiniMapTitleBar']
Exports.ISMiniMap = _G['ISMiniMap']

--[lua/client/ISUI/Maps/ISTextBoxMap.d.ts]
Exports.ISTextBoxMap = _G['ISTextBoxMap']

--[lua/client/ISUI/Maps/ISWorldMap.d.ts]
Exports.ISWorldMap = _G['ISWorldMap']
Exports.ISWorldMapButtonPanel = _G['ISWorldMapButtonPanel']
Exports.WorldMapOptions = _G['WorldMapOptions']

--[lua/client/ISUI/Maps/ISWorldMapSymbols.d.ts]
Exports.ISWorldMapSymbols = _G['ISWorldMapSymbols']
Exports.ISWorldMapSymbolTool = _G['ISWorldMapSymbolTool']
Exports.ISWorldMapSymbolTool_AddNote = _G['ISWorldMapSymbolTool_AddNote']
Exports.ISWorldMapSymbolTool_AddSymbol = _G['ISWorldMapSymbolTool_AddSymbol']
Exports.ISWorldMapSymbolTool_EditNote = _G['ISWorldMapSymbolTool_EditNote']
Exports.ISWorldMapSymbolTool_MoveAnnotation = _G['ISWorldMapSymbolTool_MoveAnnotation']
Exports.ISWorldMapSymbolTool_RemoveAnnotation = _G['ISWorldMapSymbolTool_RemoveAnnotation']

--[lua/client/ISUI/PlayerData/ISPlayerData.d.ts]
Exports.ISPlayerData = _G['ISPlayerData']

--[lua/client/ISUI/PlayerData/ISPlayerDataObject.d.ts]
Exports.ISPlayerDataObject = _G['ISPlayerDataObject']

--[lua/client/ISUI/PlayerStats/ISPlayerStatsAddXPUI.d.ts]
Exports.ISPlayerStatsAddXPUI = _G['ISPlayerStatsAddXPUI']

--[lua/client/ISUI/PlayerStats/ISPlayerStatsChooseAccessLevel.d.ts]
Exports.ISPlayerStatsChooseAccessLevelUI = _G['ISPlayerStatsChooseAccessLevelUI']

--[lua/client/ISUI/PlayerStats/ISPlayerStatsChooseProfessionUI.d.ts]
Exports.ISPlayerStatsChooseProfessionUI = _G['ISPlayerStatsChooseProfessionUI']

--[lua/client/ISUI/PlayerStats/ISPlayerStatsChooseTraitUI.d.ts]
Exports.ISPlayerStatsChooseTraitUI = _G['ISPlayerStatsChooseTraitUI']

--[lua/client/ISUI/PlayerStats/ISPlayerStatsManageInvUI.d.ts]
Exports.ISPlayerStatsManageInvUI = _G['ISPlayerStatsManageInvUI']

--[lua/client/ISUI/PlayerStats/ISPlayerStatsUI.d.ts]
Exports.ISPlayerStatsUI = _G['ISPlayerStatsUI']

--[lua/client/ISUI/PlayerStats/ISPlayerStatsUserlogUI.d.ts]
Exports.ISPlayerStatsUserlogUI = _G['ISPlayerStatsUserlogUI']

--[lua/client/ISUI/PlayerStats/ISPlayerStatsWarningPointUI.d.ts]
Exports.ISPlayerStatsWarningPointUI = _G['ISPlayerStatsWarningPointUI']

--[lua/client/ISUI/RichTextLayout.d.ts]
Exports.ISRichTextLayout = _G['ISRichTextLayout']

--[lua/client/ISUI/SpeedControlsHandler.d.ts]
Exports.SpeedControlsHandler = _G['SpeedControlsHandler']

--[lua/client/ISUI/UserPanel/ISCreateFactionTagUI.d.ts]
Exports.ISCreateFactionTagUI = _G['ISCreateFactionTagUI']

--[lua/client/ISUI/UserPanel/ISCreateFactionUI.d.ts]
Exports.ISCreateFactionUI = _G['ISCreateFactionUI']

--[lua/client/ISUI/UserPanel/ISFactionAddPlayerUI.d.ts]
Exports.ISFactionAddPlayerUI = _G['ISFactionAddPlayerUI']

--[lua/client/ISUI/UserPanel/ISFactionUI.d.ts]
Exports.ISFactionUI = _G['ISFactionUI']

--[lua/client/ISUI/UserPanel/ISSafehouseAddPlayerUI.d.ts]
Exports.ISSafehouseAddPlayerUI = _G['ISSafehouseAddPlayerUI']

--[lua/client/ISUI/UserPanel/ISSafehouseUI.d.ts]
Exports.ISSafehouseUI = _G['ISSafehouseUI']

--[lua/client/ISUI/UserPanel/ISTicketsUI.d.ts]
Exports.ISTicketsUI = _G['ISTicketsUI']

--[lua/client/ISUI/UserPanel/ISUserPanelUI.d.ts]
Exports.ISUserPanelUI = _G['ISUserPanelUI']

--[lua/client/ISUI/ZombiePopulationWindow.d.ts]
Exports.ZombiePopulationWindow = _G['ZombiePopulationWindow']

--[lua/client/JoyPad/ISJoypadDebugUI.d.ts]
Exports.ISJoypadDebugUI = _G['ISJoypadDebugUI']

--[lua/client/JoyPad/ISJoypadDisconnectedUI.d.ts]
Exports.ISJoypadDisconnectedUI = _G['ISJoypadDisconnectedUI']

--[lua/client/JoyPad/ISJoyPadListBox.d.ts]
Exports.ISJoypadListBox = _G['ISJoypadListBox']

--[lua/client/LastStand/AReallyCDDAy.d.ts]
Exports.CDDA = _G['CDDA']

--[lua/client/LastStand/AStormIsComing.d.ts]
Exports.AStormIsComing = _G['AStormIsComing']

--[lua/client/LastStand/Challenge1.d.ts]
Exports.Challenge1 = _G['Challenge1']

--[lua/client/LastStand/Challenge2.d.ts]
Exports.Challenge2 = _G['Challenge2']

--[lua/client/LastStand/EightMonthsLater.d.ts]
Exports.EightMonthsLater = _G['EightMonthsLater']

--[lua/client/LastStand/Insomnia.d.ts]
Exports.InsomniaChallenge = _G['InsomniaChallenge']

--[lua/client/LastStand/ISUI/ISChallenge2PlayerUpWindow.d.ts]
Exports.ISChallenge2PlayerUpWindow = _G['ISChallenge2PlayerUpWindow']

--[lua/client/LastStand/ISUI/ISChallenge2UpgradeTab.d.ts]
Exports.ISChallenge2UpgradeTab = _G['ISChallenge2UpgradeTab']

--[lua/client/LastStand/ISUI/ISChallenge2VariousItemWindow.d.ts]
Exports.ISChallenge2VariousItemWindow = _G['ISChallenge2VariousItemWindow']

--[lua/client/LastStand/ISUI/ISChallenge2WeaponRepairWindow.d.ts]
Exports.ISChallenge2WeaponRepairWindow = _G['ISChallenge2WeaponRepairWindow']

--[lua/client/LastStand/ISUI/ISChallenge2WeaponUpWindow.d.ts]
Exports.ISChallenge2WeaponUpWindow = _G['ISChallenge2WeaponUpWindow']

--[lua/client/LastStand/Kingsmouth.d.ts]
Exports.Kingsmouth = _G['Kingsmouth']

--[lua/client/LastStand/LastStandPlayerFile.d.ts]
Exports.LastStandPlayerFile = _G['LastStandPlayerFile']

--[lua/client/LastStand/LastStandSetup.d.ts]
Exports.LastStandData = _G['LastStandData']

--[lua/client/LastStand/OpeningHours.d.ts]
Exports.OpeningHours = _G['OpeningHours']

--[lua/client/LastStand/Studio.d.ts]
Exports.Studio = _G['Studio']

--[lua/client/LastStand/TheDescendingFog.d.ts]
Exports.TheDescendingFog = _G['TheDescendingFog']

--[lua/client/LastStand/WinterIsComing.d.ts]
Exports.WinterIsComing = _G['WinterIsComing']

--[lua/client/LastStand/YouHaveOneDay.d.ts]
Exports.YouHaveOneDay = _G['YouHaveOneDay']

--[lua/client/Map/CGlobalObject.d.ts]
Exports.CGlobalObject = _G['CGlobalObject']

--[lua/client/Map/CGlobalObjectSystem.d.ts]
Exports.CGlobalObjectSystem = _G['CGlobalObjectSystem']

--[lua/client/MetalDrum/CMetalDrumGlobalObject.d.ts]
Exports.CMetalDrumGlobalObject = _G['CMetalDrumGlobalObject']

--[lua/client/MetalDrum/CMetalDrumSystem.d.ts]
Exports.CMetalDrumSystem = _G['CMetalDrumSystem']

--[lua/client/Moveables/ISMoveableDefinitions.d.ts]
Exports.ISMoveableDefinitions = _G['ISMoveableDefinitions']

--[lua/client/Moveables/ISMoveablesAction.d.ts]
Exports.ISMoveablesAction = _G['ISMoveablesAction']

--[lua/client/Moveables/ISMoveablesIconToolTip.d.ts]
Exports.ISMoveablesIconToolTip = _G['ISMoveablesIconToolTip']

--[lua/client/Moveables/ISMoveableSpriteProps.d.ts]
Exports.InfoPanelFlags = _G['InfoPanelFlags']
Exports.ISMoveableSpriteProps = _G['ISMoveableSpriteProps']
Exports.ISThumpableSpriteProps = _G['ISThumpableSpriteProps']
Exports.SpriteGridCache = _G['SpriteGridCache']

--[lua/client/Moveables/ISMoveableTools.d.ts]
Exports.ISMoveableTools = _G['ISMoveableTools']

--[lua/client/Music/MusicChoices.d.ts]
Exports.MusicChoices = _G['MusicChoices']

--[lua/client/NPCs/UI/CharacterInfoPage.d.ts]
Exports.CharacterInfoPage = _G['CharacterInfoPage']

--[lua/client/NPCs/UI/TeamOverview.d.ts]
Exports.TeamOverview = _G['TeamOverview']

--[lua/client/NPCs/UI/TeamPicker.d.ts]
Exports.TeamPicker = _G['TeamPicker']

--[lua/client/OptionScreens/BootstrapConnectPopup.d.ts]
Exports.BootstrapConnectPopup = _G['BootstrapConnectPopup']

--[lua/client/OptionScreens/CharacterCreationHeader.d.ts]
Exports.CharacterCreationHeader = _G['CharacterCreationHeader']

--[lua/client/OptionScreens/CharacterCreationMain.d.ts]
Exports.CharacterCreationMain = _G['CharacterCreationMain']
Exports.CharacterCreationMainCharacterPanel = _G['CharacterCreationMainCharacterPanel']
Exports.CharacterCreationMainPresetPanel = _G['CharacterCreationMainPresetPanel']

--[lua/client/OptionScreens/CharacterCreationProfession.d.ts]
Exports.CharacterCreationProfession = _G['CharacterCreationProfession']
Exports.BCRC = _G['BCRC']

--[lua/client/OptionScreens/ConnectToServer.d.ts]
Exports.ConnectToServer = _G['ConnectToServer']

--[lua/client/OptionScreens/CoopCharacterCreation.d.ts]
Exports.CoopCharacterCreation = _G['CoopCharacterCreation']

--[lua/client/OptionScreens/CoopCharacterCreationMain.d.ts]
Exports.CoopCharacterCreationMain = _G['CoopCharacterCreationMain']

--[lua/client/OptionScreens/CoopCharacterCreationProfession.d.ts]
Exports.CoopCharacterCreationProfession = _G['CoopCharacterCreationProfession']

--[lua/client/OptionScreens/CoopMapSpawnSelect.d.ts]
Exports.CoopMapSpawnSelect = _G['CoopMapSpawnSelect']

--[lua/client/OptionScreens/CoopOptionsScreen.d.ts]
Exports.CoopOptionsScreen = _G['CoopOptionsScreen']
Exports.CoopOptionsScreenPanel = _G['CoopOptionsScreenPanel']
Exports.CoopConnection = _G['CoopConnection']

--[lua/client/OptionScreens/CoopUserName.d.ts]
Exports.CoopUserName = _G['CoopUserName']

--[lua/client/OptionScreens/InviteFriends.d.ts]
Exports.InviteFriends = _G['InviteFriends']

--[lua/client/OptionScreens/ISGameSounds.d.ts]
Exports.ISGameSounds = _G['ISGameSounds']

--[lua/client/OptionScreens/ISModsNagPanel.d.ts]
Exports.ISModsNagPanel = _G['ISModsNagPanel']

--[lua/client/OptionScreens/ISScoreboard.d.ts]
Exports.ISScoreboard = _G['ISScoreboard']

--[lua/client/OptionScreens/LastStandChallenge.d.ts]
Exports.LastStandChallenge = _G['LastStandChallenge']

--[lua/client/OptionScreens/LastStandPlayerSelect.d.ts]
Exports.LastStandPlayerSelect = _G['LastStandPlayerSelect']

--[lua/client/OptionScreens/LoadGameScreen.d.ts]
Exports.LoadGameScreen = _G['LoadGameScreen']

--[lua/client/OptionScreens/LoginScreen.d.ts]
Exports.LoginScreen = _G['LoginScreen']

--[lua/client/OptionScreens/MainOptions.d.ts]
Exports.MainOptions = _G['MainOptions']

--[lua/client/OptionScreens/MainScreen.d.ts]
Exports.MainScreen = _G['MainScreen']

--[lua/client/OptionScreens/MapSpawnSelect.d.ts]
Exports.MapSpawnSelect = _G['MapSpawnSelect']
Exports.MapSpawnSelectInfoPanel = _G['MapSpawnSelectInfoPanel']
Exports.MapSpawnSelectListBox = _G['MapSpawnSelectListBox']

--[lua/client/OptionScreens/ModMoreInfo.d.ts]
Exports.ModMoreInfo = _G['ModMoreInfo']

--[lua/client/OptionScreens/ModOrderUI.d.ts]
Exports.ModOrderUI = _G['ModOrderUI']

--[lua/client/OptionScreens/ModSelector.d.ts]
Exports.ModInfoPanel = _G['ModInfoPanel']
Exports.ModListBox = _G['ModListBox']
Exports.ModPosterPanel = _G['ModPosterPanel']
Exports.ModSelector = _G['ModSelector']
Exports.ModThumbnailPanel = _G['ModThumbnailPanel']

--[lua/client/OptionScreens/NewGameScreen.d.ts]
Exports.NewGameScreen = _G['NewGameScreen']

--[lua/client/OptionScreens/PublicServerList.d.ts]
Exports.PublicServerList = _G['PublicServerList']

--[lua/client/OptionScreens/SandboxOptions.d.ts]
Exports.SandboxOptionsScreen = _G['SandboxOptionsScreen']

--[lua/client/OptionScreens/ServerConnectPopup.d.ts]
Exports.ServerConnectPopup = _G['ServerConnectPopup']

--[lua/client/OptionScreens/ServerList.d.ts]
Exports.ServerList = _G['ServerList']

--[lua/client/OptionScreens/ServerSettingsScreen.d.ts]
Exports.BaseServerSettingsPanel = _G['BaseServerSettingsPanel']
Exports.ServerSettingsScreen = _G['ServerSettingsScreen']
Exports.SpawnRegionsNameFilePanel = _G['SpawnRegionsNameFilePanel']
Exports.DefaultServerSettings = _G['DefaultServerSettings']

--[lua/client/OptionScreens/ServerToolbox.d.ts]
Exports.ServerToolbox = _G['ServerToolbox']

--[lua/client/OptionScreens/ServerWorkshopItemScreen.d.ts]
Exports.ServerWorkshopItemScreen = _G['ServerWorkshopItemScreen']

--[lua/client/OptionScreens/WorkshopSubmitScreen.d.ts]
Exports.WorkshopSubmitScreen = _G['WorkshopSubmitScreen']

--[lua/client/OptionScreens/WorldSelect.d.ts]
Exports.WorldSelect = _G['WorldSelect']

--[lua/client/RadioCom/ISRadioAction.d.ts]
Exports.ISRadioAction = _G['ISRadioAction']

--[lua/client/RadioCom/ISRadioInteractions.d.ts]
Exports.ISRadioInteractions = _G['ISRadioInteractions']

--[lua/client/RadioCom/ISRadioWindow.d.ts]
Exports.ISRadioWindow = _G['ISRadioWindow']

--[lua/client/RadioCom/ISUIRadio/ISBatteryStatusDisplay.d.ts]
Exports.ISBatteryStatusDisplay = _G['ISBatteryStatusDisplay']

--[lua/client/RadioCom/ISUIRadio/ISItemDropBox.d.ts]
Exports.ISItemDropBox = _G['ISItemDropBox']

--[lua/client/RadioCom/ISUIRadio/ISLedLight.d.ts]
Exports.ISLedLight = _G['ISLedLight']

--[lua/client/RadioCom/ISUIRadio/ISSineWaveDisplay.d.ts]
Exports.ISSineWaveDisplay = _G['ISSineWaveDisplay']

--[lua/client/RadioCom/ISUIRadio/ISSliderPanel.d.ts]
Exports.ISSliderPanel = _G['ISSliderPanel']

--[lua/client/RadioCom/ISUIRadio/ISSpeakerButton.d.ts]
Exports.ISSpeakerButton = _G['ISSpeakerButton']

--[lua/client/RadioCom/ISUIRadio/ISVolumeBar.d.ts]
Exports.ISVolumeBar = _G['ISVolumeBar']

--[lua/client/RadioCom/RadioWindowModules/RWM.d.ts]
Exports.RWM = _G['RWM']

--[lua/client/RadioCom/RadioWindowModules/RWMChannel.d.ts]
Exports.RWMChannel = _G['RWMChannel']

--[lua/client/RadioCom/RadioWindowModules/RWMChannelTV.d.ts]
Exports.RWMChannelTV = _G['RWMChannelTV']

--[lua/client/RadioCom/RadioWindowModules/RWMElement.d.ts]
Exports.RWMElement = _G['RWMElement']

--[lua/client/RadioCom/RadioWindowModules/RWMGeneral.d.ts]
Exports.RWMGeneral = _G['RWMGeneral']

--[lua/client/RadioCom/RadioWindowModules/RWMGridPower.d.ts]
Exports.RWMGridPower = _G['RWMGridPower']

--[lua/client/RadioCom/RadioWindowModules/RWMMedia.d.ts]
Exports.RWMMedia = _G['RWMMedia']

--[lua/client/RadioCom/RadioWindowModules/RWMMicrophone.d.ts]
Exports.RWMMicrophone = _G['RWMMicrophone']

--[lua/client/RadioCom/RadioWindowModules/RWMPanel.d.ts]
Exports.RWMPanel = _G['RWMPanel']

--[lua/client/RadioCom/RadioWindowModules/RWMPower.d.ts]
Exports.RWMPower = _G['RWMPower']

--[lua/client/RadioCom/RadioWindowModules/RWMSignal.d.ts]
Exports.RWMSignal = _G['RWMSignal']

--[lua/client/RadioCom/RadioWindowModules/RWMSubEditPreset.d.ts]
Exports.RWMSubEditPreset = _G['RWMSubEditPreset']

--[lua/client/RadioCom/RadioWindowModules/RWMTestPane.d.ts]
Exports.RWMTestPane = _G['RWMTestPane']

--[lua/client/RadioCom/RadioWindowModules/RWMVolume.d.ts]
Exports.RWMVolume = _G['RWMVolume']

--[lua/client/RadioCom/StoryLineSounds/ISSLEvent.d.ts]
Exports.ISSLEvent = _G['ISSLEvent']

--[lua/client/RadioCom/StoryLineSounds/ISSLFrame.d.ts]
Exports.ISSLFrame = _G['ISSLFrame']

--[lua/client/RadioCom/StoryLineSounds/ISSLManager.d.ts]
Exports.ISSLManager = _G['ISSLManager']

--[lua/client/RadioCom/StoryLineSounds/ISSLSounds.d.ts]
Exports.ISSLSounds = _G['ISSLSounds']

--[lua/client/RadioCom/StoryLineSounds/StorySoundDebug.d.ts]
Exports.ISStorySoundsDebug = _G['ISStorySoundsDebug']

--[lua/client/RainBarrel/CRainBarrelGlobalObject.d.ts]
Exports.CRainBarrelGlobalObject = _G['CRainBarrelGlobalObject']

--[lua/client/RainBarrel/CRainBarrelSystem.d.ts]
Exports.CRainBarrelSystem = _G['CRainBarrelSystem']

--[lua/client/RecordedMedia/ISMediaInfo.d.ts]
Exports.ISMediaInfo = _G['ISMediaInfo']

--[lua/client/Seasons/ISUI/ISWeather.d.ts]
Exports.ISWeather = _G['ISWeather']

--[lua/client/SurvivalGuide/ISTutorialPageInfo.d.ts]
Exports.ISTutorialPageInfo = _G['ISTutorialPageInfo']
Exports.ISTutorialSetInfo = _G['ISTutorialSetInfo']

--[lua/client/SurvivalGuide/ISTutorialPanel.d.ts]
Exports.ISSurvivalGuideListBox = _G['ISSurvivalGuideListBox']
Exports.ISSurvivalGuideRichText = _G['ISSurvivalGuideRichText']
Exports.ISSurvivalGuideRightPanel = _G['ISSurvivalGuideRightPanel']
Exports.ISTutorialPanel = _G['ISTutorialPanel']

--[lua/client/SurvivalGuide/SurvivalGuideEntries.d.ts]
Exports.SurvivalGuideEntries = _G['SurvivalGuideEntries']

--[lua/client/SurvivalGuide/SurvivalGuideManager.d.ts]
Exports.SurvivalGuideManager = _G['SurvivalGuideManager']

--[lua/client/Tests/MapObjectTests.d.ts]

--[lua/client/Tests/RecipeTests.d.ts]

--[lua/client/Tests/RecipeUtils.d.ts]
Exports.RecipeUtils = _G['RecipeUtils']

--[lua/client/Tests/TimedActionsTests.d.ts]
Exports.TimedActionTests = _G['TimedActionTests']

--[lua/client/TimedActions/ISActivateCarBatteryChargerAction.d.ts]
Exports.ISActivateCarBatteryChargerAction = _G['ISActivateCarBatteryChargerAction']

--[lua/client/TimedActions/ISActivateGenerator.d.ts]
Exports.ISActivateGenerator = _G['ISActivateGenerator']

--[lua/client/TimedActions/ISAddCompost.d.ts]
Exports.ISAddCompost = _G['ISAddCompost']

--[lua/client/TimedActions/ISAddFuel.d.ts]
Exports.ISAddFuel = _G['ISAddFuel']

--[lua/client/TimedActions/ISAddItemInRecipe.d.ts]
Exports.ISAddItemInRecipe = _G['ISAddItemInRecipe']

--[lua/client/TimedActions/ISAddSheetAction.d.ts]
Exports.ISAddSheetAction = _G['ISAddSheetAction']

--[lua/client/TimedActions/ISAddSheetRope.d.ts]
Exports.ISAddSheetRope = _G['ISAddSheetRope']

--[lua/client/TimedActions/ISAddWaterFromItemAction.d.ts]
Exports.ISAddWaterFromItemAction = _G['ISAddWaterFromItemAction']

--[lua/client/TimedActions/ISApplyBandage.d.ts]
Exports.ISApplyBandage = _G['ISApplyBandage']

--[lua/client/TimedActions/ISAttachItemHotbar.d.ts]
Exports.ISAttachItemHotbar = _G['ISAttachItemHotbar']

--[lua/client/TimedActions/ISBarricadeAction.d.ts]
Exports.ISBarricadeAction = _G['ISBarricadeAction']

--[lua/client/TimedActions/ISBBQAddFuel.d.ts]
Exports.ISBBQAddFuel = _G['ISBBQAddFuel']

--[lua/client/TimedActions/ISBBQExtinguish.d.ts]
Exports.ISBBQExtinguish = _G['ISBBQExtinguish']

--[lua/client/TimedActions/ISBBQInfoAction.d.ts]
Exports.ISBBQInfoAction = _G['ISBBQInfoAction']

--[lua/client/TimedActions/ISBBQInsertPropaneTank.d.ts]
Exports.ISBBQInsertPropaneTank = _G['ISBBQInsertPropaneTank']

--[lua/client/TimedActions/ISBBQLightFromKindle.d.ts]
Exports.ISBBQLightFromKindle = _G['ISBBQLightFromKindle']

--[lua/client/TimedActions/ISBBQLightFromLiterature.d.ts]
Exports.ISBBQLightFromLiterature = _G['ISBBQLightFromLiterature']

--[lua/client/TimedActions/ISBBQLightFromPetrol.d.ts]
Exports.ISBBQLightFromPetrol = _G['ISBBQLightFromPetrol']

--[lua/client/TimedActions/ISBBQRemovePropaneTank.d.ts]
Exports.ISBBQRemovePropaneTank = _G['ISBBQRemovePropaneTank']

--[lua/client/TimedActions/ISBBQToggle.d.ts]
Exports.ISBBQToggle = _G['ISBBQToggle']

--[lua/client/TimedActions/ISBurnCorpseAction.d.ts]
Exports.ISBurnCorpseAction = _G['ISBurnCorpseAction']

--[lua/client/TimedActions/ISBuryCorpse.d.ts]
Exports.ISBuryCorpse = _G['ISBuryCorpse']

--[lua/client/TimedActions/ISCampingInfoAction.d.ts]
Exports.ISCampingInfoAction = _G['ISCampingInfoAction']

--[lua/client/TimedActions/ISChopTreeAction.d.ts]
Exports.ISChopTreeAction = _G['ISChopTreeAction']

--[lua/client/TimedActions/ISCleanBandage.d.ts]
Exports.ISCleanBandage = _G['ISCleanBandage']

--[lua/client/TimedActions/ISCleanBlood.d.ts]
Exports.ISCleanBlood = _G['ISCleanBlood']

--[lua/client/TimedActions/ISCleanBurn.d.ts]
Exports.ISCleanBurn = _G['ISCleanBurn']

--[lua/client/TimedActions/ISClearAshes.d.ts]
Exports.ISClearAshes = _G['ISClearAshes']

--[lua/client/TimedActions/ISClimbOverFence.d.ts]
Exports.ISClimbOverFence = _G['ISClimbOverFence']

--[lua/client/TimedActions/ISClimbSheetRopeAction.d.ts]
Exports.ISClimbSheetRopeAction = _G['ISClimbSheetRopeAction']

--[lua/client/TimedActions/ISClimbThroughWindow.d.ts]
Exports.ISClimbThroughWindow = _G['ISClimbThroughWindow']

--[lua/client/TimedActions/ISClothingExtraAction.d.ts]
Exports.ISClothingExtraAction = _G['ISClothingExtraAction']

--[lua/client/TimedActions/ISComfreyCataplasm.d.ts]
Exports.ISComfreyCataplasm = _G['ISComfreyCataplasm']

--[lua/client/TimedActions/ISConnectCarBatteryToChargerAction.d.ts]
Exports.ISConnectCarBatteryToChargerAction = _G['ISConnectCarBatteryToChargerAction']

--[lua/client/TimedActions/ISConsolidateDrainable.d.ts]
Exports.ISConsolidateDrainable = _G['ISConsolidateDrainable']

--[lua/client/TimedActions/ISConsolidateDrainableAll.d.ts]
Exports.ISConsolidateDrainableAll = _G['ISConsolidateDrainableAll']

--[lua/client/TimedActions/ISCraftAction.d.ts]
Exports.ISCraftAction = _G['ISCraftAction']

--[lua/client/TimedActions/ISCutHair.d.ts]
Exports.ISCutHair = _G['ISCutHair']

--[lua/client/TimedActions/ISDestroyStuffAction.d.ts]
Exports.ISDestroyStuffAction = _G['ISDestroyStuffAction']

--[lua/client/TimedActions/ISDetachItemHotbar.d.ts]
Exports.ISDetachItemHotbar = _G['ISDetachItemHotbar']

--[lua/client/TimedActions/ISDisinfect.d.ts]
Exports.ISDisinfect = _G['ISDisinfect']

--[lua/client/TimedActions/ISDismantleAction.d.ts]
Exports.ISDismantleAction = _G['ISDismantleAction']

--[lua/client/TimedActions/ISDrinkFromBottle.d.ts]
Exports.ISDrinkFromBottle = _G['ISDrinkFromBottle']

--[lua/client/TimedActions/ISDropItemAction.d.ts]
Exports.ISDropItemAction = _G['ISDropItemAction']

--[lua/client/TimedActions/ISDropWorldItemAction.d.ts]
Exports.ISDropWorldItemAction = _G['ISDropWorldItemAction']

--[lua/client/TimedActions/ISDryMyself.d.ts]
Exports.ISDryMyself = _G['ISDryMyself']

--[lua/client/TimedActions/ISDumpContentsAction.d.ts]
Exports.ISDumpContentsAction = _G['ISDumpContentsAction']

--[lua/client/TimedActions/ISDumpWaterAction.d.ts]
Exports.ISDumpWaterAction = _G['ISDumpWaterAction']

--[lua/client/TimedActions/ISDyeHair.d.ts]
Exports.ISDyeHair = _G['ISDyeHair']

--[lua/client/TimedActions/ISEatFoodAction.d.ts]
Exports.ISEatFoodAction = _G['ISEatFoodAction']

--[lua/client/TimedActions/ISEjectMagazine.d.ts]
Exports.ISEjectMagazine = _G['ISEjectMagazine']

--[lua/client/TimedActions/ISEmptyRainBarrelAction.d.ts]
Exports.ISEmptyRainBarrelAction = _G['ISEmptyRainBarrelAction']

--[lua/client/TimedActions/ISEquipHeavyItem.d.ts]
Exports.ISEquipHeavyItem = _G['ISEquipHeavyItem']

--[lua/client/TimedActions/ISEquipWeaponAction.d.ts]
Exports.ISEquipWeaponAction = _G['ISEquipWeaponAction']

--[lua/client/TimedActions/ISFillGrave.d.ts]
Exports.ISFillGrave = _G['ISFillGrave']

--[lua/client/TimedActions/ISFinalizeDealAction.d.ts]
Exports.ISFinalizeDealAction = _G['ISFinalizeDealAction']

--[lua/client/TimedActions/ISFireplaceAddFuel.d.ts]
Exports.ISFireplaceAddFuel = _G['ISFireplaceAddFuel']

--[lua/client/TimedActions/ISFireplaceExtinguish.d.ts]
Exports.ISFireplaceExtinguish = _G['ISFireplaceExtinguish']

--[lua/client/TimedActions/ISFireplaceInfoAction.d.ts]
Exports.ISFireplaceInfoAction = _G['ISFireplaceInfoAction']

--[lua/client/TimedActions/ISFireplaceLightFromKindle.d.ts]
Exports.ISFireplaceLightFromKindle = _G['ISFireplaceLightFromKindle']

--[lua/client/TimedActions/ISFireplaceLightFromLiterature.d.ts]
Exports.ISFireplaceLightFromLiterature = _G['ISFireplaceLightFromLiterature']

--[lua/client/TimedActions/ISFireplaceLightFromPetrol.d.ts]
Exports.ISFireplaceLightFromPetrol = _G['ISFireplaceLightFromPetrol']

--[lua/client/TimedActions/ISFitnessAction.d.ts]
Exports.ISFitnessAction = _G['ISFitnessAction']

--[lua/client/TimedActions/ISFixAction.d.ts]
Exports.ISFixAction = _G['ISFixAction']

--[lua/client/TimedActions/ISFixGenerator.d.ts]
Exports.ISFixGenerator = _G['ISFixGenerator']

--[lua/client/TimedActions/ISGarlicCataplasm.d.ts]
Exports.ISGarlicCataplasm = _G['ISGarlicCataplasm']

--[lua/client/TimedActions/ISGeneratorInfoAction.d.ts]
Exports.ISGeneratorInfoAction = _G['ISGeneratorInfoAction']

--[lua/client/TimedActions/ISGetCompost.d.ts]
Exports.ISGetCompost = _G['ISGetCompost']

--[lua/client/TimedActions/ISGrabCorpseAction.d.ts]
Exports.ISGrabCorpseAction = _G['ISGrabCorpseAction']

--[lua/client/TimedActions/ISGrabItemAction.d.ts]
Exports.ISGrabItemAction = _G['ISGrabItemAction']

--[lua/client/TimedActions/ISInsertMagazine.d.ts]
Exports.ISInsertMagazine = _G['ISInsertMagazine']

--[lua/client/TimedActions/ISInventoryTransferAction.d.ts]
Exports.ISInventoryTransferAction = _G['ISInventoryTransferAction']

--[lua/client/TimedActions/ISLightActions.d.ts]
Exports.ISLightActions = _G['ISLightActions']

--[lua/client/TimedActions/ISLoadBulletsInMagazine.d.ts]
Exports.ISLoadBulletsInMagazine = _G['ISLoadBulletsInMagazine']

--[lua/client/TimedActions/ISLockDoor.d.ts]
Exports.ISLockDoor = _G['ISLockDoor']

--[lua/client/TimedActions/ISMedicalCheckAction.d.ts]
Exports.ISMedicalCheckAction = _G['ISMedicalCheckAction']

--[lua/client/TimedActions/ISOpenCloseCurtain.d.ts]
Exports.ISOpenCloseCurtain = _G['ISOpenCloseCurtain']

--[lua/client/TimedActions/ISOpenCloseDoor.d.ts]
Exports.ISOpenCloseDoor = _G['ISOpenCloseDoor']

--[lua/client/TimedActions/ISOpenCloseWindow.d.ts]
Exports.ISOpenCloseWindow = _G['ISOpenCloseWindow']

--[lua/client/TimedActions/ISOpenContainerTimedAction.d.ts]
Exports.ISOpenContainerTimedAction = _G['ISOpenContainerTimedAction']

--[lua/client/TimedActions/ISOvenUITimedAction.d.ts]
Exports.ISOvenUITimedAction = _G['ISOvenUITimedAction']

--[lua/client/TimedActions/ISPadlockAction.d.ts]
Exports.ISPadlockAction = _G['ISPadlockAction']

--[lua/client/TimedActions/ISPickupBrokenGlass.d.ts]
Exports.ISPickupBrokenGlass = _G['ISPickupBrokenGlass']

--[lua/client/TimedActions/ISPlaceCarBatteryChargerAction.d.ts]
Exports.ISPlaceCarBatteryChargerAction = _G['ISPlaceCarBatteryChargerAction']

--[lua/client/TimedActions/ISPlaceTrap.d.ts]
Exports.ISPlaceTrap = _G['ISPlaceTrap']

--[lua/client/TimedActions/ISPlantainCataplasm.d.ts]
Exports.ISPlantainCataplasm = _G['ISPlantainCataplasm']

--[lua/client/TimedActions/ISPlugGenerator.d.ts]
Exports.ISPlugGenerator = _G['ISPlugGenerator']

--[lua/client/TimedActions/ISPlumbItem.d.ts]
Exports.ISPlumbItem = _G['ISPlumbItem']

--[lua/client/TimedActions/ISPutOutFire.d.ts]
Exports.ISPutOutFire = _G['ISPutOutFire']

--[lua/client/TimedActions/ISQueueActionsAction.d.ts]
Exports.ISQueueActionsAction = _G['ISQueueActionsAction']

--[lua/client/TimedActions/ISRackFirearm.d.ts]
Exports.ISRackFirearm = _G['ISRackFirearm']

--[lua/client/TimedActions/ISReadABook.d.ts]
Exports.ISReadABook = _G['ISReadABook']

--[lua/client/TimedActions/ISReadWorldMap.d.ts]
Exports.ISReadWorldMap = _G['ISReadWorldMap']

--[lua/client/TimedActions/ISReloadWeaponAction.d.ts]
Exports.ISReloadWeaponAction = _G['ISReloadWeaponAction']

--[lua/client/TimedActions/ISRemoveBrokenGlass.d.ts]
Exports.ISRemoveBrokenGlass = _G['ISRemoveBrokenGlass']

--[lua/client/TimedActions/ISRemoveBullet.d.ts]
Exports.ISRemoveBullet = _G['ISRemoveBullet']

--[lua/client/TimedActions/ISRemoveBush.d.ts]
Exports.ISRemoveBush = _G['ISRemoveBush']

--[lua/client/TimedActions/ISRemoveCarBatteryFromChargerAction.d.ts]
Exports.ISRemoveCarBatteryFromChargerAction = _G['ISRemoveCarBatteryFromChargerAction']

--[lua/client/TimedActions/ISRemoveGlass.d.ts]
Exports.ISRemoveGlass = _G['ISRemoveGlass']

--[lua/client/TimedActions/ISRemoveGrass.d.ts]
Exports.ISRemoveGrass = _G['ISRemoveGrass']

--[lua/client/TimedActions/ISRemovePatch.d.ts]
Exports.ISRemovePatch = _G['ISRemovePatch']

--[lua/client/TimedActions/ISRemoveSheetAction.d.ts]
Exports.ISRemoveSheetAction = _G['ISRemoveSheetAction']

--[lua/client/TimedActions/ISRemoveSheetRope.d.ts]
Exports.ISRemoveSheetRope = _G['ISRemoveSheetRope']

--[lua/client/TimedActions/ISRemoveWeaponUpgrade.d.ts]
Exports.ISRemoveWeaponUpgrade = _G['ISRemoveWeaponUpgrade']

--[lua/client/TimedActions/ISRepairClothing.d.ts]
Exports.ISRepairClothing = _G['ISRepairClothing']

--[lua/client/TimedActions/ISRestAction.d.ts]
Exports.ISRestAction = _G['ISRestAction']

--[lua/client/TimedActions/ISRipClothing.d.ts]
Exports.ISRipClothing = _G['ISRipClothing']

--[lua/client/TimedActions/ISScavengeAction.d.ts]
Exports.ISScavengeAction = _G['ISScavengeAction']

--[lua/client/TimedActions/ISSetComboWasherDryerMode.d.ts]
Exports.ISSetComboWasherDryerMode = _G['ISSetComboWasherDryerMode']

--[lua/client/TimedActions/ISSitOnChairAction.d.ts]
Exports.ISSitOnChairAction = _G['ISSitOnChairAction']

--[lua/client/TimedActions/ISSmashWindow.d.ts]
Exports.ISSmashWindow = _G['ISSmashWindow']

--[lua/client/TimedActions/ISSplint.d.ts]
Exports.ISSplint = _G['ISSplint']

--[lua/client/TimedActions/ISStitch.d.ts]
Exports.ISStitch = _G['ISStitch']

--[lua/client/TimedActions/ISStopAlarmClockAction.d.ts]
Exports.ISStopAlarmClockAction = _G['ISStopAlarmClockAction']

--[lua/client/TimedActions/ISTakeCarBatteryChargerAction.d.ts]
Exports.ISTakeCarBatteryChargerAction = _G['ISTakeCarBatteryChargerAction']

--[lua/client/TimedActions/ISTakeFuel.d.ts]
Exports.ISTakeFuel = _G['ISTakeFuel']

--[lua/client/TimedActions/ISTakeGenerator.d.ts]
Exports.ISTakeGenerator = _G['ISTakeGenerator']

--[lua/client/TimedActions/ISTakePillAction.d.ts]
Exports.ISTakePillAction = _G['ISTakePillAction']

--[lua/client/TimedActions/ISTakeTrap.d.ts]
Exports.ISTakeTrap = _G['ISTakeTrap']

--[lua/client/TimedActions/ISTakeWaterAction.d.ts]
Exports.ISTakeWaterAction = _G['ISTakeWaterAction']

--[lua/client/TimedActions/ISTimedActionQueue.d.ts]
Exports.ISTimedActionQueue = _G['ISTimedActionQueue']

--[lua/client/TimedActions/ISToggleClothingDryer.d.ts]
Exports.ISToggleClothingDryer = _G['ISToggleClothingDryer']

--[lua/client/TimedActions/ISToggleClothingWasher.d.ts]
Exports.ISToggleClothingWasher = _G['ISToggleClothingWasher']

--[lua/client/TimedActions/ISToggleComboWasherDryer.d.ts]
Exports.ISToggleComboWasherDryer = _G['ISToggleComboWasherDryer']

--[lua/client/TimedActions/ISToggleLightAction.d.ts]
Exports.ISToggleLightAction = _G['ISToggleLightAction']

--[lua/client/TimedActions/ISToggleSafetyAction.d.ts]
Exports.ISToggleSafetyAction = _G['ISToggleSafetyAction']

--[lua/client/TimedActions/ISToggleStoveAction.d.ts]
Exports.ISToggleStoveAction = _G['ISToggleStoveAction']

--[lua/client/TimedActions/ISTransferWaterAction.d.ts]
Exports.ISTransferWaterAction = _G['ISTransferWaterAction']

--[lua/client/TimedActions/ISTrimBeard.d.ts]
Exports.ISTrimBeard = _G['ISTrimBeard']

--[lua/client/TimedActions/ISUnbarricadeAction.d.ts]
Exports.ISUnbarricadeAction = _G['ISUnbarricadeAction']

--[lua/client/TimedActions/ISUnequipAction.d.ts]
Exports.ISUnequipAction = _G['ISUnequipAction']

--[lua/client/TimedActions/ISUnloadBulletsFromFirearm.d.ts]
Exports.ISUnloadBulletsFromFirearm = _G['ISUnloadBulletsFromFirearm']

--[lua/client/TimedActions/ISUnloadBulletsFromMagazine.d.ts]
Exports.ISUnloadBulletsFromMagazine = _G['ISUnloadBulletsFromMagazine']

--[lua/client/TimedActions/ISUpgradeWeapon.d.ts]
Exports.ISUpgradeWeapon = _G['ISUpgradeWeapon']

--[lua/client/TimedActions/ISWakeOtherPlayer.d.ts]
Exports.ISWakeOtherPlayer = _G['ISWakeOtherPlayer']

--[lua/client/TimedActions/ISWashClothing.d.ts]
Exports.ISWashClothing = _G['ISWashClothing']

--[lua/client/TimedActions/ISWashYourself.d.ts]
Exports.ISWashYourself = _G['ISWashYourself']

--[lua/client/TimedActions/ISWearClothing.d.ts]
Exports.ISWearClothing = _G['ISWearClothing']
Exports.WearClothingAnimations = _G['WearClothingAnimations']

--[lua/client/TimedActions/WalkToTimedAction.d.ts]
Exports.ISWalkToTimedAction = _G['ISWalkToTimedAction']

--[lua/client/Traps/CTrapGlobalObject.d.ts]
Exports.CTrapGlobalObject = _G['CTrapGlobalObject']

--[lua/client/Traps/CTrapSystem.d.ts]
Exports.CTrapSystem = _G['CTrapSystem']

--[lua/client/Traps/TimedActions/ISAddBaitAction.d.ts]
Exports.ISAddBaitAction = _G['ISAddBaitAction']

--[lua/client/Traps/TimedActions/ISCheckTrapAction.d.ts]
Exports.ISCheckTrapAction = _G['ISCheckTrapAction']

--[lua/client/Traps/TimedActions/ISRemoveBaitAction.d.ts]
Exports.ISRemoveBaitAction = _G['ISRemoveBaitAction']

--[lua/client/Traps/TimedActions/ISRemoveTrapAction.d.ts]
Exports.ISRemoveTrapAction = _G['ISRemoveTrapAction']

--[lua/client/Tutorial/ISUI/TutorialFocus.d.ts]
Exports.TutorialFocus = _G['TutorialFocus']

--[lua/client/Tutorial/ISUI/TutorialMessage.d.ts]
Exports.TutorialMessage = _G['TutorialMessage']

--[lua/client/Tutorial/Steps.d.ts]
Exports.BandageStep = _G['BandageStep']
Exports.FightStep = _G['FightStep']
Exports.InventoryLootingStep = _G['InventoryLootingStep']
Exports.InventoryUseStep = _G['InventoryUseStep']
Exports.ShotgunStep = _G['ShotgunStep']
Exports.SneakStep = _G['SneakStep']
Exports.WalkToAdjacent = _G['WalkToAdjacent']
Exports.WelcomeStep = _G['WelcomeStep']
Exports.TutorialTests = _G['TutorialTests']

--[lua/client/Tutorial/Tutorial1.d.ts]
Exports.Tutorial1 = _G['Tutorial1']

--[lua/client/Tutorial/TutorialSetup.d.ts]
Exports.TutorialData = _G['TutorialData']

--[lua/client/Tutorial/TutorialStep.d.ts]
Exports.TutorialStep = _G['TutorialStep']

--[lua/client/Vehicles/ISUI/EditVehicleState.d.ts]
Exports.EditVehicleUI = _G['EditVehicleUI']
Exports.EditVehicleUI_EditArea = _G['EditVehicleUI_EditArea']
Exports.EditVehicleUI_EditAttachment = _G['EditVehicleUI_EditAttachment']
Exports.EditVehicleUI_EditChassis = _G['EditVehicleUI_EditChassis']
Exports.EditVehicleUI_EditPanel = _G['EditVehicleUI_EditPanel']
Exports.EditVehicleUI_EditPassenger = _G['EditVehicleUI_EditPassenger']
Exports.EditVehicleUI_EditPhysics = _G['EditVehicleUI_EditPhysics']
Exports.EditVehicleUI_EditWheel = _G['EditVehicleUI_EditWheel']
Exports.EditVehicleUI_ListBox = _G['EditVehicleUI_ListBox']
Exports.EditVehicleUI_Scene = _G['EditVehicleUI_Scene']
Exports.EditVehicleUI_SwitchView = _G['EditVehicleUI_SwitchView']

--[lua/client/Vehicles/ISUI/ISCarMechanicsOverlay.d.ts]
Exports.ISCarMechanicsOverlay = _G['ISCarMechanicsOverlay']

--[lua/client/Vehicles/ISUI/ISLightbarUI.d.ts]
Exports.ISLightbarUI = _G['ISLightbarUI']

--[lua/client/Vehicles/ISUI/ISUI3DScene.d.ts]
Exports.ISUI3DScene = _G['ISUI3DScene']

--[lua/client/Vehicles/ISUI/ISUIVehicleModel.d.ts]
Exports.ISUIVehicleModel = _G['ISUIVehicleModel']

--[lua/client/Vehicles/ISUI/ISVehicleACUI.d.ts]
Exports.ISVehicleACUI = _G['ISVehicleACUI']

--[lua/client/Vehicles/ISUI/ISVehicleAngles.d.ts]
Exports.ISVehicleAngles = _G['ISVehicleAngles']

--[lua/client/Vehicles/ISUI/ISVehicleBloodUI.d.ts]
Exports.ISVehicleBloodUI = _G['ISVehicleBloodUI']

--[lua/client/Vehicles/ISUI/ISVehicleColor.d.ts]
Exports.ISVehicleHSV = _G['ISVehicleHSV']

--[lua/client/Vehicles/ISUI/ISVehicleDashboard.d.ts]
Exports.ISVehicleDashboard = _G['ISVehicleDashboard']

--[lua/client/Vehicles/ISUI/ISVehicleGauge.d.ts]
Exports.ISVehicleGauge = _G['ISVehicleGauge']

--[lua/client/Vehicles/ISUI/ISVehicleMechanics.d.ts]
Exports.ISVehicleMechanics = _G['ISVehicleMechanics']

--[lua/client/Vehicles/ISUI/ISVehicleMenu.d.ts]
Exports.ISVehicleMenu = _G['ISVehicleMenu']

--[lua/client/Vehicles/ISUI/ISVehiclePartMenu.d.ts]
Exports.ISVehiclePartMenu = _G['ISVehiclePartMenu']

--[lua/client/Vehicles/ISUI/ISVehicleRegulator.d.ts]
Exports.ISVehicleRegulator = _G['ISVehicleRegulator']

--[lua/client/Vehicles/ISUI/ISVehicleRoadtripDebug.d.ts]
Exports.ISVehicleRoadtripDebug = _G['ISVehicleRoadtripDebug']

--[lua/client/Vehicles/ISUI/ISVehicleSeatUI.d.ts]
Exports.ISVehicleSeatUI = _G['ISVehicleSeatUI']
Exports.ImageScale = _G['ImageScale']
Exports.SeatOffsetX = _G['SeatOffsetX']
Exports.SeatOffsetY = _G['SeatOffsetY']

--[lua/client/Vehicles/ISVehicleTrailerUtils.d.ts]
Exports.ISVehicleTrailerUtils = _G['ISVehicleTrailerUtils']

--[lua/client/Vehicles/TimedActions/ISAddGasolineToVehicle.d.ts]
Exports.ISAddGasolineToVehicle = _G['ISAddGasolineToVehicle']

--[lua/client/Vehicles/TimedActions/ISAttachTrailerToVehicle.d.ts]
Exports.ISAttachTrailerToVehicle = _G['ISAttachTrailerToVehicle']

--[lua/client/Vehicles/TimedActions/ISCloseVehicleDoor.d.ts]
Exports.ISCloseVehicleDoor = _G['ISCloseVehicleDoor']

--[lua/client/Vehicles/TimedActions/ISConfigHeadlight.d.ts]
Exports.ISConfigHeadlight = _G['ISConfigHeadlight']

--[lua/client/Vehicles/TimedActions/ISDeflateTire.d.ts]
Exports.ISDeflateTire = _G['ISDeflateTire']

--[lua/client/Vehicles/TimedActions/ISDetachTrailerFromVehicle.d.ts]
Exports.ISDetachTrailerFromVehicle = _G['ISDetachTrailerFromVehicle']

--[lua/client/Vehicles/TimedActions/ISEnterVehicle.d.ts]
Exports.ISEnterVehicle = _G['ISEnterVehicle']

--[lua/client/Vehicles/TimedActions/ISExitVehicle.d.ts]
Exports.ISExitVehicle = _G['ISExitVehicle']

--[lua/client/Vehicles/TimedActions/ISHorn.d.ts]
Exports.ISHorn = _G['ISHorn']

--[lua/client/Vehicles/TimedActions/ISHotwireVehicle.d.ts]
Exports.ISHotwireVehicle = _G['ISHotwireVehicle']

--[lua/client/Vehicles/TimedActions/ISInflateTire.d.ts]
Exports.ISInflateTire = _G['ISInflateTire']

--[lua/client/Vehicles/TimedActions/ISInstallVehiclePart.d.ts]
Exports.ISInstallVehiclePart = _G['ISInstallVehiclePart']

--[lua/client/Vehicles/TimedActions/ISLightbarUITimedAction.d.ts]
Exports.ISLightbarUITimedAction = _G['ISLightbarUITimedAction']

--[lua/client/Vehicles/TimedActions/ISLockDoors.d.ts]
Exports.ISLockDoors = _G['ISLockDoors']

--[lua/client/Vehicles/TimedActions/ISLockVehicleDoor.d.ts]
Exports.ISLockVehicleDoor = _G['ISLockVehicleDoor']

--[lua/client/Vehicles/TimedActions/ISOpenCloseVehicleWindow.d.ts]
Exports.ISOpenCloseVehicleWindow = _G['ISOpenCloseVehicleWindow']

--[lua/client/Vehicles/TimedActions/ISOpenMechanicsUIAction.d.ts]
Exports.ISOpenMechanicsUIAction = _G['ISOpenMechanicsUIAction']

--[lua/client/Vehicles/TimedActions/ISOpenVehicleDoor.d.ts]
Exports.ISOpenVehicleDoor = _G['ISOpenVehicleDoor']

--[lua/client/Vehicles/TimedActions/ISPathFindAction.d.ts]
Exports.ISPathFindAction = _G['ISPathFindAction']

--[lua/client/Vehicles/TimedActions/ISRechargeCarBattery.d.ts]
Exports.ISRechargeCarBattery = _G['ISRechargeCarBattery']

--[lua/client/Vehicles/TimedActions/ISRefuelFromGasPump.d.ts]
Exports.ISRefuelFromGasPump = _G['ISRefuelFromGasPump']

--[lua/client/Vehicles/TimedActions/ISRemoveBurntVehicle.d.ts]
Exports.ISRemoveBurntVehicle = _G['ISRemoveBurntVehicle']

--[lua/client/Vehicles/TimedActions/ISRepairEngine.d.ts]
Exports.ISRepairEngine = _G['ISRepairEngine']

--[lua/client/Vehicles/TimedActions/ISShutOffVehicleEngine.d.ts]
Exports.ISShutOffVehicleEngine = _G['ISShutOffVehicleEngine']

--[lua/client/Vehicles/TimedActions/ISSmashVehicleWindow.d.ts]
Exports.ISSmashVehicleWindow = _G['ISSmashVehicleWindow']

--[lua/client/Vehicles/TimedActions/ISStartVehicleEngine.d.ts]
Exports.ISStartVehicleEngine = _G['ISStartVehicleEngine']

--[lua/client/Vehicles/TimedActions/ISStopVehicle.d.ts]
Exports.ISStopVehicle = _G['ISStopVehicle']

--[lua/client/Vehicles/TimedActions/ISSwitchVehicleSeat.d.ts]
Exports.ISSwitchVehicleSeat = _G['ISSwitchVehicleSeat']

--[lua/client/Vehicles/TimedActions/ISTakeEngineParts.d.ts]
Exports.ISTakeEngineParts = _G['ISTakeEngineParts']

--[lua/client/Vehicles/TimedActions/ISTakeGasolineFromVehicle.d.ts]
Exports.ISTakeGasolineFromVehicle = _G['ISTakeGasolineFromVehicle']

--[lua/client/Vehicles/TimedActions/ISUninstallVehiclePart.d.ts]
Exports.ISUninstallVehiclePart = _G['ISUninstallVehiclePart']

--[lua/client/Vehicles/TimedActions/ISUnlockVehicleDoor.d.ts]
Exports.ISUnlockVehicleDoor = _G['ISUnlockVehicleDoor']

--[lua/client/Vehicles/TimedActions/ISWashVehicle.d.ts]
Exports.ISWashVehicle = _G['ISWashVehicle']

--[lua/client/XpSystem/ISUI/ISCharacterInfo.d.ts]
Exports.ISCharacterInfo = _G['ISCharacterInfo']

--[lua/client/XpSystem/ISUI/ISCharacterInfoWindow.d.ts]
Exports.ISCharacterInfoWindow = _G['ISCharacterInfoWindow']

--[lua/client/XpSystem/ISUI/ISCharacterProtection.d.ts]
Exports.ISCharacterProtection = _G['ISCharacterProtection']

--[lua/client/XpSystem/ISUI/ISCharacterScreen.d.ts]
Exports.ISCharacterScreen = _G['ISCharacterScreen']
Exports.ISCharacterScreenAvatar = _G['ISCharacterScreenAvatar']

--[lua/client/XpSystem/ISUI/ISClothingInsPanel.d.ts]
Exports.ISClothingInsPanel = _G['ISClothingInsPanel']

--[lua/client/XpSystem/ISUI/ISHealthPanel.d.ts]
Exports.HealthPanelAction = _G['HealthPanelAction']
Exports.ISHealthBodyPartListBox = _G['ISHealthBodyPartListBox']
Exports.ISHealthBodyPartPanel = _G['ISHealthBodyPartPanel']
Exports.ISHealthPanel = _G['ISHealthPanel']
Exports.ISNewHealthPanel = _G['ISNewHealthPanel']

--[lua/client/XpSystem/ISUI/ISSkillProgressBar.d.ts]
Exports.ISSkillProgressBar = _G['ISSkillProgressBar']

-- [LUA-PARTIAL:STOP]
return Exports
