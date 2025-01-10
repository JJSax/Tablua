
---@class Table
---@field insert function
---@field remove function
local Table = {}
setmetatable(Table, { __index = table })
Table.__extVersion = "0.4.6"


local function assert(condition, message, stack)
	if not condition then
		error(message, stack)
	end
end

local function assertTable(t)
	assert(type(t) == "table",
		"Parameter type needs to be of type 'table'.  Passed type: "..type(t), 4)
end

-------------------------------------------------

---@return Table
function Table.new(t)
	return setmetatable(t or {}, { __index = Table })
end

function Table.isArray(a)

	--[[
	Returns if the Table is an ordered array.
	This does iterate through all items in the Table to get the count.
	]]

	assertTable(a)
	return #a == Table.size(a)

end

function Table.size(a)

	--[[
	Works like #Table but works for tables with string keys and non sequence number keys
	If the Table is an array, use #tableName
	]]

	assertTable(a)

	local count = 0
	for k,v in pairs(a) do
		count = count + 1
	end
	return count

end

function Table.swap(a, first, second)

	--[[
	This will swap two elements in the Table.
	]]

	assertTable(a)

	local cache = a[first]
	a[first] = a[second]
	a[second] = cache

end

function Table.shallowClone(a)

	--[[
	This function is a simple clone.  Only meant for single layer tables and arrays.
	Passed a Table with a nested Table, original references to subsequent Table could interfere.
	If you are unsure if you should use this function, or Table.clone, use Table.clone.
	]]

	assertTable(a)

	local output = {}
	for k,v in pairs(a) do
		output[k] = v
	end
	return Table.new(output)

end

function Table.clone(a)

	--[[
	This function will create copy of the passed Table, and will clone any nested tables.
	]]

	if type(a) ~= "table" then return a end
	local output = {}
	for k, v in pairs(a) do
		if type(v) == "table" then
			output[k] = Table.clone(v)
		else
			output[k] = v
		end
	end
	return Table.new(output)

end

function Table.join(a, ...)

	--[[
	This function will join multiple tables together.
	Tables with string keys will set a[key] to b[key] value.
	]]

	assertTable(a)

	local output = Table.clone(a)
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		assertTable(t)
		for k,v in pairs(t) do
			if type(k) == "number" then
				Table.insert(output, v)
			else
				output[k] = v
			end
		end
	end
	return Table.new(output)
end

function Table.slice(a, start, finish)

	--[[
	Returns a new array from a from numerical index start to finish.
	]]

	assertTable(a)

	if not finish then finish = #a end

	local out = {}
	for i = start, finish do
		if not a[i] then break end
		Table.insert(out, a[i])
	end
	return Table.new(out)

end

function Table.splice(a, index, howmany, ...)
	--[[
	This function will remove a range of elements from a Table.
	... will insert at index
	developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
	]]

	assertTable(a)

	if not howmany then howmany = 0 end
	local out = {}
	for i = 1, index do
		Table.insert(out, a[i])
	end
	for k,v in ipairs({...}) do
		Table.insert(out, v)
	end
	for i = index + howmany + 1, #a do
		Table.insert(out, a[i])
	end

	return Table.new(out)
end

function Table.last(a)

	--This will return the last item in a sorted array
	return a[#a]

end

function Table.choice(a)

	--Returns a random item from the Table.

	assertTable(a)

	local choice = math.random(#a)
	return a[choice], choice

end

function Table.choices(a, count)

	--Returns count number of random items from the Table.

	assertTable(a)

	local out = {}
	local cache = Table.clone(a)
	for i = 1, count do
		local choice, key = Table.choice(cache)
		Table.insert(out, choice)
		Table.remove(cache, key)
	end
	return Table.new(out)

end

function Table.find(a, value)

	--[[
	This function will search a Table for a value and return the index of the value.
	If the value is not found, it will return nil.
	]]

	assertTable(a)

	for k,v in pairs(a) do
		if v == value then
			return k
		end
	end
	return nil

end

function Table.binarySearch(a, value)

	--[[
	This function will search a Table for a value and return the index of the value.
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

function Table.compare(a, b)

	--[[
	This function will compare two tables and return true if they are the same.
	]]

	assertTable(a)
	assertTable(b)

	if a == b then return true end
	if #a ~= #b then return false end

	local clone = Table.clone(b)
	for k,v in pairs(a) do
		if clone[k] ~= v then
			return false
		end
		clone[k] = nil
	end

	return Table.size(clone) == 0

end

function Table.unique(a)

	--[[
	This will reduce a into it's unique values
	]]

	local unique = {}
	local uniqueSet = {}
	for k,v in pairs(a) do
		if not uniqueSet[v] then
			uniqueSet[v] = true
			Table.insert(unique, v)
		end
	end
	return Table.new(unique)

end

function Table.gCondense(a, remove)

	--[[
	This will go through an array and remove all that match [remove].
	This one returns the result of this.  Table.condense will set the Table to the result.
	]]

	local out = {}
	for k,v in pairs(a) do
		if v ~= remove then
			Table.insert(out, v)
		end
	end
	return Table.new(out)

end

function Table.condense(a, remove)
	--[[
	This will go through an array and remove all that match [remove].
	This one will condense Table passed.  Table.gCondense will return a new Table.
	*This will work with tables with sparse indices (AKA tables like a = {}; a[2] = true)

	I chose to use this algorithm to preserve Table address and prevent iterating
	  over the Table twice.
	]]

	local newTab = {}
	for k, v in pairs(a) do
		if v ~= remove then
			Table.insert(newTab, v)
		end
		a[k] = nil
	end

	for k,v in pairs(newTab) do
		a[k] = v
	end


end


function Table.every(a, test)

	--[[
	Returns true if every element in this array satisfies the testing function.

	example:
	t = Table.new({6,7,8})
	print(t:every(function(v) return v > 4 end)) -- returns true
		OR
	print(Table.every(t, function(v) return v == 1 end)) -- returns false

	]]

	for k,v in pairs(a) do
		if not test(v) then
			return false
		end
	end
	return true

end

function Table.filter(a, test)

	--[[
	Returns a new array containing all elements of the calling array
	  for which the provided filtering function returns true.
	]]

	local out = Table.new()
	for k,v in pairs(a) do
		if test(k, v) then
			Table.insert(out, v)
		end
	end
	return out

end

function Table.invert(a)

	--[[
	Reverses the order of a
	]]

	for i = 1, math.floor(#a/2) do
		Table.swap(a, i, #a-(i-1))
	end

end

function Table.shuffle(a)

	--[[
		Implements Fisher-Yates Shuffle algorithm.
		This directly shuffles Table a
	]]

	local length = #a
	while length > 1 do
		local i = math.random(1, length)
		Table.swap(a, length, i)

		length = length - 1
	end

end

function Table.arrayIter(a, remove)

	--[[
	This is a custom iterator that will return each item in the array for you to alter as needed.
	Upon finishing the iterator, it will run through and delete [remove] items safely and efficiently.
	]]

	local i = 0
	local size = #a
	return function()
		i = i + 1
		if i <= size then return i, a[i] end
		Table.condense(a, remove)
	end

end

function Table.reverse(a)

	--[[
	This is an iterator that iterates backwards through the array
	]]

	local i = #a+1
	return function()
		i = i - 1
		if i > 0 then
			return i, a[i]
		end
	end

end

return Table