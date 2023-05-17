
local HERE = (...):gsub('%.[^%.]+$', '')

local Set = require(HERE..".set")
local Array = require(HERE..".array")
local Queue = require(HERE..".queue")

local tablua = {}

tablua.Set = Set.new
tablua.array = Array.new
tablua.queue = Queue.new


return tablua