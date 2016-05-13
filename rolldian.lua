--roll点出跟上次不同的数字--
math.randomseed(os.time())
local low = 1
local high = 2
function rolldian()
	local before = nil
	function roll()
		need=math.random(low,high)
		if before~=need then 
			--print(before)
			before=need
			return before
		else 
			return roll()
		end
	end
	return roll
end
a=rolldian()
print(a(),a(),a(),a())

--[[function roll()
	local before=nil or need
	need=math.random(low,high)
	return compare()
end
function compare()
	if before ~= need then
		print(need)
		before=need
		--print(before)
	else 
		return roll()
end
end
roll()
roll()]]--
--[[function rolldian()
	local before = nil
	function roll()
		need=math.random(low,high)
		if before == need	then 
			return roll()
		end
		before=need
		return before
	end
	return roll
end
a=rolldian()
print(a(),a(),a(),a(),a(),a(),a())]]--
