require('Set')
require('Entity')

Bullet = class('Bullet', Entity)

Bullet.bullets = Set()

function Bullet:initialize(world, location, angle)
   self:circle(world, location, 2)
   self.angle = angle
   self.body:setMass(0.1)
   Bullet.bullets:add(self)
end

function Bullet:draw()
   local g = love.graphics
   local b = self.body
   local s = self.shape

   g.setColor(220, 220, 0)
   g.circle('fill', b:getX(), b:getY(), s:getRadius(), 20)
end

function Bullet:collision()
   Bullet.bullets:remove(self)
   self:remove() -- Doesn't matter what we hit, we hit something.
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