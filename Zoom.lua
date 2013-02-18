require('middleclass')
require('Effect')

Zoom = class('Zoom', Effect)

function Zoom:initialize(center_on)
   Effect.initialize(self, 0.5)
   self.center_on = center_on

   self:tween('zoom', 0.1, 1, self.duration)
end

function Zoom:applyTransform()
   local width, height = love.graphics.getWidth(), love.graphics.getHeight()
   local z = self.zoom
   local c = self.center_on:location()

   love.graphics.scale(z)
   love.graphics.translate(width/2/z - c.x,
                           height/2/z - c.y)
end

return Zoom