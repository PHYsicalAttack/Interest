----Time:	2016-12-22
----File:	SeerActivityAnalyze.lua
----Author: Fallever	
----Desc:	只用修改Trunk_path,其他的只用修改start_actid
----修改备忘: 1.累计登陆和召回有个隐藏bug:如果后面再在这个配置里新增了其他类型的活动就会出现错误。
-----------------------------------
local Trunk_path=os.getenv("HOME") .. "/Desktop/Project"			
local branch_ver=false						--控制是否使用支线版本及支线版本号,字符串和svn支线文件夹名字一致,在版本更新时,改成false使用主线测试
--活动ID设置
local start_actid = 3052       				--想检测的活动开始ID必填
local end_actid = nil 						--可为nil或具体ID，默认nil，解析到最后一个活动;要测开服活动改成100000.
--登陆召回活动配置、转盘活动配置解析控制
local login_open = true  					--登陆福利活动解析开启控制
local back_open = true						--召回活动活动解析开启控制			
local turntable_open = true 				--转盘开启活动解析开启控制
local nian_open =false						--年兽开启控制,暂时没写

---------以下内容无需修改-------------
if type(Trunk_path)=="string" then
	Desktop_path=string.sub(Trunk_path,string.find(Trunk_path,".*Desktop"))
	SeerFunc_path=Desktop_path .. "/SeerFunc/"
	config_path = SeerFunc_path .."config/"
	if not branch_ver then
		real_Trunk=Trunk_path .. "/Trunk"
		config_ger_path=";"..real_Trunk .. "/client/src/config/ger/?.lua"
		config_item_path=";" ..real_Trunk .."/client/src/config/item/?.lua"
	else
		real_Trunk=Trunk_path .. "/branches/client/" .. branch_ver
		config_ger_path=";"..real_Trunk .. "/client/src/config/ger/?.lua"
		config_item_path=";" ..real_Trunk .."/client/src/config/item/?.lua"
	end
end
package.path=package.path .. ";" .. config_path .."?.lua" .. config_item_path .. config_ger_path
--加载客户端的道具和精灵配置，确认道具和精灵的版本与活动测试版本一致
local ger = require("config_general")
local item = require("config_itemTemplate")
local analfun = require("comlib.analfun")
--活动类型字段定义,当前总共有这些类型的活动
act_case={
	--活动类型字段,并用于data_activity.config的英文字段替换
	pay_one= [["pay_one"]],				--单笔充值
	pay_acc= [["pay_acc"]],				--累计充值
	pay_day= [["pay_day"]],				--充值签到
	on_sale= [["on_sale"]],				--限时打折
	consume= [["consume"]],				--消耗
	exchange= [["exchange"]],			--兑换
	continue= [["continue"]],			--连续充值
	grow_up= [["grow_up"]],				--成长基金
	discount= [["discount"]],			--折扣礼包
	level_rwd= [["level_rwd"]],			--等级礼包
	level_run= [["level_run"]],			--冲级活动
	first_pay= [["first_pay"]],			--首冲奖励
	power_rwd= [["power_rwd"]],			--战力礼包
	display= [["display"]],				--展示活动
	nono_gift= [["nono_gift"]],			--nono礼包
	on_uprank = [["on_uprank"]],		--限时进阶
	second_pay = [["second_pay"]],		--续充有礼
	cultivate = [["cultivate"]],		--精灵培养
	active = [["active"]],				--活跃活动
	select = [["select"]],				--选择充值
	activity_id = [["activity_id"]],	--登陆活动字段
	day  = [["day"]],
	back_id = [["back_id"]],			--召回活动字段
	back = [["back"]],
	library_id = [["library_id"]] 		--转盘活动字段
}
-- act_case 加入特殊字符索引 
act_case["%"] = "--"
act_case["\\"] = [[\\]]
act_case["["] = "{"
act_case["]"] = "}"

