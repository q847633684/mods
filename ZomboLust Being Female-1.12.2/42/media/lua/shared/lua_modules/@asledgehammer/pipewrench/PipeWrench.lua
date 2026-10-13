local Exports = {}
-- [JAVA-PARTIAL:START]

function Exports.tonumber(arg) return tonumber(arg) end
function Exports.tostring(arg) return tostring(arg) end
function Exports.global(id) return _G[id] end
function Exports.addEventListener(id, func) Events[id].Add(func) end
function Exports.removeEventListener(id, func) Events[id].Add(func) end
function Exports.AddNoiseToken(arg1,arg2) return AddNoiseToken(arg1,arg2) end
function Exports.AddWorldSound(arg1,arg2,arg3) return AddWorldSound(arg1,arg2,arg3) end
function Exports.InvMngGetItem(arg1,arg2,arg3) return InvMngGetItem(arg1,arg2,arg3) end
function Exports.InvMngRemoveItem(arg1,arg2) return InvMngRemoveItem(arg1,arg2) end
function Exports.proceedFactionMessage(arg1) return proceedFactionMessage(arg1) end
function Exports.processAdminChatMessage(arg1) return processAdminChatMessage(arg1) end
function Exports.processSafehouseMessage(arg1) return processSafehouseMessage(arg1) end
function Exports.SendCommandToServer(arg1) return SendCommandToServer(arg1) end
function Exports.ZombRand(arg1,arg2) return ZombRand(arg1,arg2) end
function Exports.ZombRandBetween(arg1,arg2) return ZombRandBetween(arg1,arg2) end
function Exports.ZombRandFloat(arg1,arg2) return ZombRandFloat(arg1,arg2) end
function Exports.acceptFactionInvite(arg1,arg2) return acceptFactionInvite(arg1,arg2) end
function Exports.acceptSafehouseInvite(arg1,arg2) return acceptSafehouseInvite(arg1,arg2) end
function Exports.acceptTrading(arg1,arg2,arg3) return acceptTrading(arg1,arg2,arg3) end
function Exports.activateJoypadOnSteamDeck() return activateJoypadOnSteamDeck() end
function Exports.activateSteamOverlayToWebPage(arg1) return activateSteamOverlayToWebPage(arg1) end
function Exports.activateSteamOverlayToWorkshop() return activateSteamOverlayToWorkshop() end
function Exports.activateSteamOverlayToWorkshopItem(arg1) return activateSteamOverlayToWorkshopItem(arg1) end
function Exports.activateSteamOverlayToWorkshopUser() return activateSteamOverlayToWorkshopUser() end
function Exports.addAllBurntVehicles() return addAllBurntVehicles() end
function Exports.addAllSmashedVehicles() return addAllSmashedVehicles() end
function Exports.addAllVehicles(arg1) return addAllVehicles(arg1) end
function Exports.addCarCrash() return addCarCrash() end
function Exports.addPhysicsObject() return addPhysicsObject() end
function Exports.addTicket(arg1,arg2,arg3) return addTicket(arg1,arg2,arg3) end
function Exports.addUserlog(arg1,arg2,arg3) return addUserlog(arg1,arg2,arg3) end
function Exports.addVehicle(arg1) return addVehicle(arg1) end
function Exports.addVehicleDebug(arg1,arg2,arg3,arg4) return addVehicleDebug(arg1,arg2,arg3,arg4) end
function Exports.addVirtualZombie(arg1,arg2) return addVirtualZombie(arg1,arg2) end
function Exports.addWarningPoint(arg1,arg2,arg3) return addWarningPoint(arg1,arg2,arg3) end
function Exports.addZombiesInOutfit(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11) return addZombiesInOutfit(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11) end
function Exports.assaultPlayer() return assaultPlayer() end
function Exports.attachTrailerToPlayerVehicle(arg1) return attachTrailerToPlayerVehicle(arg1) end
function Exports.backToSinglePlayer() return backToSinglePlayer() end
function Exports.breakpoint() return breakpoint() end
function Exports.canConnect() return canConnect() end
function Exports.canInviteFriends() return canInviteFriends() end
function Exports.canModifyPlayerScoreboard() return canModifyPlayerScoreboard() end
function Exports.canModifyPlayerStats() return canModifyPlayerStats() end
function Exports.canSeePlayerStats() return canSeePlayerStats() end
function Exports.checkModsNeedUpdate(arg1) return checkModsNeedUpdate(arg1) end
function Exports.checkPlayerCanUseChat(arg1) return checkPlayerCanUseChat(arg1) end
function Exports.checkSaveFileExists(arg1) return checkSaveFileExists(arg1) end
function Exports.checkSaveFolderExists(arg1) return checkSaveFolderExists(arg1) end
function Exports.checkSavePlayerExists() return checkSavePlayerExists() end
function Exports.checkStringPattern(arg1) return checkStringPattern(arg1) end
function Exports.cloneItemType(arg1,arg2) return cloneItemType(arg1,arg2) end
function Exports.configureLighting(arg1) return configureLighting(arg1) end
function Exports.connectToServerStateCallback(arg1) return connectToServerStateCallback(arg1) end
function Exports.connectionManagerLog(arg1,arg2) return connectionManagerLog(arg1,arg2) end
function Exports.copyTable(arg1,arg2) return copyTable(arg1,arg2) end
function Exports.createHordeFromTo(arg1,arg2,arg3,arg4,arg5) return createHordeFromTo(arg1,arg2,arg3,arg4,arg5) end
function Exports.createHordeInAreaTo(arg1,arg2,arg3,arg4,arg5,arg6,arg7) return createHordeInAreaTo(arg1,arg2,arg3,arg4,arg5,arg6,arg7) end
function Exports.createItemTransaction(arg1,arg2,arg3) return createItemTransaction(arg1,arg2,arg3) end
function Exports.createNewScriptItem(arg1,arg2,arg3,arg4,arg5) return createNewScriptItem(arg1,arg2,arg3,arg4,arg5) end
function Exports.createRandomDeadBody(arg1,arg2) return createRandomDeadBody(arg1,arg2) end
function Exports.createRegionFile() return createRegionFile() end
function Exports.createStory(arg1) return createStory(arg1) end
function Exports.createTile(arg1,arg2) return createTile(arg1,arg2) end
function Exports.createWorld(arg1) return createWorld(arg1) end
function Exports.createZombie(arg1,arg2,arg3,arg4,arg5,arg6) return createZombie(arg1,arg2,arg3,arg4,arg5,arg6) end
function Exports.debugFullyStreamedIn(arg1,arg2) return debugFullyStreamedIn(arg1,arg2) end
function Exports.debugLuaTable(arg1,arg2) return debugLuaTable(arg1,arg2) end
function Exports.debugSetRoomType(arg1) return debugSetRoomType(arg1) end
function Exports.deleteAllGameModeSaves(arg1) return deleteAllGameModeSaves(arg1) end
function Exports.deletePlayerSave(arg1) return deletePlayerSave(arg1) end
function Exports.deleteSandboxPreset(arg1) return deleteSandboxPreset(arg1) end
function Exports.deleteSave(arg1) return deleteSave(arg1) end
function Exports.disconnect() return disconnect() end
function Exports.doChallenge(arg1) return doChallenge(arg1) end
function Exports.doKeyPress(arg1) return doKeyPress(arg1) end
function Exports.doLuaDebuggerAction(arg1) return doLuaDebuggerAction(arg1) end
function Exports.doTutorial(arg1) return doTutorial(arg1) end
function Exports.drawOverheadMap(arg1,arg2,arg3,arg4) return drawOverheadMap(arg1,arg2,arg3,arg4) end
function Exports.endFileInput() return endFileInput() end
function Exports.endFileOutput() return endFileOutput() end
function Exports.endHelicopter() return endHelicopter() end
function Exports.endTextFileInput() return endTextFileInput() end
function Exports.executeQuery(arg1,arg2) return executeQuery(arg1,arg2) end
function Exports.fileExists(arg1) return fileExists(arg1) end
function Exports.focusOnTab(arg1) return focusOnTab(arg1) end
function Exports.forceChangeState(arg1) return forceChangeState(arg1) end
function Exports.forceDisconnect() return forceDisconnect() end
function Exports.forceSnowCheck() return forceSnowCheck() end
function Exports.getAbsoluteSaveFolderName(arg1) return getAbsoluteSaveFolderName(arg1) end
function Exports.getAccessLevel() return getAccessLevel() end
function Exports.getActivatedMods() return getActivatedMods() end
function Exports.getAllBeardStyles() return getAllBeardStyles() end
function Exports.getAllDecalNamesForItem(arg1) return getAllDecalNamesForItem(arg1) end
function Exports.getAllHairStyles(arg1) return getAllHairStyles(arg1) end
function Exports.getAllItems() return getAllItems() end
function Exports.getAllItemsForBodyLocation(arg1) return getAllItemsForBodyLocation(arg1) end
function Exports.getAllOutfits(arg1) return getAllOutfits(arg1) end
function Exports.getAllRecipes() return getAllRecipes() end
function Exports.getAllSavedPlayers() return getAllSavedPlayers() end
function Exports.getAllVehicles() return getAllVehicles() end
function Exports.getAmbientStreamManager() return getAmbientStreamManager() end
function Exports.getAnimationViewerState() return getAnimationViewerState() end
function Exports.getAttachmentEditorState() return getAttachmentEditorState() end
function Exports.getBeardStylesInstance() return getBeardStylesInstance() end
function Exports.getBehaviourDebugPlayer() return getBehaviourDebugPlayer() end
function Exports.getButtonCount(arg1) return getButtonCount(arg1) end
function Exports.getCallframeTop(arg1) return getCallframeTop(arg1) end
function Exports.getCameraOffX() return getCameraOffX() end
function Exports.getCameraOffY() return getCameraOffY() end
function Exports.getCell() return getCell() end
function Exports.getClassField(arg1,arg2) return getClassField(arg1,arg2) end
function Exports.getClassFieldVal(arg1,arg2) return getClassFieldVal(arg1,arg2) end
function Exports.getClassFunction(arg1,arg2) return getClassFunction(arg1,arg2) end
function Exports.getClientUsername() return getClientUsername() end
function Exports.getClimateManager() return getClimateManager() end
function Exports.getClimateMoon() return getClimateMoon() end
function Exports.getConnectedPlayers() return getConnectedPlayers() end
function Exports.getControllerAxisCount(arg1) return getControllerAxisCount(arg1) end
function Exports.getControllerAxisValue(arg1,arg2) return getControllerAxisValue(arg1,arg2) end
function Exports.getControllerButtonCount(arg1) return getControllerButtonCount(arg1) end
function Exports.getControllerCount() return getControllerCount() end
function Exports.getControllerDeadZone(arg1,arg2) return getControllerDeadZone(arg1,arg2) end
function Exports.getControllerGUID(arg1) return getControllerGUID(arg1) end
function Exports.getControllerName(arg1) return getControllerName(arg1) end
function Exports.getControllerPovX(arg1) return getControllerPovX(arg1) end
function Exports.getControllerPovY(arg1) return getControllerPovY(arg1) end
function Exports.getCore() return getCore() end
function Exports.getCoroutineCallframeStack(arg1,arg2) return getCoroutineCallframeStack(arg1,arg2) end
function Exports.getCoroutineObjStack(arg1,arg2) return getCoroutineObjStack(arg1,arg2) end
function Exports.getCoroutineObjStackWithBase(arg1,arg2) return getCoroutineObjStackWithBase(arg1,arg2) end
function Exports.getCoroutineTop(arg1) return getCoroutineTop(arg1) end
function Exports.getCurrentCoroutine() return getCurrentCoroutine() end
function Exports.getCurrentUserProfileName() return getCurrentUserProfileName() end
function Exports.getCurrentUserSteamID() return getCurrentUserSteamID() end
function Exports.getDBSchema() return getDBSchema() end
function Exports.getDebug() return getDebug() end
function Exports.getDebugOptions() return getDebugOptions() end
function Exports.getDirectionTo(arg1,arg2) return getDirectionTo(arg1,arg2) end
function Exports.getEditVehicleState() return getEditVehicleState() end
function Exports.getErosion() return getErosion() end
function Exports.getEvolvedRecipes() return getEvolvedRecipes() end
function Exports.getFMODSoundBank() return getFMODSoundBank() end
function Exports.getFileInput(arg1) return getFileInput(arg1) end
function Exports.getFileOutput(arg1) return getFileOutput(arg1) end
function Exports.getFileReader(arg1,arg2) return getFileReader(arg1,arg2) end
function Exports.getFileSeparator() return getFileSeparator() end
function Exports.getFileWriter(arg1,arg2,arg3) return getFileWriter(arg1,arg2,arg3) end
function Exports.getFilenameOfCallframe(arg1) return getFilenameOfCallframe(arg1) end
function Exports.getFilenameOfClosure(arg1) return getFilenameOfClosure(arg1) end
function Exports.getFirstLineOfClosure(arg1) return getFirstLineOfClosure(arg1) end
function Exports.getFriendsList() return getFriendsList() end
function Exports.getFullSaveDirectoryTable() return getFullSaveDirectoryTable() end
function Exports.getGameClient() return getGameClient() end
function Exports.getGameFilesInput(arg1) return getGameFilesInput(arg1) end
function Exports.getGameFilesTextInput(arg1) return getGameFilesTextInput(arg1) end
function Exports.getGameSpeed() return getGameSpeed() end
function Exports.getGameTime() return getGameTime() end
function Exports.getGameVersion() return getGameVersion() end
function Exports.getGametimeTimestamp() return getGametimeTimestamp() end
function Exports.getHairStylesInstance() return getHairStylesInstance() end
function Exports.getHourMinute() return getHourMinute() end
function Exports.getIsoMarkers() return getIsoMarkers() end
function Exports.getItemNameFromFullType(arg1) return getItemNameFromFullType(arg1) end
function Exports.getItemText(arg1) return getItemText(arg1) end
function Exports.getJoypadAButton(arg1) return getJoypadAButton(arg1) end
function Exports.getJoypadAimingAxisX(arg1) return getJoypadAimingAxisX(arg1) end
function Exports.getJoypadAimingAxisY(arg1) return getJoypadAimingAxisY(arg1) end
function Exports.getJoypadBButton(arg1) return getJoypadBButton(arg1) end
function Exports.getJoypadBackButton(arg1) return getJoypadBackButton(arg1) end
function Exports.getJoypadLBumper(arg1) return getJoypadLBumper(arg1) end
function Exports.getJoypadLeftStickButton(arg1) return getJoypadLeftStickButton(arg1) end
function Exports.getJoypadMovementAxisX(arg1) return getJoypadMovementAxisX(arg1) end
function Exports.getJoypadMovementAxisY(arg1) return getJoypadMovementAxisY(arg1) end
function Exports.getJoypadRBumper(arg1) return getJoypadRBumper(arg1) end
function Exports.getJoypadRightStickButton(arg1) return getJoypadRightStickButton(arg1) end
function Exports.getJoypadStartButton(arg1) return getJoypadStartButton(arg1) end
function Exports.getJoypadXButton(arg1) return getJoypadXButton(arg1) end
function Exports.getJoypadYButton(arg1) return getJoypadYButton(arg1) end
function Exports.getKeyCode(arg1) return getKeyCode(arg1) end
function Exports.getKeyName(arg1) return getKeyName(arg1) end
function Exports.getLastPlayedDate(arg1) return getLastPlayedDate(arg1) end
function Exports.getLastStandPlayerFileNames() return getLastStandPlayerFileNames() end
function Exports.getLastStandPlayersDirectory() return getLastStandPlayersDirectory() end
function Exports.getLatestSave() return getLatestSave() end
function Exports.getLineNumber(arg1) return getLineNumber(arg1) end
function Exports.getLoadedLua(arg1) return getLoadedLua(arg1) end
function Exports.getLoadedLuaCount() return getLoadedLuaCount() end
function Exports.getLocalVarCount(arg1) return getLocalVarCount(arg1) end
function Exports.getLocalVarName(arg1,arg2) return getLocalVarName(arg1,arg2) end
function Exports.getLocalVarStack(arg1,arg2) return getLocalVarStack(arg1,arg2) end
function Exports.getLotDirectories() return getLotDirectories() end
function Exports.getLuaDebuggerErrorCount() return getLuaDebuggerErrorCount() end
function Exports.getLuaDebuggerErrors() return getLuaDebuggerErrors() end
function Exports.getMPStatus() return getMPStatus() end
function Exports.getMapDirectoryTable() return getMapDirectoryTable() end
function Exports.getMapFoldersForMod(arg1) return getMapFoldersForMod(arg1) end
function Exports.getMapInfo(arg1) return getMapInfo(arg1) end
function Exports.getMaxActivePlayers() return getMaxActivePlayers() end
function Exports.getMaxPlayers() return getMaxPlayers() end
function Exports.getMethodParameter(arg1,arg2) return getMethodParameter(arg1,arg2) end
function Exports.getMethodParameterCount(arg1) return getMethodParameterCount(arg1) end
function Exports.getModDirectoryTable() return getModDirectoryTable() end
function Exports.getModFileReader(arg1,arg2,arg3) return getModFileReader(arg1,arg2,arg3) end
function Exports.getModFileWriter(arg1,arg2,arg3,arg4) return getModFileWriter(arg1,arg2,arg3,arg4) end
function Exports.getModInfo(arg1) return getModInfo(arg1) end
function Exports.getModInfoByID(arg1) return getModInfoByID(arg1) end
function Exports.getMods() return getMods() end
function Exports.getMouseX() return getMouseX() end
function Exports.getMouseXScaled() return getMouseXScaled() end
function Exports.getMouseY() return getMouseY() end
function Exports.getMouseYScaled() return getMouseYScaled() end
function Exports.getMyDocumentFolder() return getMyDocumentFolder() end
function Exports.getNumActivePlayers() return getNumActivePlayers() end
function Exports.getNumClassFields(arg1) return getNumClassFields(arg1) end
function Exports.getNumClassFunctions(arg1) return getNumClassFunctions(arg1) end
function Exports.getOnlinePlayers() return getOnlinePlayers() end
function Exports.getOnlineUsername() return getOnlineUsername() end
function Exports.getPacketCounts(arg1) return getPacketCounts(arg1) end
function Exports.getPerformance() return getPerformance() end
function Exports.getPlayer() return getPlayer() end
function Exports.getPlayerByOnlineID(arg1) return getPlayerByOnlineID(arg1) end
function Exports.getPlayerFromUsername(arg1) return getPlayerFromUsername(arg1) end
function Exports.getPlayerInfo(arg1) return getPlayerInfo(arg1) end
function Exports.getPlayerScreenHeight(arg1) return getPlayerScreenHeight(arg1) end
function Exports.getPlayerScreenLeft(arg1) return getPlayerScreenLeft(arg1) end
function Exports.getPlayerScreenTop(arg1) return getPlayerScreenTop(arg1) end
function Exports.getPlayerScreenWidth(arg1) return getPlayerScreenWidth(arg1) end
function Exports.getPublicServersList() return getPublicServersList() end
function Exports.getPuddlesManager() return getPuddlesManager() end
function Exports.getRadioAPI() return getRadioAPI() end
function Exports.getRadioText(arg1) return getRadioText(arg1) end
function Exports.getRadioTranslators(arg1) return getRadioTranslators(arg1) end
function Exports.getRandomUUID() return getRandomUUID() end
function Exports.getRecipeDisplayName(arg1) return getRecipeDisplayName(arg1) end
function Exports.getReconnectCountdownTimer() return getReconnectCountdownTimer() end
function Exports.getRenderer() return getRenderer() end
function Exports.getSLSoundManager() return getSLSoundManager() end
function Exports.getSandboxFileWriter(arg1,arg2,arg3) return getSandboxFileWriter(arg1,arg2,arg3) end
function Exports.getSandboxOptions() return getSandboxOptions() end
function Exports.getSandboxPresets() return getSandboxPresets() end
function Exports.getSaveDirectory(arg1) return getSaveDirectory(arg1) end
function Exports.getSaveDirectoryTable() return getSaveDirectoryTable() end
function Exports.getSaveInfo(arg1) return getSaveInfo(arg1) end
function Exports.getSaveName(arg1) return getSaveName(arg1) end
function Exports.getScriptManager() return getScriptManager() end
function Exports.getSearchMode() return getSearchMode() end
function Exports.getServerAddressFromArgs() return getServerAddressFromArgs() end
function Exports.getServerIP() return getServerIP() end
function Exports.getServerList() return getServerList() end
function Exports.getServerListFile() return getServerListFile() end
function Exports.getServerModData() return getServerModData() end
function Exports.getServerName() return getServerName() end
function Exports.getServerOptions() return getServerOptions() end
function Exports.getServerPasswordFromArgs() return getServerPasswordFromArgs() end
function Exports.getServerPort() return getServerPort() end
function Exports.getServerSavedWorldVersion(arg1) return getServerSavedWorldVersion(arg1) end
function Exports.getServerSettingsManager() return getServerSettingsManager() end
function Exports.getServerSpawnRegions() return getServerSpawnRegions() end
function Exports.getServerStatistic() return getServerStatistic() end
function Exports.getServerStatisticEnable() return getServerStatisticEnable() end
function Exports.getShortenedFilename(arg1) return getShortenedFilename(arg1) end
function Exports.getSleepingEvent() return getSleepingEvent() end
function Exports.getSoundManager() return getSoundManager() end
function Exports.getSpecificPlayer(arg1) return getSpecificPlayer(arg1) end
function Exports.getSprite(arg1) return getSprite(arg1) end
function Exports.getSpriteManager(arg1) return getSpriteManager(arg1) end
function Exports.getSquare(arg1,arg2,arg3) return getSquare(arg1,arg2,arg3) end
function Exports.getMPStatistics() return getMPStatistics() end
function Exports.getSteamAvatarFromSteamID(arg1) return getSteamAvatarFromSteamID(arg1) end
function Exports.getSteamAvatarFromUsername(arg1) return getSteamAvatarFromUsername(arg1) end
function Exports.getSteamIDFromUsername(arg1) return getSteamIDFromUsername(arg1) end
function Exports.getSteamModeActive() return getSteamModeActive() end
function Exports.getSteamProfileNameFromSteamID(arg1) return getSteamProfileNameFromSteamID(arg1) end
function Exports.getSteamProfileNameFromUsername(arg1) return getSteamProfileNameFromUsername(arg1) end
function Exports.getSteamScoreboard() return getSteamScoreboard() end
function Exports.getSteamWorkshopItemIDs() return getSteamWorkshopItemIDs() end
function Exports.getSteamWorkshopItemMods(arg1) return getSteamWorkshopItemMods(arg1) end
function Exports.getSteamWorkshopStagedItems() return getSteamWorkshopStagedItems() end
function Exports.getTableResult(arg1,arg2) return getTableResult(arg1,arg2) end
function Exports.getText(arg1,arg2,arg3,arg4,arg5) return getText(arg1,arg2,arg3,arg4,arg5) end
function Exports.getTextManager() return getTextManager() end
function Exports.getTextMediaEN(arg1) return getTextMediaEN(arg1) end
function Exports.getTextOrNull(arg1,arg2,arg3,arg4,arg5) return getTextOrNull(arg1,arg2,arg3,arg4,arg5) end
function Exports.getTexture(arg1) return getTexture(arg1) end
function Exports.getTextureFromSaveDir(arg1,arg2) return getTextureFromSaveDir(arg1,arg2) end
function Exports.getTickets(arg1) return getTickets(arg1) end
function Exports.getTimeInMillis() return getTimeInMillis() end
function Exports.getTimestamp() return getTimestamp() end
function Exports.getTimestampMs() return getTimestampMs() end
function Exports.getTranslatorCredits(arg1) return getTranslatorCredits(arg1) end
function Exports.getUrlInputStream(arg1) return getUrlInputStream(arg1) end
function Exports.getVehicleById(arg1) return getVehicleById(arg1) end
function Exports.getVehicleInfo(arg1) return getVehicleInfo(arg1) end
function Exports.getVehicleZoneAt(arg1,arg2,arg3) return getVehicleZoneAt(arg1,arg2,arg3) end
function Exports.getWorld() return getWorld() end
function Exports.getWorldMarkers() return getWorldMarkers() end
function Exports.getWorldSoundManager() return getWorldSoundManager() end
function Exports.getZombieInfo(arg1) return getZombieInfo(arg1) end
function Exports.getZomboidRadio() return getZomboidRadio() end
function Exports.getZone(arg1,arg2,arg3) return getZone(arg1,arg2,arg3) end
function Exports.getZones(arg1,arg2,arg3) return getZones(arg1,arg2,arg3) end
function Exports.hasBreakpoint(arg1,arg2) return hasBreakpoint(arg1,arg2) end
function Exports.hasDataBreakpoint(arg1,arg2) return hasDataBreakpoint(arg1,arg2) end
function Exports.hasDataReadBreakpoint(arg1,arg2) return hasDataReadBreakpoint(arg1,arg2) end
function Exports.initUISystem() return initUISystem() end
function Exports.instanceItem(arg1) return instanceItem(arg1) end
function Exports._instanceof_(arg1,arg2) return instanceof(arg1,arg2) end
function Exports.inviteFriend(arg1) return inviteFriend(arg1) end
function Exports.is64bit() return is64bit() end
function Exports.isAccessLevel(arg1) return isAccessLevel(arg1) end
function Exports.isAdmin() return isAdmin() end
function Exports.isAltKeyDown() return isAltKeyDown() end
function Exports.isClient() return isClient() end
function Exports.isControllerConnected(arg1) return isControllerConnected(arg1) end
function Exports.isCoopHost() return isCoopHost() end
function Exports.isCtrlKeyDown() return isCtrlKeyDown() end
function Exports.isCurrentExecutionPoint(arg1,arg2) return isCurrentExecutionPoint(arg1,arg2) end
function Exports.isDebugEnabled() return isDebugEnabled() end
function Exports.isDemo() return isDemo() end
function Exports.isDesktopOpenSupported() return isDesktopOpenSupported() end
function Exports.isFloatingGamepadTextInputVisible() return isFloatingGamepadTextInputVisible() end
function Exports.isGamePaused() return isGamePaused() end
function Exports.isIngameState() return isIngameState() end
function Exports.isItemTransactionConsistent(arg1,arg2,arg3) return isItemTransactionConsistent(arg1,arg2,arg3) end
function Exports.isJoypadConnected(arg1) return isJoypadConnected(arg1) end
function Exports.isJoypadDown(arg1) return isJoypadDown(arg1) end
function Exports.isJoypadLBPressed(arg1) return isJoypadLBPressed(arg1) end
function Exports.isJoypadLTPressed(arg1) return isJoypadLTPressed(arg1) end
function Exports.isJoypadLeft(arg1) return isJoypadLeft(arg1) end
function Exports.isJoypadLeftStickButtonPressed(arg1) return isJoypadLeftStickButtonPressed(arg1) end
function Exports.isJoypadPressed(arg1,arg2) return isJoypadPressed(arg1,arg2) end
function Exports.isJoypadRBPressed(arg1) return isJoypadRBPressed(arg1) end
function Exports.isJoypadRTPressed(arg1) return isJoypadRTPressed(arg1) end
function Exports.isJoypadRight(arg1) return isJoypadRight(arg1) end
function Exports.isJoypadRightStickButtonPressed(arg1) return isJoypadRightStickButtonPressed(arg1) end
function Exports.isJoypadUp(arg1) return isJoypadUp(arg1) end
function Exports.isKeyDown(arg1) return isKeyDown(arg1) end
function Exports.isKeyPressed(arg1) return isKeyPressed(arg1) end
function Exports.isModActive(arg1) return isModActive(arg1) end
function Exports.isMouseButtonDown(arg1) return isMouseButtonDown(arg1) end
function Exports.isPublicServerListAllowed() return isPublicServerListAllowed() end
function Exports.isServer() return isServer() end
function Exports.isServerSoftReset() return isServerSoftReset() end
function Exports.isShiftKeyDown() return isShiftKeyDown() end
function Exports.isShowConnectionInfo() return isShowConnectionInfo() end
function Exports.isShowPingInfo() return isShowPingInfo() end
function Exports.isShowServerInfo() return isShowServerInfo() end
function Exports.isSoundPlaying(arg1) return isSoundPlaying(arg1) end
function Exports.isSteamOverlayEnabled() return isSteamOverlayEnabled() end
function Exports.isSteamRunningOnSteamDeck() return isSteamRunningOnSteamDeck() end
function Exports.isSystemLinux() return isSystemLinux() end
function Exports.isSystemMacOS() return isSystemMacOS() end
function Exports.isSystemWindows() return isSystemWindows() end
function Exports.istype(arg1,arg2) return istype(arg1,arg2) end
function Exports.isValidSteamID(arg1) return isValidSteamID(arg1) end
function Exports.isValidUserName(arg1) return isValidUserName(arg1) end
function Exports.isXBOXController() return isXBOXController() end
function Exports.isoRegionsRenderer() return isoRegionsRenderer() end
function Exports.isoToScreenX(arg1,arg2,arg3,arg4) return isoToScreenX(arg1,arg2,arg3,arg4) end
function Exports.isoToScreenY(arg1,arg2,arg3,arg4) return isoToScreenY(arg1,arg2,arg3,arg4) end
function Exports.loadSkinnedZomboidModel(arg1,arg2,arg3) return loadSkinnedZomboidModel(arg1,arg2,arg3) end
function Exports.loadStaticZomboidModel(arg1,arg2,arg3) return loadStaticZomboidModel(arg1,arg2,arg3) end
function Exports.loadVehicleModel(arg1,arg2,arg3) return loadVehicleModel(arg1,arg2,arg3) end
function Exports.loadZomboidModel(arg1,arg2,arg3,arg4,arg5) return loadZomboidModel(arg1,arg2,arg3,arg4,arg5) end
function Exports.localVarName(arg1,arg2) return localVarName(arg1,arg2) end
function Exports.luaDebug() return luaDebug() end
function Exports.manipulateSavefile(arg1,arg2) return manipulateSavefile(arg1,arg2) end
function Exports.moduleDotType(arg1,arg2) return moduleDotType(arg1,arg2) end
function Exports.openUrl(arg1) return openUrl(arg1) end
function Exports.pauseSoundAndMusic() return pauseSoundAndMusic() end
function Exports.ping(arg1,arg2,arg3,arg4) return ping(arg1,arg2,arg3,arg4) end
function Exports.playServerSound(arg1,arg2) return playServerSound(arg1,arg2) end
function Exports.proceedPM(arg1) return proceedPM(arg1) end
function Exports.processGeneralMessage(arg1) return processGeneralMessage(arg1) end
function Exports.processSayMessage(arg1) return processSayMessage(arg1) end
function Exports.processShoutMessage(arg1) return processShoutMessage(arg1) end
function Exports.querySteamWorkshopItemDetails(arg1,arg2,arg3) return querySteamWorkshopItemDetails(arg1,arg2,arg3) end
function Exports.queueCharEvent(arg1) return queueCharEvent(arg1) end
function Exports.queueKeyEvent(arg1) return queueKeyEvent(arg1) end
function Exports.rainConfig(arg1,arg2) return rainConfig(arg1,arg2) end
function Exports.reactivateJoypadAfterResetLua() return reactivateJoypadAfterResetLua() end
function Exports.refreshAnimSets(arg1) return refreshAnimSets(arg1) end
function Exports.reloadActionGroups() return reloadActionGroups() end
function Exports.reloadControllerConfigFiles() return reloadControllerConfigFiles() end
function Exports.reloadEngineRPM() return reloadEngineRPM() end
function Exports.reloadLuaFile(arg1) return reloadLuaFile(arg1) end
function Exports.reloadModelsMatching(arg1) return reloadModelsMatching(arg1) end
function Exports.reloadServerLuaFile(arg1) return reloadServerLuaFile(arg1) end
function Exports.reloadSoundFiles() return reloadSoundFiles() end
function Exports.reloadVehicleTextures(arg1) return reloadVehicleTextures(arg1) end
function Exports.reloadVehicles() return reloadVehicles() end
function Exports.removeItemTransaction(arg1,arg2,arg3) return removeItemTransaction(arg1,arg2,arg3) end
function Exports.removeTicket(arg1) return removeTicket(arg1) end
function Exports.removeUserlog(arg1,arg2,arg3) return removeUserlog(arg1,arg2,arg3) end
function Exports.renameSavefile(arg1,arg2,arg3) return renameSavefile(arg1,arg2,arg3) end
function Exports.renderIsoCircle(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9) return renderIsoCircle(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9) end
function Exports.replaceWith(arg1,arg2,arg3) return replaceWith(arg1,arg2,arg3) end
function Exports.requestPacketCounts() return requestPacketCounts() end
function Exports.requestTrading(arg1,arg2) return requestTrading(arg1,arg2) end
function Exports.requestUserlog(arg1) return requestUserlog(arg1) end
function Exports.require(arg1) return require(arg1) end
function Exports.resetRegionFile() return resetRegionFile() end
function Exports.resumeSoundAndMusic() return resumeSoundAndMusic() end
function Exports.revertToKeyboardAndMouse() return revertToKeyboardAndMouse() end
function Exports.sanitizeWorldName(arg1) return sanitizeWorldName(arg1) end
function Exports.save(arg1) return save(arg1) end
function Exports.saveControllerSettings(arg1) return saveControllerSettings(arg1) end
function Exports.saveGame() return saveGame() end
function Exports.saveModsFile() return saveModsFile() end
function Exports.scoreboardUpdate() return scoreboardUpdate() end
function Exports.screenToIsoX(arg1,arg2,arg3,arg4) return screenToIsoX(arg1,arg2,arg3,arg4) end
function Exports.screenToIsoY(arg1,arg2,arg3,arg4) return screenToIsoY(arg1,arg2,arg3,arg4) end
function Exports.sendBandage(arg1,arg2,arg3,arg4,arg5,arg6) return sendBandage(arg1,arg2,arg3,arg4,arg5,arg6) end
function Exports.sendCataplasm(arg1,arg2,arg3,arg4,arg5) return sendCataplasm(arg1,arg2,arg3,arg4,arg5) end
function Exports.sendCleanBurn(arg1,arg2,arg3,arg4) return sendCleanBurn(arg1,arg2,arg3,arg4) end
function Exports.sendClientCommand(arg1,arg2,arg3,arg4) return sendClientCommand(arg1,arg2,arg3,arg4) end
function Exports.sendClothing(arg1) return sendClothing(arg1) end
function Exports.sendDisinfect(arg1,arg2,arg3,arg4) return sendDisinfect(arg1,arg2,arg3,arg4) end
function Exports.sendFactionInvite(arg1,arg2,arg3) return sendFactionInvite(arg1,arg2,arg3) end
function Exports.sendItemListNet(arg1,arg2,arg3,arg4,arg5) return sendItemListNet(arg1,arg2,arg3,arg4,arg5) end
function Exports.sendItemsInContainer(arg1,arg2) return sendItemsInContainer(arg1,arg2) end
function Exports.sendPersonalColor(arg1) return sendPersonalColor(arg1) end
function Exports.sendPing() return sendPing() end
function Exports.sendPlayerExtraInfo(arg1) return sendPlayerExtraInfo(arg1) end
function Exports.sendPlayerStatsChange(arg1) return sendPlayerStatsChange(arg1) end
function Exports.sendRemoveBullet(arg1,arg2,arg3) return sendRemoveBullet(arg1,arg2,arg3) end
function Exports.sendRemoveGlass(arg1,arg2,arg3,arg4) return sendRemoveGlass(arg1,arg2,arg3,arg4) end
function Exports.sendRequestInventory(arg1) return sendRequestInventory(arg1) end
function Exports.sendSafehouseInvite(arg1,arg2,arg3) return sendSafehouseInvite(arg1,arg2,arg3) end
function Exports.sendServerCommand(arg1,arg2,arg3,arg4) return sendServerCommand(arg1,arg2,arg3,arg4) end
function Exports.sendSplint(arg1,arg2,arg3,arg4,arg5) return sendSplint(arg1,arg2,arg3,arg4,arg5) end
function Exports.sendStitch(arg1,arg2,arg3,arg4,arg5) return sendStitch(arg1,arg2,arg3,arg4,arg5) end
function Exports.sendSwitchSeat(arg1,arg2,arg3,arg4) return sendSwitchSeat(arg1,arg2,arg3,arg4) end
function Exports.sendVisual(arg1) return sendVisual(arg1) end
function Exports.serverConnect(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) return serverConnect(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) end
function Exports.serverConnectCoop(arg1) return serverConnectCoop(arg1) end
function Exports.serverFileExists(arg1) return serverFileExists(arg1) end
function Exports.setActivePlayer(arg1) return setActivePlayer(arg1) end
function Exports.setAdmin() return setAdmin() end
function Exports.setAggroTarget(arg1,arg2,arg3) return setAggroTarget(arg1,arg2,arg3) end
function Exports.setBehaviorStep(arg1) return setBehaviorStep(arg1) end
function Exports.setControllerDeadZone(arg1,arg2,arg3) return setControllerDeadZone(arg1,arg2,arg3) end
function Exports.setDebugToggleControllerPluggedIn(arg1) return setDebugToggleControllerPluggedIn(arg1) end
function Exports.setGameSpeed(arg1) return setGameSpeed(arg1) end
function Exports.setModelMetaData(arg1,arg2,arg3,arg4,arg5) return setModelMetaData(arg1,arg2,arg3,arg4,arg5) end
function Exports.setMouseXY(arg1,arg2) return setMouseXY(arg1,arg2) end
function Exports.setPlayerJoypad(arg1,arg2,arg3,arg4) return setPlayerJoypad(arg1,arg2,arg3,arg4) end
function Exports.setPlayerMouse(arg1) return setPlayerMouse(arg1) end
function Exports.setPlayerMovementActive(arg1,arg2) return setPlayerMovementActive(arg1,arg2) end
function Exports.setProgressBarValue(arg1,arg2) return setProgressBarValue(arg1,arg2) end
function Exports.setPuddles(arg1) return setPuddles(arg1) end
function Exports.setSavefilePlayer1(arg1,arg2,arg3) return setSavefilePlayer1(arg1,arg2,arg3) end
function Exports.setServerStatisticEnable(arg1) return setServerStatisticEnable(arg1) end
function Exports.setShowConnectionInfo(arg1) return setShowConnectionInfo(arg1) end
function Exports.setShowPausedMessage(arg1) return setShowPausedMessage(arg1) end
function Exports.setShowPingInfo(arg1) return setShowPingInfo(arg1) end
function Exports.setShowServerInfo(arg1) return setShowServerInfo(arg1) end
function Exports.showAnimationViewer() return showAnimationViewer() end
function Exports.showAttachmentEditor() return showAttachmentEditor() end
function Exports.showChunkDebugger() return showChunkDebugger() end
function Exports.showFolderInDesktop(arg1) return showFolderInDesktop(arg1) end
function Exports.showGlobalObjectDebugger() return showGlobalObjectDebugger() end
function Exports.showSteamFloatingGamepadTextInput(arg1,arg2,arg3,arg4,arg5) return showSteamFloatingGamepadTextInput(arg1,arg2,arg3,arg4,arg5) end
function Exports.showSteamGamepadTextInput(arg1,arg2,arg3,arg4,arg5) return showSteamGamepadTextInput(arg1,arg2,arg3,arg4,arg5) end
function Exports.showVehicleEditor(arg1) return showVehicleEditor(arg1) end
function Exports.showWorldMapEditor(arg1) return showWorldMapEditor(arg1) end
function Exports.showWrongChatTabMessage(arg1,arg2,arg3) return showWrongChatTabMessage(arg1,arg2,arg3) end
function Exports.sledgeDestroy(arg1) return sledgeDestroy(arg1) end
function Exports.spawnHorde(arg1,arg2,arg3,arg4,arg5,arg6) return spawnHorde(arg1,arg2,arg3,arg4,arg5,arg6) end
function Exports.spawnpointsExistsForMod(arg1,arg2) return spawnpointsExistsForMod(arg1,arg2) end
function Exports.steamGetInternetServerDetails(arg1) return steamGetInternetServerDetails(arg1) end
function Exports.steamReleaseInternetServersRequest() return steamReleaseInternetServersRequest() end
function Exports.steamGetInternetServersCount() return steamGetInternetServersCount() end
function Exports.steamRequestInternetServersList() return steamRequestInternetServersList() end
function Exports.steamRequestServerDetails(arg1,arg2) return steamRequestServerDetails(arg1,arg2) end
function Exports.steamRequestServerRules(arg1,arg2) return steamRequestServerRules(arg1,arg2) end
function Exports.stopPing() return stopPing() end
function Exports.stopSound(arg1) return stopSound(arg1) end
function Exports.tabToX(arg1,arg2) return tabToX(arg1,arg2) end
function Exports.takeScreenshot(arg1) return takeScreenshot(arg1) end
function Exports.testHelicopter() return testHelicopter() end
function Exports.testSound() return testSound() end
function Exports.timSort(arg1,arg2) return timSort(arg1,arg2) end
function Exports.toInt(arg1) return toInt(arg1) end
function Exports.toggleBreakOnChange(arg1,arg2) return toggleBreakOnChange(arg1,arg2) end
function Exports.toggleBreakOnRead(arg1,arg2) return toggleBreakOnRead(arg1,arg2) end
function Exports.toggleBreakpoint(arg1,arg2) return toggleBreakpoint(arg1,arg2) end
function Exports.toggleModActive(arg1,arg2) return toggleModActive(arg1,arg2) end
function Exports.toggleSafetyServer(arg1) return toggleSafetyServer(arg1) end
function Exports.toggleVehicleRenderToTexture() return toggleVehicleRenderToTexture() end
function Exports.tradingUISendAddItem(arg1,arg2,arg3) return tradingUISendAddItem(arg1,arg2,arg3) end
function Exports.tradingUISendRemoveItem(arg1,arg2,arg3) return tradingUISendRemoveItem(arg1,arg2,arg3) end
function Exports.tradingUISendUpdateState(arg1,arg2,arg3) return tradingUISendUpdateState(arg1,arg2,arg3) end
function Exports.transformIntoKahluaTable(arg1) return transformIntoKahluaTable(arg1) end
function Exports.translatePointXInOverheadMapToWindow(arg1,arg2,arg3,arg4) return translatePointXInOverheadMapToWindow(arg1,arg2,arg3,arg4) end
function Exports.translatePointXInOverheadMapToWorld(arg1,arg2,arg3,arg4) return translatePointXInOverheadMapToWorld(arg1,arg2,arg3,arg4) end
function Exports.translatePointYInOverheadMapToWindow(arg1,arg2,arg3,arg4) return translatePointYInOverheadMapToWindow(arg1,arg2,arg3,arg4) end
function Exports.translatePointYInOverheadMapToWorld(arg1,arg2,arg3,arg4) return translatePointYInOverheadMapToWorld(arg1,arg2,arg3,arg4) end
function Exports.triggerEvent(arg1,arg2,arg3,arg4,arg5) return triggerEvent(arg1,arg2,arg3,arg4,arg5) end
function Exports.updateChatSettings(arg1,arg2,arg3) return updateChatSettings(arg1,arg2,arg3) end
function Exports.updateFire() return updateFire() end
function Exports.useStaticErosionRand(arg1) return useStaticErosionRand(arg1) end
function Exports.useTextureFiltering(arg1) return useTextureFiltering(arg1) end
function Exports.wasKeyDown(arg1) return wasKeyDown(arg1) end
function Exports.wasMouseActiveMoreRecentlyThanJoypad() return wasMouseActiveMoreRecentlyThanJoypad() end
function Exports.writeLog(arg1,arg2) return writeLog(arg1,arg2) end
function Exports.zpopClearZombies(arg1,arg2) return zpopClearZombies(arg1,arg2) end
function Exports.zpopNewRenderer() return zpopNewRenderer() end
function Exports.zpopSpawnNow(arg1,arg2) return zpopSpawnNow(arg1,arg2) end
function Exports.zpopSpawnTimeToZero(arg1,arg2) return zpopSpawnTimeToZero(arg1,arg2) end
Exports.AStarPathFinderResult = _G['AStarPathFinderResult']
Exports.AbstractStyle = _G['AbstractStyle']
Exports.ActionContext = _G['ActionContext']
Exports.ActionGroup = _G['ActionGroup']
Exports.ActionProgressBar = _G['ActionProgressBar']
Exports.ActionState = _G['ActionState']
Exports.ActionStateSnapshot = _G['ActionStateSnapshot']
Exports.ActiveMods = _G['ActiveMods']
Exports.Add = _G['Add']
Exports.AdvancedAnimator = _G['AdvancedAnimator']
Exports.AirFront = _G['AirFront']
Exports.AlarmClock = _G['AlarmClock']
Exports.AlarmClockClothing = _G['AlarmClockClothing']
Exports.Allocator = _G['Allocator']
Exports.AlphaOp = _G['AlphaOp']
Exports.Alternate = _G['Alternate']
Exports.Ambient = _G['Ambient']
Exports.AmbientLoop = _G['AmbientLoop']
Exports.AmbientSoundEffect = _G['AmbientSoundEffect']
Exports.AmbientSoundLogic = _G['AmbientSoundLogic']
Exports.AmbientStreamManager = _G['AmbientStreamManager']
Exports.AngelCodeFont = _G['AngelCodeFont']
Exports.Anim = _G['Anim']
Exports.AnimBoneWeight = _G['AnimBoneWeight']
Exports.AnimEvent = _G['AnimEvent']
Exports.AnimEventTime = _G['AnimEventTime']
Exports.AnimLayer = _G['AnimLayer']
Exports.AnimNode = _G['AnimNode']
Exports.AnimState = _G['AnimState']
Exports.AnimTimer = _G['AnimTimer']
Exports.AnimTrackSampler = _G['AnimTrackSampler']
Exports.AnimTransition = _G['AnimTransition']
Exports.AnimationAsset = _G['AnimationAsset']
Exports.AnimationAssetParams = _G['AnimationAssetParams']
Exports.AnimationBoneBinding = _G['AnimationBoneBinding']
Exports.AnimationClip = _G['AnimationClip']
Exports.AnimationMultiTrack = _G['AnimationMultiTrack']
Exports.AnimationPlayer = _G['AnimationPlayer']
Exports.AnimationPlayerRecorder = _G['AnimationPlayerRecorder']
Exports.AnimationSet = _G['AnimationSet']
Exports.AnimationTrack = _G['AnimationTrack']
Exports.AnimationVariableHandle = _G['AnimationVariableHandle']
Exports.AnimationVariableSlotCallbackBool = _G['AnimationVariableSlotCallbackBool']
Exports.AnimationVariableSlotCallbackFloat = _G['AnimationVariableSlotCallbackFloat']
Exports.AnimationVariableSlotCallbackInt = _G['AnimationVariableSlotCallbackInt']
Exports.AnimationVariableSlotCallbackString = _G['AnimationVariableSlotCallbackString']
Exports.AnimationVariableSource = _G['AnimationVariableSource']
Exports.AnimationVariableType = _G['AnimationVariableType']
Exports.AnimationViewerState = _G['AnimationViewerState']
Exports.AnimationsMesh = _G['AnimationsMesh']
Exports.AnimatorDebugMonitor = _G['AnimatorDebugMonitor']
Exports.Area = _G['Area']
Exports.ArrayList = _G['ArrayList']
Exports.Asset = _G['Asset']
Exports.AssetManager = _G['AssetManager']
Exports.AssetManagerTable = _G['AssetManagerTable']
Exports.AssetManagers = _G['AssetManagers']
Exports.AssetParams = _G['AssetParams']
Exports.AssetPath = _G['AssetPath']
Exports.AssetStateObserver = _G['AssetStateObserver']
Exports.AssetTable = _G['AssetTable']
Exports.AssetType = _G['AssetType']
Exports.AttachedItem = _G['AttachedItem']
Exports.AttachedItems = _G['AttachedItems']
Exports.AttachedLocation = _G['AttachedLocation']
Exports.AttachedLocationGroup = _G['AttachedLocationGroup']
Exports.AttachedLocations = _G['AttachedLocations']
Exports.AttachmentEditorState = _G['AttachmentEditorState']
Exports.AttackState = _G['AttackState']
Exports.AttackVars = _G['AttackVars']
Exports.Authorization = _G['Authorization']
Exports.BSFurnace = _G['BSFurnace']
Exports.BarricadeAble = _G['BarricadeAble']
Exports.BaseAction = _G['BaseAction']
Exports.BaseAmbientStreamManager = _G['BaseAmbientStreamManager']
Exports.BaseCharacterSoundEmitter = _G['BaseCharacterSoundEmitter']
Exports.BaseSoundBank = _G['BaseSoundBank']
Exports.BaseSoundEmitter = _G['BaseSoundEmitter']
Exports.BaseSoundManager = _G['BaseSoundManager']
Exports.BaseVehicle = _G['BaseVehicle']
Exports.BaseVisual = _G['BaseVisual']
Exports.BeardStyle = _G['BeardStyle']
Exports.BeardStyles = _G['BeardStyles']
Exports.BehaviorResult = _G['BehaviorResult']
Exports.BentFences = _G['BentFences']
Exports.BloodBodyPartType = _G['BloodBodyPartType']
Exports.BloodClothingType = _G['BloodClothingType']
Exports.BodyDamage = _G['BodyDamage']
Exports.BodyDamageSync = _G['BodyDamageSync']
Exports.BodyLocation = _G['BodyLocation']
Exports.BodyLocation = _G['BodyLocation']
Exports.BodyLocationGroup = _G['BodyLocationGroup']
Exports.BodyLocations = _G['BodyLocations']
Exports.BodyPart = _G['BodyPart']
Exports.BodyPartLast = _G['BodyPartLast']
Exports.BodyPartType = _G['BodyPartType']
Exports.BoneAxis = _G['BoneAxis']
Exports.BooleanConfigOption = _G['BooleanConfigOption']
Exports.BooleanDebugOption = _G['BooleanDebugOption']
Exports.BooleanDebugOption = _G['BooleanDebugOption']
Exports.BooleanDebugOption = _G['BooleanDebugOption']
Exports.BooleanDebugOption = _G['BooleanDebugOption']
Exports.BooleanDebugOption = _G['BooleanDebugOption']
Exports.BooleanGrid = _G['BooleanGrid']
Exports.BooleanSandboxOption = _G['BooleanSandboxOption']
Exports.BooleanServerOption = _G['BooleanServerOption']
Exports.BrokenFences = _G['BrokenFences']
Exports.BufferedRandomAccessFile = _G['BufferedRandomAccessFile']
Exports.BufferedReader = _G['BufferedReader']
Exports.BufferedWriter = _G['BufferedWriter']
Exports.BuildingDef = _G['BuildingDef']
Exports.BuildingScore = _G['BuildingScore']
Exports.BuildingSearchCriteria = _G['BuildingSearchCriteria']
Exports.BulletVariables = _G['BulletVariables']
Exports.BurntToDeath = _G['BurntToDeath']
Exports.ByteBufferWriter = _G['ByteBufferWriter']
Exports.CGlobalObject = _G['CGlobalObject']
Exports.CGlobalObjectSystem = _G['CGlobalObjectSystem']
Exports.CGlobalObjects = _G['CGlobalObjects']
Exports.CallbackGetStrongTyped = _G['CallbackGetStrongTyped']
Exports.CallbackGetStrongTyped = _G['CallbackGetStrongTyped']
Exports.CallbackGetStrongTyped = _G['CallbackGetStrongTyped']
Exports.CallbackGetStrongTyped = _G['CallbackGetStrongTyped']
Exports.CallbackSetStrongTyped = _G['CallbackSetStrongTyped']
Exports.CallbackSetStrongTyped = _G['CallbackSetStrongTyped']
Exports.CallbackSetStrongTyped = _G['CallbackSetStrongTyped']
Exports.CallbackSetStrongTyped = _G['CallbackSetStrongTyped']
Exports.CarController = _G['CarController']
Exports.CellGetSquare = _G['CellGetSquare']
Exports.ChannelCategory = _G['ChannelCategory']
Exports.CharDef = _G['CharDef']
Exports.CharDefTexture = _G['CharDefTexture']
Exports.CharacterActionAnims = _G['CharacterActionAnims']
Exports.CharacterMask = _G['CharacterMask']
Exports.CharacterSoundEmitter = _G['CharacterSoundEmitter']
Exports.CharacterTraits = _G['CharacterTraits']
Exports.ChatBase = _G['ChatBase']
Exports.ChatElement = _G['ChatElement']
Exports.ChatElementOwner = _G['ChatElementOwner']
Exports.ChatMessage = _G['ChatMessage']
Exports.ChatMode = _G['ChatMode']
Exports.ChatSettings = _G['ChatSettings']
Exports.ChatTab = _G['ChatTab']
Exports.ChatType = _G['ChatType']
Exports.Checks = _G['Checks']
Exports.ChecksumState = _G['ChecksumState']
Exports.ChooseGameInfo = _G['ChooseGameInfo']
Exports.Chunk = _G['Chunk']
Exports.Chunk = _G['Chunk']
Exports.ChunkData = _G['ChunkData']
Exports.CircleIsoMarker = _G['CircleIsoMarker']
Exports.CircleStencilShader = _G['CircleStencilShader']
Exports.ClickObject = _G['ClickObject']
Exports.ClientChunkRequest = _G['ClientChunkRequest']
Exports.ClientControls = _G['ClientControls']
Exports.ClientServerMap = _G['ClientServerMap']
Exports.ClimateBool = _G['ClimateBool']
Exports.ClimateColor = _G['ClimateColor']
Exports.ClimateColorInfo = _G['ClimateColorInfo']
Exports.ClimateFloat = _G['ClimateFloat']
Exports.ClimateForecaster = _G['ClimateForecaster']
Exports.ClimateHistory = _G['ClimateHistory']
Exports.ClimateManager = _G['ClimateManager']
Exports.ClimateMoon = _G['ClimateMoon']
Exports.ClimateNetAuth = _G['ClimateNetAuth']
Exports.ClimateValues = _G['ClimateValues']
Exports.ClimbDownSheetRopeState = _G['ClimbDownSheetRopeState']
Exports.ClimbOverFenceState = _G['ClimbOverFenceState']
Exports.ClimbOverWallState = _G['ClimbOverWallState']
Exports.ClimbSheetRopeState = _G['ClimbSheetRopeState']
Exports.ClimbThroughWindowState = _G['ClimbThroughWindowState']
Exports.Clipboard = _G['Clipboard']
Exports.Clock = _G['Clock']
Exports.CloseWindowState = _G['CloseWindowState']
Exports.Clothing = _G['Clothing']
Exports.ClothingItem = _G['ClothingItem']
Exports.ClothingItemReference = _G['ClothingItemReference']
Exports.ClothingPatch = _G['ClothingPatch']
Exports.ClothingPatchFabricType = _G['ClothingPatchFabricType']
Exports.ClothingWetness = _G['ClothingWetness']
Exports.Color = _G['Color']
Exports.ColorInfo = _G['ColorInfo']
Exports.ColorRGB = _G['ColorRGB']
Exports.ColorStop = _G['ColorStop']
Exports.Colors = _G['Colors']
Exports.ComboItem = _G['ComboItem']
Exports.ConfigOption = _G['ConfigOption']
Exports.ConnectToServerState = _G['ConnectToServerState']
Exports.ConnectionType = _G['ConnectionType']
Exports.Container = _G['Container']
Exports.ContainerOverlays = _G['ContainerOverlays']
Exports.Core = _G['Core']
Exports.CrawlingZombieTurnState = _G['CrawlingZombieTurnState']
Exports.Credit = _G['Credit']
Exports.CustomComparator = _G['CustomComparator']
Exports.CustomSandboxOption = _G['CustomSandboxOption']
Exports.DBResult = _G['DBResult']
Exports.DBTicket = _G['DBTicket']
Exports.DataCell = _G['DataCell']
Exports.DataChunk = _G['DataChunk']
Exports.DataInputStream = _G['DataInputStream']
Exports.DataOutputStream = _G['DataOutputStream']
Exports.DataPoint = _G['DataPoint']
Exports.DayForecast = _G['DayForecast']
Exports.DayInfo = _G['DayInfo']
Exports.DeadCharacterPacket = _G['DeadCharacterPacket']
Exports.Debug = _G['Debug']
Exports.DebugChunkState = _G['DebugChunkState']
Exports.DebugGlobalObjectState = _G['DebugGlobalObjectState']
Exports.DebugLog = _G['DebugLog']
Exports.DebugLogStream = _G['DebugLogStream']
Exports.DebugOptions = _G['DebugOptions']
Exports.DebugType = _G['DebugType']
Exports.DeferedTextDraw = _G['DeferedTextDraw']
Exports.Descriptor = _G['Descriptor']
Exports.DeviceData = _G['DeviceData']
Exports.DeviceList = _G['DeviceList']
Exports.DevicePresets = _G['DevicePresets']
Exports.DirectionArrow = _G['DirectionArrow']
Exports.Door = _G['Door']
Exports.DoorLogic = _G['DoorLogic']
Exports.DoorType = _G['DoorType']
Exports.DoubleConfigOption = _G['DoubleConfigOption']
Exports.DoubleSandboxOption = _G['DoubleSandboxOption']
Exports.DoubleServerOption = _G['DoubleServerOption']
Exports.Drainable = _G['Drainable']
Exports.DrainableComboItem = _G['DrainableComboItem']
Exports.Drawer = _G['Drawer']
Exports.DummyCharacterSoundEmitter = _G['DummyCharacterSoundEmitter']
Exports.DummySoundBank = _G['DummySoundBank']
Exports.DummySoundEmitter = _G['DummySoundEmitter']
Exports.DummySoundManager = _G['DummySoundManager']
Exports.DynamicRadioChannel = _G['DynamicRadioChannel']
Exports.EditVehicleState = _G['EditVehicleState']
Exports.EffectLight = _G['EffectLight']
Exports.Element = _G['Element']
Exports.EmitterType = _G['EmitterType']
Exports.EnumConfigOption = _G['EnumConfigOption']
Exports.EnumMap = _G['EnumMap']
Exports.EnumSandboxOption = _G['EnumSandboxOption']
Exports.ErosionConfig = _G['ErosionConfig']
Exports.ErosionData = _G['ErosionData']
Exports.ErosionMain = _G['ErosionMain']
Exports.ErosionSeason = _G['ErosionSeason']
Exports.Event = _G['Event']
Exports.EventSound = _G['EventSound']
Exports.EvolvedRecipe = _G['EvolvedRecipe']
Exports.ExitOption = _G['ExitOption']
Exports.ExplosionMode = _G['ExplosionMode']
Exports.Exposer = _G['Exposer']
Exports.FMODAudio = _G['FMODAudio']
Exports.FMODParameter = _G['FMODParameter']
Exports.FMODParameterList = _G['FMODParameterList']
Exports.FMODSoundBank = _G['FMODSoundBank']
Exports.FMODSoundEmitter = _G['FMODSoundEmitter']
Exports.Faction = _G['Faction']
Exports.FakeDeadAttackState = _G['FakeDeadAttackState']
Exports.FakeDeadZombieState = _G['FakeDeadZombieState']
Exports.FileSeekMode = _G['FileSeekMode']
Exports.FileSystem = _G['FileSystem']
Exports.FileTask = _G['FileTask']
Exports.FilterArgs = _G['FilterArgs']
Exports.FishingState = _G['FishingState']
Exports.Fitness = _G['Fitness']
Exports.FitnessExercise = _G['FitnessExercise']
Exports.FitnessState = _G['FitnessState']
Exports.Fixer = _G['Fixer']
Exports.FixerSkill = _G['FixerSkill']
Exports.Fixing = _G['Fixing']
Exports.FixingManager = _G['FixingManager']
Exports.Flare = _G['Flare']
Exports.FloatList = _G['FloatList']
Exports.FloatStop = _G['FloatStop']
Exports.FontSize = _G['FontSize']
Exports.Food = _G['Food']
Exports.ForecastValue = _G['ForecastValue']
Exports.Frame = _G['Frame']
Exports.FrameLightBlendStatus = _G['FrameLightBlendStatus']
Exports.FrameLightInfo = _G['FrameLightInfo']
Exports.FrameState = _G['FrameState']
Exports.FridgeHumLogic = _G['FridgeHumLogic']
Exports.GameCharacterAIBrain = _G['GameCharacterAIBrain']
Exports.GameClient = _G['GameClient']
Exports.GameKeyboard = _G['GameKeyboard']
Exports.GameLoadingState = _G['GameLoadingState']
Exports.GameMode = _G['GameMode']
Exports.GameSound = _G['GameSound']
Exports.GameSoundClip = _G['GameSoundClip']
Exports.GameSoundScript = _G['GameSoundScript']
Exports.GameSounds = _G['GameSounds']
Exports.GameState = _G['GameState']
Exports.GameStateMachine = _G['GameStateMachine']
Exports.GameTime = _G['GameTime']
Exports.GameVersion = _G['GameVersion']
Exports.GameWindow = _G['GameWindow']
Exports.GearInfo = _G['GearInfo']
Exports.GenericDrawer = _G['GenericDrawer']
Exports.GenericSpriteRenderState = _G['GenericSpriteRenderState']
Exports.GeometryData = _G['GeometryData']
Exports.GetSquare = _G['GetSquare']
Exports.GibletType = _G['GibletType']
Exports.GlobalObject = _G['GlobalObject']
Exports.GlobalObject = _G['GlobalObject']
Exports.GlobalObjectSystem = _G['GlobalObjectSystem']
Exports.GridSquareMarker = _G['GridSquareMarker']
Exports.HUDButton = _G['HUDButton']
Exports.HairStyle = _G['HairStyle']
Exports.HairStyles = _G['HairStyles']
Exports.HaloTextHelper = _G['HaloTextHelper']
Exports.HandWeapon = _G['HandWeapon']
Exports.HashMap = _G['HashMap']
Exports.HitCharacterPacket = _G['HitCharacterPacket']
Exports.HitInfo = _G['HitInfo']
Exports.HitReactionNetworkAI = _G['HitReactionNetworkAI']
Exports.HitType = _G['HitType']
Exports.HitVars = _G['HitVars']
Exports.HumanCorpse = _G['HumanCorpse']
Exports.HumanVisual = _G['HumanVisual']
Exports.IAnimEventCallback = _G['IAnimEventCallback']
Exports.IAnimListener = _G['IAnimListener']
Exports.IAnimatable = _G['IAnimatable']
Exports.IAnimationVariableSlot = _G['IAnimationVariableSlot']
Exports.IAnimationVariableSource = _G['IAnimationVariableSource']
Exports.IChunkRegion = _G['IChunkRegion']
Exports.IDebugLogFormatter = _G['IDebugLogFormatter']
Exports.IDebugOption = _G['IDebugOption']
Exports.IDebugOptionGroup = _G['IDebugOptionGroup']
Exports.IElementSpawner = _G['IElementSpawner']
Exports.IFile = _G['IFile']
Exports.IFileDevice = _G['IFileDevice']
Exports.IFileTask2Callback = _G['IFileTask2Callback']
Exports.IFileTaskCallback = _G['IFileTaskCallback']
Exports.IGLFramebufferObject = _G['IGLFramebufferObject']
Exports.IHumanVisual = _G['IHumanVisual']
Exports.ILighting = _G['ILighting']
Exports.IPathfinder = _G['IPathfinder']
Exports.IPooledObject = _G['IPooledObject']
Exports.IReplace = _G['IReplace']
Exports.IReplaceProvider = _G['IReplaceProvider']
Exports.IShaderProgramListener = _G['IShaderProgramListener']
Exports.IStatePermissions = _G['IStatePermissions']
Exports.ITexture = _G['ITexture']
Exports.IWorldMapStyleFilter = _G['IWorldMapStyleFilter']
Exports.IWorldRegion = _G['IWorldRegion']
Exports.IdleState = _G['IdleState']
Exports.ImageData = _G['ImageData']
Exports.ImagePyramid = _G['ImagePyramid']
Exports.ImmutableColor = _G['ImmutableColor']
Exports.ImprovedFog = _G['ImprovedFog']
Exports.Input = _G['Input']
Exports.IntegerConfigOption = _G['IntegerConfigOption']
Exports.IntegerSandboxOption = _G['IntegerSandboxOption']
Exports.IntegerServerOption = _G['IntegerServerOption']
Exports.InventoryContainer = _G['InventoryContainer']
Exports.InventoryItem = _G['InventoryItem']
Exports.InventoryItemFactory = _G['InventoryItemFactory']
Exports.IsoAnim = _G['IsoAnim']
Exports.IsoBarbecue = _G['IsoBarbecue']
Exports.IsoBarricade = _G['IsoBarricade']
Exports.IsoBrokenGlass = _G['IsoBrokenGlass']
Exports.IsoBuilding = _G['IsoBuilding']
Exports.IsoCamera = _G['IsoCamera']
Exports.IsoCarBatteryCharger = _G['IsoCarBatteryCharger']
Exports.IsoCell = _G['IsoCell']
Exports.IsoChunk = _G['IsoChunk']
Exports.IsoChunkMap = _G['IsoChunkMap']
Exports.IsoChunkRegion = _G['IsoChunkRegion']
Exports.IsoClothingDryer = _G['IsoClothingDryer']
Exports.IsoClothingWasher = _G['IsoClothingWasher']
Exports.IsoCombinationWasherDryer = _G['IsoCombinationWasherDryer']
Exports.IsoCompost = _G['IsoCompost']
Exports.IsoCurtain = _G['IsoCurtain']
Exports.IsoDeadBody = _G['IsoDeadBody']
Exports.IsoDirectionSet = _G['IsoDirectionSet']
Exports.IsoDirections = _G['IsoDirections']
Exports.IsoDoor = _G['IsoDoor']
Exports.IsoDummyCameraCharacter = _G['IsoDummyCameraCharacter']
Exports.IsoFire = _G['IsoFire']
Exports.IsoFireManager = _G['IsoFireManager']
Exports.IsoFireplace = _G['IsoFireplace']
Exports.IsoFlagType = _G['IsoFlagType']
Exports.IsoGameCharacter = _G['IsoGameCharacter']
Exports.IsoGenerator = _G['IsoGenerator']
Exports.IsoGridOcclusionData = _G['IsoGridOcclusionData']
Exports.IsoGridSquare = _G['IsoGridSquare']
Exports.IsoHeatSource = _G['IsoHeatSource']
Exports.IsoJukebox = _G['IsoJukebox']
Exports.IsoLightSource = _G['IsoLightSource']
Exports.IsoLightSwitch = _G['IsoLightSwitch']
Exports.IsoLivingCharacter = _G['IsoLivingCharacter']
Exports.IsoLot = _G['IsoLot']
Exports.IsoLuaMover = _G['IsoLuaMover']
Exports.IsoMannequin = _G['IsoMannequin']
Exports.IsoMarker = _G['IsoMarker']
Exports.IsoMarkers = _G['IsoMarkers']
Exports.IsoMetaCell = _G['IsoMetaCell']
Exports.IsoMetaChunk = _G['IsoMetaChunk']
Exports.IsoMetaGrid = _G['IsoMetaGrid']
Exports.IsoMolotovCocktail = _G['IsoMolotovCocktail']
Exports.IsoMovingObject = _G['IsoMovingObject']
Exports.IsoObject = _G['IsoObject']
Exports.IsoObjectFactory = _G['IsoObjectFactory']
Exports.IsoObjectPicker = _G['IsoObjectPicker']
Exports.IsoObjectType = _G['IsoObjectType']
Exports.IsoPlayer = _G['IsoPlayer']
Exports.IsoPuddles = _G['IsoPuddles']
Exports.IsoPuddlesGeometry = _G['IsoPuddlesGeometry']
Exports.IsoPushableObject = _G['IsoPushableObject']
Exports.IsoRadio = _G['IsoRadio']
Exports.IsoRainSplash = _G['IsoRainSplash']
Exports.IsoRaindrop = _G['IsoRaindrop']
Exports.IsoRegionLog = _G['IsoRegionLog']
Exports.IsoRegionLogType = _G['IsoRegionLogType']
Exports.IsoRegions = _G['IsoRegions']
Exports.IsoRegionsLogger = _G['IsoRegionsLogger']
Exports.IsoRegionsRenderer = _G['IsoRegionsRenderer']
Exports.IsoRoom = _G['IsoRoom']
Exports.IsoSprite = _G['IsoSprite']
Exports.IsoSpriteGrid = _G['IsoSpriteGrid']
Exports.IsoSpriteInstance = _G['IsoSpriteInstance']
Exports.IsoSpriteManager = _G['IsoSpriteManager']
Exports.IsoStackedWasherDryer = _G['IsoStackedWasherDryer']
Exports.IsoStove = _G['IsoStove']
Exports.IsoSurvivor = _G['IsoSurvivor']
Exports.IsoTelevision = _G['IsoTelevision']
Exports.IsoThumpable = _G['IsoThumpable']
Exports.IsoTrap = _G['IsoTrap']
Exports.IsoTree = _G['IsoTree']
Exports.IsoUtils = _G['IsoUtils']
Exports.IsoWaterGeometry = _G['IsoWaterGeometry']
Exports.IsoWaveSignal = _G['IsoWaveSignal']
Exports.IsoWeatherFX = _G['IsoWeatherFX']
Exports.IsoWheelieBin = _G['IsoWheelieBin']
Exports.IsoWindow = _G['IsoWindow']
Exports.IsoWindowFrame = _G['IsoWindowFrame']
Exports.IsoWorld = _G['IsoWorld']
Exports.IsoWorldInventoryObject = _G['IsoWorldInventoryObject']
Exports.IsoWorldRegion = _G['IsoWorldRegion']
Exports.IsoZombie = _G['IsoZombie']
Exports.IsoZombieGiblets = _G['IsoZombieGiblets']
Exports.Item = _G['Item']
Exports.ItemContainer = _G['ItemContainer']
Exports.ItemPickerContainer = _G['ItemPickerContainer']
Exports.ItemPickerItem = _G['ItemPickerItem']
Exports.ItemPickerJava = _G['ItemPickerJava']
Exports.ItemPickerRoom = _G['ItemPickerRoom']
Exports.ItemPickerUpgradeWeapons = _G['ItemPickerUpgradeWeapons']
Exports.ItemRecipe = _G['ItemRecipe']
Exports.ItemReplacement = _G['ItemReplacement']
Exports.ItemState = _G['ItemState']
Exports.ItemType = _G['ItemType']
Exports.ItemVisual = _G['ItemVisual']
Exports.ItemVisuals = _G['ItemVisuals']
Exports.Iterator = _G['Iterator']
Exports.JobType = _G['JobType']
Exports.Joypad = _G['Joypad']
Exports.JoypadManager = _G['JoypadManager']
Exports.KahluaUtil = _G['KahluaUtil']
Exports.Key = _G['Key']
Exports.KeyRing = _G['KeyRing']
Exports.Keyboard = _G['Keyboard']
Exports.Keyframe = _G['Keyframe']
Exports.KnownBlockedEdges = _G['KnownBlockedEdges']
Exports.Language = _G['Language']
Exports.Layout = _G['Layout']
Exports.LayoutItem = _G['LayoutItem']
Exports.LiangBarsky = _G['LiangBarsky']
Exports.LightBar = _G['LightBar']
Exports.LightInfo = _G['LightInfo']
Exports.Lighting = _G['Lighting']
Exports.Line = _G['Line']
Exports.LinkedList = _G['LinkedList']
Exports.Literature = _G['Literature']
Exports.LiveAnimNode = _G['LiveAnimNode']
Exports.LoadingQueueState = _G['LoadingQueueState']
Exports.Location = _G['Location']
Exports.LogSeverity = _G['LogSeverity']
Exports.LosUtil = _G['LosUtil']
Exports.LotHeader = _G['LotHeader']
Exports.LuaEnvironment = _G['LuaEnvironment']
Exports.LuaEventManager = _G['LuaEventManager']
Exports.LuaFileWriter = _G['LuaFileWriter']
Exports.LuaManager = _G['LuaManager']
Exports.LuaTimedAction = _G['LuaTimedAction']
Exports.LuaTimedActionNew = _G['LuaTimedActionNew']
Exports.LungeState = _G['LungeState']
Exports.MPClientStatistic = _G['MPClientStatistic']
Exports.MainScreenState = _G['MainScreenState']
Exports.MannequinScript = _G['MannequinScript']
Exports.MannequinZone = _G['MannequinZone']
Exports.Map = _G['Map']
Exports.Map = _G['Map']
Exports.MapGroups = _G['MapGroups']
Exports.MapItem = _G['MapItem']
Exports.MapKnowledge = _G['MapKnowledge']
Exports.MapObjects = _G['MapObjects']
Exports.Mask = _G['Mask']
Exports.MasterVolume = _G['MasterVolume']
Exports.Material = _G['Material']
Exports.Math = _G['Math']
Exports.Matrix4fObjectPool = _G['Matrix4fObjectPool']
Exports.MediaData = _G['MediaData']
Exports.MediaLineData = _G['MediaLineData']
Exports.MediaNameSorter = _G['MediaNameSorter']
Exports.MetaCell = _G['MetaCell']
Exports.MetaObject = _G['MetaObject']
Exports.Metabolics = _G['Metabolics']
Exports.MinMaxPosition = _G['MinMaxPosition']
Exports.MipMapLevel = _G['MipMapLevel']
Exports.Mod = _G['Mod']
Exports.ModAnimations = _G['ModAnimations']
Exports.ModData = _G['ModData']
Exports.ModalDialog = _G['ModalDialog']
Exports.Model = _G['Model']
Exports.Model = _G['Model']
Exports.ModelAssetParams = _G['ModelAssetParams']
Exports.ModelAttachment = _G['ModelAttachment']
Exports.ModelInfo = _G['ModelInfo']
Exports.ModelInstance = _G['ModelInstance']
Exports.ModelInstanceRenderData = _G['ModelInstanceRenderData']
Exports.ModelInstanceTextureCreator = _G['ModelInstanceTextureCreator']
Exports.ModelInstanceTextureInitializer = _G['ModelInstanceTextureInitializer']
Exports.ModelManager = _G['ModelManager']
Exports.ModelScript = _G['ModelScript']
Exports.ModelSlot = _G['ModelSlot']
Exports.ModelSlotRenderData = _G['ModelSlotRenderData']
Exports.ModelWeaponPart = _G['ModelWeaponPart']
Exports.Moodle = _G['Moodle']
Exports.MoodleType = _G['MoodleType']
Exports.Moodles = _G['Moodles']
Exports.MoodlesUI = _G['MoodlesUI']
Exports.MostTested = _G['MostTested']
Exports.Mouse = _G['Mouse']
Exports.MovableRecipe = _G['MovableRecipe']
Exports.MoveDeltaModifiers = _G['MoveDeltaModifiers']
Exports.Moveable = _G['Moveable']
Exports.MovementType = _G['MovementType']
Exports.Mover = _G['Mover']
Exports.MultiStageBuilding = _G['MultiStageBuilding']
Exports.NPCData = _G['NPCData']
Exports.NetworkAIParams = _G['NetworkAIParams']
Exports.NetworkCharacterAI = _G['NetworkCharacterAI']
Exports.NetworkTeleport = _G['NetworkTeleport']
Exports.NetworkTeleportDebug = _G['NetworkTeleportDebug']
Exports.NewHealthPanel = _G['NewHealthPanel']
Exports.NineGridTexture = _G['NineGridTexture']
Exports.NoCircleStencilShader = _G['NoCircleStencilShader']
Exports.NonBlockingHashMap = _G['NonBlockingHashMap']
Exports.NonPvpZone = _G['NonPvpZone']
Exports.Nutrition = _G['Nutrition']
Exports.OSValidator = _G['OSValidator']
Exports.ObjectAmbientEmitters = _G['ObjectAmbientEmitters']
Exports.ObjectPool = _G['ObjectPool']
Exports.ObjectRenderEffects = _G['ObjectRenderEffects']
Exports.ObjectTooltip = _G['ObjectTooltip']
Exports.Observation = _G['Observation']
Exports.ObservationFactory = _G['ObservationFactory']
Exports.ObserverCallback = _G['ObserverCallback']
Exports.OccluderType = _G['OccluderType']
Exports.OcclusionFilter = _G['OcclusionFilter']
Exports.OnceEvery = _G['OnceEvery']
Exports.OpenWindowState = _G['OpenWindowState']
Exports.Outfit = _G['Outfit']
Exports.OutlineShader = _G['OutlineShader']
Exports.PZArrayList = _G['PZArrayList']
Exports.PZCalendar = _G['PZCalendar']
Exports.PZFileformat = _G['PZFileformat']
Exports.PZMath = _G['PZMath']
Exports.PackFile = _G['PackFile']
Exports.PacketType = _G['PacketType']
Exports.ParameterCharacterMovementSpeed = _G['ParameterCharacterMovementSpeed']
Exports.Part = _G['Part']
Exports.Part = _G['Part']
Exports.Passenger = _G['Passenger']
Exports.Passenger = _G['Passenger']
Exports.Path = _G['Path']
Exports.Path = _G['Path']
Exports.PathFindBehavior2 = _G['PathFindBehavior2']
Exports.PathFindRequest = _G['PathFindRequest']
Exports.PathFindState = _G['PathFindState']
Exports.PathFindState2 = _G['PathFindState2']
Exports.PerObjectLogic = _G['PerObjectLogic']
Exports.PerPlayerRender = _G['PerPlayerRender']
Exports.PerformanceSettings = _G['PerformanceSettings']
Exports.Perk = _G['Perk']
Exports.PerkFactory = _G['PerkFactory']
Exports.PerkInfo = _G['PerkInfo']
Exports.Perks = _G['Perks']
Exports.PhysicsShape = _G['PhysicsShape']
Exports.Plane = _G['Plane']
Exports.PlaneObjectPool = _G['PlaneObjectPool']
Exports.PlayerActionsState = _G['PlayerActionsState']
Exports.PlayerAimState = _G['PlayerAimState']
Exports.PlayerCamera = _G['PlayerCamera']
Exports.PlayerData = _G['PlayerData']
Exports.PlayerEmoteState = _G['PlayerEmoteState']
Exports.PlayerExtState = _G['PlayerExtState']
Exports.PlayerFallDownState = _G['PlayerFallDownState']
Exports.PlayerFallingState = _G['PlayerFallingState']
Exports.PlayerGetUpState = _G['PlayerGetUpState']
Exports.PlayerHitReactionPVPState = _G['PlayerHitReactionPVPState']
Exports.PlayerHitReactionState = _G['PlayerHitReactionState']
Exports.PlayerHomingPoint = _G['PlayerHomingPoint']
Exports.PlayerKnockedDown = _G['PlayerKnockedDown']
Exports.PlayerOnGroundState = _G['PlayerOnGroundState']
Exports.PlayerPacket = _G['PlayerPacket']
Exports.PlayerRenderSettings = _G['PlayerRenderSettings']
Exports.PlayerSearchMode = _G['PlayerSearchMode']
Exports.PlayerSitOnGroundState = _G['PlayerSitOnGroundState']
Exports.PlayerStrafeState = _G['PlayerStrafeState']
Exports.Point = _G['Point']
Exports.Point = _G['Point']
Exports.PointOnPath = _G['PointOnPath']
Exports.PolygonalMap2 = _G['PolygonalMap2']
Exports.Pool = _G['Pool']
Exports.Position = _G['Position']
Exports.PredictionTypes = _G['PredictionTypes']
Exports.PresetEntry = _G['PresetEntry']
Exports.ProceduralItem = _G['ProceduralItem']
Exports.Profession = _G['Profession']
Exports.ProfessionFactory = _G['ProfessionFactory']
Exports.PropertyContainer = _G['PropertyContainer']
Exports.PuddlesDirection = _G['PuddlesDirection']
Exports.PuddlesFloat = _G['PuddlesFloat']
Exports.PyramidTexture = _G['PyramidTexture']
Exports.QuaternionfObjectPool = _G['QuaternionfObjectPool']
Exports.RBBar = _G['RBBar']
Exports.RBBasic = _G['RBBasic']
Exports.RBBurnt = _G['RBBurnt']
Exports.RBBurntCorpse = _G['RBBurntCorpse']
Exports.RBBurntFireman = _G['RBBurntFireman']
Exports.RBCafe = _G['RBCafe']
Exports.RBClinic = _G['RBClinic']
Exports.RBHairSalon = _G['RBHairSalon']
Exports.RBKateAndBaldspot = _G['RBKateAndBaldspot']
Exports.RBLooted = _G['RBLooted']
Exports.RBOffice = _G['RBOffice']
Exports.RBOther = _G['RBOther']
Exports.RBPileOCrepe = _G['RBPileOCrepe']
Exports.RBPizzaWhirled = _G['RBPizzaWhirled']
Exports.RBSafehouse = _G['RBSafehouse']
Exports.RBSchool = _G['RBSchool']
Exports.RBShopLooted = _G['RBShopLooted']
Exports.RBSpiffo = _G['RBSpiffo']
Exports.RBStripclub = _G['RBStripclub']
Exports.RDSBandPractice = _G['RDSBandPractice']
Exports.RDSBathroomZed = _G['RDSBathroomZed']
Exports.RDSBedroomZed = _G['RDSBedroomZed']
Exports.RDSBleach = _G['RDSBleach']
Exports.RDSCorpsePsycho = _G['RDSCorpsePsycho']
Exports.RDSDeadDrunk = _G['RDSDeadDrunk']
Exports.RDSFootballNight = _G['RDSFootballNight']
Exports.RDSGunmanInBathroom = _G['RDSGunmanInBathroom']
Exports.RDSGunslinger = _G['RDSGunslinger']
Exports.RDSHenDo = _G['RDSHenDo']
Exports.RDSHockeyPsycho = _G['RDSHockeyPsycho']
Exports.RDSHouseParty = _G['RDSHouseParty']
Exports.RDSPokerNight = _G['RDSPokerNight']
Exports.RDSPoliceAtHouse = _G['RDSPoliceAtHouse']
Exports.RDSPrisonEscape = _G['RDSPrisonEscape']
Exports.RDSPrisonEscapeWithPolice = _G['RDSPrisonEscapeWithPolice']
Exports.RDSSkeletonPsycho = _G['RDSSkeletonPsycho']
Exports.RDSSpecificProfession = _G['RDSSpecificProfession']
Exports.RDSStagDo = _G['RDSStagDo']
Exports.RDSStudentNight = _G['RDSStudentNight']
Exports.RDSSuicidePact = _G['RDSSuicidePact']
Exports.RDSTinFoilHat = _G['RDSTinFoilHat']
Exports.RDSZombieLockedBathroom = _G['RDSZombieLockedBathroom']
Exports.RDSZombiesEating = _G['RDSZombiesEating']
Exports.RGBAf = _G['RGBAf']
Exports.RVSAmbulanceCrash = _G['RVSAmbulanceCrash']
Exports.RVSBanditRoad = _G['RVSBanditRoad']
Exports.RVSBurntCar = _G['RVSBurntCar']
Exports.RVSCarCrash = _G['RVSCarCrash']
Exports.RVSCarCrashCorpse = _G['RVSCarCrashCorpse']
Exports.RVSChangingTire = _G['RVSChangingTire']
Exports.RVSConstructionSite = _G['RVSConstructionSite']
Exports.RVSCrashHorde = _G['RVSCrashHorde']
Exports.RVSFlippedCrash = _G['RVSFlippedCrash']
Exports.RVSPoliceBlockade = _G['RVSPoliceBlockade']
Exports.RVSPoliceBlockadeShooting = _G['RVSPoliceBlockadeShooting']
Exports.RVSTrailerCrash = _G['RVSTrailerCrash']
Exports.RVSUtilityVehicle = _G['RVSUtilityVehicle']
Exports.RZSBBQParty = _G['RZSBBQParty']
Exports.RZSBaseball = _G['RZSBaseball']
Exports.RZSBeachParty = _G['RZSBeachParty']
Exports.RZSBuryingCamp = _G['RZSBuryingCamp']
Exports.RZSFishingTrip = _G['RZSFishingTrip']
Exports.RZSForestCamp = _G['RZSForestCamp']
Exports.RZSForestCampEaten = _G['RZSForestCampEaten']
Exports.RZSHunterCamp = _G['RZSHunterCamp']
Exports.RZSMusicFest = _G['RZSMusicFest']
Exports.RZSMusicFestStage = _G['RZSMusicFestStage']
Exports.RZSSexyTime = _G['RZSSexyTime']
Exports.RZSTrapperCamp = _G['RZSTrapperCamp']
Exports.RadarPanel = _G['RadarPanel']
Exports.RadialMenu = _G['RadialMenu']
Exports.RadialProgressBar = _G['RadialProgressBar']
Exports.Radio = _G['Radio']
Exports.RadioAPI = _G['RadioAPI']
Exports.RadioBroadCast = _G['RadioBroadCast']
Exports.RadioChannel = _G['RadioChannel']
Exports.RadioData = _G['RadioData']
Exports.RadioLine = _G['RadioLine']
Exports.RadioScript = _G['RadioScript']
Exports.RadioScriptManager = _G['RadioScriptManager']
Exports.RainManager = _G['RainManager']
Exports.RakNetPeerInterface = _G['RakNetPeerInterface']
Exports.RandomData = _G['RandomData']
Exports.RandomData = _G['RandomData']
Exports.RandomizedBuildingBase = _G['RandomizedBuildingBase']
Exports.RandomizedDeadSurvivorBase = _G['RandomizedDeadSurvivorBase']
Exports.RandomizedVehicleStoryBase = _G['RandomizedVehicleStoryBase']
Exports.RandomizedWorldBase = _G['RandomizedWorldBase']
Exports.RandomizedZoneStoryBase = _G['RandomizedZoneStoryBase']
Exports.Ray = _G['Ray']
Exports.RayObjectPool = _G['RayObjectPool']
Exports.Recipe = _G['Recipe']
Exports.RecipeManager = _G['RecipeManager']
Exports.RecordedMedia = _G['RecordedMedia']
Exports.Remove = _G['Remove']
Exports.RenderArgs = _G['RenderArgs']
Exports.RenderEffectType = _G['RenderEffectType']
Exports.RenderSettings = _G['RenderSettings']
Exports.ReplaceProviderCharacter = _G['ReplaceProviderCharacter']
Exports.RequestState = _G['RequestState']
Exports.RequiredSkill = _G['RequiredSkill']
Exports.Result = _G['Result']
Exports.ResultBiggestSound = _G['ResultBiggestSound']
Exports.ResultLight = _G['ResultLight']
Exports.RingBuffer = _G['RingBuffer']
Exports.RoomDef = _G['RoomDef']
Exports.RoomRect = _G['RoomRect']
Exports.RoomTone = _G['RoomTone']
Exports.RuntimeAnimationScript = _G['RuntimeAnimationScript']
Exports.SCButton = _G['SCButton']
Exports.SGlobalObject = _G['SGlobalObject']
Exports.SGlobalObjectSystem = _G['SGlobalObjectSystem']
Exports.SGlobalObjects = _G['SGlobalObjects']
Exports.SLSoundManager = _G['SLSoundManager']
Exports.SafeHouse = _G['SafeHouse']
Exports.Safety = _G['Safety']
Exports.SandboxOption = _G['SandboxOption']
Exports.SandboxOptions = _G['SandboxOptions']
Exports.ScreenElement = _G['ScreenElement']
Exports.ScriptManager = _G['ScriptManager']
Exports.ScriptModule = _G['ScriptModule']
Exports.SearchMode = _G['SearchMode']
Exports.SearchModeFloat = _G['SearchModeFloat']
Exports.Season = _G['Season']
Exports.Seeds = _G['Seeds']
Exports.Server = _G['Server']
Exports.ServerChatMessage = _G['ServerChatMessage']
Exports.ServerOption = _G['ServerOption']
Exports.ServerOptions = _G['ServerOptions']
Exports.ServerSettings = _G['ServerSettings']
Exports.ServerSettingsManager = _G['ServerSettingsManager']
Exports.ServerVehicleState = _G['ServerVehicleState']
Exports.Shader = _G['Shader']
Exports.ShaderProgram = _G['ShaderProgram']
Exports.ShaderUnit = _G['ShaderUnit']
Exports.SharedDescriptors = _G['SharedDescriptors']
Exports.SharedSkeleAnimationRepository = _G['SharedSkeleAnimationRepository']
Exports.SharedSkeleAnimationTrack = _G['SharedSkeleAnimationTrack']
Exports.SharedVertexBufferObjects = _G['SharedVertexBufferObjects']
Exports.ShortList = _G['ShortList']
Exports.SideOfLine = _G['SideOfLine']
Exports.SimpleDateFormat = _G['SimpleDateFormat']
Exports.Skin = _G['Skin']
Exports.SkinningBone = _G['SkinningBone']
Exports.SkinningBoneHierarchy = _G['SkinningBoneHierarchy']
Exports.SkinningData = _G['SkinningData']
Exports.SleepingEvent = _G['SleepingEvent']
Exports.SleepingEventData = _G['SleepingEventData']
Exports.SliceY = _G['SliceY']
Exports.SmashWindowState = _G['SmashWindowState']
Exports.Sound = _G['Sound']
Exports.SoundManager = _G['SoundManager']
Exports.SoundTimelineScript = _G['SoundTimelineScript']
Exports.Sounds = _G['Sounds']
Exports.Source = _G['Source']
Exports.SpawnOrigin = _G['SpawnOrigin']
Exports.SpeedControls = _G['SpeedControls']
Exports.SpriteRenderState = _G['SpriteRenderState']
Exports.SpriteRenderer = _G['SpriteRenderer']
Exports.Square = _G['Square']
Exports.Stack = _G['Stack']
Exports.Stage = _G['Stage']
Exports.StaggerBackState = _G['StaggerBackState']
Exports.Stash = _G['Stash']
Exports.StashBuilding = _G['StashBuilding']
Exports.StashSystem = _G['StashSystem']
Exports.State = _G['State']
Exports.State = _G['State']
Exports.StateAction = _G['StateAction']
Exports.StateMachine = _G['StateMachine']
Exports.Stats = _G['Stats']
Exports.SteamFriend = _G['SteamFriend']
Exports.SteamUGCDetails = _G['SteamUGCDetails']
Exports.SteamWorkshopItem = _G['SteamWorkshopItem']
Exports.Step = _G['Step']
Exports.Stop = _G['Stop']
Exports.StoryEmitter = _G['StoryEmitter']
Exports.StorySound = _G['StorySound']
Exports.StorySoundEvent = _G['StorySoundEvent']
Exports.StrLerpVal = _G['StrLerpVal']
Exports.StringConfigOption = _G['StringConfigOption']
Exports.StringDrawer = _G['StringDrawer']
Exports.StringSandboxOption = _G['StringSandboxOption']
Exports.StringServerOption = _G['StringServerOption']
Exports.SubLayerSlot = _G['SubLayerSlot']
Exports.SubTexture = _G['SubTexture']
Exports.SubTextureInfo = _G['SubTextureInfo']
Exports.SubstateSlot = _G['SubstateSlot']
Exports.SurroundVehicle = _G['SurroundVehicle']
Exports.SurvivorDesc = _G['SurvivorDesc']
Exports.SurvivorFactory = _G['SurvivorFactory']
Exports.SurvivorGroup = _G['SurvivorGroup']
Exports.SurvivorType = _G['SurvivorType']
Exports.SwipeStatePlayer = _G['SwipeStatePlayer']
Exports.SwitchSeat = _G['SwitchSeat']
Exports.SystemDisabler = _G['SystemDisabler']
Exports.Temperature = _G['Temperature']
Exports.TemplateText = _G['TemplateText']
Exports.TentAmbianceLogic = _G['TentAmbianceLogic']
Exports.TermsOfServiceState = _G['TermsOfServiceState']
Exports.TestResults = _G['TestResults']
Exports.TextDrawHorizontal = _G['TextDrawHorizontal']
Exports.TextDrawObject = _G['TextDrawObject']
Exports.TextManager = _G['TextManager']
Exports.TextServerOption = _G['TextServerOption']
Exports.Texture = _G['Texture']
Exports.TextureAssetParams = _G['TextureAssetParams']
Exports.TextureDraw = _G['TextureDraw']
Exports.TextureFBO = _G['TextureFBO']
Exports.TextureID = _G['TextureID']
Exports.TextureIDAssetParams = _G['TextureIDAssetParams']
Exports.TexturePack = _G['TexturePack']
Exports.TexturePackPage = _G['TexturePackPage']
Exports.TexturePackTextures = _G['TexturePackTextures']
Exports.TextureStop = _G['TextureStop']
Exports.ThermalNode = _G['ThermalNode']
Exports.Thermoregulator = _G['Thermoregulator']
Exports.ThumpState = _G['ThumpState']
Exports.Thumpable = _G['Thumpable']
Exports.ThunderCloud = _G['ThunderCloud']
Exports.ThunderStorm = _G['ThunderStorm']
Exports.TileDef = _G['TileDef']
Exports.TileOverlays = _G['TileOverlays']
Exports.Time = _G['Time']
Exports.TorchInfo = _G['TorchInfo']
Exports.Trait = _G['Trait']
Exports.TraitCollection = _G['TraitCollection']
Exports.TraitFactory = _G['TraitFactory']
Exports.TraitSlot = _G['TraitSlot']
Exports.Transform = _G['Transform']
Exports.Translator = _G['Translator']
Exports.TransmissionNumber = _G['TransmissionNumber']
Exports.TreeAmbianceLogic = _G['TreeAmbianceLogic']
Exports.TreeShader = _G['TreeShader']
Exports.TreeSoundManager = _G['TreeSoundManager']
Exports.Trigger = _G['Trigger']
Exports.Type = _G['Type']
Exports.Type = _G['Type']
Exports.Type = _G['Type']
Exports.Type = _G['Type']
Exports.UI3DModel = _G['UI3DModel']
Exports.UI3DScene = _G['UI3DScene']
Exports.UIDebugConsole = _G['UIDebugConsole']
Exports.UIElement = _G['UIElement']
Exports.UIEventHandler = _G['UIEventHandler']
Exports.UIFont = _G['UIFont']
Exports.UIManager = _G['UIManager']
Exports.UIServerToolbox = _G['UIServerToolbox']
Exports.UITextBox2 = _G['UITextBox2']
Exports.UITransition = _G['UITransition']
Exports.UIWorldMap = _G['UIWorldMap']
Exports.UIWorldMapV1 = _G['UIWorldMapV1']
Exports.UdpConnection = _G['UdpConnection']
Exports.UdpEngine = _G['UdpEngine']
Exports.Uniform = _G['Uniform']
Exports.UniqueRecipe = _G['UniqueRecipe']
Exports.Updater = _G['Updater']
Exports.Userlog = _G['Userlog']
Exports.UserlogType = _G['UserlogType']
Exports.ValidatePacket = _G['ValidatePacket']
Exports.ValidateState = _G['ValidateState']
Exports.Vector = _G['Vector']
Exports.Vector2 = _G['Vector2']
Exports.Vector2ObjectPool = _G['Vector2ObjectPool']
Exports.Vector2f = _G['Vector2f']
Exports.Vector2fObjectPool = _G['Vector2fObjectPool']
Exports.Vector3 = _G['Vector3']
Exports.Vector3f = _G['Vector3f']
Exports.Vector3fObjectPool = _G['Vector3fObjectPool']
Exports.Vehicle = _G['Vehicle']
Exports.VehicleDistribution = _G['VehicleDistribution']
Exports.VehicleDoor = _G['VehicleDoor']
Exports.VehicleEngineRPM = _G['VehicleEngineRPM']
Exports.VehicleGauge = _G['VehicleGauge']
Exports.VehicleHitPacket = _G['VehicleHitPacket']
Exports.VehicleLight = _G['VehicleLight']
Exports.VehiclePart = _G['VehiclePart']
Exports.VehiclePoly = _G['VehiclePoly']
Exports.VehicleScript = _G['VehicleScript']
Exports.VehicleStorySpawnData = _G['VehicleStorySpawnData']
Exports.VehicleStorySpawner = _G['VehicleStorySpawner']
Exports.VehicleTemplate = _G['VehicleTemplate']
Exports.VehicleType = _G['VehicleType']
Exports.VehicleTypeDefinition = _G['VehicleTypeDefinition']
Exports.VehicleWindow = _G['VehicleWindow']
Exports.VehicleZone = _G['VehicleZone']
Exports.VirtualZombieManager = _G['VirtualZombieManager']
Exports.VisionResult = _G['VisionResult']
Exports.WalkTowardState = _G['WalkTowardState']
Exports.WallShaderTexRender = _G['WallShaderTexRender']
Exports.WallShaperWhole = _G['WallShaperWhole']
Exports.WaterDripLogic = _G['WaterDripLogic']
Exports.WaveSignalDevice = _G['WaveSignalDevice']
Exports.WeaponPart = _G['WeaponPart']
Exports.WeaponType = _G['WeaponType']
Exports.WeatherPeriod = _G['WeatherPeriod']
Exports.WeatherStage = _G['WeatherStage']
Exports.Wheel = _G['Wheel']
Exports.WheelInfo = _G['WheelInfo']
Exports.Window = _G['Window']
Exports.WindowLogic = _G['WindowLogic']
Exports.WindowType = _G['WindowType']
Exports.WorldFlares = _G['WorldFlares']
Exports.WorldMap = _G['WorldMap']
Exports.WorldMapBaseSymbol = _G['WorldMapBaseSymbol']
Exports.WorldMapBaseSymbolV1 = _G['WorldMapBaseSymbolV1']
Exports.WorldMapBooleanOption = _G['WorldMapBooleanOption']
Exports.WorldMapCell = _G['WorldMapCell']
Exports.WorldMapData = _G['WorldMapData']
Exports.WorldMapDoubleOption = _G['WorldMapDoubleOption']
Exports.WorldMapFeature = _G['WorldMapFeature']
Exports.WorldMapGridSquareMarker = _G['WorldMapGridSquareMarker']
Exports.WorldMapGridSquareMarkerV1 = _G['WorldMapGridSquareMarkerV1']
Exports.WorldMapImages = _G['WorldMapImages']
Exports.WorldMapLineStyleLayerV1 = _G['WorldMapLineStyleLayerV1']
Exports.WorldMapMarker = _G['WorldMapMarker']
Exports.WorldMapMarkerV1 = _G['WorldMapMarkerV1']
Exports.WorldMapMarkers = _G['WorldMapMarkers']
Exports.WorldMapMarkersV1 = _G['WorldMapMarkersV1']
Exports.WorldMapPolygonStyleLayerV1 = _G['WorldMapPolygonStyleLayerV1']
Exports.WorldMapRenderer = _G['WorldMapRenderer']
Exports.WorldMapStyle = _G['WorldMapStyle']
Exports.WorldMapStyleLayer = _G['WorldMapStyleLayer']
Exports.WorldMapStyleLayerV1 = _G['WorldMapStyleLayerV1']
Exports.WorldMapStyleV1 = _G['WorldMapStyleV1']
Exports.WorldMapSymbolCollisions = _G['WorldMapSymbolCollisions']
Exports.WorldMapSymbolType = _G['WorldMapSymbolType']
Exports.WorldMapSymbols = _G['WorldMapSymbols']
Exports.WorldMapSymbolsV1 = _G['WorldMapSymbolsV1']
Exports.WorldMapTextSymbol = _G['WorldMapTextSymbol']
Exports.WorldMapTextSymbolV1 = _G['WorldMapTextSymbolV1']
Exports.WorldMapTextureStyleLayerV1 = _G['WorldMapTextureStyleLayerV1']
Exports.WorldMapTextureSymbol = _G['WorldMapTextureSymbol']
Exports.WorldMapTextureSymbolV1 = _G['WorldMapTextureSymbolV1']
Exports.WorldMapVisited = _G['WorldMapVisited']
Exports.WorldMarkers = _G['WorldMarkers']
Exports.WorldSound = _G['WorldSound']
Exports.WorldSoundEmitter = _G['WorldSoundEmitter']
Exports.WorldSoundManager = _G['WorldSoundManager']
Exports.WornItem = _G['WornItem']
Exports.WornItems = _G['WornItems']
Exports.WrappedBuffer = _G['WrappedBuffer']
Exports.XP = _G['XP']
Exports.XPMultiplier = _G['XPMultiplier']
Exports.ZLogger = _G['ZLogger']
Exports.ZNetStatistics = _G['ZNetStatistics']
Exports.ZombieConfig = _G['ZombieConfig']
Exports.ZombieFallDownState = _G['ZombieFallDownState']
Exports.ZombieGetDownState = _G['ZombieGetDownState']
Exports.ZombieGetUpState = _G['ZombieGetUpState']
Exports.ZombieIdleState = _G['ZombieIdleState']
Exports.ZombieLore = _G['ZombieLore']
Exports.ZombieOnGroundState = _G['ZombieOnGroundState']
Exports.ZombiePopulationManager = _G['ZombiePopulationManager']
Exports.ZombiePopulationRenderer = _G['ZombiePopulationRenderer']
Exports.ZombieReanimateState = _G['ZombieReanimateState']
Exports.ZombieSittingState = _G['ZombieSittingState']
Exports.ZombieSound = _G['ZombieSound']
Exports.ZomboidBitFlag = _G['ZomboidBitFlag']
Exports.ZomboidRadio = _G['ZomboidRadio']
Exports.Zone = _G['Zone']
Exports.ZoneGeometryType = _G['ZoneGeometryType']
Exports.ZoneType = _G['ZoneType']
Exports.engineStateTypes = _G['engineStateTypes']
Exports.l_receive = _G['l_receive']
Exports.l_send = _G['l_send']
Exports.vector2 = _G['vector2']
-- [JAVA-PARTIAL:STOP]
-- [LUA-PARTIAL:START]

