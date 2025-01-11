--[[
	This is the base heap structure for min and max heaps.  Use those instead.
]]

---@class Heap
---@field compare function
local heap = {}
heap.__index = heap
heap.__extVersion = "0.0.5"

-- https://www.wikiwand.com/en/Heap_(data_structure)

local function swap(self, a, b)
	self[a], self[b] = self[b], self[a]
end

local function siftUp(self)
	local index = #self
	while (self:hasParent(index) and not self.compare(self:parent(index), self[index])) do
		swap(self, self:getParentIndex(index), index)
		index = self:getParentIndex(index)
	end
end

local function siftDown(self)
	local index = 1
	while (self:hasLeftChild(index)) do
		local smallerChildIndex = self:getLeftChildIndex(index)
		if (self:hasRightChild(index) and self.compare(self:rightChild(index), self:leftChild(index))) then
			smallerChildIndex = self:getRightChildIndex(index)
		end

		if self.compare(self[index], self[smallerChildIndex]) then
			break
		else
			swap(self, index, smallerChildIndex)
		end
		index = smallerChildIndex
	end
end

local function default_compare(a, b) return a < b end

---Creates a new heap.
---@param elements table? # Array of elements to put into the new heap.
---@param compare function? # Boolean return callback if a < b. i.e.
---@return Heap
function heap.new(elements, compare)
	local self = setmetatable({}, heap)
	self.compare = compare or default_compare

	for _, v in ipairs(elements or {}) do
		self:insert(v)
	end

	return self
end

--- Combines two heaps into one; Does not destroy input heaps.
---@return Heap
function heap:merge(b)
	local out = self:clone()
	for _, v in ipairs(b) do
		out:insert(v)
	end
	return out
end

---Adds a new element into the heap then restores heap properties.
---@param element any
function heap:insert(element)
	table.insert(self, element)
	siftUp(self)
end
heap.add = heap.insert

---Get the smallest element in heap and remove it from the heap.
---@return any
---@nodiscard
function heap:poll()
	local item = self[1]
	swap(self, 1, #self)
	self[#self] = nil
	siftDown(self)
	return item
end
heap.pop = heap.poll

function heap:discard() local _ = self:poll() end

---Gives the smallest element in the heap without removing it.
---@return any
function heap:peek()
	return self[1]
end

---@param parentIndex integer
---@return integer
function heap:getLeftChildIndex(parentIndex)
	return 2 * parentIndex
end

---@param parentIndex integer
---@return integer
function heap:getRightChildIndex(parentIndex)
	return 2 * parentIndex + 1
end

---@param childIndex integer
---@return integer
function heap:getParentIndex(childIndex)
	return math.floor(childIndex / 2)
end

---Checks if element at index position has a left child.
---@param index integer
---@return boolean
function heap:hasLeftChild(index)
	return self:getLeftChildIndex(index) <= #self
end
---Checks if element at index position has a right child.
---@param index integer
---@return boolean
function heap:hasRightChild(index)
	return self:getRightChildIndex(index) <= #self
end
---Checks if element at index position has a parent
---@param index integer
---@return boolean
function heap:hasParent(index)
	return index <= #self and self:getParentIndex(index) > 0
end

---The left child value of the item at index position.  Assumes element has child.
---@param index integer
---@return any
function heap:leftChild(index)
	return self[self:getLeftChildIndex(index)]
end

---The right child value of the item at index position.  Assumes element has child.
---@param index integer
---@return any
function heap:rightChild(index)
	return self[self:getRightChildIndex(index)]
end

---The parent value of the item at index position.  Assumes element has parent.
---@param index integer
---@return any
function heap:parent(index)
	return index <= #self and self[self:getParentIndex(index)]
end

---Copies the heap into a new output heap.
---@return Heap # The identical output heap.
function heap:clone()
	return heap.new(self)
end

return heap
