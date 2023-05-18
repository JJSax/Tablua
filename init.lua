
local HERE = (...):gsub('%.[^%.]+$', '')

local Set = require(HERE..".tablua.set")
local Array = require(HERE..".tablua.array")
local Queue = require(HERE..".tablua.queue")
local Stack = require(HERE..".tablua.stack")
local Tablua = require(HERE..".tablua.tablua")

local tablua = {}

tablua.Set = Set.new
tablua.Array = Array.new
tablua.Queue = Queue.new
tablua.Stack = Stack.new
tablua.Tablua = Tablua.new

return tablua