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

help = gideros.class(Sprite)

function help:init()
	--here we'd probably want to set up a background picture
	local screen = Bitmap.new(Texture.new("images/gideros_mobile.png", conf.textureFilter))
	self:addChild(screen)
	screen:setPosition((conf.width-screen:getWidth())/2, (conf.height-screen:getHeight())/2)
	
	--create layer for menu buttons
	local layer = Popup.new({easing = conf.easing})
	layer:setFillStyle(Shape.SOLID, 0x0000ff, 0.5)
	layer:setLineStyle(5, 0x000000)
	layer:setPosition(conf.width/2, conf.height/2)
	layer:setScale(0)
	self:addChild(layer)
	
	local textWidth = conf.width-60
	
	--title
	local title = TextWrap.new("Title", textWidth, "left", conf.largeFont)
	title:setPosition(-layer:getWidth()/2 + 30, -layer:getHeight()/2 + 100)
	title:setTextColor(0xffffff)
	layer:addChild(title)
	
	--help text
	local helpDesc = TextWrap.new("Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc suscipit arcu placerat lorem iaculis bibendum. Phasellus eu urna non massa rutrum euismod. Proin ac scelerisque augue. Sed vitae augue mi. Cras mi tellus, auctor pulvinar aliquet sed, suscipit eget justo. Nulla nec sem ac metus mollis ullamcorper eget eget dolor. Phasellus dapibus ligula ut lectus fringilla eu suscipit purus iaculis. Pellentesque commodo ipsum ac magna sollicitudin placerat. Morbi tempor pellentesque lacinia. Praesent quis mauris diam. Proin scelerisque venenatis libero, eu dictum orci placerat eget. In vitae metus quis ligula mollis blandit. Vestibulum est sem, ultricies id tempus et, sollicitudin eu augue.", textWidth, "justify", conf.smallFont)
	helpDesc:setPosition(-layer:getWidth()/2 + 30, -layer:getHeight()/2 + 150)
	helpDesc:setTextColor(0xffffff)
	layer:addChild(helpDesc)
	
	--back button
	local backButton = Button.new(Bitmap.new(Texture.new("images/back_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/back_down.png", conf.textureFilter)))
	backButton:setPosition(-backButton:getWidth()/2, layer:getHeight()/2-backButton:getHeight()*2)
	layer:addChild(backButton)

	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("start", 1, conf.transition, conf.easing) 
		end
	)
	
	layer:show()
end