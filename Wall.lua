require 'middleclass'
require 'Entity'

Wall = class('Wall')

-- All the walls share a body since they never move, so
-- we set that up in one place
function Wall:initialize(world)
   local ph = love.physics
   self.world = world
   self.body = ph.newBody(self.world, 0, 0, 'static')
   self.shapes = List{}
end

function Wall:add(location, width, height)
   local s = love.physics.newRectangleShape(location.x, location.y,
                                            width, height)
   local f = love.physics.newFixture(self.body, s)
   f:setUserData(self)

   self.shapes:push{
      location = location,
      size = Point(width, height)
   }
end

function Wall:update(dt) end
function Wall:alive() return true end

function Wall:draw()
   local function draw_shape(s)
      local w, h = s.size()
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle('line',
                              s.location.x-w/2,
                              s.location.y-h/2,
                              w, h)
   end

   self.shapes:map(draw_shape)                           
end