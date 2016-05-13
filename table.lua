-- zheshi zhushi
a={"1",2,3,4,5,6,7}
print(type(a[1]))
for i,v  in ipairs(a) do
	print(i)
	print(v,"\10")
end
Reva={}
for i,v in ipairs(a) do 
	Reva[v]=i
	print(v,type(v))
	print(Reva[v],type(Reva[v]))
end
for i,v in ipairs(Reva) do
	print(type(i),type(v))
end