--[lua/shared/defines.d.ts]
Exports.ZomboidGlobals = _G['ZomboidGlobals']

--[lua/shared/Definitions/ClothingRecipesDefinitions.d.ts]
Exports.ClothingRecipesDefinitions = _G['ClothingRecipesDefinitions']

--[lua/shared/Definitions/DefaultClothing.d.ts]
Exports.DefaultClothing = _G['DefaultClothing']

--[lua/shared/Definitions/FitnessExercises.d.ts]
Exports.FitnessExercises = _G['FitnessExercises']

--[lua/shared/Foraging/forageDefinitions.d.ts]
Exports.forageCategories = _G['forageCategories']
Exports.forageDefaultDefs = _G['forageDefaultDefs']
Exports.forageDefs = _G['forageDefs']
Exports.forageSkills = _G['forageSkills']
Exports.forageZones = _G['forageZones']
Exports.scavenges = _G['scavenges']

--[lua/shared/Foraging/forageSystem.d.ts]
Exports.forageSystem = _G['forageSystem']

--[lua/shared/ISBaseObject.d.ts]
Exports.ISBaseObject = _G['ISBaseObject']

--[lua/shared/iwbumstempmodelcompat.d.ts]

--[lua/shared/JoyPad/JoyPadSetup.d.ts]
Exports.JoypadControllerData = _G['JoypadControllerData']
Exports.JoypadData = _G['JoypadData']
Exports.joypad = _G['joypad']
Exports.Joypad = _G['Joypad']
Exports.JoypadState = _G['JoypadState']

