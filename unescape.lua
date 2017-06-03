function unescape( s )
	s = string.gsub(s,"+"," ")
	s = string.gsub(s,"%%(%x%x)",function (h)
		return string.char(tonumber(h,16))
	end)

	return s
end

print(unescape("a%2Bb+%3D+c"))

--[[tab扩展 空白捕获
print(string.match("hello","()ll()"))	-->3 5
print(string.find("hello","ll"))		-->3 4
]]

function expandTabs(s,tab)
	tab = tab or 8 		--制表符的"大小" (默认为8)
	local corr = 0
	s = string.gsub(s,"()\t",function ( p )
		local sp = tab -(p-1 +corr)%tab
		corr = corr - 1 +sp 
		return string.rep("",sp)
	end)
	return s
end
--print(expandTabs("1 		2  	3  		4  5"))