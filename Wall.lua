require 'middleclass'
require 'Entity'

Wall = class('Wall', Entity)

-- All the walls share a body since they never move, so
-- we set that up in one place
function Wall.static.setup(world)
   local ph = love.physics
   Wall.world = world
   Wall.body = ph.newBody(Wall.world, 0, 0, 'static')
end

function Wall:initialize(location, width, height)
   local s = love.physics.newRectangleShape(location.x, location.y, width, height)
   self:setup(Wall.world, location, s, Wall.body)
   self.location = location
   self.size = Point(width, height)
end

function Wall:draw()
   local w, h = self.size()
   love.graphics.setColor(255, 255, 255)
   love.graphics.rectangle('line',
                           self.location.x-w/2,
                           self.location.y-h/2,
                           w, h)
                           
end