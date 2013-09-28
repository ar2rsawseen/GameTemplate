local function getProperties(elem)
	local animate = {}
	animate.alpha = elem:getAlpha()
	animate.scaleX = elem:getScaleX()
	animate.scaleY = elem:getScaleY()
	animate.rotation = elem:getRotation()
	animate.x = elem:getX()
	animate.y = elem:getY()
	return animate
end

local function getDimensions(elem)
	--retrieve transformations
	local rotation = elem:getRotation()
	local scaleX, scaleY = elem:getScale()
	
	--reset transformations
	elem:setRotation(0)
	elem:setScale(1)
	
	--get real dimensions
	local width = elem:getWidth()
	local height = elem:getHeight()
	
	--put back transformations
	elem:setRotation(rotation)
	elem:setScale(scaleX, scaleY)
	
	--return real dimensions
	return width, height
	
end

View = Core.class(Sprite)

--overwrite methods
View.__addChild = View.addChild
View.__removeChild = View.removeChild

function View:init(config)
	--default configuration
	self.conf = {
		padding = 0,
		easing = easing.outBack,
		animate = true,
		duration = 1, 
		align = "center"
	}
	
	if config then
		--copying configuration
		for key,value in pairs(config) do
			self.conf[key]= value
		end
	end
	
	--properties
	self.total = 0
	self.width = 0
	self.height = 0
	
	--spacer
	self.spacer = Shape.new()
	self.spacer:beginPath()
	self.spacer:moveTo(-1, -1)
	self.spacer:lineTo(-1, 0)
	self.spacer:lineTo(0, 0)
	self.spacer:lineTo(0, -1)
	self.spacer:lineTo(-1, -1)
	self.spacer:endPath()
	self:__addChild(self.spacer)
end

function View:getWidth()
	return self.width
end

function View:getHeight()
	return self.height
end

function View:reverse()
	--reverse animation for all children
	local children = self:getNumChildren()
	for i = 1, children do
		local sprite = self:getChildAt(i)
		if(sprite.original)then
			sprite.tween:resetValues(sprite.original)
		end
	end
end

function View:addChild(item, x, y)
	local width, height = getDimensions(item)
	if self.conf.animate then
		--default properties
		local animate = {}
		animate.alpha = 1
		animate.scaleX = 1
		animate.scaleY = 1
		animate.rotation = 0
		animate.y = x
		animate.x = y
		
		--copy original properties
		item.original = getProperties(item)
		
		--use spacer
		self.spacer:setPosition(width, self.total + height)
		
		--animate
		item.tween = GTween.new(item, self.conf.duration, animate, {ease = self.conf.easing})
	else
		item:setPosition(x, y)
	end
	self:__addChild(item)
	self.width = self:getWidth()
	self.height = self:getHeight()
end

function View:removeChild(item)
	--find and remove button
	local children = self:getNumChildren()
	for i = 1, children do
		local sprite = self:getChildAt(i)
		if(sprite == item)then
			self:__removeChild(item)
		end
	end
end

function View:replaceChild(oldItem, newItem)
	--find and replace button
	local children = self:getNumChildren()
	for i = 1, children do
		local sprite = self:getChildAt(i)
		if(sprite == oldItem)then
			local x, y = oldItem:getPosition()
			sprite.tween = oldItem.tween
			self:__removeChild(oldItem)
			newItem:setPosition(x,y)
			self:__addChild(newItem)
		end
	end
end

VerticalView = Core.class(View)

function VerticalView:addChild(item)
	local width, height = getDimensions(item)
	item.__width = width
	item.__height = height
	--calculate positions
	if self.total > 0 then
		self.total = self.total + self.conf.padding
	end
	
	if self.conf.animate then
		--default properties
		local animate = {}
		animate.alpha = 1
		animate.scaleX = 1
		animate.scaleY = 1
		animate.rotation = 0
		animate.y = self.total
		animate.x = 0
		item.__animate = animate
		
		--copy original properties
		item.original = getProperties(item)
		
		--use spacer
		self.spacer:setPosition(width, self.total + height)
		
		--animate
		item.tween = GTween.new(item, self.conf.duration, animate, {ease = self.conf.easing})
	else
		item:setPosition(0, self.total)
	end
	
	self.total = self.total + height
	if self.total > self.height then
		self.height = self.total
	end
	if width > self.width then
		self.width = width
	end
	self:__addChild(item)
	self:reposition()
