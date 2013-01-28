require('middleclass')
require('Effect')
require('Point')

Puff = class('Puff', Effect)

function Puff:initialize(location, angle)
   Effect.initialize(self, 0.5)
   self.location = location
   self.angle = angle or 0
   self.t = 0

   self:tween('size', 16, 100)
   self:tween('alpha', 255, 1)
end

function Puff:update(dt)
   if self.alpha == 1 then
      self:finish() end
end

function Puff:draw()
   local g = love.graphics

   g.push()
   g.translate(self.location())
   g.rotate(self.angle)
   g.setColor(190, 190, 30, self.alpha)
   local s = self.size
   g.rectangle('fill', -s/2, -s/2, s, s)
   g.pop()
end

return Puff