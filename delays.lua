function delay(s,st)

	local start_time=st or os.time()
	repeat 
		end_time=os.time()
	until	end_time==start_time+s
		print(start_time,end_time)
		delay(s,end_time)
end
secret="I will kill you , that is a promise !"
for w in string.gmatch(secret,".") do
	local start_time=os.time()
	local delay_sec=1
	repeat 
		over_time=os.time()
	until over_time>=start_time+delay_sec
	print("*    " .. w .. "    *")
end
