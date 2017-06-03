function zero(num)
	local zeronum = 0
	if num %10 ==0 then
		zeronum = zeronum+1
		zero(num//10)
	end
	return zeronum,num
end

print(zero(10))
print("你好")