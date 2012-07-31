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

level = gideros.class(Sprite)

function level:onMouseDown( event )
	if(startGame) then
		--if isset description hide it
		if self.description then
			showDescription = false
			self.description:setVisible(false)
		end
		level:startGame()
	else
		local x, y = levelSelf.crate:getPosition()
		--apply some random force
		levelSelf.crate.body:applyForce(1000*(math.random(1,3)-2), -10000, x+(math.random(1,3)-2), y+(math.random(1,3)-2))
	end
end

function level:startGame()
	--game started
	startGame = false
	--do your game logic and stuff
	--let's simply drop crate
	levelSelf.crate = displayImage.new("images/crate.png", levelSelf)
	levelSelf.crate:setPosition(200, 10)
	physicsAddBody(levelSelf.world, levelSelf.crate, {type = "dynamic", density = 1.0, friction = 0.1, bounce = 0.2})
	levelSelf.crate.body.type = "crate";
	levelSelf:addChild(levelSelf.crate)
	
	--collision handler
	local function onBeginContact(event)
		local fixtureA = event.fixtureA
		local fixtureB = event.fixtureB
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB:getBody()
		
		--calculate points based on velocity
		vx, vy = bodyB:getLinearVelocity()
		currentScore = currentScore + (math.ceil((math.abs(vx)+math.abs(vy))*10)*10)
		
		--update score on screen
		levelSelf.score:setText("Score: "..currentScore)
		
		--play hit sound
		sounds.play("hit")
		
		--add next level button
		if currentScore > 1000 and not levelSelf:contains(levelSelf.nextLevel) then
			levelSelf:addChild(levelSelf.nextLevel)
		end
	end
	
	--add collision handler
	levelSelf.world:addEventListener(Event.BEGIN_CONTACT, onBeginContact)
end

