require('middleclass')
require('Entity')

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

return Gem