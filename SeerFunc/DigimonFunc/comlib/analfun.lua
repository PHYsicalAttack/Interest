----Time:	2016-3-17
----File:	analfun.lua
----Author: Fallever
----Desc:	重写活动分析函数，封装代码减少重复代码数量
----隐藏bug记录: 
-----------------------------------
local analfun={}
analfun.forever =nil				--永久活动时间nil标识
analfun.undefined =nil				--刷新字段/其他条件 字段标识	
analfun.act_name = "活动名称: "
analfun.act_type = "类型: "
analfun.act_time = "活动时间: "
analfun.act_refresh = "每日刷新: "
analfun.other_con = "其他条件: "
analfun.act_lvl = "优先级: "
analfun.act_desc = "活动描述: "
--加载客户端道具/精灵配置
local ger,item 
if IsDigimon then 
	ger = require("config_gerTemplate")
	item = require("config_moneyTemplate")
else
	ger= require("config_general")
	item = require("config_itemTemplate")
end
--抓取当前时间开启的活动
function analfun:getActivity(activity,mode)
    if mode == "all" then 
        return activity
    end
    local start_date = {}
    if startdate =="auto" then  
        local nowtime = os.date("*t",os.date)
        local add_days  = 7-nowtime.wday
        start_date = {year = nowtime.year,month = nowtime.month,day = nowtime.day + add_days+2}
    else
        local y,m,d = string.match(mode,"(%d+)%.(%d+)%.(%d+)")
        start_date = {year = tonumber(y),month = tonumber(m),day = tonumber(d)}
    end
    local openactivity = {}
    for k,v in pairs(activity) do
    	local act_time = v[6]
    	if act_time then 
	        local open_date = act_time[1][1]                --{y,m,d} or day
	        if type(open_date) == "table" then
	            local y,m,d = table.unpack(open_date)
	            if os.time({year = y,month = m,day = d}) >= os.time(start_date) then
	                table.insert(openactivity,v)
	            end
	        end
	    end
    end
    return openactivity
end
--检查活动id是否重复
function analfun:IsIDRepeated(act)
	local t = {}
	for k,v in pairs(act) do 
		if not t[v[2]] then
			t[v[2]] = true
		else
			if DEBUG =="showrepeated" then print(v[2],t[v[2]]) end
			return true
		end
	end
	return false
end
--解析函数:奖励
function analfun:reward(allrwd)
	local rwd_t = allrwd
	function poorseer(t)
		local reward_item=""
		local reward_ger=""
		local reward_equ=""
		local reward_last=""
		for i=1,#t[2] do 															--解析货币表
			if #t[2] <= 0 then reward_item="没有道具"  break end  					--没有配置奖励
			local item_id , item_num = t[2][i][1] ,t[2][i][2]
			if item[item_id] then	         
				if item_id==2 and item_num <10000 then
					reward_item=reward_item .. "Warning:配置中金币(".. item_num.. ")不足1W!请核对!"
				elseif item_id == 2 and item_num % 10000 ==0 then
					reward_item = reward_item ..item[item_id].Name .. "*" .. math.floor(item_num/10000) .."万;"
				else
					reward_item =reward_item .. item[item_id].Name .. "*" .. item_num .."个;"
				end
			else
				reward_item =string.format("Item[%d] doesn't exist!",item_id)
			end
		end
		for i=1,#t[3] do 															--解析精灵表
			if #t[3] <= 0 then reward_ger="没有精灵"  break end  					--没有配置奖励
			local ger_id,ger_num,ger_level,ger_rank,ger_evo = t[3][i][1],t[3][i][2],t[3][i][3],t[3][i][4],t[3][i][5]
			--print(ger_id,ger_num)
			if ger_level == nil then 
				reward_ger =reward_ger .. ger[ger_id].gername .. "*" .. ger_num .."个;"
			else
				reward_ger =reward_ger .. ger[ger_id].gername .. ger_level .. "级" ..ger_rank .."阶" ..ger_evo+1 .. "态" .. "*" .. ger_num .."个;"
			end
		end
		for i=1,#t[4] do  															--解析装备表
			if #t[4] <= 0 then reward_item="没有装备"  break end  					--没有配置奖励
			local equ_id , equ_num = t[4][i][1] ,t[4][i][2]
			--print(equ_id,equ_num)
			reward_equ =reward_equ .. item[equ_id].Name .. "*" .. equ_num .."个;"
		end
		reward_last = reward_item .. reward_ger .. reward_equ
		if #t[5]~= 0 then  reward_last="错误!!非法配置" end 							--最后一个配置无效
		return reward_last
	end
	function richdigimon(ttt)
		local t_strrwd = {}
		for i,subrwd in ipairs(ttt) do
			local id,num = table.unpack(subrwd)
			local rwd = item[id] or ger[id]
			table.insert(t_strrwd,(rwd.name or rwd.names[1]) .. "*" .. num)
		end
		return table.concat(t_strrwd,";")

	end 
	if IsDigimon then 
		return richdigimon(rwd_t)
	else 
		return poorseer(rwd_t)
	end
