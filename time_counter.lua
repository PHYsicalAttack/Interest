local t1=os.time()
co=coroutine.create(function()
		for i=1,10000 do
			sec=i
	local hour=math.floor(sec/3600)
	local min = math.floor((sec%3600)/60)
	local sec=math.floor(sec%60)
	io.write("Now is :",hour,min,sec)
		coroutine.yield()
	end
	end)
while 1 do
	local t2 = os.time()
	local t2 = os.time()
	if t2==t1+1 then
		coroutine.resume(co)
		if coroutine.status(co)=="dead" then break end
	t1=t2
	end
end