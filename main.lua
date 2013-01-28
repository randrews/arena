require('middleclass')

require('Point')
require('Clock')
require('List')
require('Entity')
require('Map')
require('Behavior')
require('Follow')
require('Shoot')
require('Bullet')
require('Player')
require('Wall')
require('Crate')
require('Gem')
require('Mob')
require('Shooter')
require('Level')
require('Effect')
require('Puff')

local level = nil

function love.load()
   math.randomseed(os.time())
   love.physics.setMeter(32)
   love.graphics.setBackgroundColor(64, 120, 64)

   level = Level{
      map = {
         "###########################",
         "#..........######.........#",
         "#....1.....#..............#",
         "#..........#.#............#",
         "#.....######.#......o.....#",
         "#............#......o.....#",
         "#.....##..##.#............#",
         "#......#..##.#........&...#",
         "#...o..#..#....*...#......#",
         "#..#@.......o.*.*..#.##...#",
         "#..............*..........#",
         "#.....#...#.......##.#....#",
         "#...#...#...#........#....#",
         "#.....#...#...............#",
         "#A.........B.........2....#",
         "#.*********.....E.........#",
         "#D.........C..............#",
         "###########################",
      }
   }

   level:load()
 
   -- player = Player(world)
   -- crates = List{ Crate(world, 5, 5),
   --                Crate(world, 5, 6) }
   -- mobs = List{ Mob(world, Point(100, 100), player, 150, 50),
   --              Mob(world, Point(100, 100), player, 300, 10),
   --              Mob(world, Point(100, 100), player, 80, 95),
   --              Mob(world, Point(100, 100), player, 80, 95),
   --              Shooter(world, Point(100, 100), player), }

   -- mobs.items[1]:set_behavior(Follow(player, 150, 50))
   -- mobs.items[2]:set_behavior(Follow(player, 300, 30))
   -- mobs.items[3]:set_behavior(Follow(player, 80, 95))
   -- mobs.items[4]:set_behavior(Follow(player, 80, 95))
end

function love.draw()
   love.graphics.push()

   local center = level.player:location()
   love.graphics.translate(-center.x + 400, -center.y + 300)

   level:draw()
   Effect.draw()

   love.graphics.pop()

   if FPS then love.graphics.setColor(255, 255, 255) ; love.graphics.print(FPS, 0, 0) end
end

function love.update(dt)
   FPS = math.floor(1 / dt)
   Clock.update(dt)
   level:update(dt)
   Effect.update(dt)
   Entity.cull()
end