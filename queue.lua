
local queue = {}
queue.__index = queue
queue.__extVersion = "0.0.1"


local function assert(condition, message, stack)
	if not condition then
		error(message, stack)
	end
end

-- local function assertTable(t)
-- 	assert(type(t) == "table",
-- 		"Parameter type needs to be of type \"table\".  Passed type: "..type(t), 4)
-- end


-------------------------------------------------

function queue.new(t)
	t = t or {}
	t.size = #t
	return setmetatable(t or {}, queue)
end

function queue:enqueue(value)
	self.size = self.size + 1
	table.insert(self, value)
end
queue.add = queue.enqueue

function queue:dequeue()
	self.size = self.size - 1
	return table.remove(self, 1)
end
queue.remove = queue.dequeue

function queue:peek()
	return self[1]
end
queue.front = queue.peek

function queue:isEmpty() return self.size == 0 end
function queue:getSize() return self.size end
function queue:clear()
	-- making new table may be faster.  Consider if you need the same memory address
	self.size = 0
	for k in ipairs(self) do
		self[k] = nil
	end
end

function queue:contains(value)
	for i, v in ipairs(self) do
		if v == value then return true, i end
	end
	return false
end

function queue:iterate()
	return ipairs(self)
end

function queue:clone()

	--[[
	This function will create copy of the passed table.  No recursive table clones.
	]]
	local output = {}
	for k, v in ipairs(self) do
		output[k] = v
	end
	return queue.new(output)

end

function queue:toString(delimiter)
	local s = ""
	for i, v in ipairs(self) do
		assert(type(v) == "string" or type(v) == "number", "Invalid value in queue.")
		s = s..v..delimiter
	end
	s = s:sub(1, -#delimiter-1)
	return s
end






-- Enqueue: Adds an element to the rear of the queue.
-- Dequeue: Removes and returns the element from the front of the queue.
-- Peek/Front: Returns the element at the front of the queue without removing it.
-- IsEmpty: Checks if the queue is empty and returns a boolean value.
-- Size: Returns the number of elements currently in the queue.
-- Clear: Removes all elements from the queue, making it empty.
-- Contains: Checks if a specific element is present in the queue.
-- Iterator: Provides an iterator or enumerator to iterate over the elements in the queue.
-- toString: Converts the queue into a string representation.
-- Clone: Creates a copy of the queue.

return queue