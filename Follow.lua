require('Behavior')

Follow = class('Follow', Behavior)

function Follow:initialize(target, range, speed)
   self.target = target
   self.range = range or 0
   self.speed = speed or 50
   assert(self.speed > 0 and self.speed <= 100)
   self.turn_speed = 100 * (self.speed) / 5
   self.accel = 640
end

function Follow:install(mob)
   Behavior.install(self,mob)
   mob.body:setLinearDamping((110 - self.speed) / 5)
   mob.body:setAngle(self:angle_to_target())
end

function Follow:distance_to_target()
   local mob = self.mob
   local dx = mob.body:getX() - self.target.body:getX()
   local dy = mob.body:getY() - self.target.body:getY()
   return math.sqrt(dx*dx+dy*dy)
end

function Follow:angle_to_target()
   local mob = self.mob
   local dx = mob.body:getX() - self.target.body:getX()
   local dy = mob.body:getY() - self.target.body:getY()
   local angle = math.atan(dy/dx) + math.pi/2
   if dx < 0 then angle = angle + math.pi end
   return angle + math.pi / 2
end

function Follow:turn_toward_target()
   local ta = self:angle_to_target()
   local a = self.mob.body:getAngle()
   local ccw = (a - ta) % (math.pi * 2)
   local cw = (math.pi * 2) - ccw
   local thresh = math.pi / 180 -- one degree

   if cw < thresh or ccw < thresh then
      self.mob.body:setAngularVelocity(0)
   elseif cw < ccw then
      self.mob.body:applyTorque(self.turn_speed)
   else
      self.mob.body:applyTorque(-self.turn_speed)
   end
end

function Follow:update(dt)
   Behavior.update(self, dt)
   local dist = self:distance_to_target()
   local accel = self.accel
   local b = self.mob.body

   self:turn_toward_target()

   if dist > self.range + 5 then
      b:applyForce(math.cos(b:getAngle()) * accel,
                   math.sin(b:getAngle()) * accel)

   elseif dist < self.range - 5 then
      b:applyForce(math.cos(b:getAngle()) * -accel,
                   math.sin(b:getAngle()) * -accel)
   end
end

return Follow