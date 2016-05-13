--return 需要返回的是一个值，不能是表达式。--
--[[e.g1:
function NewCounter1()
local i = 0
return function(x)
	i=i+1
	return i
	end
end
]]--
--[[
e.g2
function NewCounter1()
local i = 0
return function(x)
	return i==i+1
end
end
]]--
--e.g3
function NewCounter1()
local i 
return function(x)
	return i
end
end
--
c1=NewCounter1()
print(c1(),c1())