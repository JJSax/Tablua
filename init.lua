
local HERE = (...):gsub('%.[^%.]+$', '')

local Set = require(HERE..".set")
local Array = require(HERE..".array")
local Queue = require(HERE..".queue")
local Stack = require(HERE..".stack")
local Tablua = require(HERE..".table")

local tablua = {}

tablua.Set = Set.new
tablua.Array = Array.new
tablua.Queue = Queue.new
tablua.Stack = Stack.new
tablua.Tablua = Tablua.new

return tablua