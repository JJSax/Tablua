-- all tests in one.

local tests = require "tests.baseTest"
tests.supressPasses = true

require "tests.Table"
require "tests.array"
require "tests.set"
require "tests.queue"
require "tests.stack"
require "tests.minHeap"
require "tests.maxHeap"

print()
print(" -> Tablua full library test concluded")
tests.dump()
