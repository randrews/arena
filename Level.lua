require('middleclass')

require('Point')
require('List')
require('Map')
require('Player')
require('Crate')
require('Gem')
require('Zoom')
require('ExitLevel')
require('Floor')

Level = class('Level')

function Level:initialize()
   self.world = love.physics.newWorld(0, 0)
   self.freeze_player = false -- Set to true when we are in the exit-level animation
   self.game = nil
end

function Level:setEntities(ents)
   assert(ents.class == List)
   self.entities = ents

   self.starting_gems = self:remaining_gems()
end

function Level:setGame(game)
   self.game = game
end

function Level:load()
   self.effect = Zoom(self.player)
   Entity.setup(self.world)
   self:start_floor_glow()
end

function Level:draw()
   love.graphics.push()
   if self.effect then self.effect:applyTransform() end

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
   if not self.freeze_player then
      self.player:update(dt)
   else
      self.player:brake(dt)
   end
   self.entities:method_map('update', dt)
   self.world:update(dt)
   self.entities = self.entities:method_select('alive')
   self:update_floor_glow()
end

function Level:remaining_gems()
   local gems = self.entities:select(function(e) return e.class == Gem end)
   return gems:length()
end

function Level:exit_to(portal, destination)
   self.freeze_player = true
   self.effect = ExitLevel(self, portal)
   self.effect.on_finish = function()
                              self.game:start_level(destination)
                           end
end

return Level