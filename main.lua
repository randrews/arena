require('middleclass')
require('Point')
require('Player')
--require('Crate')

local world = nil
local player = nil

function love.load()
   math.randomseed(os.time())
   love.physics.setMeter(32)
   love.graphics.setBackgroundColor(64, 120, 64)
 
   world = love.physics.newWorld(0, 0)
   player = Player(world)
end

function love.draw()
   player:draw()
end

function love.update(dt)
   player:update(dt)
   world:update(dt)
end