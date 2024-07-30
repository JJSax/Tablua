---@class MinHeap : Heap
local minHeap = require((...):match("(.-)[^%.]+$") .. ".heap")
minHeap.__extVersion = "0.0.6"

local function default_compare(a, b) return a < b end

---Creates a new minheap.
---@param elements table? # An array of elements to init with.
---@param compare function? # A less than comparison callback: a < b
---@return MinHeap
function minHeap.new(elements, compare)
	local self = setmetatable({}, minHeap)
	self.compare = compare or default_compare

	for _, v in ipairs(elements or {}) do
		self:insert(v)
	end

	---@type MinHeap
	return self
end

return minHeap
