require('middleclass')
require('Entity')

Crate = class('Crate', Entity)
Crate.CATEGORY = 3

function Crate:initialize(world, x, y)
   self:rectangle(world, Point(x, y), 30, 30)
   self.body:setFixedRotation(true)
   self.body:setMass(5)
   self.body:setLinearDamping(4)

   self.nudge_accel = 20 -- This needs to be scaled with player.speed
end

function Crate:draw()
   love.graphics.setColor(140, 140, 140)
   love.graphics.rectangle('fill',
                           self.body:getX()-15,
                           self.body:getY()-15, 30, 30)
end

function Crate:update(dt)
   local sq = Point(
      math.floor(self.body:getX() / 32),
      math.floor(self.body:getY() / 32))
   self:nudgeToSquare(sq)
end

----------------------------------------

function Crate:nudgeToSquare(sq)
   local y = self.body:getY() - 16
   local ty = sq.y * 32
   local f = self.nudge_accel * (ty - y)
   self.body:applyForce(0, f)
 
   local x = self.body:getX() - 16
   local tx = sq.x * 32
   local f = self.nudge_accel * (tx - x)
   self.body:applyForce(f, 0)
end