require('middleclass')
require('Point')

Floor = class('Floor')

function Floor:initialize(location)
   self.location = location
end

function Floor:draw()
   love.graphics.setColor(60, 60, 180, 30)
   love.graphics.rectangle('fill', self.location.x-14, self.location.y-14, 28, 28)
end

return Floor