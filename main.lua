require('middleclass')
require('Point')
require('List')
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
   crates = List{ Crate(world, 5, 5),
                  Crate(world, 5, 6) }
   mobs = List{ Mob(world, Point(100, 100), player, 150, 50),
                Mob(world, Point(100, 100), player, 300, 10),
                Mob(world, Point(100, 100), player, 80, 95),
                Mob(world, Point(100, 100), player, 80, 95),
                Mob(world, Point(100, 100), player, 80, 95), }
end

function love.draw()
   love.graphics.push()

   local center = player:location()
   love.graphics.translate(-center.x + 400, -center.y + 300)
   player:draw()
   crates:method_map('draw')
   mobs:method_map('draw')

   love.graphics.pop()
end

function love.update(dt)
   player:update(dt)
   crates:method_map('update', dt)
   mobs:method_map('update', dt)
   world:update(dt)
end