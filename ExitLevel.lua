require('middleclass')
require('Effect')
require('Zoom')

ExitLevel = class('ExitLevel', Zoom)

function ExitLevel:initialize(level)
   self.level = level
   Effect.initialize(self, 4)

   self:tween('zoom', 1, 100, self.duration)
end

function ExitLevel:on_finish()
   print('Exiting')
end

return ExitLevel