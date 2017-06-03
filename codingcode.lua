str =[[
t = {1,2,3,4,5}
math.randomseed(121)
for i = #t,1,-1 do
	x = math.random(i)

	t[x],t[i] = t[i],t[x]
end

for i,v in ipairs(t) do
	print(i,v)
end]]

local codedstr = ""
for p,c in utf8.codes(str) do
	--pos,code
	codedstr = codedstr .. utf8.char(c+2)
end
--print(codedstr)

--解码
local uncodedstr =""
for p,c in utf8.codes(codedstr) do
	uncodedstr = uncodedstr .. utf8.char(c-2)
end
--print(uncodedstr)

b=load(uncodedstr)
b()

a=load(str)
