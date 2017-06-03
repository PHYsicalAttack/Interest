--求100以内的素数
--素数:对于正整数n，如果用2~√n之间的证书去除，均无法除尽，则n是正数
local prime ={2,3}
for num = 4,100 do
	local temp = math.ceil(math.sqrt(num))
	for i = 2,temp,1 do 
		if num%i == 0 then 
			break
		elseif i ==temp then
			table.insert(prime,num)
		end
	end

end
print(table.unpack(prime))

