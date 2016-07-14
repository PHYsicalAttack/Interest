-----------------------------------
----Time:	2016-11-4
----File:	seer_insert_new2.lua
----Author: Fallever
----Desc:	重新写插入账号脚本，用表来写以便支持grole表扩展,支持公会的插入,方便紧急测试用
-----------------------------------
--控制变量表
local key={
	severid	 = 17,							--服务器id
	acc_need = false,						--是否需要插入账号，如果有账号则不用多次插入
	role_need = true,						--是否需要角色
	family_need = false, 					--不使用的话改成false,不要用于平常正式测试!!!用sql注入公会成员数据会有其他问题，目的是为了紧急测试公会战显示
	family_member=20,						--只会为bot100以后的角色注入公会，一个公会20人，最多5个公会,按照 id % family_need来分配公会的
	money_need = true, 	 					--暂时没有用
	amount 	=200,							--插入的角色数量
}
local login_database = "seer_login" 			--需要插入账号的数据库
local game_database = "seer2"					--需要插入角色的数据库

--每次执行删除上次的写出文件
os.execute("rm " .. os.getenv("HOME") .. "/Desktop/seer.sql")				
local file=io.open(os.getenv("HOME") .. "/Desktop/seer.sql","a")
--随机种子
math.randomseed(os.time())					
local account={									--账号数据表								
	1000000,							--accid
	1024,								--srctype
	"dev_c",							--acc_char
	"1",								--passwd
	"9842053723102220",					--devid
	"2015-1-1",							--regtime
	"110",								--phone
	"pc",								--phone_model
	"mac",								--sys_version
	"none",								--subtype
}
local grole={									--角色数据表
	(key.severid+1)*1000000,					--初始的roleid
	"bot",										--rolename
	((key.severid+1)*1000000)*100000+account[1],		--初始的raccid
	account[3],											--rname
	1,											--sex性别
	8,											--icon头像有8个
	1024,										--srctype
	1,											--level等级
	0,											--level经验
	0,											--nonolv
	10000,										--power
	0,											--totalpaid
	"9842053723102220",							--devid
	0,											--familyid
	"",											--familyname
	1451620800,									--lastlogout(2015-1-1)
	"",											--desc
	0,											--overdue
	"2015-1-1",									--regtime
	"pc",										--phone_model
	"mac",										--sys_version
	"none",										--subtype
	"",											--guarderlist
}

local gfamily=									--公会信息表，还需插入gFMember,gFName，修改grole
{
	1000000*(key.severid+1),			--familyid
	"family",							--familyname
	1,									--familylv
	0,									--familycons	
	"",									--techlist
	0,									--techpoints
	"notice",							--公告
	"announce",							--宣言
	100000,								--active公会活跃度
	"2015-1-1",							--creat_time
	0,									--chairid
	"",									--chairname
	123456,								--totalpower
	0,									--membernum
	"",									--floglist
	"",									--chatdata
	0,									--donate_times
	"2015-1-2",							--refresh
	0,									--impeach_time
	"",									--impeach_list
}

local gfighters=
{
	context="0x836c0000000168136400036765726e0500d3c7b743ba620000040f64000b656c6563747269636974796105610061016100610061026100681664000461747472616a620000021c61006164610061006100610062000001f46100610061006155610c616661146100610061006100610061ee620000021c61006a6a610e610d6a,0x836a,0x789c6bce0200017200ee"
}

for  i=1,key.amount do
	if key.acc_need then 
		local str_acc=str_acc or ""
		for j,v in ipairs(account) do
			if j == 3 then v = string.format("%s%d",v,i)  end					--给账号加对应数字
			if  type(v)=="string" then v= string.format("\34%s\34",v) end 		--字符串加引号
			str_acc = str_acc .. "," .. v
		end
		file:write(string.format("insert into %s.account values(%s);\10",login_database,string.sub(str_acc,2)))
	end
	if key.role_need then
		--grole[1]=grole[1]+1 
		local str_role = str_role or ""
		for j,v in ipairs(grole) do
			if j==1 then v=v+i end												--roleid增加	
			if j==2 then v =string.format("%s%d",v,i) end 						--给角色名加对应数字
			if j==4 then v=string.format("%s%d",v,i) end 						--给账号加对应数字
			if j==6 then v= math.random(v) end 									--随机头像
			if j==11 then v = math.random(200,v) end
			if  type(v)=="string" then v= string.format("\34%s\34",v) end 		--字符串加引号
			str_role=str_role .. "," .. v
 		end 
 		file:write(string.format("insert into %s.grole values(%s);\10",game_database,string.sub(str_role,2)))
 		file:write(string.format("insert into %s.grname values(%d,\34%s%d\34);\10",game_database,grole[1]+i,grole[2],i))
 		file:write(string.format("insert into %s.gfighters values(%d,%s);\10",game_database,grole[1]+i,gfighters.context))
 	end
 	if key.family_need or 1 then  --改变racc的值
 	account[1]=account[1]+1;grole[3]=((key.severid+1)*1000000)*100000+account[1]	--改表值的败笔
	end
end
if key.family_need and key.family_need>0 and key.family_member <21 then 			--参数检查
	for i=1,key.family_need do
		local str_fm = str_fm or ""
		for j,v in ipairs(gfamily) do
			if j == 1 then v = v+i+100000 end									--公会编号
			if j == 2 then v = string.format("%s%d",v,i) end					--公会名编号
			if  type(v)=="string" then v= string.format("\34%s\34",v) end 		--字符串加引号
			str_fm = str_fm .."," .. v
		end
		file:write(string.format("insert into %s.gfamily values(%s);\10",game_database,string.sub(str_fm,2)))
		file:write(string.format("insert into %s.gFName values(%d,\34%s%d\34);\10",game_database,gfamily[1]+100000+i,gfamily[2],i))
	end
	--grole[1]=(key.severid+1)*1000000			--重新把grole变成初始值，败笔，以后不要随便改表的值了
	for i=1,key.family_member*key.family_need do
		if 100+i <=key.amount then
			if i<5 then title=2 else title =0 end  
			file:write(string.format("insert into %s.gFMember values(%d,%d,%d,0);\10",game_database,grole[1]+100+i,gfamily[1]+100000+(i-1)%key.family_need+1,title))
			file:write(string.format("update %s.grole set level=80,exp=2251941,familyid=%d,familyname=\34%s%d\34 where roleid=%d;\10",game_database,gfamily[1]+100000+(i-1)%key.family_need+1,gfamily[2],(i-1)%key.family_need+1,grole[1]+100+i))
		end
	end

end
os.execute("open ".. os.getenv("HOME") .. "/Desktop/seer.sql")