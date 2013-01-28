require('middleclass')

require('Point')
require('List')
require('Map')
require('Player')
require('Crate')
require('Gem')

Level = class('Level')

function Level:initialize(opts)
   assert(type(opts) == 'table')

   self.map = Map.new_from_strings(opts.map)
   self.zoom = 0.1
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
      elseif c == '*' then
         entity = Gem(self.world, p)
      elseif c == '@' then
         player_loc = p
      end

      if entity then self.entities:push(entity) end
   end

   assert(player_loc, "Your map doesn't have a player on it.")
   self.player = Player(self.world, player_loc)
end

function Level:draw()
   love.graphics.push()
   love.graphics.scale(self.zoom)
   local center = self.player:location()
   local width, height = love.graphics.getWidth(), love.graphics.getHeight()
   love.graphics.translate(width/2/self.zoom - center.x,
                           height/2/self.zoom - center.y)

   --------------------

   Bullet.draw()
   self.player:draw()
   self.entities:method_map('draw')
   Effect.draw()

   --------------------

   love.graphics.pop()

end

function Level:update(dt)
   if self.zoom < 1 then
      self.zoom = self.zoom + dt
      if self.zoom > 1 then self.zoom = 1 end
   end

   self.player:update(dt)
   self.entities:method_map('update', dt)
   self.world:update(dt)
   self.entities = self.entities:method_select('alive')
end

return Level