end

--解析函数:活动时间
function analfun:time(t)
	function f(x)
		hour,min,sec=table.unpack(x)
		return hour ..":" .. min ..":" .. sec
	end
	function g(x)
		year,mon,day=table.unpack(x)
		return year .."年" .. mon .."月" .. day .. "日"
	end
	if t==analfun.forever then
		act_time = "永久"								--永久活动
	else
		act_start,act_end=t[1],t[2]
		if type(act_start[1]) =="number" and type(act_end[1]) =="number" then						--相对时间
			act_time = "开服第" .. act_start[1]+1 .. "天" .. f(act_start[2]) .. " ~ 第" .. act_end[1]+1 .. "天" .. f(act_end[2])
			--开服第x天~开服第y天
		elseif type(act_start[1]) =="table" and type(act_end[1]) =="table" then						--绝对时间
			act_time = g(act_start[1]) .. f(act_start[2]) .. " ~ " .. g(act_end[1]) ..f(act_end[2])
		else
			act_time="时间有误!"
		end
	end
	return act_time,f,g
end
--字符串处理函数,每多一个汉字s.len()比utf.len()多2,返回字符串中英文个数
local function str_utf8(str)
	return (str:len() - utf8.len(str))/2,utf8.len(str) -(str:len() - utf8.len(str))/2
