--[[ 
 
This is a helper library class created by Shark Soup Studios
http://www.sharksoupstudios.com
 
Feel free to use, amend, extend as needed!
 
]]
 
displayGroup = gideros.class(Sprite)
displayImage = gideros.class(Sprite)
 
function displayGroup:init(addToStage)
	if addToStage == nil then addToStage = true; end
	if addToStage then
		stage:addChild(self)
	end
	self.group = true
end
 
function displayImage:init(texture, displaygroup)
	local thisImage = Bitmap.new(Texture.new(texture))
	self:addChild(thisImage)
	self.image = thisImage
	if displaygroup then
		displaygroup:addChild(self)
	else
		stage:addChild(self)
	end
end
 
function displayGroup:insert(sprite)
	self:addChild(sprite)
end
 
 
function stage:insert(sprite)
	self:addChild(sprite)
end
 
function physicsAddBody(b2world, object, args)
	local bodyDef = {}
	if args.type then
		if args.type == "static" then
			bodyDef.type = b2.STATIC_BODY
		elseif args.type == "kinematic" then
			bodyDef.type = b2.KINEMATIC_BODY
		elseif args.type == "dynamic" then
			bodyDef.type = b2.DYNAMIC_BODY
		else
			bodyDef.type = b2.DYNAMIC_BODY
		end
	end
 
	bodyDef.density = args.density or 1.0
	bodyDef.restitution = args.bounce or 0.0
	if args.restitution then
		bodyDef.restitution = args.restitution
	end
	bodyDef.friction = args.friction or 0.0
	bodyDef.isSensor = args.isSensor or false
 
	if args.width then
		bodyDef.width = args.width
	else
		bodyDef.width = object:getWidth()
	end
 
	if args.height then 
		bodyDef.height = args.height
	else
		bodyDef.height = object:getHeight()
	end
 
	if args.radius then
		bodyDef.radius = args.radius
	end
 
	local thisShape
	local thisBody = b2world:createBody({type = bodyDef.type})
 
	bodyDef.x = math.floor(object:getX() + bodyDef.width/2)
	bodyDef.y = math.floor(object:getY() + bodyDef.height/2)	
 
	if args.radius then
		bodyDef.width = object:getWidth()
		bodyDef.height = object:getHeight()
		bodyDef.x = math.floor(object:getX() + (bodyDef.width/2))
		bodyDef.y = math.floor(object:getY() + (bodyDef.height/2))
		thisShape = b2.CircleShape.new(0, 0, bodyDef.radius)
	else
		thisShape = b2.PolygonShape.new()
		thisShape:setAsBox(bodyDef.width/2, bodyDef.height/2)
	end
 
	local thisFixture = thisBody:createFixture{shape = thisShape, density = bodyDef.density, restitution = bodyDef.restitution, friction = bodyDef.friction, isSensor = bodyDef.isSensor}
	thisBody:setPosition(bodyDef.x, bodyDef.y)
 
	if object.image then
		object.image:setAnchorPoint(0.5, 0.5)
	end
	object:setPosition(bodyDef.x, bodyDef.y)
 
	thisBody.object = object
	object.body = thisBody
	object.fixture = thisFixture
end
 
 
 
local function updatePosition(object)
	local body = object.body
	local bodyX, bodyY = body:getPosition()
	object:setPosition(bodyX, bodyY)
	object:setRotation(body:getAngle() * 180 / math.pi)
end
 
function updatePhysicsObjects(physWorld, scope)
	physWorld:step(1/60, 8, 3)	-- edit the step values if required. These are good defaults!
	for i = 1, scope:getNumChildren() do
		local sprite = scope:getChildAt(i)
		-- determine if this is a sprite, or a group
		if sprite.group == nil then
			local body = sprite.body
			-- if it's not a group, but HAS a body (ie, it's a physical object directly on the stage)
			if body then
				updatePosition(sprite)
			else 
 
			end
		elseif sprite.group == true then
			-- if it IS a group, then iterate through the groups children
			for j = 1, sprite:getNumChildren() do
				local childSprite = sprite:getChildAt(j)
				local body = childSprite.body
				if body then
					updatePosition(childSprite)
				end				
			end
		end
	end
end