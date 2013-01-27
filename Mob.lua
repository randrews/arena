require 'middleclass'
require('Entity')

Mob = class('Mob', Entity)
Mob.CATEGORY = 2

function Mob:initialize(world, location)
   assert(world and location)

   self.color = {110, 140, 190}
   self:circle(world, location, 16)
   self.fixture:setCategory(Mob.CATEGORY)

   self.body:setMass(1)
   self.body:setAngularDamping(3)
   self.body:setLinearDamping(10)
end

function Mob:set_behavior(behavior)
   self.behavior = behavior
   behavior:install(self)
end

function Mob:draw()
   local g = love.graphics
   local b = self.body
   local s = self.shape

   g.setColor(unpack(self.color))
   g.circle('fill', b:getX(), b:getY(), s:getRadius(), 20)

   g.setColor(220, 220, 90)
   g.line(b:getX(),b:getY(),
          b:getX() + 50 * math.cos(b:getAngle()),
          b:getY() + 50 * math.sin(b:getAngle()))

end

function Mob:update(dt)
   if self.behavior then self.behavior:update(dt) end
   self:max_speed(600)
end