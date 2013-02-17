require('middleclass')
require('Entity')

Portal = class('Portal', Entity)

function Portal:initialize(world, location, level)
   self:circle(world, location, 5)
   self.body:setType('static')
   self.fixture:setSensor(true)
   self.level = level
end

function Portal:draw()
   local g = love.graphics

   g.push()
   g.translate(self:location()())

   if not self:open() then
      g.setColor(50, 35, 255)
      g.circle('line', 0, 0, 15, 20)
      local lv = self.level
      g.rotate(-math.pi/2)
      local gem_angle = math.pi * 2 / lv.starting_gems
      local a = gem_angle * (lv.starting_gems - lv:remaining_gems())
      g.arc('fill', 0, 0, 15, 0, a)
   else
      g.setColor(50, 35, 120)
      g.circle('fill', 0, 0, 15, 20)
   end

   g.pop()
end

function Portal:collision(other)
   if other.class == Player then
      print(self:open())
   end
end

-- Returns whether this portal is open
function Portal:open()
   return self.level:remaining_gems() == 0
end