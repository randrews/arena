require('middleclass')
require('Entity')
require('Player')
require('Crate')
require('Puff')

Gem = class('Gem', Entity)

function Gem:initialize(world, location)
   self:rectangle(world, location, 16, 16)
   self.body:setAngle(math.pi/4)
   self.body:applyTorque(150)
   self.fixture:setSensor(true)
end

function Gem:draw()
   local g = love.graphics
   local l = self:location()
   g.push()
   g.setColor(190, 190, 30)
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