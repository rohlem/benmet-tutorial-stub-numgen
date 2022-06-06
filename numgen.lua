assert(#arg == 3, "expected 3 arguments: <noise type ('w' or 'p')>, <filter (0 or 1)>, <amount (integer)>")

local noise_type = arg[1]
local filter = arg[2]
local amount = tonumber(arg[3])
assert(amount and (amount % 1 == 0), "third argument (amount) must be an integer number")

local n = noise_type == 'w' and math.random
	or noise_type == 'p' and function() local x = 1/math.random(); return x / (x + 20) end
	or error("unknown noise type: first argument must be 'w' or 'p'")
local f = filter == '0' and function(x) return x end
	or filter == '1' and function(x) return math.sin(x*math.pi) end
	or error("unknown filter: second argument must be 0 or 1")

if _G.jit or _VERSION < "Lua 5.4" then -- versions 5.4 and above actually already initialize with usably random default seeds
	math.randomseed(os.time() + os.clock()*1e10) -- on older versions we use system time as seed; granularity is not great though, multiple runs may get the same seed.
end

for i = 1, amount do
	print(f(n()))
end
