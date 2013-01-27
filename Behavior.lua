require('middleclass')

Behavior = class('Behavior')

function Behavior:initialize()
   error("Abstract class")
end

function Behavior:install(mob)
   self.mob = mob
end   

function Behavior:update(dt)
end

return Behavior