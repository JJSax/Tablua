local HERE = (...):gsub('%.[^%.]+$', '')

---@class MaxHeap : Heap
local maxHeap = require((...):match("(.-)[^%.]+$") .. ".heap")
maxHeap.__extVersion = "0.0.4"

local function default_compare(a, b) return a > b end

---Creates a new maxHeap.
---@param elements table? # An array of elements to init with.
---@param compare function? # A less than comparison callback: a < b
---@return MaxHeap
function maxHeap.new(elements, compare)
	local self = setmetatable({}, maxHeap)
	self.compare = compare or default_compare

	for _, v in ipairs(elements or {}) do
		self:insert(v)
	end

	---@type MaxHeap
	return self
end

return maxHeap
