

local Set = {}
Set.__index = Set
local sizeName = "__SIZEOFSETPROTECTEDVARIABLENAMESPACE__"

function Set.new()
	return setmetatable({[sizeName] = 0}, Set)
end

function Set:add(key)
	assert(key ~= sizeName, "Attempt to use protected key.")
	if key == nil then return end
	self[sizeName] = self[sizeName] + 1
	self[key] = true
end

function Set:remove(key)
	if key == nil then return end
	self[sizeName] = self[sizeName] - 1
	self[key] = nil
end

function Set:toggle(key)
	local sz, to = 1, true
	if self[key] then
		sz, to = -1, nil
	end
	self[key] = to
	self[sizeName] = self[sizeName] + sz
end

function Set:size()
	return self[sizeName]
end

function Set:clone()
	local out = {}
	for k,v in pairs(self) do
		out[k] = v
	end
	return setmetatable(out, Set)
end

return Set