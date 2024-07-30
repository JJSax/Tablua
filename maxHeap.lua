---@class MaxHeap
---@field compare function
local maxHeap = {}
maxHeap.__index = maxHeap
maxHeap.__extVersion = "0.0.3"

-- https://www.wikiwand.com/en/Heap_(data_structure)

local function swap(self, a, b)
	self[a], self[b] = self[b], self[a]
end

local function siftUp(self)
	local index = #self
	while (self:hasParent(index) and self.compare(self[index], self:parent(index))) do
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

local function default_compare(a, b) return a > b end

---Creates a new MaxHeap.
---@param elements table? # Array of elements to put into the new MaxHeap.
---@param compare function? # Boolean return callback if a > b. i.e.
---@return MaxHeap
function maxHeap.new(elements, compare)
	local self = setmetatable({}, maxHeap)
	self.compare = compare or default_compare

	for _, v in ipairs(elements or {}) do
		self:insert(v)
	end

	return self
end

--- Combines two heaps into one; Does not destroy input heaps.
---@return MaxHeap
function maxHeap:merge(b)
	local out = self:clone()
	for _, v in ipairs(b) do
		out:insert(v)
	end
	return out
end

---Adds a new element into the MaxHeap then restores MaxHeap properties.
---@param element any
function maxHeap:insert(element)
	table.insert(self, element)
	siftUp(self)
end
maxHeap.add = maxHeap.insert

---Get the smallest element in MaxHeap and remove it from the MaxHeap.
---@return any
---@nodiscard
function maxHeap:poll()
	local item = self[1]
	swap(self, 1, #self)
	self[#self] = nil
	siftDown(self)
	return item
end
maxHeap.pop = maxHeap.poll

function maxHeap:discard() local _ = self:poll() end

---Gives the smallest element in the MaxHeap without removing it.
---@return any
function maxHeap:peek()
	return self[1]
end

---@param parentIndex integer
---@return integer
function maxHeap:getLeftChildIndex(parentIndex)
	return 2 * parentIndex
end

---@param parentIndex integer
---@return integer
function maxHeap:getRightChildIndex(parentIndex)
	return 2 * parentIndex + 1
end

---@param childIndex integer
---@return integer
function maxHeap:getParentIndex(childIndex)
	return math.floor(childIndex / 2)
end

---Checks if element at index position has a left child.
---@param index integer
---@return boolean
function maxHeap:hasLeftChild(index)
	return self:getLeftChildIndex(index) <= #self
end
---Checks if element at index position has a right child.
---@param index integer
---@return boolean
function maxHeap:hasRightChild(index)
	return self:getRightChildIndex(index) <= #self
end
---Checks if element at index position has a parent
---@param index integer
---@return boolean
function maxHeap:hasParent(index)
	return index <= #self and self:getParentIndex(index) > 0
end

---The left child value of the item at index position.  Assumes element has child.
---@param index integer
---@return any
function maxHeap:leftChild(index)
	return self[self:getLeftChildIndex(index)]
end

---The right child value of the item at index position.  Assumes element has child.
---@param index integer
---@return any
function maxHeap:rightChild(index)
	return self[self:getRightChildIndex(index)]
end

---The parent value of the item at index position.  Assumes element has parent.
---@param index integer
---@return any
function maxHeap:parent(index)
	return index <= #self and self[self:getParentIndex(index)]
end

---Copies the MaxHeap into a new output MaxHeap.
---@return MaxHeap # The identical output MaxHeap.
function maxHeap:clone()
	return maxHeap.new(self)
end

return maxHeap
