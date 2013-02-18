require('middleclass')
require('Effect')

Zoom = class('Zoom', Effect)

function Zoom:initialize()
   Effect.initialize(self, 0.5)

   self:tween('zoom', 0.1, 1, self.duration)
end

function Zoom:applyTransform(center)
   local width, height = love.graphics.getWidth(), love.graphics.getHeight()
   local z = self.zoom
   love.graphics.scale(z)
   love.graphics.translate(width/2/z - center.x,
                           height/2/z - center.y)
end

return Zoom