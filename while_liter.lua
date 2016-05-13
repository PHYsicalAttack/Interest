--while liter-
function Values(t)
local i = i or 1 
while 1 do
	local j = t[i]
	i=i+1
	if t[i]==nil then break end
	return t[i]
	end
end
liter = Values(t)

a={"a","b"}
print(Values(a))
