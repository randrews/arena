Entity = class('Entity')

function Entity:setup(world, location, shape)
   assert(world and location and shape)
   self.body = love.physics.newBody(world, location.x, location.y, 'dynamic')
   self.shape = shape
   self.fixture = love.physics.newFixture(self.body, self.shape)
   self.world = world
   self.fixture:setUserData(self)
end

function Entity:circle(world, location, radius)
   local s = love.physics.newCircleShape(radius)
   self:setup(world, location, s)
end

function Entity:rectangle(world, location, width, height)
   local s = love.physics.newRectangleShape(width, height)
   self:setup(world, location, s)
end

function Entity:location()
   return Point(self.body:getX(), self.body:getY())
end

function Entity:draw()
   love.graphics.setColor(255, 255, 255)
   local loc = self:location()
   love.graphics.circle('line', loc.x, loc.y, 5, 20)
end

-- Limits max linear speed
function Entity:max_speed(max)
   local x, y = self.body:getLinearVelocity()
   if x*x + y*y > max*max then
      local a = math.atan2(y,x)
      self.body:setLinearVelocity(max * math.cos(a),
                                  max * math.sin(a))
   end
end
