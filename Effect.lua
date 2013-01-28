require('middleclass')
require('List')

Effect = class('Effect')
Effect.all = List{}

function Effect.static.update(dt)
   Effect.all:method_map('update', dt)
   Effect.all = Effect.all:method_select('alive')
end

function Effect.static.draw(dt)
   Effect.all:method_map('draw')
end

function Effect:initialize()
   Effect.all:push(self)
end

function Effect:alive()
   return not self.dead
end

function Effect:finish()
   self.dead = true
end

function Effect:update(dt) end
function Effect:draw() end

return Effect