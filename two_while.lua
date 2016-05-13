--
local startN = 1
local endN=10
local singelN=2
local countN=0
do
while startN<endN do
		while countN<singelN do	
				countN=countN+1
		end
	--print(startN,"\b",countN)
	startN=startN+1
end
end
print(startN,"\b",countN)