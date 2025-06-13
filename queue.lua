
local HERE = (...):match("(.-)[^%.]+$")
local Base = require(HERE .. ".base")

---@class Queue
local queue = {}
queue.__index = queue
queue.__extVersion = "0.0.5"

-------------------------------------------------

---@return Queue
function queue.new(t)
	return setmetatable(t or {}, queue)
end

--- Adds an element to the rear of the queue.
function queue:enqueue(value)
	table.insert(self, value)
end
queue.add = queue.enqueue

--- Removes and returns the element from the front of the queue.
function queue:dequeue()
	return table.remove(self, 1)
end
queue.remove = queue.dequeue

--- Returns the element at the front of the queue without removing it.
function queue:peek()
	return self[1]
end
queue.front = queue.peek

--- Clears the queue while keeping same memory address.<br>
--- Use queue.new unless you need the same memory address.
function queue:clear()
	for k in ipairs(self) do
		self[k] = nil
	end
end

--- Checks if the queue is empty and returns a boolean value.
function queue:isEmpty()
	return #self == 0
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

---Create copy of the passed Queue recursively.
queue.clone = Base.clone

---Create a simple clone.
queue.shallowClone = Base.shallowClone

queue.toString = table.concat


return queue