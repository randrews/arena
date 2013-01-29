require('middleclass')
require('Effect')

Glow = class('Glow', Effect)

function Glow:initialize(t)
   Effect.initialize(self, 3)
   self:tween('up', 0, 100, 1.5)
   self:tween('down', 200, 0, 3)
   if t then self:skip_time(t) end
end

function Glow:get_color()
   local i = self.up
   if i == 100 then i = self.down end
   return 60+i, 60+i, 180, 50
end