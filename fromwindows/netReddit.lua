local socket= require("socket")
local http = require("socket.http")
--百度贴吧帖子id
local url="http://tieba.baidu.com/p/%d?pn=%d"

function dealurl(url,id)
	local downt = {}
	local pn = 0
  local res,err = http.request(string.format(url,id,pn))
  print(res)
  while err == 200 do
  	for l in string.gmatch(res,"BDE_Image\34.-src=\34http://.-%.jpg") do
  			l = string.match(l,"src='htt://.-%jpg")
  			local png = string.match(l,"http://.-%.png")
				local jpeg = string.match(l,"http://.-%.jpeg")
				local gif = string.match(l,"http://.-%.gif")
				if png then
					table.insert(downt,png)
				elseif jpeg then
					table.insert(downt,jpeg)
				elseif gif then
					table.insert(downt,gif)
				else
					table.insert(downt,l)
				end
				print(downt[#downt])
				for i = #downt-1,1 do
					if downt[#downt] == downt[i] then
						table.remove(downt,#downt)
						return downt
					end
				end
		end
  	pn= pn+1
  	print("Now is page :",pn,#downt)
  	res,err = http.request(string.format(url,id,pn))
  end
 	return downt
end

for i,v in ipairs(dealurl(url,4684600503)) do
	print(i,v)
end