--[lua/shared/keyBinding.d.ts]
Exports.keyBinding = _G['keyBinding']

--[lua/shared/Logs/ISLogSystem.d.ts]
Exports.ISLogSystem = _G['ISLogSystem']

--[lua/shared/Logs/ISPerkLog.d.ts]
Exports.ISPerkLog = _G['ISPerkLog']

--[lua/shared/luautils.d.ts]
Exports.luautils = _G['luautils']

--[lua/shared/NPCs/MainCreationMethods.d.ts]
Exports.BaseGameCharacterDetails = _G['BaseGameCharacterDetails']

--[lua/shared/RecordedMedia/ISRecordeMedia.d.ts]
Exports.ISRecordedMedia = _G['ISRecordedMedia']

--[lua/shared/Reloading/ISRackAction.d.ts]
Exports.ISRackAction = _G['ISRackAction']

--[lua/shared/Reloading/ISReloadable.d.ts]
Exports.ISReloadable = _G['ISReloadable']

--[lua/shared/Reloading/ISReloadableMagazine.d.ts]
Exports.ISReloadableMagazine = _G['ISReloadableMagazine']

--[lua/shared/Reloading/ISReloadableWeapon.d.ts]
Exports.ISReloadableWeapon = _G['ISReloadableWeapon']

