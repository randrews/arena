require('middleclass')
require('FrozenLevel')

Game = class('Game')

function Game:initialize(start)
   self.first_level = start
end

function Game:start()
   self:start_level(self.first_level)
end

function Game:start_level(name)
   local fl = FrozenLevel(name)
   self.current_level = fl:thaw()
   self.current_level:setGame(self)
   self.current_level:load()
end

function Game:draw()
   assert(self.current_level)
   self.current_level:draw()
end

function Game:update(dt)
   assert(self.current_level)
   self.current_level:update(dt)
end