end
--将字符串处理成一个大约long个汉字长的字符串,如果超过long则直接返回
local function str_cnlong(str,long)
		local size_diff = 0.6 				--一个其他字符大约是 size_diff倍的汉字
		local cn_num,en_num = str_utf8(str)
		local str_len_in_cn = cn_num + 0.6*en_num
		if  str_len_in_cn >= long then
			return str
		end
		local need_len = long - str_len_in_cn
		str = str .. utf8.char(12288):rep(need_len//1)
		if need_len % 1 >=0.5 then 
			str = str .. string.char(32)
		end
		return str
end

local function str_cnlong2(str,samplestr)
		local cn_num,en_num = str_utf8(samplestr)
		local has_cn_num,has_en_num = str_utf8(str)
		return str .. utf8.char(12288):rep(cn_num - has_cn_num)
	-- body
end
--解析函数:通用,将活动名称、活动类型、活动时间、活动刷新时间、活动条件、活动优先级、活动描述解析封装为一个函数
function analfun:common(t)
	local common ={}
	local common_name,_=string.gsub(t[3],"\\n"," ")  --活动名字(替换掉名字中的换行，更好显示一点)
	common.name=common_name
	--活动类型
	local sc_name=
	{
		["pay_one"] = "单笔充值",
		["pay_acc"] = "累计充值",
		["pay_day"] = "充值签到",
		["on_sale"] = "限时打折",
		["consume"] = "消耗有礼",
		["exchange"] ="超值兑换",
		["continue"] ="连续充值",
		["grow_up"] = "成长基金",
		["discount"] = "折扣礼包",
		["level_rwd"] ="等级礼包",
		["level_run"] ="冲击活动",
		["first_pay"] = "首冲奖励",
		["power_rwd"] = "战力礼包",
		["display"] ="展示活动",
		["nono_gift"] = "nono礼包",
		["on_uprank"] = "限时进阶",
		["second_pay"] = "续充奖励",		
		["cultivate"] = "精灵培养",	
		["active"] = "活跃活动",				
		["select"] = "选择领奖",	
		----- 数码宝贝活动字段  -----
		--["month_pay"] = "每月奖励",		

	}	
	----活动类型			
	common.type = (sc_name[t[4]] or "类型错误")  .. "(" .. t[4] ..")"	
    ----活动时间
    function f(x)
		hour,min,sec=table.unpack(x)
		return hour ..":" .. min ..":" .. sec
	end
	function g(x)
		year,mon,day=table.unpack(x)
		return year .."年" .. mon .."月" .. day .. "日"
	end
 	if t[6] == analfun.forever then 
 		common.time = "永久"
 	else
 		act_start,act_end = t[6][1],t[6][2]
 		if type(act_start[1]) =="number" and type(act_end[1]) =="number" then						--相对时间
			common.time = "开服第" .. act_start[1]+1 .. "天" .. f(act_start[2]) .. " ~ 第" .. act_end[1]+1 .. "天" .. f(act_end[2])
			--开服第x天~开服第y天
		elseif type(act_start[1]) =="table" and type(act_end[1]) =="table" then						--绝对时间
			common.time = g(act_start[1]) .. f(act_start[2]) .. " ~ " .. g(act_end[1]) ..f(act_end[2])
		else
			common.time="时间有误!"
		end
	end
	--刷新时间
	if t[7] == analfun.undefined then 
		common.refresh = "不重置"
	elseif math.max(table.unpack(t[7]))==0 then 
		common.refresh = "每日重置"
	else
		common.refresh = "重置时间不是0:0:0"
	end
	--其他条件
	if t[4]=="pay_day" then
		common.other_con = "最低充值钻石:" .. t[9]
	elseif t[4]== "grow_up" then
		if IsDigimon then 
			common.other_con = "VIP等级:" .. t[9][1] .. ";钻石:" .. t[9][2]
		else
			local temp_time,temp_nono,temp_price=table.unpack(t[9])
		    local temp_day,temp_hour=table.unpack(temp_time)
		    local temp_hour=f(temp_hour)
			common.other_con = "截止时间:开服第" .. temp_day+1 .."天" .. temp_hour .. ";最低Nono:" .. temp_nono.. ";购买消耗:" .. temp_price .."钻;"
		end
	elseif t[4] == "discount" then
		for i=1,#t[9] do
			common.other_con = common.other_con or ""
			local nono_level,nono_dis = table.unpack(t[9][i])
			common.other_con = string.format("%sNono等级为%d级,折扣为%2.1f折;",common.other_con,nono_level,nono_dis/10)
		end
	elseif t[4] == "continue" then
		common.other_con = "每天至少充值:" .. t[9] .."钻石"
	elseif t[4] =="nono_gift" then
		common.other_con = "Nono等级:" .. t[9] .. "级以上"
	elseif t[4] == "on_uprank" then
		common.other_con = "精灵星级:" ..t[9] .. "星以上"
    elseif t[4] == "select" then
    	common.other_con = "充值档位:" .. t[9]
    else 
    	common.other_con = "无其他条件"
    end
    --活动描述
 	if t[4] == "display" then
 		common.desc = "****展示活动,富文本进入游戏里面查看****"
 	else
 		common.desc  = t[8]
 	end
	local result = string.format("%s\n%s%s (%s)--%-s\n%s%s\n%s%s\n%s%s\n",common.type,analfun.act_name,common.name,common.refresh,t[11],analfun.act_time,common.time,analfun.other_con,common.other_con,analfun.act_desc,common.desc)
	return result
end
--通用子活动解析1
function analfun:commonfun1(t)
	local act_draw=""
	for i=1,#t[10] do
		local draw=t[10][i]
		local _,draw_id,draw_desc,draw_times,draw_con,draw_reward= table.unpack(draw)
		local real_reward = analfun:reward(draw_reward)
		act_draw= act_draw .. string.format("%d%-7s%-20s%-12d%-21d%s\10",draw_id,".",draw_desc,draw_times,draw_con,real_reward)
	end
	return act_draw
end
--通用子活动解析2,活动条件是表的用这个函数,改成方便扩展的,通过活动类型来判断,目前特殊处理的是: active 、cultivate
function  analfun:commonfun2( t )
	local act_draw =""
	--特殊处理兑换活动条件字符串,为了显示对齐,使用见这个函数的最后(已经看不懂了,但是不要删看起来和下面重复的代码)
	local longest_str = ""
	if t[4] == "exchange" then
		for i = 1,#t[10] do
			local con_str = ""
			for i,v in ipairs(t[10][i][5]) do 
				local item_id,item_num = table.unpack(v)
				con_str = con_str .. string.format("%s:%s",item[item_id].Name or item[item_id].name,item_num)
			end
			if longest_str:len() < con_str:len() then
				longest_str = con_str
			end
		end
	end
	for i=1,#t[10] do
		local draw=t[10][i]
		local _,draw_id,draw_desc,draw_times,draw_con,draw_reward= table.unpack(draw)
		local real_reward = analfun:reward(draw_reward)
		if t[4] == "active" then 
			local misson = {
								"星际争霸战斗次数"
								,"星际争霸胜利次数"
								,"参与关卡副本次数"
								,"星际探险探索次数"
								,"竞技场的战斗次数"
								,"钻石抽卡抽卡次数"
								,"黑暗袭击战斗次数"
								,"装备突破突破次数"
								,"镜像试炼挑战次数"
								,"宝藏遗迹挑战次数"
								,"大乱斗的挑战次数"
								,"金币炼金炼金次数"
								,"精灵进阶进阶次数"
								,"精灵进化进化次数"
								,"巅峰之战参与次数"
								,"巅峰之战胜利次数"
							} 
			local misson_type,misson_times= table.unpack(draw_con)
			draw_con = string.format("%s:%d次",misson[misson_type],misson_times)
			--描述修改:处理成显示长度不小于8个汉字的字符串(对齐)
			draw_desc = str_cnlong(draw_desc,8) 
			act_draw= act_draw .. string.format("%d%-10s%-s%5d%-12s%-42s%s\10",draw_id,".",draw_desc,draw_times,string.char(32),draw_con,real_reward)
		elseif t[4] == "cultivate" then
			local ger_id,ger_level,ger_rank,ger_state = table.unpack(draw_con)
			draw_con = string.format("%s%s级%s阶%s态",ger[ger_id].gername,ger_level,ger_rank,ger_state)
			act_draw= act_draw .. string.format("%d%-7s%-21s%-10d%-30s%s\10",draw_id,".",draw_desc,draw_times,draw_con,real_reward)
		else
			local draw_con_son = ""
			for i,v in ipairs(draw_con) do 
				local item_id,item_num = table.unpack(v)
				draw_con_son = draw_con_son .. string.format("%s:%s",item[item_id].Name or item[item_id].name,item_num)
			end
			if t[4] == "exchange" then draw_con_son = str_cnlong2(draw_con_son,longest_str) end 				--exchange条件对齐输出
			act_draw= act_draw .. string.format("%d%-7s%-21s%-10d%-24s%-s\10",draw_id,".",draw_desc,draw_times,draw_con_son,real_reward)
		end
	end
	return act_draw
end
--解析函数:pay_one
function analfun:pay_one(t)
	local common = self:common(t)
	local pay_one = self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","充值档位","奖励")
	return common .. title.. pay_one
end
--解析函数:pay_acc
function analfun:pay_acc(t)
	local common = self:common(t)
	local pay_acc = self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","累计充值","奖励")
	return common .. title .. pay_acc
end
--解析函数:pay_day
function analfun:pay_day(t)
	local common = self:common(t)
	local pay_day =self:commonfun1(t)
	local check_days={}
	for i=1,#t[10] do
		check_days[i]= t[10][i][5]
	end
	for i,v in ipairs(check_days) do
		if check_days[i] ~= i then pay_day="Warning:签到天数不是从1开始序数增加的!\10" break end
	end
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","签到天数","奖励")
	return common .. title .. pay_day
end
--解析函数:on_sale
function analfun:on_sale(t)
	local common = self:common(t)
	local on_sale = self:commonfun2(t)
	local title = string.format("%-10s%-21s%-18s%-30s%s\10","子ID","子描述","领取次数","消耗货币","奖励")
	return common .. title .. on_sale
end
--解析函数:consume
function analfun:consume(t)
	local common = self:common(t)
	local consume =self:commonfun2(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","消耗货币","奖励")
	return common .. title ..consume
end
--解析函数:exchange
function analfun:exchange( t )
	local common =self:common(t)
	local exchange = self:commonfun2(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","消耗货币","奖励")
	return common .. title .. exchange
end
--解析函数:grow_up
function analfun:grow_up(t)	
	local common = self:common(t)
	local grow_up = self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","领取等级","奖励")
	return common .. title ..grow_up
end
--解析函数:discount
function analfun:discount( t )
	local common = self:common(t)
	local discount = self:commonfun2(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","道具原价","奖励")
	return common .. title .. discount
end
--解析函数:等级礼包
function  analfun:level_rwd( t )
	local common = self:common(t)
	local level_rwd = self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","领取等级","奖励")
	return common .. title .. level_rwd
end
--解析函数:冲级活动
function analfun:level_run( t )
	local common = self:common(t)
	local level_run = self:commonfun1(t)	
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","领取等级","奖励")	
	return common .. title .. level_run
end
--解析函数:首冲有奖
function analfun:first_pay( t )
	local common = self:common(t)
	local first_pay = self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","首冲次数","奖励")
	return common .. title .. first_pay
end
--解析函数:连续充值
function analfun:continue( t )
	local common = self:common(t)
	local continue = self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","连冲天数","奖励")
	return common .. title .. continue
end
--解析函数:战力礼包
function analfun:power_rwd( t )
	local common =self:common(t)
	local power_rwd = self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","战力要求","奖励")
	return common .. title .. power_rwd
end
--解析函数:普通展示
function analfun:display( t )
	local common= self:common(t)
	local display = "***********************************************\10**********展示活动,富文本进入游戏里面查看!*********\10***********************************************\10"
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","xxxxx","奖励")
	return common .. title .. display
end
--解析函数:nono_gift
function analfun:nono_gift( t )
	local common = self:common(t)
	local nono_gift = self:commonfun2(t)
	local title = string.format("%-10s%-18s%-18s%-30s%s\10","子ID","子描述","领取次数","购买消耗","奖励")
	return common .. title .. nono_gift	
end
--解析函数:on_uprank
function analfun:on_uprank( t )
	local common = self:common(t)
	local on_uprank =self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","进阶要求","奖励")
	return common .. title .. on_uprank
end
--解析函数:second_pay
function analfun:second_pay( t )
	local common = self:common(t)
	local second_pay = self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","续充次数","奖励")
	return common .. title ..second_pay
end
--解析函数:cultivate
function analfun:cultivate( t )
	local common = self:common(t)
	local cultivate = self:commonfun2(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","精灵要求","奖励")
	return common .. title ..cultivate		
end
--解析函数:active
function analfun:active( t )
	local common =self:common(t)
	local active = self:commonfun2(t) --"%d%-7s%-27s%-10d%-42s%s\10
	local title = string.format("%-13s%-18s%-24s%-28s%s\10","子ID","子描述","领取次数","活动要求","奖励")
	return common .. title .. active
end
--解析函数:select
function analfun:select( t )
	local common = self:common(t)
	local selectt = self:commonfun1(t)
	local title = string.format("%-10s%-16s%-18s%-30s%s\10","子ID","子描述","领取次数","充值档位","奖励")
	return common .. title .. selectt
end

--解析函数:登陆福利
function analfun:login(t)
	local id = "活动ID: " .. t[1][2]
	local time = "活动时间: " .. analfun:time(t[2][2])
	local draw=""
	local check_days ={}
	for i=5,#t do
		local day = t[i][1][2]
		check_days[i-4]=day
		local reward =analfun:reward(t[i][2]) 
		draw= string.format("%s累计登陆%d天:  %s\10",draw,day,reward)
	end
	for i,v in ipairs(check_days) do
		if i~= v then draw="Warning:累计天数不是从1开始连续的!!\10" break end
	end
	local login = string.format("%s\10%s\10%s\10%s\10","###登陆福利活动###",id,time,draw)
	return login
end

--解析函数:召回活动
function analfun:back( t )
	local id = "活动ID: " .. t[1][2]
	local time = "活动时间: " .. analfun:time(t[2][2])
	local condition = "召回条件: " .."离线时长:" ..t[5][2][1] .."天;最低等级:" .. t[5][2][2] .."级;" 
	local draw=""
	local check_days ={}
	for i=6,#t do
		local day = t[i][1][2]
		check_days[i-5]=day
		local reward =analfun:reward(t[i][2]) 
		draw= string.format("%s召回第%d天:  %s\10",draw,day,reward)
	end
	for i,v in ipairs(check_days) do
		if i~= v then draw="Warning:召回天数不是从1开始连续的!!\10" break end
	end
	local back = string.format("%s\10%s\10%s\10%s\10%s\10","###召回福利活动###",id,time,condition,draw)
	return back
end

--解析函数:turntable
function analfun:turntable( t )
	local id = "活动ID: " .. t[1][2]
	local time = "活动时间: " .. analfun:time(t[2][2])
	local fixed_rwd={}						--固定奖励表
	local rand_rwd={}						--随机奖励表
	local fixed_str=""
	local rand_str=""
	local lucky_box_num = 4 				--保底宝箱数量=4,t[34]开始为保底宝箱
	local lucky_box={}
	local rank_num =7 						--排名档次
	local rank_rwd={}
	local rank_rwd_str=""
	
	--初始化16个格子,每个格子存放自己可以刷新的道具	
	local box = {}						
	for i = 1,16 do 
		box[i] ={}
	end
	--将每个library_id 中16格子的道具分别存入对应的box中
	for i,v in ipairs(t) do
		if v[1] and v[1][1]=="library_id" then 
			for box_id =1,16 do 
				table.insert(box[box_id],v[2][box_id][2][2])
			end
		end
	end
	--去重函数
	local function rmduplicate(t,index)
			local index = index or 1
			if index == #t then 
				return t
			end
			local check_str = analfun:reward(t[index])
			for i = index+1,#t do
				local target_str = analfun:reward(t[i])
				if check_str == target_str then 
					table.remove(t,index)
					return rmduplicate(t,index)
				end
			end
			return rmduplicate(t,index+1)
		end
	--排序函数
	--t = {{reward,{{1027,1}},{},{},{}},{reward,{{1027,1}},{},{},{}}}
	-- rwa = {reward,{{1027,1}},{},{},{}}
	local function sortbyid(rwda,rwdb)
			local rwda_index,rwda_num,rwdb_index,rwdb_num
			--reward结构中只要有1个有值，则按照其道具id和数量排序
			for i= 2,4 do
				if rwda[i][1] then
					rwda_index,rwda_num = table.unpack(rwda[i][1])
					break
				end
			end
			for i = 2,4 do 
				if rwdb[i][1] then
					rwdb_index,rwdb_num = table.unpack(rwdb[i][1])
					break
				end
			end
			--按照道具id从小到大,数量由小到大排序
			--return (rwda_index == rwdb_index) and (rwda_num < rwdb_num) or (rwda_index < rwdb_index)
			if rwda_index == rwdb_index then 
				return rwda_num < rwdb_num
			else
				return rwda_index < rwdb_index
			end
	end
	--对每个格子去重,按照是否是固定奖励或随机奖励放入不同的表
	for i = 1,16 do
		box[i] = rmduplicate(box[i])
		if #box[i] == 1 then 
			table.insert(fixed_rwd,box[i][1])
		else 
			for i,v in ipairs(box[i]) do
				table.insert(rand_rwd,v)
			end
		end
	end
	--再次对随机奖励表去重
	fixed_rwd = rmduplicate(fixed_rwd)
	rand_rwd = rmduplicate(rand_rwd)
	table.sort(fixed_rwd,sortbyid)
	table.sort(rand_rwd,sortbyid)
	--奖励表转化成字符串
	for i,v in ipairs(fixed_rwd) do
		fixed_str = fixed_str .. "\n" .. analfun:reward(v)
	end
	for i,v in ipairs(rand_rwd) do
		rand_str = rand_str .. "\n" .. analfun:reward(v)
	end
	--保底宝箱 {幸运值,reward表}
	for i=1,lucky_box_num do
		 table.insert(lucky_box,t[33+i][2])
	end 
	local luck_str=""
	for i,v in ipairs(lucky_box) do
		local luck,luck_rwd = table.unpack(v)
		luck_str=string.format("%s\n%s",luck_str,string.format("累计幸运值 %2d%-5s%s",luck,":",analfun:reward(luck_rwd)))
	end
	--排名奖励
	local _,rank= table.unpack(t[4])
	for i=1,rank_num do
		rank_rwd[i]={}
		table.insert(rank_rwd[i],t[4+i][1][2])
		table.insert(rank_rwd[i],t[4+i][2])
	end
	for i=1,rank_num do
		local start_num,end_num,rank_rwd_num =table.unpack(rank[i])
		local rank_rwd_id,rank_rwd_t = table.unpack(rank_rwd[i])
		local temp_str = string.format("第%d档名次:%-2d~%2d%s%s",rank_rwd_id,start_num,end_num,string.rep(" ",4),analfun:reward(rank_rwd_t))
		rank_rwd_str = rank_rwd_str .."\n" ..temp_str
		if rank_rwd_num ~= rank_rwd_id then
			rank_rwd_str="排名信息和排名档位不一致!~"
			break
		end
	end
	local turntable = string.format("%s\n%s\n%s\n%s\n%s%s\n%s%s\n%s%s\n%s%s\n","###转盘活动###",id,time,"###奖励仓库###",
		"----随机刷新道具----",rand_str,"----固定刷新道具----",fixed_str,"###幸运值宝箱###",luck_str,"###排名奖励###",rank_rwd_str)
	return turntable
end
return analfun







