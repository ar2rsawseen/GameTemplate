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

local function randomize(elem)
	elem:setPosition(math.random(-1000, 1000), math.random(-1000, 1000))
	elem:setRotation(math.random(0, 360))
	elem:setAlpha(math.random())
	elem:setScale(math.random())
end
start = Core.class(Sprite)

function start:init()
	--here we'd probably want to set up a background picture
	local screen = Bitmap.new(Texture.new("images/gideros_mobile.png", conf.textureFilter))
	self:addChild(screen)
	screen:setPosition((conf.width-screen:getWidth())/2, (conf.height-screen:getHeight())/2)
	
	--create menu
	--with 20px padding between buttons
	local menu = VerticalView.new({padding = 20, easing = conf.easing})
	
	self:addChild(menu)
	
	local button = Button.new(Bitmap.new(Texture.new("images/start_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/start_down.png", conf.textureFilter)))
	randomize(button)
	button:addEventListener("click", function()
		menu:reverse()
		--go to pack select scene
		sceneManager:changeScene("pack_select", 1, conf.transition, conf.easing) 
	end)
	--add menu buttons
	menu:addChild(button)
	
	local button =  Button.new(Bitmap.new(Texture.new("images/options_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/options_down.png", conf.textureFilter)))
	randomize(button)
	button:addEventListener("click", function()
		menu:reverse()
		--go to pack select scene
		sceneManager:changeScene("options", 1, conf.transition, conf.easing) 
	end)
	menu:addChild(button)
	
	local button =  Button.new(Bitmap.new(Texture.new("images/help_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/help_down.png", conf.textureFilter)))
	randomize(button)
	button:addEventListener("click", function()
		menu:reverse()
		--go to pack select scene
		sceneManager:changeScene("help", 1, conf.transition, conf.easing) 
	end)
	menu:addChild(button)
	
	--position menu in center
	menu:setPosition((conf.width-menu:getWidth())/2, (conf.height-menu:getHeight())/2)
	
end