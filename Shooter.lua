require('Mob')

Shooter = class('Shooter', Mob)

function Shooter:initialize(world, location, target)
   Mob.initialize(self, world, location)
   self:set_behavior(Shoot(target))
   self.color = {220, 80, 80}
end
