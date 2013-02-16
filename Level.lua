require('middleclass')

require('Point')
require('List')
require('Map')
require('Player')
require('Crate')
require('Gem')
require('Zoom')
require('Floor')

Level = class('Level')

function Level:initialize()
   self.world = love.physics.newWorld(0, 0)
end

function Level:load()
   self.zoom = Zoom()
   Entity.setup(self.world)
   self:start_floor_glow()
end

function Level:draw()
   local center = self.player:location()
   local width, height = love.graphics.getWidth(), love.graphics.getHeight()
   local z = self.zoom.zoom

   love.graphics.push()
   love.graphics.scale(z)
   love.graphics.translate(width/2/z - center.x,
                           height/2/z - center.y)

   --------------------

   self.floor:method_map('draw')
   Bullet.draw()
   self.player:draw()
   self.entities:method_map('draw')
   Effect.draw()

   --------------------

   love.graphics.pop()

end

function Level:start_floor_glow()
   self.floor:map(function(f)
                     if math.random(5) == 1 then
                        f.effect = Glow(math.random(3000) / 1000)
                     end
                  end)
end

function Level:update_floor_glow()
   -- First, remove the effects from all the tiles with dead effects
   local finished = 0
   self.floor:map(function(f)
                     if f:finish_glow() then finished = finished + 1 end
                  end)

   -- Spawn new glows to replace the finished ones
   while finished > 0 do
      local f = self.floor:random()
      if not f:glowing() then
         f:start_glow()
         finished = finished - 1
      end
   end
end

function Level:update(dt)
   self.player:update(dt)
   self.entities:method_map('update', dt)
   self.world:update(dt)
   self.entities = self.entities:method_select('alive')
   self:update_floor_glow()
end

return Level