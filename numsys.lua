--[[
ABCD是N进制下的数，k是N进制下的个位数，使得ABCD*K =DCBA,求4-16进制下的所有解
]]
--[[local t ={}]]
function haha()
	local t ={}
	function  tenintox(num,x)
		local v = math.floor(num/x)
		local l = math.fmod(num,x)
		--local t = t or {}
		table.insert(t,l)
		if v < x then 
			table.insert(t,v)
			return t
		else 
			return tenintox(v,x)		
		end
	end
	return tenintox
end

local n = 4
while n < 17 do
	print(n)
	local star = 1*n^3
	while star < n^4 do 
		local hehe = haha()
		local t = hehe(star,n)
		print(#t)
		w,x,y,z = table.unpack(t)
		--print(w,x,y,z)
		for k = 1, n -1 do 
			if (w*n^3+x*n^2+y*n^1+z*n^0) * k == star then 
				print(string.format("A = %d,B= %d,C = %d,D = %d,K = %d",z,y,x,w,k))
			end
		end
		star = star + 1
	end
	n = n + 1
end