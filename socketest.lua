local socket = require "socket"
local https = require("ssl.https")
local http = require "socket.http"

--[[local file = io.open(os.getenv("HOME") .. "/Desktop/test.jpg","w")
local file2 = io.open(os.getenv("HOME") .. "/Desktop/test2.jpg","w")
local img_https ="https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1466128898&di=ddfa4316ee2d559fe612be8ddd076041&src=http://4493bz.1985t.com/uploads/allimg/141030/4-141030140001.jpg"
local img_html ="http://a4.att.hudong.com/16/47/20300542517256139796477874110.jpg"
local res,code = http.request(img_html)
local res2,code2 = https.request(img_https)

--print(code,code2)
file:write(res)
file:close()

file2:write(res2)
file2:close()
http.TIMEOUT = 3
local res3,code3 =https.request("htpp://www.google.com")
print(res3,code3)]]

local context,code = http.request("http://10.10.11.20/cmd?type=any")  --170
--local context,code = http.request("http://10.10.11.20/cmd?type=pkg")  --主线
print(code)
os.remove(os.getenv("HOME") .. "/Desktop/test.zip")
local file = io.open(os.getenv("HOME") .. "/Desktop/test.zip","w")
file:write(context)
file:close()