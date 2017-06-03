function isprime(num)
	local ans = true
	for i = 2,math.ceil(num^(1/2)) do
		if num%i ==0 and num ~= 2 then
			ans = false
		end
	end

	return ans
end

print(isprime(2))