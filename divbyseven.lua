--迭代算一个数字能不能被7整除。
tarNum={1,3,5,6}
decNum={}
decNum2={}
subNum={}
subNum2={}
resNum={}
for i=1,#tarNum-1 do
	lastNum=tarNum[#tarNum]*2
	decNum[i]=tarNum[i]
end
local i=1
for w in string.gmatch(lastNum,".") do
		subNum[i]=tonumber(w)
		i=i+1

end
--把表倒过来，因为我菜
for i=1,#decNum do
	decNum2[i]=decNum[#decNum-i+1]
end
for i=1,#subNum do
	subNum2[i]=subNum[#subNum-i+1]
	--print(type(subNum2[i]))

end

--进行逐位减法运算
for i,v in ipairs(decNum2) do
	if subNum2[i]==nil then
		resNum[i]=decNum2[i]
	elseif subNum2[i]<=decNum2[i] then
		resNum[i]=decNum2[i]-subNum2[i]
	elseif decNum2[i]<subNum2[i] then
		resNum[i]=10+decNum2[i]-subNum2[i]
		decNum2[i+1]=decNum2[i+1]-1
	end
end
--把resNum表按照倒序分配给表tar
resNum2={}
resNum2={}
for i=1,#resNum do
	resNum2[i]=resNum[#resNum-i+1]
end
for i,v in ipairs(resNum2) do
	print(i .. "位上的数字是"  .. v)
end