--[lua/shared/Reloading/ISReloadAction.d.ts]
Exports.ISReloadAction = _G['ISReloadAction']

--[lua/shared/Reloading/ISReloadManager.d.ts]
Exports.ISReloadManager = _G['ISReloadManager']
Exports.aaa = _G['aaa']

--[lua/shared/Reloading/ISReloadUtil.d.ts]
Exports.ISReloadUtil = _G['ISReloadUtil']

--[lua/shared/Reloading/ISRevolverWeapon.d.ts]
Exports.ISRevolverWeapon = _G['ISRevolverWeapon']

--[lua/shared/Reloading/ISSemiAutoWeapon.d.ts]
Exports.ISSemiAutoWeapon = _G['ISSemiAutoWeapon']

--[lua/shared/Reloading/ISShotgunWeapon.d.ts]
Exports.ISShotgunWeapon = _G['ISShotgunWeapon']

--[lua/shared/Reloading/stormysReload.d.ts]
Exports.ReloadManager = _G['ReloadManager']

--[lua/shared/SoundBanks/SoundBanks.d.ts]
Exports.ambientSoundTable = _G['ambientSoundTable']
Exports.baseSoundTable = _G['baseSoundTable']
Exports.footStepTable = _G['footStepTable']
Exports.globalSoundTable = _G['globalSoundTable']
Exports.voiceTable = _G['voiceTable']

--[lua/shared/SpawnRegions.d.ts]
Exports.SpawnRegionMgr = _G['SpawnRegionMgr']

--[lua/shared/StashDescriptions/StashUtil.d.ts]
Exports.StashUtil = _G['StashUtil']

--[lua/shared/TimedActions/ISBaseTimedAction.d.ts]
Exports.ISBaseTimedAction = _G['ISBaseTimedAction']

--[lua/shared/Util/AdjacentFreeTileFinder.d.ts]
Exports.AdjacentFreeTileFinder = _G['AdjacentFreeTileFinder']

--[lua/shared/Util/BuildingHelper.d.ts]
Exports.BuildingHelper = _G['BuildingHelper']

--[lua/shared/Util/ISPriorityTable.d.ts]
Exports.ISPriorityTable = _G['ISPriorityTable']

--[lua/shared/Util/LuaList.d.ts]
Exports.LuaList = _G['LuaList']

--[lua/shared/Util/LuaNet.d.ts]
Exports.LuaNet = _G['LuaNet']

--[lua/shared/Util/StringReplacer.d.ts]
Exports.StringReplacer = _G['StringReplacer']

-- [LUA-PARTIAL:STOP]
return Exports
