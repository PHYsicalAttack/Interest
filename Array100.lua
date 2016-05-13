math.randomseed(os.time())
local N = 10;
local array = {};
for i=1,N do
	array[i]=i
end
for i=1,N do 
	local j =math.random(N-i+1)+i-1
	array[i],array[j]=array[j],array[i]

end
for i=1,10 do 
	print(array[i])
end