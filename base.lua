-- only for use with tablua files

---@class TabluaBaseFunctions
---@field insert function
---@field remove function
local Base = {}
setmetatable(Base, { __index = table })
Base.__extVersion = "0.0.2"


local function assert(condition, message, stack)
	if not condition then
		error(message, stack)
	end
end

local function assertTable(t)
	assert(type(t) == "table",
		"Parameter type needs to be of type 'table'.  Passed type: " .. type(t), 4)
end

-------------------------------------------------

---@return table
function Base.new(t)
	return setmetatable(t or {}, { __index = Base })
end

function Base.swap(a, first, second)
	--[[
	This will swap two elements in the table.
	]]

	assertTable(a)

	local cache = a[first]
	a[first] = a[second]
	a[second] = cache
end

function Base.shallowClone(a)
	--[[
	This function is a simple clone.  Only meant for single layer tables and arrays.
	Passed a table with a nested table, original references to subsequent table could interfere.
	If you are unsure if you should use this function, or table.clone, use table.clone.
	]]

	assertTable(a)

	local output = {}
	for k, v in pairs(a) do
		output[k] = v
	end
	return Base.new(output)
end

function Base.clone(a)
	--[[
	This function will create copy of the passed table, and will clone any nested tables.
	]]

	if type(a) ~= "table" then return a end
	local output = {}
	for k, v in pairs(a) do
		if type(v) == "table" then
			output[k] = Base.clone(v)
		else
			output[k] = v
		end
	end
	return Base.new(output)
end

function Base.join(a, ...)
	--[[
	This function will join multiple tables together.
	Tables with string keys will set a[key] to b[key] value.
	]]

	assertTable(a)

	local output = Base.clone(a)
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		assertTable(t)
		for k, v in pairs(t) do
			if type(k) == "number" then
				Base.insert(output, v)
			else
				output[k] = v
			end
		end
	end
	return Base.new(output)
end

function Base.slice(a, start, finish)
	--[[
	Returns a new array from a from numerical index start to finish.
	]]

	assertTable(a)

	if not finish then finish = #a end

	local out = {}
	for i = start, finish do
		if not a[i] then break end
		Base.insert(out, a[i])
	end
	return Base.new(out)
end

function Base.splice(a, index, howmany, ...)
	--[[
	This function will remove a range of elements from a table.
	... will insert at index
	developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
	]]

	assertTable(a)

	if not howmany then howmany = 0 end
	local out = {}
	for i = 1, index do
		Base.insert(out, a[i])
	end
	for k, v in ipairs({ ... }) do
		Base.insert(out, v)
	end
	for i = index + howmany + 1, #a do
		Base.insert(out, a[i])
	end

	return Base.new(out)
end

function Base.last(a)
	--This will return the last item in a sorted array
	return a[#a]
end

function Base.choice(a)
	--Returns a random item from the table.

	assertTable(a)

	local choice = math.random(#a)
	return a[choice], choice
end

function Base.choices(a, count)
	--Returns count number of random items from the table.

	assertTable(a)

	local out = {}
	local cache = Base.clone(a)
	for i = 1, count do
		local choice, key = Base.choice(cache)
		Base.insert(out, choice)
		Base.remove(cache, key)
	end
	return Base.new(out)
end

function Base.find(a, value)
	--[[
	This function will search a table for a value and return the index of the value.
	If the value is not found, it will return nil.
	]]

	assertTable(a)

	for k, v in pairs(a) do
		if v == value then
			return k
		end
	end
	return nil
end

function Base.binarySearch(a, value)
	--[[
	This function will search a table for a value and return the index of the value.
	If the value is not found, it will return nil.
	@Ensure a is sorted before using this function.
	]]

	assertTable(a)

	local low = 1
	local high = #a
	while low <= high do
		local mid = math.floor((low + high) / 2)
		if a[mid] == value then
			return mid
		elseif a[mid] < value then
			low = mid + 1
		else
			high = mid - 1
		end
	end
	return nil
end

function Base.unique(a)
	--[[
	This will reduce a into it's unique values
	]]

	local unique = {}
	local uniqueSet = {}
	for k, v in pairs(a) do
		if not uniqueSet[v] then
			uniqueSet[v] = true
			Base.insert(unique, v)
		end
	end
	return Base.new(unique)
end

function Base.gCondense(a, remove)
	--[[
	This will go through an array and remove all that match [remove].
	This one returns the result of this.  table.condense will set the table to the result.
	]]

	local out = {}
	for k, v in pairs(a) do
		if v ~= remove then
			Base.insert(out, v)
		end
	end
	return Base.new(out)
end

function Base.condense(a, remove)
	--[[
	This will go through an array and remove all that match [remove].
	This one will condense table passed.  table.gCondense will return a new table.
	*This will work with tables with sparse indices (AKA tables like a = {}; a[2] = true)

	I chose to use this algorithm to preserve table address and prevent iterating
	  over the table twice.
	]]

	local newTab = {}
	for k, v in pairs(a) do
		if v ~= remove then
			Base.insert(newTab, v)
		end
		a[k] = nil
	end

	for k, v in pairs(newTab) do
		a[k] = v
	end
end

function Base.every(a, test)
	--[[
	Returns true if every element in this array satisfies the testing function.

	example:
	t = table.new({6,7,8})
	print(t:every(function(v) return v > 4 end)) -- returns true
		OR
	print(table.every(t, function(v) return v == 1 end)) -- returns false

	]]

	for k, v in pairs(a) do
		if not test(v) then
			return false
		end
	end
	return true
end

function Base.filter(a, test)
	--[[
	Returns a new array containing all elements of the calling array
	  for which the provided filtering function returns true.
	]]

	local out = Base.new()
	for k, v in pairs(a) do
		if test(k, v) then
			Base.insert(out, v)
		end
	end
	return out
end

function Base.invert(a)
	--[[
	Reverses the order of a
	]]

	for i = 1, math.floor(#a / 2) do
		Base.swap(a, i, #a - (i - 1))
	end
end

function Base.shuffle(a)
	--[[
		Implements Fisher-Yates Shuffle algorithm.
		This directly shuffles table a
	]]

	local length = #a
	while length > 1 do
		local i = math.random(1, length)
		Base.swap(a, length, i)

		length = length - 1
	end
end

function Base.arrayIter(a, remove)
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

function Base.reverse(a)
	--[[
	This is an iterator that iterates backwards through the array
	]]

	local i = #a + 1
	return function()
		i = i - 1
		if i > 0 then
			return i, a[i]
		end
	end
end

return Base
