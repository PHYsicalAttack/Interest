----Time:   2017-3-28
----File:   SeerActivityAnalyzer.lua
----Author: Fallever    
----隐藏BUG记录: 1.累计登陆和召回有个隐藏bug:如果后面再在这个配置里新增了其他类型的活动就会出现错误。
local Project = os.getenv("HOME") .. "/Desktop/Project"              --项目位置
local Master_Ver = false                                              --是否使用主线,在更新版本时使用true.
local StartDate = "2017.5.22"                                             --解析开始时间在该时间以后的活动,"all"|"auto"|2017.3.28"(all是解析所有活动,有开服活动的话用all,需要名称为all,auto的话自动会设定为下周一)
IsDigimon = false                                                    --数码宝贝专用:是否是数码宝贝
local DigimonBranchVer = "001"                                       --数码宝贝专用:数码宝贝支线版本文件夹名字
---------以下内容无需修改-------------
DEBUG = "release"                                                         -- convertToTable |release | showrepeated |debug
local comfunc = require("comlib.comfunc")
local config_path = Project .. "/Trunk/client/src/?.lua"
local config_ger_path = Project .. "/Trunk/client/src/config/ger/?.lua"
local config_item_path = Project .. "/Trunk/client/src/config/item/?.lua"
if not Master_Ver then
    local replace_branch,branch_ver
    if IsDigimon then 
        replace_branch = "branches"
        branch_ver = DigimonBranchVer
    else
        replace_branch = "branches/client"
        branch_ver = comfunc.getTableMaxinum(comfunc.strSplit(comfunc.getAllOfDIR(Project .. "/".. replace_branch)))
    end
    config_path,_ = string.gsub(config_path,"Trunk",replace_branch .. "/" .. branch_ver)
    config_ger_path,_ = string.gsub(config_ger_path,"Trunk",replace_branch .. "/" .. branch_ver)
    config_item_path,_ = string.gsub(config_item_path,"Trunk",replace_branch .. "/" .. branch_ver)
end
package.path = table.concat({package.path,config_path,config_ger_path,config_item_path},";")
-- 数码宝贝神秘代码/(ㄒoㄒ)/~~
if IsDigimon then
    require ("comlib.digimon")
    require ("config.config_enum")
    for k,v in pairs(cc.exports) do 
        _G[k] = v
    end
end
local analfun = require("comlib.analfun")
-- 普通活动,只解析混服活动,对所有都检查活动id是否重复/(ㄒoㄒ)/~~
local function getModDir(mod)
    if mod =="all" or mod =="auto" then
        local nowtime = os.date("*t",os.time())
        local add_days  = 7-nowtime.wday
        local nextwekdate = os.date("*t",os.time({year = nowtime.year,month = nowtime.month,day = nowtime.day + add_days+2}))
        return string.format("%s.%s.%s",nextwekdate.year,nextwekdate.month,nextwekdate.day)
    else
        return mod
    end
end
local weekdir = comfunc.getItemByName(comfunc.strSplit(comfunc.getAllOfDIR("config")),getModDir(StartDate))     --本周活动文件夹名称
if not weekdir then
     return print("!!! 未找到本周活动文件,请检查StartDate是否正确 !!!")
end
local weekdetail = comfunc.strSplit(comfunc.getAllOfDIR("config/" .. weekdir))                                  --记录本周活动文件内容的表

if DEBUG == "release" then                                                                                  
    local activity_app = comfunc.convertToTable("config/".. weekdir .."/" .. (comfunc.getItemByName(weekdetail,"Activity_APP")) .. "/data_activity.config")
    if analfun:IsIDRepeated(activity_app) or not activity_app then 
      return  print("!!! APP活动重复了或不存在 !!!") 
     end
    local activity_4399 = comfunc.convertToTable("config/".. weekdir .."/" .. (comfunc.getItemByName(weekdetail,"Activity_4399")) .. "/data_activity.config")
    if analfun:IsIDRepeated(activity_4399) or not activity_4399 then 
        return  print("!!! 4399活动重复了或不存在 !!!") 
    end
end
local activity = comfunc.convertToTable("config/".. weekdir .."/" .. (comfunc.getItemByName(weekdetail,"Activity_混服")) .. "/data_activity.config")
if analfun:IsIDRepeated(activity) or not activity then print("!!! 混服活动重复了或不存在 !!!") return end
--分析普通活动
os.remove("config/analyzed_activity.lua")
local analfile = io.open("config/analyzed_activity.lua","w")                                                                       
for k,sub_activity in pairs(analfun:getActivity(activity,StartDate)) do                                          --传入activity_app|activity_4399会解析对应活动
    local able_activity_func = sub_activity[4]                                                                   --这儿没有判断是活动类型字段是否有错
    local answer="!!该活动类型字段有误或未定义!!\10"
    if able_activity_func then
        answer = analfun[able_activity_func](analfun,sub_activity)
    end
    analfile:write(string.format("%d.%s\10",sub_activity[2],answer))
end
--数码宝贝只解析普通活动
if IsDigimon then os.execute("open config/analyzed_activity.lua") return print("数码宝贝活动解析完毕!") end 
--登陆和召回活动
if comfunc.getItemByName(weekdetail,"data_ghandrwd") then
    local ghandrwd = comfunc.convertToTable("config/".. weekdir .."/" .. (comfunc.getItemByName(weekdetail,"data_ghandrwd")) .. "/data_ghandrwd.config")
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
    --登陆福利,由于在一个文件里面,所以就会同时解析出来
    analfile:write(string.format("%s",analfun:login(login)))
    analfile:write(string.format("%s",analfun:back(back)))
end
--转盘活动
if comfunc.getItemByName(weekdetail,"data_turntable") then
    local turntable = comfunc.convertToTable("config/".. weekdir .."/" .. (comfunc.getItemByName(weekdetail,"data_turntable")) .. "/data_turntable.config")
    analfile:write(string.format("%s",analfun:turntable(turntable)))
end
--许愿池活动
if comfunc.getItemByName(weekdetail,"data_wish") then 
    local wish = comfunc.convertToTable("config/" .. weekdir .. "/" .. (comfunc.getItemByName(weekdetail,"data_wish")) .. "/data_wish.config")
    analfile:write(string.format("%s",analfun:wish(wish)))
end
analfile:close()
os.execute("open config/analyzed_activity.lua")






