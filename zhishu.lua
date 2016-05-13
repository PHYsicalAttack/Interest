
local z={}
local j=1
z[1]=2
for i=3,100 do
	for k=1,j do
	if i%z[1]~=0 then
		z[j+1]=i
	end
	
 end
 j =j+1
end
print(table.unpack(z))

