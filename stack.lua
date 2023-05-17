
-- Think of this data structure like a stack of paper
-- can put on the top of the stack,
-- then take it off the top

local stack = {}
stack.__index = stack

function stack.new(input)
	return setmetatable(input or {}, stack)
end

function stack:push(input)
	self.size = self.size + 1
	table.insert(self, input)
end

function stack:pop()
	self.size = self.size - 1
	return table.remove(self, #self)
end

function stack:isEmpty()
	return self.size == 0
end

return stack