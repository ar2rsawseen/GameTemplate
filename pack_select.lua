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
pack_select = gideros.class(Sprite)

function pack_select:init()
	--load game manager
	local gm = GameManager.new(packs)
	--unlock first level
	gm:unlockLevel(1, 1)
	
	--create slider
	local slider = AceSlide.new()
	self:addChild(slider)
	--loop through packs
	for i, value in ipairs(packs.packs) do
		--create group
		local group = Sprite.new()
		
		--get pack picture
		local box
		--check if first level of pack is unlocked
		--then pack is probably unlocked
		if(gm:isUnlocked(i, 1)) then
			box = Button.new(Bitmap.new(Texture.new("images/crate.png", conf.textureFilter)), Bitmap.new(Texture.new("images/crate.png", conf.textureFilter)))
			--pack number
			box.cnt = i
			--add event listener
			box:addEventListener("click", function(e)
				--get target of event
				local target = e:getTarget()
				--get selected pack
				sets:set("curPack", target.cnt)
				--stop propagation
				e:stopPropagation()
				--go to level select of current pack
				sceneManager:changeScene("level_select", 1, conf.transition, conf.easing)
			end)
		else
			box = Button.new(Bitmap.new(Texture.new("images/crate_locked.png", conf.textureFilter)), Bitmap.new(Texture.new("images/crate_locked.png", conf.textureFilter)))
		end
		
		--scaling just for example to look better
		box.upState:setScaleX(3)
		box.upState:setScaleY(3)
		box.downState:setScaleX(3)
		box.downState:setScaleY(3)
		
		group:addChild(box)
		
		--add pack name
		local packName = TextWrap.new(value.name, box:getWidth(), "center", conf.largeFont)
		packName:setPosition(0, box:getHeight()/2 - packName:getHeight())
		packName:setTextColor(0xffffff)
		group:addChild(packName)
		
		if sets:get("curPack") == i then
			slider:add(group, true)
		else
			slider:add(group)
		end
	end
	--show Ace slide
	slider:show()
	
	--Select pack also with arrow buttons
	--just delete this if you don't need it
	
	local leftButton = Button.new(Bitmap.new(Texture.new("images/left-up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/left-down.png", conf.textureFilter)))
	leftButton:setPosition((conf.width-leftButton:getWidth())/4, (conf.height/2)-(leftButton:getHeight()/2))
	self:addChild(leftButton)
	leftButton:addEventListener("click", 
		function()	
			slider:prevItem()
		end
	)
	
	local rightButton = Button.new(Bitmap.new(Texture.new("images/right-up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/right-down.png", conf.textureFilter)))
	rightButton:setPosition(((conf.width-rightButton:getWidth())/4)*3, (conf.height/2)-(rightButton:getHeight()/2))
	self:addChild(rightButton)
	rightButton:addEventListener("click", 
		function()	
			slider:nextItem()
		end
	)
	
	
	--back button
	local backButton = Button.new(Bitmap.new(Texture.new("images/back_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/back_down.png", conf.textureFilter)))
	backButton:setPosition((conf.width-backButton:getWidth())/2, conf.height-backButton:getHeight()-10)
	self:addChild(backButton)

	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("start", 1, conf.transition, conf.easing) 
		end
	)

end