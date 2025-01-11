
local HERE = (...):match("(.-)[^%.]+$")
local Base = require(HERE .. ".base")

---@class Array : TabluaBaseFunctions
local array = setmetatable({}, { __index = Base })
array.__index = array
array.__extVersion = "0.2.0"

local function assert(condition, message, stack)
	if not condition then
		error(message, stack)
	end
end

local function assertTable(t)
	assert(type(t) == "table",
		'Parameter type needs to be of type "table".  Passed type: '..type(t), 4)
end

-------------------------------------------------

---@return Array
function array.new(t)
	return setmetatable(t or {}, {__index = array})
end

function array.compare(a, b)

	--[[
	This function will compare two tables and return true if they are the same.
	]]

	assertTable(a)
	assertTable(b)

	if a == b then return true end
	if #a ~= #b then return false end

	local clone = Base.clone(b)
	for k,v in pairs(a) do
		if clone[k] ~= v then
			return false
		end
		clone[k] = nil
	end

	return #clone == 0

end

function array.iterate(a, remove)

	--[[
	This is a custom iterator that will return each item in the array for you to alter as needed.
	Upon finishing the iterator, it will run through and delete [remove] items safely and efficiently.
	]]

	local i = 0
	local size = #a
	return function()
		i = i + 1
		if i <= size then return i, a[i] end
		Base.condense(a, remove)
	end

end

function array.mipairs(a, mi)

	--[[
	This is an iterator that wraps back to the start to complete the iteration.
	Works like ipairs, but you can start in the middle.
	@mi is the part of the array you wish to start at.
	{1,2,3,4,5} with mi = 3 would iterate as [3,4,5,1,2]
	]]

	assert(mi <= #a and mi > 0, "Attempt to start iteration out of bounds.")
	local iterations = -1
	return function()
		iterations = iterations + 1
		if iterations < #a then
			local pos = (mi + iterations - 1) % #a + 1
			return pos, a[pos]
		end
	end

end

return array