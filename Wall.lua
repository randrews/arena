require 'middleclass'
require 'Entity'

Wall = class('Wall', Entity)

function Wall.static.setup(world)
   local ph = love.physics
   Wall.world = world
   Wall.body = ph.newBody(Wall.world, 0, 0, 'static')

   -- for p in self:each() do
   --    if self(p) == '#' then
   --       local s = ph.newRectangleShape(p.x*SIZE + SIZE/2, p.y*SIZE + SIZE/2,
   --                                      SIZE, SIZE)
   --       self.manager:add(walls, s, 'wall')
   --    end
   -- end
end

function Wall:initialize(location, width, height)
   local s = love.physics.newRectangleShape(location.x, location.y, width, height)
   self:setup(Wall.world, location, s, Wall.body)
   self.location = location
   self.size = Point(width, height)
end

function Wall:draw()
   local w, h = self.size()
   love.graphics.setColor(155, 155, 155)
   love.graphics.rectangle('fill',
                           self.location.x-w/2,
                           self.location.y-h/2,
                           w, h)
                           
end