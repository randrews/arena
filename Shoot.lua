require 'Follow'

Shoot = class('Shoot', Follow)

function Shoot:initialize(target)
   Follow.initialize(self, target, 80, 95)
   self.magazine = 4
end

function Shoot:install(mob)
   Follow.install(self, mob)
   self.clock = Clock(0.1, self.shoot, self)
   self.clock.elapsed = math.random(1000) / 1000
end   

function Shoot:shoot()
   self.magazine = self.magazine - 1

   if self.magazine >= 0 then
      local b = Bullet(self.mob.world, self.mob:location(), self:angle_to_target())
      b:setIgnore(Mob.CATEGORY)
      b:fire(100)
   else
      if self.magazine < -6 then self.magazine = 4 end
   end
end

return Shoot