
local HERE = (...):gsub('%.[^%.]+$', '')

local Set = require(HERE..".set")
local Array = require(HERE..".array")
local Queue = require(HERE..".queue")
local Stack = require(HERE..".stack")

local tablua = {}

tablua.Set = Set.new
tablua.Array = Array.new
tablua.Queue = Queue.new
tablua.Stack = Stack.new

return tablua