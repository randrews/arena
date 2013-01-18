require('middleclass')

List = class('List')

function List:initialize(items)
   self.items = items or {}
end

-- Add to end
function List:push(item)
   table.insert(self.items, item)
end

-- Remove from end
function List:pop()
   return table.remove(self.items)
end

-- Add to beginning
function List:unshift(item)
   table.insert(self.items, item, 1)
end

-- Remove from beginning
function List:shift()
   return table.remove(self.items, 1)
end

----------------------------------------

function List:length()
   return #(self.items)
end

function List:clear()
   self.items = {}
end

----------------------------------------

function List:map(fn, ...)
   local result = List()

   for _, item in ipairs(self.items) do
      result:push( fn(item, ...) )
   end

   return result
end

function List:method_map(fn_name, ...)
   local result = List()

   for _, item in ipairs(self.items) do
      local fn = item[fn_name]
      result:push( fn(item, ...) )
   end

   return result
end