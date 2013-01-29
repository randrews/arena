require('middleclass')
require('Point')
require('Glow')

Floor = class('Floor')

function Floor:initialize(location)
   self.location = location
end

function Floor:draw()
   if self.effect then
      love.graphics.setColor(self.effect:get_color())
   else
      love.graphics.setColor(60, 60, 180, 50)
   end

   love.graphics.rectangle('fill', self.location.x-14, self.location.y-14, 28, 28)
end

function Floor:finish_glow()
   if self.effect and not self.effect:alive() then
      self.effect = nil
      return true
   end

   return false
end

function Floor:start_glow()
   self.effect = Glow()
end

function Floor:glowing()
   return self.effect
end

return Floor