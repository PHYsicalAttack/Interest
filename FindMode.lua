function FindMode(...)
local arg={...}
local result={}
for i,v in ipairs(arg) do
	if type(v)~="number" then
		return "error" 
	else
		if not result[v] then result[v]=1 else result[v]=result[v]+1 end
	end
end
local rev={}
for k,v in pairs(result) do
	rev[#rev+1]=v
end
local times=math.max(table.unpack(rev))
local mode = "众数:"
for k,v in ipairs(result) do
	if v==times then  mode=mode .. k .. ";" end
end
return string.sub(mode,1,-2)
end
print(FindMode(1,2,2,3,3,3333,444,3))
