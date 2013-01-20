require 'Point'

Player = class('Player')
Player.CATEGORY = 1

function Player:initialize(world)
   local b = love.physics.newBody(world, 48, 48, 'dynamic')
   local s = love.physics.newCircleShape(16)
   love.physics.newFixture(b, s)
   b:setMass(1)
   self.body=b
   self.shape=s
   self.speed = 640 -- 320 is also good
end

function Player:draw()
   local g = love.graphics
   g.setColor(160, 64, 64)
   g.circle('fill', self.body:getX(), self.body:getY(), 16)
end

function Player:update(dt)
   local dir, keys_down = self:readDirection()

   if keys_down > 0 then
      self.body:setLinearDamping(0)
   else
      self.body:setLinearDamping(8)
   end

   self:max_speed()
   self.body:applyForce(dir.x * self.speed, dir.y * self.speed)

   if keys_down == 1 then
      self:dampenSidewaysVelocity(dir, dt)
   end
end

function Player:location()
   return Point(self.body:getX(), self.body:getY())
end

--------------------------------------------------

-- Reads the keyboard arrow keys and returns a direction (as a point),
-- and the number of direction keys that are down
function Player:readDirection()
   local k = love.keyboard.isDown
   local kd, dir = 0, Point(0, 0)

   if k('up') then dir = dir + Point.up ; kd = kd + 1 end
   if k('down') then dir = dir + Point.down ; kd = kd + 1 end
   if k('left') then dir = dir + Point.left ; kd = kd + 1 end
   if k('right') then dir = dir + Point.right ; kd = kd + 1 end

   return dir, kd
end

-- Limits player max linear speed
function Player:max_speed()
   local x, y = self.body:getLinearVelocity()
   if x*x + y*y > self.speed*self.speed then
      local a = math.atan2(y,x)
      self.body:setLinearVelocity(self.speed * math.cos(a),
                                  self.speed * math.sin(a))
   end
end

-- Dampens tangential motion while we're accelerating in a direction
function Player:dampenSidewaysVelocity(dir, dt)
   local a = 1 - 4 * dt
   if a > 1.0 then a = 1.0 elseif a < 0 then a = 0 end
   local v = Point(self.body:getLinearVelocity())

   if dir.y == 0 then v.y = v.y * a end
   if dir.x == 0 then v.x = v.x * a end

   self.body:setLinearVelocity(v.x, v.y)
end