end

function VerticalView:reposition()
	local sprite
	if self.conf.align ~= "left" then
		for i = 1, self:getNumChildren() do
			sprite = self:getChildAt(i)
			if sprite ~= self.spacer then
				if self.conf.align == "center" then
					if self.conf.animate then
						sprite.__animate.x = (self.width - sprite.__width)/2
						sprite.tween:resetValues(sprite.__animate)
					else
						sprite:setX((self.width - sprite:getWidth())/2)
					end
				else
					if self.conf.animate then
						sprite.__animate.x = (self.width - sprite.__width)
						sprite.tween:resetValues(sprite.__animate)
					else
						sprite:setX((self.width - sprite:getWidth()))
					end
				end
			end
		end
	end
end

HorizontalView = Core.class(View)

function HorizontalView:addChild(item)
	local width, height = getDimensions(item)
	item.__width = width
	item.__height = height
	--calculate positions
	if self.total > 0 then
		self.total = self.total + self.conf.padding
	end
	
	if self.conf.animate then
		--default properties
		local animate = {}
		animate.alpha = 1
		animate.scaleX = 1
		animate.scaleY = 1
		animate.rotation = 0
		animate.y = 0
		animate.x = self.total
		item.__animate = animate
		
		--copy original properties
		item.original = getProperties(item)
		
		--use spacer
		self.spacer:setPosition(self.total + width, height)
		
		--animate
		item.tween = GTween.new(item, self.conf.duration, animate, {ease = self.conf.easing})
	else
		item:setPosition(self.total, 0)
	end
	
	self.total = self.total + width
	if self.total > self.width then
		self.width = self.total
	end
	if height > self.height then
		self.height = height
	end
	self:__addChild(item)
	self:reposition()
end

function HorizontalView:reposition()
	local sprite
	if self.conf.align ~= "top" then
		for i = 1, self:getNumChildren() do
			sprite = self:getChildAt(i)
			if sprite ~= self.spacer then
				if self.conf.align == "center" then
					if self.conf.animate then
						sprite.__animate.y = (self.height - sprite.__height)/2
						sprite.tween:resetValues(sprite.__animate)
					else
						sprite:setY((self.height - sprite:getHeight())/2)
					end
				else
					if self.conf.animate then
						sprite.__animate.y = (self.height - sprite.__height)
						sprite.tween:resetValues(sprite.__animate)
					else
						sprite:setY((self.height - sprite:getHeight()))
					end
				end
			end
		end
	end
end

GridView = Core.class(View)

function GridView:init(config)
	--default configuration
	self.conf = {
		cols = 4,
		padding = 0,
		easing = nil,
		animate = true,
		duration = 1,
		reverse = true
	}
	
	if config then
		--copying configuration
		for key,value in pairs(config) do
			self.conf[key]= value
		end
	end
	
	--properties
	self.cnt = 0
	self.startX = 0
	self.startY = 0
end

function GridView:addChild(item)
	local width, height = getDimensions(item)
	
	if self.conf.animate then
		--default properties
		local animate = {}
		animate.alpha = 1
		animate.scaleX = 1
		animate.scaleY = 1
		animate.rotation = 0
		animate.y = self.startY
		animate.x = self.startX
		
		if(self.startX + width > self.width) then
			self.width = self.startX + width
		end
		
		if(self.startY + height > self.height) then
			self.height = self.startY + height
		end
		
		--copy original properties
		item.original = getProperties(item)
		
		--use spacer
		self.spacer:setPosition(self.width + width, self.height  + height)
		
		--animate
		item.tween = GTween.new(item, self.conf.duration, animate, {ease = self.conf.easing})
	else
		item:setPosition(self.startX, self.startY)
	end
	
	--split levels in rows by 5 columns
	if self.cnt == self.conf.cols-1 then 
		self.cnt = 0
		self.startX = 0
		self.startY = self.startY + height + self.conf.padding
	else
		self.startX = self.startX + width + self.conf.padding
		self.cnt = self.cnt + 1
	end
	
	self:__addChild(item)
end