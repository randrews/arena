require('middleclass')

require('Point')
require('List')
require('Map')

Level = class('Level')

function Level:initialize(opts)
   assert(type(opts) == 'table')

   self.map = Map.new_from_strings(opts.map)
end

function Level:load()
   self.world = love.physics.newWorld(0, 0)
   Entity.setup(self.world)
   Wall.setup(self.world)

   self.entities = List{}
   for tile_coord in self.map:each() do
      local c = self.map(tile_coord)
      local p = tile_coord * 32 - Point(16, 16)
      local entity = nil

      if c == '#' then
         entity = Wall(p, 32, 32)
      elseif c == 'o' then
         entity = Crate(self.world, p.x, p.y)
      elseif c == '@' then
         player_loc = p
      end

      if entity then self.entities:push(entity) end
   end

   assert(player_loc)
   self.player = Player(self.world, player_loc)
end

function Level:draw()
   Bullet.draw()
   self.player:draw()
   self.entities:method_map('draw')
end

function Level:update(dt)
   self.player:update(dt)
   self.entities:method_map('update', dt)
   self.world:update(dt)
end

return Level