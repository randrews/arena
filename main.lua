require('middleclass')
require('Point')
require('Player')
require('Crate')
require('Mob')

local world = nil
local player = nil
local crates = nil
local mobs = nil

function love.load()
   math.randomseed(os.time())
   love.physics.setMeter(32)
   love.graphics.setBackgroundColor(64, 120, 64)
 
   world = love.physics.newWorld(0, 0)
   player = Player(world)
   crates = { Crate(world, 5, 5),
              Crate(world, 5, 6) }
   mobs = { Mob(world, Point(100, 100), player, 150, 50),
            Mob(world, Point(100, 100), player, 300, 10),
            Mob(world, Point(100, 100), player, 80, 95),
            Mob(world, Point(100, 100), player, 80, 95),
            Mob(world, Point(100, 100), player, 80, 95), }
end

function love.draw()
   player:draw()
   for _, c in ipairs(crates) do c:draw() end
   for _, m in ipairs(mobs) do m:draw() end
end

function love.update(dt)
   player:update(dt)
   for _, c in ipairs(crates) do c:update(dt) end
   for _, m in ipairs(mobs) do m:update(dt) end
   world:update(dt)
end