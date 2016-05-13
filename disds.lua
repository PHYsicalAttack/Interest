local s=0
math.randomseed(os.time())
for k=1,10000 do
	local A,B,C,D,E,F=0,0,0,0,0,0
	for i=1,60 do
		local flag=math.random(1,3)
		local flag2=math.random(1,3)
		if flag==1 then
		A=A+1
		elseif flag==2 then
		B=B+1
		elseif flag==3 then
		C=C+1
		end
		if flag2==1 then
		D=D+1
		elseif flag2==2 then
		E=E+1
		elseif flag2==3 then
		F=F+1
		end
	if A>=3 and B>=3 and C>=4 and D>=3 and E>=3 and F>=4 then
	-- print(i)
	s=s+i
	break
	end
	end
end



print(math.floor(s/10000))