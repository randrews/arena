require('middleclass')
require('Map')
require('Point')
require('Level')
require('Portal')

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
   self.level_spec = self:load()
   self.map = Map.new_from_string(self.level_spec.map)
   self.waypoints = self:init_waypoints(self.map)

   local level = Level()

   level.floor = self:init_floor(self.map, level.world)
   level.player = self:init_player(self.map, level.world)

   local entities = self:init_entities(self.map, level.world)

   entities:push_all(self:init_portals(level))

   level:setEntities(entities)

   return level
end

function FrozenLevel:init_portals(level)
   local function make_portal(portal_spec)
      local loc = self.waypoints[tostring(portal_spec[1])]
      local dest = portal_spec[2]
      return Portal(level.world, loc, level, dest)
   end

   return self.level_spec.portals:map(make_portal)
end

function FrozenLevel:init_waypoints(map)
   local waypoints = {}
   for tile_coord in map:each() do
      local c = map(tile_coord)
      local p = tile_coord * 32 - Point(16, 16)

      if c:match('[%a%d]') then
         waypoints[c] = p
      end
   end

   return waypoints
end

function FrozenLevel:init_floor(map, world)
   local floor = List{}

   for tile_coord in map:each() do
      local c = map(tile_coord)
      local p = tile_coord * 32 - Point(16, 16)

      if c ~= '' and c ~= ' ' and c ~= '#' then
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
         entity = Crate(world, p)
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
   local env = {}

   -- Given a name, makes a list called that and returns
   -- a function that, when called, shoves a table of its
   -- arguments into that list.
   local function store(name)
      env[name] = List{}
      return function(...) env[name]:push{...} end
   end

   -- By convention, you call these with a waypoint and any
   -- args it needs, like: portal('A', 'level2.lua')
   -- Waypoints will be tostring()ed before use, so
   -- message(2, 'blah') will work the same as message('2', 'blah')
   env.portal = store('portals')
   env.message = store('messages')

   return env
end

return FrozenLevel