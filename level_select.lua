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
	elem:setY(-1000)
	--[[elem:setPosition(math.random(-1000, 1000), math.random(-1000, 1000))
	elem:setRotation(math.random(0, 360))
	elem:setAlpha(math.random())
	elem:setScale(math.random())]]
end

level_select = gideros.class(Sprite)

function level_select:init()
	--get current pack
	local curPack = sets:get("curPack")
	
	--load game manager
	local gm = GameManager.new(packs)
	
	--back button
	local backButton = Button.new(Bitmap.new(Texture.new("images/back_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/back_down.png", conf.textureFilter)))
	backButton:setPosition((conf.width-backButton:getWidth())/2, conf.height-backButton:getHeight())
	self:addChild(backButton)

	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("pack_select", 1, conf.transition, conf.easing) 
		end
	)
	
	--create grid
	local grid = GridView.new({cols = 3, padding = 35, easing = conf.easing})
	self:addChild(grid)
	
	--just for the awesome effect of separate box tweening let's create a timer instead of loop
	local i = 1
	--execute timer as much times as there are levels in current pack
	local timer = Timer.new(20, packs.packs[curPack].levels)
	--for each level
	timer:addEventListener(Event.TIMER, function()
		--create group
		local group = Sprite.new()
		
		--create level image
		local box
		--check if unlocked level
		if(gm:isUnlocked(curPack, i)) then
			box = Button.new(Bitmap.new(Texture.new("images/crate.png", conf.textureFilter)), Bitmap.new(Texture.new("images/crate.png", conf.textureFilter)))
			--level number
			box.cnt = i
		
			--add event listener
			box:addEventListener("click", function(e)
				--get target of event
				local target = e:getTarget()
				--save selected level
				sets:set("curLevel", target.cnt)
				--set to show description
				sets:set("showDescription", true)
				--stop propagation
				e:stopPropagation()
				--go to selected level
				sceneManager:changeScene("level", 1, conf.transition, conf.easing)
			end)
		else
			box = Button.new(Bitmap.new(Texture.new("images/crate_locked.png", conf.textureFilter)), Bitmap.new(Texture.new("images/crate_locked.png", conf.textureFilter)))
		end
		
		group:addChild(box)
		
		local levelName = TextWrap.new(""..i.."", box:getWidth(), "center", conf.largeFont)

		levelName:setPosition(0, box:getHeight()/2)

		levelName:setTextColor(0xffffff)
		group:addChild(levelName)
		
		--set position somewhere up outside the screen
		group:setY(-1000)
		
		grid:addChild(group)
		i = i + 1
		
		--set current position of grid
		grid:setPosition((conf.width-grid:getWidth())/2, 50)
	end)
	timer:start()
	
	--as new elements are added, dimenstions of grid are expanding
	--set positioning one last time
	grid:setPosition((conf.width-grid:getWidth())/2, 50)
	
end