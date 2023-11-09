
---@class Set
local Set = {}
Set.__extVersion = "0.0.6"
Set.__index = Set
local setsize = {} -- use in key of the set to store it's size.

---@return Set
function Set.new(keys)
	local self = setmetatable({[setsize] = 0}, Set)
	self:padd(keys)
	return self
end

function Set:add(key)
	assert(key ~= setsize, "Attempt to use protected key.")
	if key == nil or self[key] then return end
	self[setsize] = self[setsize] + 1
	self[key] = true
end

function Set:padd(keys)
	if keys == nil then return end
	for i, v in ipairs(keys) do self:add(v) end
end

function Set:remove(key)
	assert(key ~= setsize, "Attempt to use protected key.")
	if key == nil or not self[key] then return end
	self[setsize] = self[setsize] - 1
	self[key] = nil
end

function Set:toggle(key)
	assert(key ~= setsize, "Attempt to use protected key.")
	local sz, to = 1, true ---@type number,boolean|nil
	if self[key] then
		sz, to = -1, nil
	end
	self[key] = to
	self[setsize] = self[setsize] + sz
end

---@deprecated use #Set
function Set:size()
	return self[setsize]
end

function Set:list()
	local out = {}
	for k, v in pairs(self) do
		if k ~= setsize then
			table.insert(out, k)
		end
	end
	return out
end

function Set:clone()
	local out = {}
	for k,v in pairs(self) do
		out[k] = v
	end
	return setmetatable(out, Set)
end

function Set:iter()
	local key
	return function()
		key = next(self, key)
		if key == setsize then key = next(self, key) end
		return key
	end
end

function Set:__len()
	return self[setsize]
end

function Set:__eq(other)
	if other[setsize] and #other ~= #self then return false end
	local matchCount = 0
	for k in self:iter() do
		if other[k] then
			matchCount = matchCount + 1
		end
	end
	return matchCount == #self
end

return Set