function level:init()

	--load scores
	local highScore = dataSaver.loadValue("scores")
	--if not exist yet
	if(not highScore) then
		highScore = {}
	end
	--score for this level
	if(not highScore[(sets.curPack).."-"..sets.curLevel]) then
		highScore[(sets.curPack).."-"..sets.curLevel] = {}
		highScore[(sets.curPack).."-"..sets.curLevel].score = 0
	end
	currentScore = 0
	--save score function
	local saveScore = function()
		if(currentScore > highScore[(sets.curPack).."-"..sets.curLevel].score) then
			highScore[(sets.curPack).."-"..sets.curLevel].score = currentScore
		end
		--increase level
		sets.curLevel = sets.curLevel + 1
		
		--if level does not exist in pack
		if(packs.packs[sets.curPack].levels < sets.curLevel) then
			--level one
			sets.curLevel = 1
			--increase pack
			sets.curPack = sets.curPack + 1
			--if pack exists
			if(packs.packs[sets.curPack]) then
				--unlock pack
				local unPacks = dataSaver.loadValue("unPacks")
				if(not unPacks) then
					unPacks = {}
				end
				unPacks[sets.curPack] = true
				dataSaver.saveValue("unPacks", unPacks)
			else
				--if doesn't exist, go back
				sets.curPack = sets.curPack - 1
			end
			--unlock next level
			if(not highScore[(sets.curPack).."-"..sets.curLevel]) then
				highScore[(sets.curPack).."-"..sets.curLevel] = {}
				highScore[(sets.curPack).."-"..sets.curLevel].score = 0
				highScore[(sets.curPack).."-"..sets.curLevel].unlocked = true
			end
			--save high score
			dataSaver.saveValue("scores", highScore)
			ret = "pack_select"
		else
			--unlock next level
			if(not highScore[(sets.curPack).."-"..sets.curLevel]) then
				highScore[(sets.curPack).."-"..sets.curLevel] = {}
				highScore[(sets.curPack).."-"..sets.curLevel].score = 0
				highScore[(sets.curPack).."-"..sets.curLevel].unlocked = true
			end
			--save high score
			dataSaver.saveValue("scores", highScore)
			ret = "level"
		end
		--save setting
		dataSaver.saveValue("sets", sets)
		--return to scene
		return ret
	end
	--self reference
	--fore easy access out of scope
	levelSelf = self
	--allow to start game
	startGame = true
	--is game paused
	pauseGame = false
	--create worl
	self.world = b2.World.new(0, 10, true)

	--add event listener
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)

	local lastLeft = 10
	--reset button
	resetButton = Button.new(Bitmap.new(Texture.new("images/reset_up.png")), Bitmap.new(Texture.new("images/reset_down.png")))
	resetButton:setPosition(lastLeft, 10)
	self:addChild(resetButton)
	resetButton:addEventListener("click", 
		function()	
			if not startGame then
				--dont show description
				showDescription = false
				--simply load same scene
				sceneManager:changeScene("level", 1, transition, easing.outBack)
			end
		end
	)
	lastLeft = lastLeft + resetButton:getWidth() + 45
	
	--back to menu button
	menuBtn = Button.new(Bitmap.new(Texture.new("images/menu_up.png")), Bitmap.new(Texture.new("images/menu_down.png")))
	menuBtn:setPosition(lastLeft, 10)
	self:addChild(menuBtn)
	menuBtn:addEventListener("click", 
		function()	
			if not startGame then
				pauseGame = true
				--create layer for menu buttons
				local menu = Shape.new()
				menu:setFillStyle(Shape.SOLID, 0xffffff, 0.5)   
				menu:beginPath(Shape.NON_ZERO)
				menu:moveTo(application:getContentWidth()/5,application:getContentHeight()/16)
				menu:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()/16)
				menu:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()-(application:getContentHeight()/16))
				menu:lineTo(application:getContentWidth()/5, application:getContentHeight()-(application:getContentHeight()/16))
				menu:lineTo(application:getContentWidth()/5, application:getContentHeight()/16)
				menu:endPath()
				levelSelf:addChild(menu)
				
				--close menu button
				local backButton = menuButton("images/back_up.png","images/back_down.png", menu, 1,5)
				menu:addChild(backButton)
				backButton:addEventListener("click", 
					function()	
						pauseGame = false
						levelSelf:removeChild(menu)
					end
				)
				
				--reset level button
				local restartButton = menuButton("images/reset_up.png","images/reset_down.png", menu, 2,5)
				menu:addChild(restartButton)
				restartButton:addEventListener("click", 
					function()	
						sceneManager:changeScene("level", 1, transition, easing.outBack)
					end
				)
				
				--select pack button
				local packButton = menuButton("images/packselect_up.png","images/packselect_down.png", menu, 3,5)
				menu:addChild(packButton)
				packButton:addEventListener("click", 
					function()	
						sceneManager:changeScene("pack_select", 1, transition, easing.outBack)
					end
				)
				
				--select level of current pack button
				local levelButton = menuButton("images/levelselect_up.png","images/levelselect_down.png", menu, 4,5)
				menu:addChild(levelButton)
				levelButton:addEventListener("click", 
					function()	
						sceneManager:changeScene("level_select", 1, transition, easing.outBack)
					end
				)
				
				--go to start menu
				local menuButton = menuButton("images/menu_up.png","images/menu_down.png", menu, 5,5)
				menu:addChild(menuButton)
				menuButton:addEventListener("click", 
					function()	
						sceneManager:changeScene("start", 1, transition, easing.outBack)
					end
				)
			end
		end
	)
	lastLeft = lastLeft + menuBtn:getWidth() + 45
	
	--pause button
	self.pauseButton = Button.new(Bitmap.new(Texture.new("images/pause_up.png")), Bitmap.new(Texture.new("images/pause_down.png")))
	self.pauseButton:setPosition(lastLeft, 10)
	self:addChild(self.pauseButton)
	self.pauseButton:addEventListener("click", 
		function()
			if not startGame then
				pauseGame = true
				self:removeChild(self.pauseButton)
				self:addChild(self.resumeButton)
			end
		end
	)
	
	--resume button
	self.resumeButton = Button.new(Bitmap.new(Texture.new("images/resume_up.png")), Bitmap.new(Texture.new("images/resume_down.png")))
	self.resumeButton:setPosition(lastLeft, 10)
	self.resumeButton:addEventListener("click", 
		function()
			if not startGame then
				pauseGame = false
				self:removeChild(self.resumeButton)
				self:addChild(self.pauseButton)
			end
		end
	)
	
	
	--next level button
	self.nextLevel = Button.new(Bitmap.new(Texture.new("images/next_up.png")), Bitmap.new(Texture.new("images/next_down.png")))
	self.nextLevel:setPosition((application:getContentWidth()-self.nextLevel:getWidth())/2, (application:getContentHeight()-self.nextLevel:getHeight())/2)
	self.nextLevel:addEventListener("click", 
		function()	
			--display description of next level
			showDescription = true
			--play complete sounds
			sounds.play("complete")
			--vibrate phone
			application:vibrate()
			--save score, increase level, reset scene
			sceneManager:changeScene(saveScore(), 1, SceneManager.flipWithFade, easing.outBack)
		end
	)
	
	--display highscore
	local highscore = TextField.new(nil, "Highscore: "..highScore[(sets.curPack).."-"..sets.curLevel].score)
	highscore:setPosition(10,application:getContentHeight()-30)
	highscore:setTextColor(0x000000)
	self:addChild(highscore)
	
	--display current score
	self.score = TextField.new(nil, "Score: 0")
	self.score:setPosition(10,application:getContentHeight()-20)
	self.score:setTextColor(0x000000)
	self:addChild(self.score)
	showDescription = false
	if showDescription then
		--create level description
		self.description = Shape.new()
		self.description:setFillStyle(Shape.SOLID, 0xff0000, 0.5)   
		self.description:beginPath(Shape.NON_ZERO)
		self.description:moveTo(application:getContentWidth()/5,application:getContentHeight()/16)
		self.description:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()/16)
		self.description:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()-(application:getContentHeight()/16))
		self.description:lineTo(application:getContentWidth()/5, application:getContentHeight()-(application:getContentHeight()/16))
		self.description:lineTo(application:getContentWidth()/5, application:getContentHeight()/16)
		self.description:endPath()
		self:addChild(self.description)
		
		--setting up description texts
		local lastHeight = (application:getContentHeight()/16)*2
		local textWidth = ((application:getContentWidth()/5)*3) - ((application:getContentHeight()/16)*2)
		local levelName = TextWrap.new("Level Name "..sets.curLevel.." - simply click to start", textWidth)
		levelName:setPosition((application:getContentWidth()/5)+application:getContentHeight()/16, lastHeight)
		levelName:setTextColor(0xffffff)
		self.description:addChild(levelName)
		lastHeight = lastHeight + 20 + levelName:getHeight()
		
		local levelDesc = TextWrap.new("Click more to make crate jump. Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc suscipit arcu placerat lorem iaculis bibendum. Phasellus eu urna non massa rutrum euismod. Proin ac scelerisque augue. Sed vitae augue mi. Cras mi tellus, auctor pulvinar aliquet sed, suscipit eget justo. Nulla nec sem ac metus mollis ullamcorper eget eget dolor. Phasellus dapibus ligula ut lectus fringilla eu suscipit purus iaculis. Pellentesque commodo ipsum ac magna sollicitudin placerat. Morbi tempor pellentesque lacinia. Praesent quis mauris diam. Proin scelerisque venenatis libero, eu dictum orci placerat eget. In vitae metus quis ligula mollis blandit. Vestibulum est sem, ultricies id tempus et, sollicitudin eu augue.", textWidth, "justify")
		levelDesc:setPosition((application:getContentWidth()/5)+application:getContentHeight()/16, lastHeight)
		levelDesc:setTextColor(0xffffff)
		self.description:addChild(levelDesc)
	else
		level:startGame()
	end
	
	--bounding walls around screen
	self:addChild(self:wall(0,0,10,application:getContentHeight()))
	self:addChild(self:wall(0,0,application:getContentWidth(),10))
	self:addChild(self:wall(application:getContentWidth()-10,0,10,application:getContentHeight()))
	self:addChild(self:wall(0,application:getContentHeight()-10,application:getContentWidth(),10))

	--debug drawing
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)

	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame)
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

--removing event
function level:onEnterFrame() 
	if not startGame and not pauseGame then
		updatePhysicsObjects(levelSelf.world, levelSelf)
	end
end

--removing event on exiting scene
function level:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end