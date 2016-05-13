local function roll()
	local obj={}
	local last_roll = nil
	function obj.roll(low,high)
		local once_roll = math.random(low,high)
		if once_roll==last_roll then
			return obj.roll(low,high)
		end
		last_roll=once_roll
		return last_roll
	end
	math.random(os.time())
	return obj
end
local x=roll()
print (x.roll(1,2))
print (x.roll(1,2))
print (x.roll(1,2))
print (x.roll(1,2))