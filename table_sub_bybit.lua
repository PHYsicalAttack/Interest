--2个表按最末尾对齐相减--
a={1,1,1,1}
b={9,3,2}
c={}
a2={}
b2={}
c2={}
--试试把一个表倒过来
for i=1,#a do
	a2[i]=a[#a-i+1]
	print(a2[i])
end
for i=1,#b do
	b2[i]=b[#b-i+1]
	print(b2[i])
end
print("****")

for i,v in ipairs(a2) do
	--print("ha" .. v)
	if b[i]==nil then 
		c[i]=a2[i]
	elseif b2[i]<=a2[i] then 
		c[i]=a2[i]-b2[i]
	elseif b2[i]>a2[i] then
		c[i]=10+a2[i]-b2[i]
		a2[i+1]=a2[i+1]-1
	end
end
--把表c变成顺序
for i=1,#c do
	c2[i]=c[#c-i+1]
	print("第"..i .."位数字:" .. c2[i])
end