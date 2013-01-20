require('List')
require('Entity')

Bullet = class('Bullet', Entity)

Bullet.bullets = List{}

function Bullet:initialize(world, location, angle)
   self:circle(world, location, 2)
   self.angle = angle
   self.body:setMass(0.1)
   Bullet.bullets:push(self)
end

function Bullet:draw()
   local g = love.graphics
   local b = self.body
   local s = self.shape

   g.setColor(220, 220, 0)
   g.circle('fill', b:getX(), b:getY(), s:getRadius(), 20)
end

function Bullet:fire(speed)
   self.body:applyLinearImpulse(speed * math.cos(self.angle),
                                speed * math.sin(self.angle))
end

function Bullet.static.draw()
   Bullet.bullets:method_map('draw')
end

function Bullet:setIgnore(...)
   self.fixture:setMask(...)
end