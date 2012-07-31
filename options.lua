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

options = gideros.class(Sprite)

function options:init()
	--here we'd probably want to set up a background picture
	local screen = Bitmap.new(Texture.new("images/gideros_mobile.png", conf.textureFilter))
	self:addChild(screen)
	screen:setPosition((conf.width-screen:getWidth())/2, (conf.height-screen:getHeight())/2)
	
	--create layer for menu buttons
	local layer = Popup.new({easing = conf.easing})
	layer:setFillStyle(Shape.SOLID, 0xff0000, 0.2)
	layer:setLineStyle(5, 0x000000)
	layer:setPosition(conf.width/2, conf.height/2)
	layer:setScale(0)
	
	self:addChild(layer)
	
	local menu = VerticalView.new({padding = 20, easing = conf.easing})
	
	layer:addChild(menu)

	local musicOnButton = Button.new(Bitmap.new(Texture.new("images/musicon_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/musicon_down.png", conf.textureFilter)))
	local musicOffButton = Button.new(Bitmap.new(Texture.new("images/musicoff_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/musicoff_down.png", conf.textureFilter)))
	
	musicOnButton:addEventListener("click", function()
			menu:replaceChild(musicOnButton, musicOffButton)
			music:off()
	end)
	
	musicOffButton:addEventListener("click", function()
			menu:replaceChild(musicOffButton, musicOnButton)
			music:on()
	end)
	
	if sets:get("music") then
		menu:addChild(musicOnButton)
	else
		menu:addChild(musicOffButton)
	end
	
	local soundsOnButton = Button.new(Bitmap.new(Texture.new("images/soundson_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/soundson_down.png", conf.textureFilter)))
	local soundsOffButton = Button.new(Bitmap.new(Texture.new("images/soundsoff_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/soundsoff_down.png", conf.textureFilter)))
	
	soundsOnButton:addEventListener("click", 
		function()
			menu:replaceChild(soundsOnButton, soundsOffButton)
			sounds:off()
		end
	)
	
	soundsOffButton:addEventListener("click", 
		function()
			menu:replaceChild(soundsOffButton, soundsOnButton)
			sounds:on()
		end
	)
	
	if sets:get("sounds") then
		menu:addChild(soundsOnButton)
	else
		menu:addChild(soundsOffButton)
	end
	
	local backButton = Button.new(Bitmap.new(Texture.new("images/back_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/back_down.png", conf.textureFilter)))
	backButton:addEventListener("click", 
		function()
		menu:reverse()
		sceneManager:changeScene("start", 1, conf.transition, conf.easing) 
	end
	)
	menu:addChild(backButton)
	
	--position menu in center
	menu:setPosition(-menu:getWidth()/2, -menu:getHeight()/2)
	
	layer:show()
	
end