local MC = 12
local MH=1
local MO= 16
local matter ="CH(CO2H)3"

function getmatter(matter)
	local temp = {}
	for w in string.gmatch(matter) do
		temp[#temp+1] =w 
	end
	local stack ={}
	for i,v in ipairs(temp) do
		local typev = string.find("CHO()",v) 
		if typev<=3 then
			if stack[#stack] ==nil then
				stack[1] = select(typev,MC,MH,MO)
			elseif type(stack[#stack]) == "number" then
				stack[#stack] = stack[#stack] + select(typev,MC,MH,MO)
			else
				stack[#stack+1] = select(typev,MC,MH,MO)
			end
		elseif



end
