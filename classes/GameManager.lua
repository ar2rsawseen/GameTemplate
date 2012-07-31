GameManager = Core.class()

function GameManager:init(gameData, player)
	self.player = player or "player"
	self.data = gameData
	self.packs = {}
end

function GameManager:loadPack(pack)
	if self.packs[pack] == nil then
		self.packs[pack] = dataSaver.load("|D|scores"..self.player.."-"..pack)
	end
	if not self.packs[pack] then
		self.packs[pack] = {}
	end
end

function GameManager:createLevel(pack, level)
	self.packs[pack][level] = {}
	self.packs[pack][level].score = 0
	self.packs[pack][level].stars = 0
	self.packs[pack][level].time = nil
	self.packs[pack][level].unlocked = false
	self:save(pack)
end

function GameManager:getScore(pack, level)
	self:loadPack(pack)
	if(self.packs[pack][level] == nil) then
		self:createLevel(pack, level)
	end
	return self.packs[pack][level].score, self.packs[pack][level].time
end

function GameManager:getStars(pack, level)
	self:loadPack(pack)
	if(self.packs[pack][level] == nil) then
		self:createLevel(pack, level)
	end
	return self.packs[pack][level].stars
end

function GameManager:unlockLevel(pack, level)
	self:loadPack(pack)
	if(self.packs[pack][level] == nil) then
		self:createLevel(pack, level)
	end
	if not self.packs[pack][level].unlocked then
		self.packs[pack][level].unlocked = true
		self:save(pack)
	end
end

function GameManager:getNextLevel(pack, level, unlock)
	self:loadPack(pack)
	level = level + 1
	if self.data.packs[pack].levels < level then
		level = 1
		pack = pack + 1
	end
	if self.data.packs[pack] and self.data.packs[pack].levels >= level then
		if unlock then
			self:unlockLevel(pack, level)
		end
		return pack, level
	else
		return nil
	end
end

function GameManager:isUnlocked(pack, level)
	self:loadPack(pack)
	if(self.packs[pack][level] == nil) then
		self:createLevel(pack, level)
	end
	if(self.packs[pack][level] and self.packs[pack][level].unlocked) then
		return true
	end
	return false
end

function GameManager:setScore(pack, level, score)
	self:loadPack(pack)
	if(self.packs[pack][level] == nil) then
		self:createLevel(pack, level)
	end
	if(self.packs[pack][level].score < score)then
		self.packs[pack][level].score = score
		self.packs[pack][level].time = os.time()
		self:save(pack)
		return true
	end
	return false
end

function GameManager:setStars(pack, level, stars)
	self:loadPack(pack)
	if(self.packs[pack][level] == nil) then
		self:createLevel(pack, level)
	end
	if(self.packs[pack][level].stars < stars)then
		self.packs[pack][level].stars = stars
		self:save(pack)
		return true
	end
	return false
end

function GameManager:save(pack)
	dataSaver.save("|D|scores"..self.player.."-"..pack, self.packs[pack])
end