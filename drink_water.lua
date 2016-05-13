--想要喝的水 、大瓶子的容量 、 小瓶子的容量
local x,m,n=2,8,3
--瓶子太小了
if x>m and x>n then 
	print("NO!your bottles are too small! ")
elseif x==m or x==n then 
	print("Yes! First try you can get what you want")
else 
	--大瓶子水的体积
	local maxBott=0
	--小瓶子水的体积
	local minBott=n
	for i=1,1000 do
		--把小瓶子的水倒入大瓶子
		maxBott=minBott+maxBott
		if maxBott >= m then 
			--大瓶子水满了，小瓶子的水就等于大瓶子倒不下的水
			minbott=maxBott-m
			--然后倒空大瓶子，将小瓶子的水倒入大瓶子中
			maxBott=minbott
		end
		--倒的过程如果水的体积等于需要的量则跳出循环
		if minBott==x or maxBott==x then 
			print("yes")
			break 
		elseif i==1000 then
			print("no!")
		end	
	end
end