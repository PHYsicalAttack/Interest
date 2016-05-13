function div(x)
	return function (y) return y/x end

end
local div2 =div(2)
local div3 =div(3)
print(div2(4))
print(div3(6))