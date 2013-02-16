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
require('FrozenLevel')
require('Effect')
require('Puff')

local level = nil

function love.load()
   math.randomseed(os.time())
   love.physics.setMeter(32)
   love.graphics.setBackgroundColor(0, 0, 20)

   local fl = FrozenLevel('tutorial.lua')
   level = fl:thaw()
   level:load()
end

function love.draw()
   level:draw()
   if FPS then love.graphics.setColor(255, 255, 255) ; love.graphics.print(FPS, 0, 0) end
end

function love.update(dt)
   FPS = math.floor(1 / dt)
   Clock.update(dt)
   level:update(dt)
   Effect.update(dt)
   Entity.cull()
end