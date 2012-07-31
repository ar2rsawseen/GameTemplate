Sounds = Core.class(EventDispatcher)

function Sounds:init()
	self.isOn = false
	self.sounds = {}
	self.eventOn = Event.new("onSoundsOn")
	self.eventOff = Event.new("onSoundsOff")
end

function Sounds:add(name, sound)
	if self.sounds[name] == nil then
		self.sounds[name] = {}
	end
	self.sounds[name][#self.sounds[name]+1] = Sound.new(sound)
end

--turn sounds on
function Sounds:on()
	if not self.isOn then
		self.isOn = true
		self:dispatchEvent(self.eventOn)
	end
end

--turn sounds off
function Sounds:off()
	if self.isOn then
		self.isOn = false
		self:dispatchEvent(self.eventOff)
	end
end

function Sounds:play(sound)
	if self.isOn and self.sounds[sound] then
		self.sounds[sound][math.random(1, #self.sounds)]:play()
	end
end