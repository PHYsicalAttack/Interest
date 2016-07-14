local socket = require("socket")
local http = require("socket.http")
TIMEOUT = 5

local my_url = "http://gonglong:gonglong@192.168.1.100:8090/display/QWQ/QWQ+Home"

--res,code = http.request(url)
--res,code = http.request("http://gonglong:gonglong@192.168.1.100:8090/display/QWQ/QWQ+Home",[[<div class="wiki-content"> </div>]])
--print(res,code)
r,c,h= http.request{
	method = "POST",
	url= my_url,
}

print(r,c,h)
for k,v in pairs(h) do
	print(k,v)
end