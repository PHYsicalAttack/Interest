function Fun1()
	local iVal = 10
	function innerFunc1()
		print(iVal)
	end
	function innerFunc2()
		iVal=iVal+10
	end
	return innerFunc1,innerFunc2
end
local a,b = Fun1()
a()
a()
b()
a()