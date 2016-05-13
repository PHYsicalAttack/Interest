local x = 1
for i=2,100 do 
	for j=2,i-1 do
		if i%j==0 then
			break
		elseif i~=x then 
			x=i
			print(i)
		end
	end
end