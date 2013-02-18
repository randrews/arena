require('middleclass')
require('Effect')
require('Zoom')

ExitLevel = class('ExitLevel', Zoom)

function ExitLevel:initialize(level, center_on)
   self.level = level
   self.center_on = center_on
   Effect.initialize(self, 2)

   self:tween('zoom', 1, 100, self.duration)
end

return ExitLevel