
-- Think of this data structure like a stack of paper
-- can put on the top of the stack,
-- then take it off the top
---@class Stack
local stack = {}
stack.__index = stack
local sizeName = "__SIZEOFSETPROTECTEDVARIABLENAMESPACE__"

---@return Stack
function stack.new(input)
	input = input or {}
	input[sizeName] = 0

	for i, v in ipairs(input) do
		input[sizeName] = input[sizeName] + 1
		assert(v ~= sizeName, "Attempt to use protected namespace.")
	end

	return setmetatable(input, stack)
end

function stack:push(input)
	assert(input ~= sizeName, "Attempt to use protected namespace.")
	self[sizeName] = self[sizeName] + 1
	table.insert(self, input)
end

function stack:pop()
	self[sizeName] = self[sizeName] - 1
	return table.remove(self, #self)
end

function stack:isEmpty()
	return self[sizeName] == 0
end

function stack:getSize()
	return self[sizeName]
end

return stack