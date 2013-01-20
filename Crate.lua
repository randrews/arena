require('middleclass')

Crate = class('Crate')
Crate.CATEGORY = 3

function Crate:initialize(world, x, y)
   local b = love.physics.newBody(world, x*32 + 16, y*32 + 16, 'dynamic')
   local s = love.physics.newRectangleShape(0, 0, 32, 32)
   love.physics.newFixture(b, s)
   b:setFixedRotation(true)
   b:setMass(5)
   b:setLinearDamping(4)
   self.body = b
   self.shape = s
   self.nudge_accel = 40 -- This needs to be scaled with player.speed
end

function Crate:draw()
   love.graphics.setColor(180, 120, 90)
   love.graphics.rectangle('fill',
                           self.body:getX()-16,
                           self.body:getY()-16, 32, 32)
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