--活动配置导出为lua的表。
local file=io.open(config_path .. "data_activity.config")
local config_context = file:read("*a")
file:close()
local function reg_replace(str)
	str,_ = string.gsub(str,"({.-})%.","%1,")					--特殊处理:只替换erlang元表最后的.号
	str,_ = string.gsub(str,"(%d+)%%","%1percent")				--特殊处理下百分号,将描述中的百分号先变成特殊字,变回来。
	str,_ = string.gsub(str,"%p",act_case)						--标点符号替换
	str,_ = string.gsub(str,"percent","%%")						--特殊处理下百分号,将描述中的百分号先变成特殊字,变回来。
	str,_ = string.gsub(str,"[_%a]+",act_case)					--所有英文及数字加引号
	return str
end
os.remove(config_path .. "activity.lua")
local activity=io.open(config_path .. "activity.lua","a")
activity:write("activity_t={\10" .. reg_replace(config_context)  .. "\10}\10return activity_t")
activity:close()
--os.execute("open "..config_path .. "activity.lua")
local activity=require("config.activity")							--加载activity为lua模块
--os.remove(config_path .. "activity.lua")
--打开分析文件
os.remove(config_path .. "analyzed_activity.lua")
local analfile=io.open(config_path .. "analyzed_activity.lua","a")
--分析结果
if not end_actid then end_actid=activity_t[#activity_t][2] end 		-- 如果没有定义endid则将endid设定为最后一个活动的id
--检查id重复
local check_t = {}
for i,v in ipairs(activity_t) do
	if check_t[v[2]] then
		print("!!!要死了!活动ID重复了!!!")
		return
	else
		check_t[v[2]] = true
	end
	if v[2] > start_actid -1 and v[2] <end_actid+1 then
		local able_activity_func = activity_t[i][4]					--这儿没有判断是活动类型字段是否有错
		local answer="!!该活动类型字段有误或未定义!!\10"
		if able_activity_func then
			answer = analfun[able_activity_func](analfun,activity_t[i])
		end
		analfile:write(string.format("%d.%s\10",activity_t[i][2],answer))
	end
end
--登陆福利活动和召回活动
if (login_open or back_open) and os.rename(config_path .. "data_ghandrwd.config",config_path .. "data_ghandrwd.config") then 
	local file = io.open(config_path .. "data_ghandrwd.config")
	local config_context = file:read("*a")
	file:close()
	os.remove(config_path .. "ghandrwd.lua")
	local ghandrwd = io.open(config_path .. "ghandrwd.lua","a")
	ghandrwd:write("ghandrwd_t={\10" .. reg_replace(config_context) .. "\10}\10return ghandrwd_t")
	ghandrwd:close()
	--os.execute("open " .. config_path .. "ghandrwd.lua")
	local ghandrwd = require("config.ghandrwd")
	os.remove(config_path .. "ghandrwd.lua")
	--处理登陆活动，将其重新存入表中
	local login,back,key ={},{},0
	for i,v in ipairs(ghandrwd) do
		if v[1] == "activity_id" then
			key=1
		elseif v[1] == "back_id" then
			key=2
		end
		if key ==1 then
			table.insert(login,v)
		elseif key==2 then
			table.insert(back,v)
		end
	end
	--登陆福利
	if login_open then	analfile:write(string.format("%s",analfun:login(login))) end
	if back_open then	analfile:write(string.format("%s",analfun:back(back))) end
end

--转盘活动
if turntable_open and os.rename(config_path .. "data_turntable.config",config_path .. "data_turntable.config")then
	local file=io.open(config_path .. "data_turntable.config")
	local config_context = file:read("*a")
	file:close()
	os.remove(config_path .. "turntable.lua")
	local turntable = io.open(config_path .. "turntable.lua","a")
	turntable:write("turntable_t={\10" .. reg_replace(config_context) .. "\10}\10return turntable_t")
	turntable:close()
	--os.execute("open " .. config_path .. "turntable.lua")
	local turntable = require("config.turntable")
	--os.remove(config_path .. "turntable.lua")
	analfile:write(string.format("%s",analfun:turntable(turntable)))
end
analfile:close()
os.execute("open " .. config_path .. "analyzed_activity.lua")
--分析结果写出完毕
