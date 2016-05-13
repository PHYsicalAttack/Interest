--local t1=tonumber(os.date("%S",os.time())) --返回当前秒数
--print(type(t1),t1)
local t1 = os.time()
--local cyc=0
co=coroutine.create(function()
		for i=1,10 do
		local hour=math.floor(i/3600)
		local min = math.floor((i%3600)/60)
		local sec=math.floor(i%60)
		print("Time is :",hour,min,sec,"\10")
		coroutine.yield()
	end
	end)
while 1 do
	--local t2=tonumber(os.date("%S",os.time()))
	--print(type(t2),t2)
	local t2 = os.time()
	if t2==t1+1 then
		coroutine.resume(co)
		if coroutine.status(co)=="dead" then break end
		--local cyc=cyc+1
		 t1=t2
	end
	if cyc==10 then break end
end

