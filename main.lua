require('middleclass')

require('Point')
require('Clock')
require('List')
require('Entity')
require('Level')
require('Behavior')

require('Follow')
require('Shoot')

require('Bullet')
require('Player')
require('Wall')
require('Crate')
require('Mob')
require('Shooter')

local world = nil
local player = nil
local walls = nil
local crates = nil
local mobs = nil

function love.load()
   math.randomseed(os.time())
   love.physics.setMeter(32)
   love.graphics.setBackgroundColor(64, 120, 64)
 
   world = love.physics.newWorld(0, 0)
   Entity.setup(world)
   Wall.setup(world)

   player = Player(world)
   crates = List{ Crate(world, 5, 5),
                  Crate(world, 5, 6) }
   mobs = List{ Mob(world, Point(100, 100), player, 150, 50),
                Mob(world, Point(100, 100), player, 300, 10),
                Mob(world, Point(100, 100), player, 80, 95),
                Mob(world, Point(100, 100), player, 80, 95),
                Shooter(world, Point(100, 100), player), }

   mobs.items[1]:set_behavior(Follow(player, 150, 50))
   mobs.items[2]:set_behavior(Follow(player, 300, 30))
   mobs.items[3]:set_behavior(Follow(player, 80, 95))
   mobs.items[4]:set_behavior(Follow(player, 80, 95))

   walls = List{ Wall(Point(50, 50), 128, 32) }
end

function love.draw()
   love.graphics.push()

   local center = player:location()
   love.graphics.translate(-center.x + 400, -center.y + 300)
   player:draw()
   crates:method_map('draw')
   mobs:method_map('draw')
   walls:method_map('draw')
   Bullet.draw()

   love.graphics.pop()
end

function love.update(dt)
   Clock.update(dt)
   player:update(dt)
   crates:method_map('update', dt)
   mobs:method_map('update', dt)
   world:update(dt)
   Entity.cull()
end