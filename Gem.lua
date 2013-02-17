require('middleclass')
require('Entity')
require('Player')
require('Crate')
require('Puff')

Gem = class('Gem', Entity)

function Gem:initialize(world, location)
   self:rectangle(world, location, 16, 16)
   --self.body:setAngle(math.random(24) * math.pi / 12)
   self.body:setAngularVelocity(4)
   self.fixture:setSensor(true)
end

function Gem:draw()
   local g = love.graphics
   local l = self:location()
   g.push()
   g.setColor(240, 160, 30)
   g.translate(l())
   g.rotate(self.body:getAngle())
   g.rectangle('fill', -8, -8, 16, 16)
   g.pop()
end

function Gem:collision(other)
   if other.class == Player then
      Puff(self:location(), self.body:getAngle())
      self:remove()

   elseif other.class == Crate then
      local dx = other.body:getX() - self.body:getX()
      local dy = other.body:getY() - self.body:getY()
      other.body:applyLinearImpulse(dx*15, dy*15)
   end
end

return Gem