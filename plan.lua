-----------------------------------
----Time:	2015-11-4
----File:	plan.lua
----Author: Fallever
----Desc:	输出当月的所有天数和星期
-----------------------------------
local desk_path="/Users/0280102pc0102/Desktop/"
local file=io.open(desk_path .. "workplan.lua","w")
assert(file,"呃呃呃呃")
file:write("")
file:close()
local file = io.open(desk_path .. "workplan.lua","w")
local now=os.date("*t",os.time())
--now.month=1 --调月份
local n_month=now.month
now.day=1
file:write(string.format("----------%d月工作记录表----------\10",now.month))
local next_month=now.month+1
repeat 
	if tonumber(os.date("%m",os.time(now)))==n_month then
		file:write(string.format("%d%s:\10",os.date("%m",os.time(now)),os.date("月%d日 %a",os.time(now))))
	end
	now.day=now.day+1
until os.time(now)>=os.time({year=now.year;month=next_month;day=1})
file:write(string.format("----------%d月工作记录表----------\10",now.month))
file:close()