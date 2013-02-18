require 'Point'
require 'Entity'
require 'Bullet'

Player = class('Player', Entity)
Player.CATEGORY = 1

function Player:initialize(world, location)
   self:circle(world, location, 14)
   self.body:setMass(1)
   self.speed = 320 -- 640 is also good
end

function Player:draw()
   local g = love.graphics
   g.setColor(134, 134, 240)
   g.circle('fill', self.body:getX(), self.body:getY(), 14)
end

function Player:update(dt)
   local dir, keys_down, conflict = self:readDirection()

   if conflict or keys_down == 0 then
      self.body:setLinearDamping(12)
   else
      self.body:setLinearDamping(0)
   end

   self:max_speed(self.speed/2)
   self.body:applyForce(dir.x * self.speed, dir.y * self.speed)

   if keys_down == 1 then
      self:dampenSidewaysVelocity(dir, dt)
   end
end

-- Treat the player as if all controls went dead: in other words,
-- brake to a quick stop (this happens when the level ends and we
-- jump into a portal
function Player:brake()
   self.body:setLinearDamping(12)
end

function Player:collision(entity)
   if instanceOf(Bullet, entity) then
      print("Shot")
   end
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

   local conflict = k('up') and k('down') or k('left') and k('right')

   return dir, kd, conflict
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
