--设计一个循环，如果currentTime-startTime<3这个值则重复该循环
--如果currentTime-startTime=3,则执行一次corountine程序,并将currentTime的值重新赋给starttime
--当corountine处于死亡状态结束程序
local startTime = os.time()
--print(startTime)
local currentTime = os.clock()
--print(currentTime)
function cyc()
	for i=1,1000 do
		local x = 1
	end
	return
end
function useTime()
	if currentTime-startTime<1 then 
		return cyc()
	else
		return coco()
	end
end

	co=coroutine.create(function()
		for i=1,10 do
			print(i)
		coroutine.yield()
	end

	end)
	coroutine.resume(co)
print(os.time{year=1970,month=1,day=1,hour=0})
print(os.date("*t",906000490))
a=(os.date("*t",os.time()))
print(a)
for k,v in pairs(a) do
	print(k,v)
end

local n,s,s0 = 0,0,0
print(n,s,s0)
while true do
s = os.date("%S", os.time());
if s0 ~= s then
n = n + 1;
print("this is the "..n.." seceod");
end;
if n == 10 then
break;
end;
end;