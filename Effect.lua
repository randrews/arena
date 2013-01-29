require('middleclass')
require('List')

Effect = class('Effect')
Effect.all = List{}

function Effect.static.update(dt)
   Effect.all:method_map('skip_time', dt)
   Effect.all = Effect.all:method_select('alive')
end

function Effect.static.draw(dt)
   Effect.all:method_map('draw')
end

function Effect:initialize(duration)
   Effect.all:push(self)
   self.tweens = List{}
   self.duration = duration or 0
   self.time = 0
end

function Effect:skip_time(dt)
   self:update_tweens(dt)
   self:update_duration(dt)
   self:update(dt)
end

function Effect:alive()
   return not self.dead
end

function Effect:finish()
   self.dead = true
end

function Effect:tween(property, start, finish, duration)
   duration = duration or self.duration
   assert(duration > 0)

   self.tweens:push{
      property = property,
      start = start,
      finish = finish,
      duration = duration,
      diff = finish - start,
      t = 0
   }

   self[property] = start
end

function Effect:update_tweens(dt)
   self.tweens:map(function(t)
                      t.t = t.t + dt
                      self[t.property] = t.start + t.diff * t.t / t.duration

                      if self[t.property] >= t.finish and t.finish >= t.start or
                         self[t.property] <= t.finish and t.finish <= t.start then
                         self[t.property] = t.finish
                         t.dead = true
                      end
                   end)

   self.tweens = self.tweens:select(function(t) return not t.dead end)
end

function Effect:update_duration(dt)
   self.time = self.time + dt
   if self.duration > 0 and self.time >= self.duration then
      self:finish()
   end
end

-- Stuff you can (should) override
function Effect:update(dt) end
function Effect:draw() end

return Effect