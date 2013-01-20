require('Mob')

Shooter = class('Shooter', Mob)

function Shooter:initialize(world, location, target)
   Mob.initialize(self, world, location, target, 80, 95)
   self.color = {220, 80, 80}
   self.clock = Clock(0.1, self.shoot, self)
   self.clock.elapsed = math.random(1000) / 1000
   self.magazine = 4
end

function Shooter:shoot()
   self.magazine = self.magazine - 1

   if self.magazine >= 0 then
      local b = Bullet(self.world, self:location(), self:angle_to_target())
      b:setIgnore(Mob.CATEGORY)
      b:fire(100)
   else
      if self.magazine < -6 then self.magazine = 4 end
   end
end