time和date两个函数在Lua中实现所有的时钟查询功能。函数time在没有参数时返回当前时钟的数值。（在许多系统中该数值是当前距离某个特定时间的秒数。）当为函数调用附加一个特殊的时间表时，该函数就是返回距该表描述的时间的数值。这样的时间表有如下的区间：
year
a full year
month
01-12
day
01-31
hour
01-31
min
00-59
sec
00-59
isdst
a boolean, true if daylight saving
前三项是必需的，如果未定义后几项，默认时间为正午（12:00:00）。如果是在里约热内卢（格林威治向西三个时区）的一台Unix计算机上（相对时间为1970年1月1日，00:00:00）执行如下代码，其结果将如下。
-- obs: 10800 = 3*60*60 (3 hours)
print(os.time{year=1970, month=1, day=1, hour=0})
    --> 10800
print(os.time{year=1970, month=1, day=1, hour=0, sec=1})
    --> 10801
print(os.time{year=1970, month=1, day=1})
    --> 54000   (obs: 54000 = 10800 + 12*60*60)

os.time()                <== 返回当前系统的日历时间
os.date()                <== 返回本地化的时间字符串，这里是"11/28/08 17:23:37"
os.date("%x", os.time()) <== 返回自定义格式化时间字符串（完整的格式化参数），这里是"11/28/08"
os.clock()               <== 返回执行该程序CPU花去的时钟秒数，这里是1156.726

函数date，不管它的名字是什么，其实是time函数的一种“反函数”。它将一个表示日期和时间的数值，转换成更高级的表现形式。其第一个参数是一个格式化字符串，描述了要返回的时间形式。第二个参数就是时间的数字表示，默认为当前的时间。使用格式字符 "*t"，创建一个时间表。例如下面这段代码：
temp = os.date("*t", 906000490)
则会产生表
{year = 1998, month = 9, day = 16, yday = 259, wday = 4,
 hour = 23, min = 48, sec = 10, isdst = false}
不难发现该表中除了使用到了在上述时间表中的区域以外，这个表还提供了星期（wday，星期天为1）和一年中的第几天（yday，一月一日为1）除了使用 "*t" 格式字符串外，如果使用带标记（见下表）的特殊字符串，os.data函数会将相应的标记位以时间信息进行填充，得到一个包含时间的字符串。（这些特殊标记都是以 "%" 和一个字母的形式出现）如下：
print(os.date("today is %A, in %B"))
    --> today is Tuesday, in May
print(os.date("%x", 906000490))
    --> 09/16/1998
这些时间输出的字符串表示是经过本地化的。所以如果是在巴西（葡萄牙语系），"%B" 得到的就是 "setembro"（译者按：大概是葡萄牙语九月？），"%x" 得到的就是 "16/09/98"（月日次序不同）。标记的意义和显示实例总结如下表。实例的时间是在1998年九月16日，星期三，23:48:10。返回值为数字形式的还列出了它们的范围。（都是按照英语系的显示描述的，也比较简单，就不烦了）
%a
abbreviated weekday name (e.g., Wed)
%A
full weekday name (e.g., Wednesday)
%b
abbreviated month name (e.g., Sep)
%B
full month name (e.g., September)
%c
date and time (e.g., 09/16/98 23:48:10)
%d
day of the month (16) [01-31]
%H
hour, using a 24-hour clock (23) [00-23]
%I
hour, using a 12-hour clock (11) [01-12]
%M
minute (48) [00-59]
%m
month (09) [01-12]
%p
either "am" or "pm" (pm)
%S
second (10) [00-61]
%w
weekday (3) [0-6 = Sunday-Saturday]
%x
date (e.g., 09/16/98)
%X
time (e.g., 23:48:10)
%Y
full year (1998)
%y
two-digit year (98) [00-99]
%%
the character '%'
事实上如果不使用任何参数就调用date，就是以%c的形式输出。这样就是得到经过格式化的完整时间信息。还要注意%x、%X和%c由所在地区和计算机系统的改变会发生变化。如果该字符串要确定下来（例如确定为mm/dd/yyyy），可以使用明确的字符串格式方式（例如"%m/%d/%Y"）。
函数os.clock返回执行该程序CPU花去的时钟秒数。该函数常用来测试一段代码。
local x = os.clock()
local s = 0
for i=1,100000 do s = s + i end
print(string.format("elapsed time: %.2f\n", os.clock() - x))