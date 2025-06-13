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


---Create a new tablua base
---@param t table?
---@return table|TabluaBaseFunctions
function Base.new(t)
	return setmetatable(t or {}, { __index = Base })
end

---Swaps two elements in the table.
---@param a table
---@param first integer
---@param second integer
function Base.swap(a, first, second)
	assertTable(a)

	local cache = a[first]
	a[first] = a[second]
	a[second] = cache
end

---This function is a simple clone.  Only meant for single layer tables and arrays. <br>
---If passed a table with a nested table, original references to the subsequent table could interfere. <br>
---If you are unsure if you should use this function, or table.clone, use table.clone. <br>
---@param a table|TabluaBaseFunctions
---@return table
function Base.shallowClone(a)
	assertTable(a)

	local output = {}
	for k, v in pairs(a) do
		output[k] = v
	end
	return Base.new(output)
end

---This function will create copy of the passed table, and will clone any nested tables.
---@param a table|TabluaBaseFunctions
---@return TabluaBaseFunctions
function Base.clone(a)
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

---This function will join multiple tables together.
---Tables with string keys will set a[key] to b[key] value.
---@param a table|TabluaBaseFunctions
---@param ... table|TabluaBaseFunctions
---@return TabluaBaseFunctions
function Base.join(a, ...)
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

---Returns a new array from a from numerical index start to finish.
---@param a any
---@param start any
---@param finish any
---@return table|TabluaBaseFunctions
function Base.slice(a, start, finish)
	assertTable(a)

	if not finish then finish = #a end

	local out = {}
	for i = start, finish do
		if not a[i] then break end
		Base.insert(out, a[i])
	end
	return Base.new(out)
end

---This function will remove a range of elements from a table.
---@param a TabluaBaseFunctions
---@param index integer Index to start removing elements exclusive.  Item at index will remain
---@param howmany integer Amount of elements to remove
---@param ... any Elements to insert at index
---@return TabluaBaseFunctions
function Base.splice(a, index, howmany, ...)
	-- inspired by
	-- developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
	assertTable(a)

	if not howmany then howmany = 0 end
	local out = {}
	for i = 1, index do
		Base.insert(out, a[i])
	end
	for _, v in ipairs({ ... }) do
		Base.insert(out, v)
	end
	for i = index + howmany + 1, #a do
		Base.insert(out, a[i])
	end

	return Base.new(out)
end

---Returns the last ordered item in the table.  Holes in array will not be considered.
---@param a table|TabluaBaseFunctions
---@return TabluaBaseFunctions #The last ordered item in the table
function Base.last(a)
	return a[#a]
end

---Returns a random item from the table.
---@param a table|TabluaBaseFunctions
---@return TabluaBaseFunctions #The random item
---@return integer #The index of the random item
function Base.choice(a)
	assertTable(a)

	local choice = math.random(#a)
	return a[choice], choice
end

---Returns count number of random items from the table.
---@param a table|TabluaBaseFunctions
---@param count integer total number of random items to return
---@return TabluaBaseFunctions
function Base.choices(a, count)
	assertTable(a)

	local out = {}
	local cache = Base.clone(a)
	for _ = 1, count do
		local choice, key = Base.choice(cache)
		Base.insert(out, choice)
		Base.remove(cache, key)
	end
	return Base.new(out)
end

---This function will search a table for a value and return the index of the value.<br>
---If the value is not found, it will return nil.
---@param a table|TabluaBaseFunctions
---@param value any
---@return TabluaBaseFunctions?
function Base.find(a, value)
	assertTable(a)

	for k, v in pairs(a) do
		if v == value then
			return k
		end
	end
	return nil
end

---This function will search a table for a value and return the index of the value.<br>
---If the value is not found, it will return nil.<br>
---Important! The table must be sorted before using this function.
---@param a table|TabluaBaseFunctions
---@param value any
---@return integer?
function Base.binarySearch(a, value)
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

---This will reduce a into it's unique values
---@param a table|TabluaBaseFunctions
---@return TabluaBaseFunctions
function Base.unique(a)
	local unique = {}
	local uniqueSet = {}
	for _, v in pairs(a) do
		if not uniqueSet[v] then
			uniqueSet[v] = true
			Base.insert(unique, v)
		end
	end
	return Base.new(unique)
end

---This will go through an array and remove all that match [remove].
---@param a table|TabluaBaseFunctions
---@param remove any The value to remove
---@return TabluaBaseFunctions
---@nodiscard
function Base.gCondense(a, remove)
	local out = {}
	for _, v in pairs(a) do
		if v ~= remove then
			Base.insert(out, v)
		end
	end
	return Base.new(out)
end

---This will go through an array and remove all that match [remove].<br>
---Condenses the table in place without creating a new address
---@param a table|TabluaBaseFunctions
---@param remove any The value to remove
function Base.condense(a, remove)
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

---Returns true if every element in this array satisfies the testing function.
---@param a table|TabluaBaseFunctions
---@param test function The test function. ex. `function(v) return v > 4 end`
---@return boolean
function Base.every(a, test)
	for _, v in pairs(a) do
		if not test(v) then
			return false
		end
	end
	return true
end

---Returns a new array containing all elements that param test returns true on
---@param a table|TabluaBaseFunctions
---@param test function The test function.  ex. `function(k, v) return v > 4 end`
---@return TabluaBaseFunctions
function Base.filter(a, test)
	local out = Base.new()
	for k, v in pairs(a) do
		if test(k, v) then
			Base.insert(out, v)
		end
	end
	return out
end

---Reverses the order of a
---@param a table|TabluaBaseFunctions
function Base.invert(a)
	for i = 1, math.floor(#a / 2) do
		Base.swap(a, i, #a - (i - 1))
	end
end

---Directly shuffles table `a` using Fisher-Yates Shuffle algorithm
---@param a table|TabluaBaseFunctions
function Base.shuffle(a)
	local length = #a
	while length > 1 do
		local i = math.random(1, length)
		Base.swap(a, length, i)

		length = length - 1
	end
end

---This is an iterator that iterates backwards through the array
---@param a table|TabluaBaseFunctions
---@return function The iterator
function Base.reverse(a)
	local i = #a + 1
	return function()
		i = i - 1
		if i > 0 then
			return i, a[i]
		end
	end
end

return Base
