
-- Think of this data structure like a stack of paper
-- can put on the top of the stack,
-- then take it off the top
---@class Stack
local stack = {}
stack.__index = stack
stack.__extVersion = "0.0.3"

---@return Stack
function stack.new(input)
	return setmetatable(input or {}, stack)
end

function stack:push(input)
	table.insert(self, input)
end

function stack:pop()
	return table.remove(self, #self)
end

function stack:peek()
	return self[#self]
end

return stack