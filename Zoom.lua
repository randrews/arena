require('middleclass')
require('Effect')

Zoom = class('Zoom', Effect)

function Zoom:initialize()
   Effect.initialize(self, 0.5)

   self:tween('zoom', 0.1, 1, self.duration)
end

return Zoom