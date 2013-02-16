require('middleclass')
require('Map')
require('Point')
require('Level')

FrozenLevel = class('FrozenLevel')

function FrozenLevel:initialize(filename)
   self.filename = filename
end

-- Runs the file, which calls some methods and returns
-- a table
function FrozenLevel:load()
   local file = love.filesystem.load(self.filename)
   local env = self:make_environment()
   setfenv(file, env)
   file()
   return env
end

function FrozenLevel:thaw()
   local level = Level()
   local world = level.world
   local fl = self:load()
   local map = Map.new_from_string(fl.map)

   level.floor = self:init_floor(map, world)
   level.entities = self:init_entities(map, world)
   level.player = self:init_player(map, world)

   return level
end

function FrozenLevel:init_floor(map, world)
   local floor = List{}

   for tile_coord in map:each() do
      local c = map(tile_coord)
      local p = tile_coord * 32 - Point(16, 16)

      if c ~= ' ' and c ~= '#' then
         floor:push(Floor(p))
      end
   end

   return floor
end

function FrozenLevel:init_entities(map, world)
   local entities = List{}
   local wall = Wall(world)
   entities:push(wall)

   for tile_coord in map:each() do
      local c = map(tile_coord)
      local p = tile_coord * 32 - Point(16, 16)
      local entity = nil

      if c == '#' then
         wall:add(p, 32, 32)
      elseif c == '=' then
         entity = Crate(world, p.x, p.y)
      elseif c == '*' then
         entity = Gem(world, p)
      end

      if entity then entities:push(entity) end
   end

   return entities
end

function FrozenLevel:init_player(map, world)
   local player_loc = map:find_value('@'):shift()
   assert(player_loc, "Your map doesn't have a player on it.")
   local p = player_loc * 32 - Point(16, 16)
   return Player(world, p)
end

function FrozenLevel:make_environment()
   local function curry(fn)
      return function(...) return fn(self, ...) end
   end

   return {
      print = print
   }
end

return FrozenLevel