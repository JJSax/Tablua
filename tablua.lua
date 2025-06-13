
local HERE = (...):match("(.-)[^%.]+$")
local Base = require(HERE..".base")

---@class Table : TabluaBaseFunctions
local Table = setmetatable({}, { __index = Base })
Table.__index = Table
Table.__extVersion = "0.5.1"


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
	return setmetatable(Base.new(t), Table)
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
	for _ in pairs(a) do
		count = count + 1
	end
	return count

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

---This is a custom iterator that will return each item in the array for you to alter as needed.<br>
---Upon finishing the iterator, it will run through and delete [remove] items safely and efficiently.
---@param a table|TabluaBaseFunctions
---@return function The iterator
function Table.arrayIter(a, remove)
	local i = 0
	local size = #a
	return function()
		i = i + 1
		if i <= size then return i, a[i] end
		Base.condense(a, remove)
	end
end

return Table