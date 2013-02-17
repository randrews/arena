Entity = class('Entity')
Entity.graveyard = List{} -- List of entities to be removed

function Entity:setup(world, location, shape, body, fixture)
   assert(world and location and shape)
   self.body = body or love.physics.newBody(world, location.x, location.y, 'dynamic')
   self.shape = shape
   self.fixture = fixture or love.physics.newFixture(self.body, self.shape)
   self.world = world
   self.fixture:setUserData(self)
end

function Entity:circle(world, location, radius)
   local s = love.physics.newCircleShape(radius)
   self:setup(world, location, s)
end

function Entity:rectangle(world, location, width, height)
   local s = love.physics.newRectangleShape(width, height)
   self:setup(world, location, s)
end

function Entity:location()
   return Point(self.body:getX(), self.body:getY())
end

function Entity:draw()
   love.graphics.setColor(255, 255, 255)
   local loc = self:location()
   love.graphics.circle('line', loc.x, loc.y, 5, 20)
end

function Entity:update(dt)
end

-- Limits max linear speed
function Entity:max_speed(max)
   local x, y = self.body:getLinearVelocity()
   if x*x + y*y > max*max then
      local a = math.atan2(y,x)
      self.body:setLinearVelocity(max * math.cos(a),
                                  max * math.sin(a))
   end
end

-- Adds this to Entity.graveyard to be removed at the end of the tick
function Entity:remove()
   if self.dead then return end
   Entity.graveyard:push(self)
   self.dead = true
end

function Entity:alive() return not self.dead end

-- Implement this to handle collisions with other entities.
-- function Entity:collision(entity)

----------------------------------------

function Entity.static.setup(world)
   world:setCallbacks(Entity.collision)
end

function Entity.static.collision(fix_a, fix_b)
   local ent_a, ent_b = fix_a:getUserData(), fix_b:getUserData()
   if ent_a and ent_a.collision then ent_a:collision(ent_b) end
   if ent_b and ent_b.collision then ent_b:collision(ent_a) end
end

function Entity.static.cull()
   if not Entity.graveyard:empty() then
      Entity.graveyard:map(function(ent)
                              -- ent.body:destroy()
                              ent.fixture:destroy()
                           end)
      Entity.graveyard:clear()
   end
end