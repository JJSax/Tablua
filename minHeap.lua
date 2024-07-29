---@class Heap
local minHeap = {}
minHeap.__index = minHeap
minHeap.__extVersion = "0.0.3"

-- https://www.wikiwand.com/en/Heap_(data_structure)

local function swap(self, a, b)
	self[a], self[b] = self[b], self[a]
end

local function siftUp(self)
	local index = #self
	while (self:hasParent(index) and self:parent(index) > self[index]) do
		swap(self, self:getParentIndex(index), index)
		index = self:getParentIndex(index)
	end
end

local function siftDown(self)
	local index = 1
	while (self:hasLeftChild(index)) do
		local smallerChildIndex = self:getLeftChildIndex(index)
		if (self:hasRightChild(index) and self:rightChild(index) < self:leftChild(index)) then
			smallerChildIndex = self:getRightChildIndex(index)
		end

		if (self[index] < self[smallerChildIndex]) then
			break
		else
			swap(self, index, smallerChildIndex)
		end
		index = smallerChildIndex
	end
end


---Creates a new heap.
---@param elements table | nil # Array of elements to put into the new heap.
---@return Heap
function minHeap.new(elements)
	local self = setmetatable({}, minHeap)

	for _, v in ipairs(elements or {}) do
		self:insert(v)
	end

	return self
end

--- Combines two heaps into one; Does not destroy input heaps.
---@return Heap
function minHeap:merge(b)
	local out = self:clone()
	for _, v in ipairs(b) do
		out:insert(v)
	end
	return out
end

---Adds a new element into the heap then restores heap properties.
---@param element any
function minHeap:insert(element)
	table.insert(self, element)
	siftUp(self)
end
minHeap.add = minHeap.insert

---Get the smallest element in heap and remove it from the heap.
---@return any
---@nodiscard
function minHeap:poll()
	local item = self[1]
	swap(self, 1, #self)
	self[#self] = nil
	siftDown(self)
	return item
end
minHeap.pop = minHeap.poll

function minHeap:discard() local _ = self:poll() end

---Gives the smallest element in the heap without removing it.
---@return any
function minHeap:peek()
	return self[1]
end

---@param parentIndex integer
---@return integer
function minHeap:getLeftChildIndex(parentIndex)
	return 2 * parentIndex
end

---@param parentIndex integer
---@return integer
function minHeap:getRightChildIndex(parentIndex)
	return 2 * parentIndex + 1
end

---@param childIndex integer
---@return integer
function minHeap:getParentIndex(childIndex)
	return math.floor(childIndex / 2)
end

---Checks if element at index position has a left child.
---@param index integer
---@return boolean
function minHeap:hasLeftChild(index)
	return self:getLeftChildIndex(index) <= #self
end
---Checks if element at index position has a right child.
---@param index integer
---@return boolean
function minHeap:hasRightChild(index)
	return self:getRightChildIndex(index) <= #self
end
---Checks if element at index position has a parent
---@param index integer
---@return boolean
function minHeap:hasParent(index)
	return index <= #self and self:getParentIndex(index) > 0
end

---The left child value of the item at index position.  Assumes element has child.
---@param index integer
---@return any
function minHeap:leftChild(index)
	return self[self:getLeftChildIndex(index)]
end

---The right child value of the item at index position.  Assumes element has child.
---@param index integer
---@return any
function minHeap:rightChild(index)
	return self[self:getRightChildIndex(index)]
end

---The parent value of the item at index position.  Assumes element has parent.
---@param index integer
---@return any
function minHeap:parent(index)
	return index <= #self and self[self:getParentIndex(index)]
end

---Copies the heap into a new output heap.
---@return Heap # The identical output heap.
function minHeap:clone()
	return minHeap.new(self)
end

return minHeap
