
local HERE = (...):gsub('%.[^%.]+$', '')

local Set = require(HERE..".set")
local Array = require(HERE..".array")
local queue = require(HERE..".queue")

local tablua = {}

tablua.Set = Set.new
tablua.array = Array.new


return tablua