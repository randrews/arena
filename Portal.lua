require('middleclass')
require('Entity')

Portal = class('Portal', Entity)

function Portal:initialize(world, location)
   self:circle(world, location, 15)
   self.body:setType('static')
   self.fixture:setSensor(true)
   self.open = false
end

function Portal:draw()
   love.graphics.setColor(50, 35, 255)
   local loc = self:location()
   love.graphics.circle('line', loc.x, loc.y, 15, 20)
end

function Portal:collision(other)
   if other.class == Player then
      print(self.open)
   end
end