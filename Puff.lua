require('middleclass')
require('Effect')
require('Point')

Puff = class('Puff', Effect)

Puff.duration = 0.5
Puff.final_size = 100

function Puff:initialize(location, angle)
   Effect.initialize(self)
   self.location = location
   self.angle = angle or 0
   self.t = 0
end

function Puff:update(dt)
   self.t = self.t + dt
   if self.t >= self.duration then self:finish() end
end

function Puff:draw()
   local g = love.graphics
   local s = self.final_size * self.t / self.duration

   g.push()
   g.translate(self.location())
   g.rotate(self.angle)
   g.setColor(190, 190, 30, 255 * (self.duration - self.t))
   g.rectangle('fill', -s/2, -s/2, s, s)
   g.pop()
end

return Puff