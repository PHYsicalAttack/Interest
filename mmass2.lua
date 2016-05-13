local MC = 12
local MH=1
local MO= 16

local matter ="CH(CO2H)3"
local mat_table={}
local sub_i=1
--有bug如果输入超过2位数字就是错的！
while string.sub(matter,sub_i,sub_i) ~= "" do
	mat_table[#mat_table+1]=string.sub(matter,sub_i,sub_i)
	sub_i=sub_i+1
end
--返回 pl pr 左右括号的位置
function find_smy(t) 
	local pl,pr = 0,0
	for i=1,#t do
		if t[i]==")" then pr=i end
	end
	for i=1,#t do
		if t[#t-i+1] == "(" then pl=#t-i+1 end
	end
	return pl,pr
	-- body
end

--最小单元计算
function add_tem(t)
	assert(type(t)=="table","表是错的")
	local res=0
	local i = 1
	while i < #t+1 do
		if t[i+1] and tonumber(t[i+1]) and not tonumber(t[i])  then  --适用于 {"H","2"}这样
			--{"o","2"}
			--print(i+1,chsn(t[i]))
			res=res+chsn(t[i])*tonumber(t[i+1])
			i=i+2
		elseif t[i+1] and tonumber(t[i+1]) and  tonumber(t[i]) then		--使用 (ch)2这样的计算
			res=res+tonumber(t[i])* tonumber(t[i+1])
			i=i+2
		elseif t[i] then
			res=res+chsn(t[i])
			i=i+1
		end
		print(res)
	end	
	return res
end

--转化字母为值
function chsn(ch)
	local res
	if ch=="C"  then
		res=MC
	elseif ch=="H" then
		res=MH
	elseif ch=="O" then
		res=MO
	else 
		res=to
	end
	return res
end

--反复迭代计算

local answer = 0
function answer(t)
	local pl,pr = find_smy(t)
	local size=pr-pl-1
	if  size > 0 then
		local tem_t={}
		for i=1,size do
			tem_t[i]=t[pl+i]
			--print(tem_t[i])
		end
		--然后移除左括号后+1 到右括号的值
		t[pl]=add_tem(tem_t)
		--print(t[pl])
		for i=1,size+1 do
			table.remove(t,pl+1)
		end
		answer(t)
	else
		answer = add_tem(t)
	end
	return answer
end
--t={"C","H","H","O","2","O","(","O","2",")","2"}
t={"O","13","2","O"}
print(answer(t))