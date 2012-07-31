Settings = Core.class()

--here you can define your settings to be used
--everytime you add new setting here, class will automatically load it
--no need to create new setting version
--setting versions are only if you want to maintain multiple setting versions
--for example, for multiple players.

local settings = {
	sounds = true,
	music = true,
	curLevel = 1,
	curPack = 1,
	showDescription = true
}

--create setting instance with optional setting version
function Settings:init(version)
	self.version = version or 0
	--loading application settings
	self.sets = dataSaver.loadValue("sets"..self.version)
	--settings did not change
	self.changed = false
	--if sets not define (first launch)
	--define defaults
	if(not self.sets) then
		self.sets = {}
		self.changed = true
	end
	--check if there are any new settings added
	if settings then
		for i, val in pairs(settings) do
			if self.sets[i] == nil then
				self.sets[i] = val
				self.changed = true
			end
		end
	end
	--save settings
	self:save()
end

--get value for specific setting
function Settings:get(key)
	return self.sets[key]
end

--set new setting or/and setting value
function Settings:set(key, value, autosave)
	if(self.sets[key] == nil or self.sets[key] ~= value) then
		self.sets[key] = value
		self.changed = true
	end
	if autosave then
		self:save()
	end
end

--save settings
function Settings:save()
	--check if anything was changed
	if(self.changed)then
		self.changed = false
		dataSaver.saveValue("sets"..self.version, self.sets)
	end
end

--clear settings for specific version
function Settings:clear(version)
	version = version or self.version
	dataSaver.saveValue("sets"..self.version, {})
end