require 'middleclass'

Mob = class('Mob')
Mob.CATEGORY = 2

function Mob:initialize(world, location, target, range, speed)
   assert(world and target and location)

   self.world = world
   self.target = target
   self.range = range or 0
   self.speed = speed or 50

   assert(self.speed > 0 and self.speed <= 100)

   local b = love.physics.newBody(world, location.x, location.y, 'dynamic')
   local s = love.physics.newCircleShape(16)
   self.fixture = love.physics.newFixture(b, s)
   self.fixture:setCategory(Mob.CATEGORY)
   b:setMass(1)
   b:setAngularDamping(3)
   b:setLinearDamping((110 - self.speed) / 5)

   self.turn_speed = 100 * (self.speed) / 5
   self.accel = 640

   self.body=b
   self.shape=s

   b:setAngle(self:angle_to_target())

   self.color = {110, 140, 190}
end

function Mob:draw()
   local g = love.graphics
   local b = self.body
   local s = self.shape

   g.setColor(unpack(self.color))
   g.circle('fill', b:getX(), b:getY(), s:getRadius(), 20)

   g.setColor(220, 220, 90)
   g.line(b:getX(),b:getY(),
          b:getX() + 50 * math.cos(b:getAngle()),
          b:getY() + 50 * math.sin(b:getAngle()))

end

function Mob:location()
   return Point(self.body:getX(), self.body:getY())
end

function Mob:distance_to_target()
   local dx = self.body:getX() - self.target.body:getX()
   local dy = self.body:getY() - self.target.body:getY()
   return math.sqrt(dx*dx+dy*dy)
end

function Mob:angle_to_target()
   local dx = self.body:getX() - self.target.body:getX()
   local dy = self.body:getY() - self.target.body:getY()
   local angle = math.atan(dy/dx) + math.pi/2
   if dx < 0 then angle = angle + math.pi end
   return angle + math.pi / 2
end

function Mob:turn_toward_target()
   local ta = self:angle_to_target()
   local a = self.body:getAngle()
   local ccw = (a - ta) % (math.pi * 2)
   local cw = (math.pi * 2) - ccw
   local thresh = math.pi / 180 -- one degree

   if cw < thresh or ccw < thresh then
      self.body:setAngularVelocity(0)
   elseif cw < ccw then
      self.body:applyTorque(self.turn_speed)
   else
      self.body:applyTorque(-self.turn_speed)
   end
end

-- Limits mob max linear speed
function Mob:max_speed()
   local max = 600
   local x, y = self.body:getLinearVelocity()
   if x*x + y*y > max*max then
      local a = math.atan2(y,x)
      self.body:setLinearVelocity(max * math.cos(a),
                                  max * math.sin(a))
   end
end

function Mob:update()
   local dist = self:distance_to_target()
   local accel = self.accel

   self:turn_toward_target()

   if dist > self.range + 5 then
      self.body:applyForce(math.cos(self.body:getAngle()) * accel,
                           math.sin(self.body:getAngle()) * accel)

   elseif dist < self.range - 5 then
      self.body:applyForce(math.cos(self.body:getAngle()) * -accel,
                           math.sin(self.body:getAngle()) * -accel)

   else
   end

   self:max_speed()
end