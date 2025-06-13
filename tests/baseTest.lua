print(_VERSION)

local tests = {
	passes = 0,
	fails = 0,
	errors = 0,
	totalTests = 0,

	supressPasses = false,
	callers = {
		-- set of errors
	}
}

function tests.test(name, func, expected)
	tests[debug.getinfo(2).short_src] = tests[debug.getinfo(2).short_src] or {
		passes = 0,
		fails = 0,
		errors = 0,
		totalTests = 0,
	}
	local srcset = tests[debug.getinfo(2).short_src]
	assert(srcset, "Problem setting source set")

	local function errorHandler(err)
		tests.errors = tests.errors + 1
		tests.fails = tests.fails + 1
		srcset.errors = srcset.errors + 1
		srcset.fails = srcset.fails + 1
		local trace = debug.traceback("", 2)
		local line = trace:match(":(%d+): in function") or "unknown"
		print(string.format("[ERROR] Test '%s' failed on line %s: %s", name, line, tostring(err)))
	end

	if expected == nil then
		expected = true
	end

	-- expected = expected == false and false or expected -- protected default against falsy values
	tests.totalTests = tests.totalTests + 1
	srcset.totalTests = srcset.totalTests + 1
	local ok, result = xpcall(func, errorHandler)

	if ok then
		if result ~= expected then
			local info = debug.getinfo(2, "Sl")
			local line = info and info.currentline or "unknown"
			print(string.format("[FAIL] Test '%s' on line %s: expected '%s', got '%s'", name, line, tostring(expected),
				tostring(result)))
			tests.fails = tests.fails + 1
			srcset.fails = srcset.fails + 1
		else
			if not tests.supressPasses then
				print(string.format("[PASS] Test '%s'", name))
			end
			tests.passes = tests.passes + 1
		end
	end
end

function tests.dump()
	print("\nRESULTS:")
	if tests.fails > 0 then
		print(" -> One or more tests failed!")
	else
		print(" -> All Tests Passed")
	end

	print("Tests ran: " .. tests.totalTests)
	print("Tests passed: " .. tests.passes)
	print("Tests failed: " .. tests.fails)
	print("Tests that errored: " .. tests.errors)
end

return tests
