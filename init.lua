
local HERE = (...):gsub('%.[^%.]+$', '')

local Set = require(HERE..".tablua.set")
local Array = require(HERE..".tablua.array")
local Queue = require(HERE..".tablua.queue")
local Stack = require(HERE..".tablua.stack")
local Tablua = require(HERE..".tablua.tablua")
local MinHeap = require(HERE..".tablua.minHeap")

local tablua = {}

tablua.Set = Set.new ---@type Set
tablua.Array = Array.new ---@type Array
tablua.Queue = Queue.new ---@type Queue
tablua.Stack = Stack.new ---@type Stack
tablua.Tablua = Tablua.new ---@type Table
tablua.minHeap = MinHeap.new

return tablua