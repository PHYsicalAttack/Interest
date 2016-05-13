
baoguo={}	--ding yi bei bao 
local A,B,C,D,E,F,G,H,I,J = 0,0,0,0,0,0,0,0,0,0
function Roll()
	math.randomseed(os.time())
	
	for i=1,4 do
		jieguo=math.random(10)
		if i>3 then
			if jieguo==1 then
				A=A+1
			elseif jieguo==2 then
				B=B+1
			elseif jieguo==3 then
				C=C+1
			elseif jieguo==4 then
				D=D+1
			elseif jieguo==5 then
				E=E+1
			elseif jieguo==6 then
				F=F+1
			elseif jieguo==7 then
				G=G+1
			elseif jieguo==8 then
				H=H+1
			elseif jieguo==9 then
				I=I+1
			elseif jieguo==10 then
				J=J+1
			end
		end
	end
	table.insert(baoguo,A)
	table.insert(baoguo,B)
	table.insert(baoguo,C)
	table.insert(baoguo,D)
	table.insert(baoguo,E)
	table.insert(baoguo,F)
	table.insert(baoguo,G)
	table.insert(baoguo,H)
	table.insert(baoguo,I)
	table.insert(baoguo,J)
end
roll()
for k,v in pairs(baoguo) do
	print(k,v)
end