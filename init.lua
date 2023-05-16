
local HERE = (...):gsub('%.[^%.]+$', '')

local Set = require(HERE..".set")

local tablua = {}

tablua.Set = Set.new


return tablua