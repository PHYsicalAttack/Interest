table={"A","B","C","D","E"}
math.randomseed(os.time())
for i=1,3 do 
	a=math.random(5)
	if i>3 then 
		print(a)
		return a
	end
end
