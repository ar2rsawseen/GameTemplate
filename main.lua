--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Game Template for developing games. Includes: 
 * Start scene, pack select, level select, settings, score system and much more
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Gideros-Mobile-Game-Template
**************************************************************
]]--


--[[
NEED TO DO
Create ScrollableView
Add levels
Create level handling (locking unocking levels, etc maybe even packs)
Add localization
]]--

--setting up some configurations
application:setOrientation(conf.orientation)
application:setLogicalDimensions(conf.width, conf.height)
application:setScaleMode(conf.scaleMode)
application:setFps(conf.fps)
application:setKeepAwake(conf.keepAwake)

--get new dimensions
conf.width = application:getContentWidth()
conf.height = application:getContentHeight()

--create settings instance
sets = Settings.new()

--background music
music = Music.new("audio/main.mp3")
--when music gets enabled
music:addEventListener("onMusicOn", function()
	sets:set("music", true, true)
end)
--when music gets disabled
music:addEventListener("onMusicOff", function()
	sets:set("music", false, true)
end)

--play music if enabled
if sets:get("music") then
	music:on()
end

--sounds
sounds = Sounds.new()
--set up sound events
--when sounds turn on
sounds:addEventListener("onSoundsOn", function()
	sets:set("sounds", true, true)
end)

--when sounds turn off
sounds:addEventListener("onSoundsOff", function()
	sets:set("sounds", false, true)
end)

--load all your sounds here
--after that you can simply play them as sounds:play("hit")
sounds:add("complete", "audio/complete.mp3")
sounds:add("hit", "audio/hit.wav")
	
--load packs and level amounts from packs.json
packs = dataSaver.load("packs")

--define scenes
sceneManager = SceneManager.new({
	--start scene
	["start"] = start,
	--options scene
	["options"] = options,
	--pack select scene
	["pack_select"] = pack_select,
	--level select scene
	["level_select"] = level_select,
	--help scene
	["help"] = help,
	--level itself
	["level"] = level
})
--add manager to stage
stage:addChild(sceneManager)

--start start scene
sceneManager:changeScene("start", 1, conf.transition, conf.easing)