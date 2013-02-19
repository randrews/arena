require('middleclass')
require('loveframes')

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
require('Game')
require('Effect')
require('Puff')
require('MainMenu')

local game = nil

function love.load()
   math.randomseed(os.time())
   love.physics.setMeter(32)
   love.graphics.setBackgroundColor(0, 0, 20)

   local m = MainMenu()
   m:show()
   --game = Game('tutorial.lua')
   --game:start()
end

function love.draw()
   --game:draw()
   if FPS then love.graphics.setColor(255, 255, 255) ; love.graphics.print(FPS, 0, 0) end
   loveframes.draw()
end

function love.update(dt)
   FPS = math.floor(1 / dt)
   Clock.update(dt)
   Effect.update(dt)
   Entity.cull()
   loveframes.update(dt)
   --game:update(dt)
end

function love.mousepressed(x, y, button)
   loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
   loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
   loveframes.keypressed(key, unicode)
end

function love.keyreleased(key)
   loveframes.keyreleased(key)
end