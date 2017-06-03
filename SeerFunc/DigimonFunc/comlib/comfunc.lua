local comfunc = {}

--返回脚本运行cwd
function  comfunc.getCWD()
    return string.sub(io.popen("pwd"):read("*a"),1,-2)
end

--返回当前目录|某目录下所有内容
function comfunc.getAllOfDIR(path)
    if not path then 
        return string.sub(io.popen("ls"):read("*a"),1,-2)
    end
    local command = "cd " .. path .."\nls"
    return string.sub(io.popen(command):read("*a"),1,-2) 
end
--切分字符串
function  comfunc.strSplit(str,split)
    local  split = split or "\n"
    local str = str .. split
    local res = {}
    for w in string.gmatch(str,"(.-)"..split) do 
        table.insert(res,w)
    end
    return res 
end
--返回目录下匹配当前名字的文件夹|文件
function comfunc.getItemByName(tabledir,findname)
    table.sort( tabledir, function (a,b)
        return a>b
    end )
    for i,v in ipairs(tabledir) do 
        if string.find(v,findname) then
            return v
        end
    end
end

--返回表里最大值
function comfunc.getTableMaxinum(t)
    local maxvalue = t[1]
    for i,v in ipairs(t) do
        if v> maxvalue then
            maxvalue  = v
        end
    end
    return maxvalue
end
--合并为一个路径
function comfunc.joinPath( ...)
   local arg = { ...}
   return table.concat( arg,"")
end
--读取一个通用的config配置,返回一个table
function comfunc.convertToTable2(filename)
    local configfile = io.open(filename)
    if not configfile then 
        return print(filename .. "not exist")
    end
    local configcontext  = configfile:read("*a")
    local act_case = 
    {
            --配置特殊字符
        ["%"] = "--",
        ["\\"] = [[\\]],
        ["["] = "{",
        ["]"] = "}" 
    }
    local function reg_replace(str)
        str,_ = string.gsub(str,"({.-})%.","%1,")                   --特殊处理:只替换erlang元表最后的.号
        str,_ = string.gsub(str,"%p",act_case)                      --标点符号替换
        str,_ = string.gsub(str,"[_%a]+","\"%0\"")                  --字段加引号
        return str
    end
    if DEBUG == "convertToTable" then 
        print(reg_replace(configcontext))
    end
    return load( "t = {" .. reg_replace(configcontext) .. "} return t")()
end






--读取一个通用的config配置,返回一个table
function comfunc.convertToTable(filename)
    local configfile = io.open(filename)
    if not configfile then 
        return print(filename .. "not exist")
    end
    local configcontext  = configfile:read("*a")
    local act_case =
    {
        --活动类型字段,并用于data_activity.config的英文字段替换
        pay_one= [["pay_one"]],             --单笔充值
        pay_acc= [["pay_acc"]],             --累计充值
        pay_day= [["pay_day"]],             --充值签到
        on_sale= [["on_sale"]],             --限时打折
        consume= [["consume"]],             --消耗
        exchange= [["exchange"]],           --兑换
        continue= [["continue"]],           --连续充值
        grow_up= [["grow_up"]],             --成长基金
        discount= [["discount"]],           --折扣礼包
        level_rwd= [["level_rwd"]],         --等级礼包
        level_run= [["level_run"]],         --冲级活动
        first_pay= [["first_pay"]],         --首冲奖励
        power_rwd= [["power_rwd"]],         --战力礼包
        display= [["display"]],             --展示活动
        nono_gift= [["nono_gift"]],         --nono礼包
        on_uprank = [["on_uprank"]],        --限时进阶
        second_pay = [["second_pay"]],      --续充有礼
        cultivate = [["cultivate"]],        --精灵培养
        active = [["active"]],              --活跃活动
        select = [["select"]],              --选择充值
        activity_id = [["activity_id"]],    --登陆活动字段
        day  = [["day"]],
        back_id = [["back_id"]],            --召回活动字段
        back = [["back"]],
        library_id = [["library_id"]],      --转盘活动字段
       -- month_pay = [["month_pay"]],        --数码宝贝活动活动月
       --配置特殊字符
        ["%"] = "--",
        ["\\"] = [[\\]],
        ["["] = "{",
        ["]"] = "}" 
    }
    local function reg_replace(str)
        str,_ = string.gsub(str,"({.-})%.","%1,")                   --特殊处理:只替换erlang元表最后的.号
        str,_ = string.gsub(str,"(%d+)%%","%1percent")              --特殊处理下百分号,将描述中的百分号先变成特殊字,变回来。
        str,_ = string.gsub(str,"%p",act_case)                      --标点符号替换
        str,_ = string.gsub(str,"percent","%%")                     --特殊处理下百分号,将描述中的百分号先变成特殊字,变回来。
        str,_ = string.gsub(str,"[_%a]+",act_case)                  --匹配字母及下划线
        return str
    end
    if DEBUG == "convertToTable" then 
        print(reg_replace(configcontext))
    end
    return load( "t = {" .. reg_replace(configcontext) .. "} return t")()
end






--isFile
return comfunc