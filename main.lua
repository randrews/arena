require('middleclass')
require('Point')
require('Player')
require('Crate')

local world = nil
local player = nil
local crates = nil

function love.load()
   math.randomseed(os.time())
   love.physics.setMeter(32)
   love.graphics.setBackgroundColor(64, 120, 64)
 
   world = love.physics.newWorld(0, 0)
   player = Player(world)
   crates = { Crate(world, 5, 5),
              Crate(world, 5, 6) }
end

function love.draw()
   player:draw()
   for _, c in ipairs(crates) do c:draw() end
end

function love.update(dt)
   player:update(dt)
   for _, c in ipairs(crates) do c:update(dt) end
   world:update(dt)
end