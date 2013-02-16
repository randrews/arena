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

function Level:initialize(opts)
   assert(type(opts) == 'table')

   self.map = Map.new_from_strings(opts.map)
   self.zoom = Zoom()
end

function Level:load()
   self.world = love.physics.newWorld(0, 0)
   Entity.setup(self.world)
   Wall.setup(self.world)

   self.entities = List{}
   self.floor = List{}
   for tile_coord in self.map:each() do
      local c = self.map(tile_coord)
      local p = tile_coord * 32 - Point(16, 16)
      local entity = nil

      if c ~= ' ' and c ~= '#' then
         self.floor:push(Floor(p))
      end

      if c == '#' then
         entity = Wall(p, 32, 32)
      elseif c == '=' then
         entity = Crate(self.world, p.x, p.y)
      elseif c == '*' then
         entity = Gem(self.world, p)
      elseif c == '@' then
         player_loc = p
      end

      if entity then self.entities:push(entity) end
   end

   assert(player_loc, "Your map doesn't have a player on it.")
   self.player = Player(self.world, player_loc)
   self:init_floor_glow()
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

function Level:init_floor_glow()
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