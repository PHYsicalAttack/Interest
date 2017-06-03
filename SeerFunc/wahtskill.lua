--wahtskill.lua				[[DESC:什么吊技能]]
--[[使用方法:放在seerfunc里面,在condfig文件夹里面放入最新的data_skill.config配置,将testid的值改成要测的技能id即可]]
-- skikk = {xxxxxx shuxing liuxue xx  x x  特效几率 特效目标 {特效效果表  === {特效补充表}} }
local testid = 430091
-------下面的都不用改---
testid = tonumber(arg[1]) or testid
local comfunc = require("comlib.comfunc")
--lua文件生成结束
local skilllib = comfunc.convertToTable2("config/data_skill.config")
local skill = {}
for i,v in ipairs(skilllib) do 
	if testid == v[2] then skill = v break end
end
if not next(skill) then 
	return print("未能找到技能:" .. testid)
end
--mt
local SMT={skillid = testid}
SMT.__index=SMT
setmetatable(skill,SMT)
function SMT:__tostring()
	return self.skillid
end
--目标选择
function SMT:GetTarSelc()
	return self[6]
end

--buff_type
function SMT:GetBuffType()
	local buff=self[7]
	local buffstr=""
	for i,v in ipairs(buff) do
		local x,y,z =  table.unpack(v)
		buffstr = buffstr ..string.format("效果:%s;几率:%d%%;计算方式:%s",x,y/100,z or "无")
	end
	return buffstr
end

--damage_radio
function SMT:GetDmgRatio()
	local ratio = self[8]
	local x,y = table.unpack(ratio)
	return string.format("%d%%~%d%%",x/100,y/100)
end

--skill_type
function SMT:GetSkillType()
	local skill_type={"主动技能","被动技能","回血技能"}
	return skill_type[self[9]]	
end

--release_type
function SMT:GetReleaseType()
	return self[10]
end

--critic
function SMT:GetCrt(  )
	if self[11]~= 0 then 
		return self[11]/100
	end
end

--absorb  //吸血
function SMT:GetAbsorb()
	if self[12]~= 0 then 
		return self[12]/100
	end
end

--doom //命中
function SMT:GetDoom()
	if self[13]~= 0 then 
		return self[13]/100
	end
end

--dot_round
function SMT:GetDotRound()
	if self[14]~= 0 then 
		return "dotround:" .. self[14]
	end
end

--dot_ratio
function SMT:GetDotRatio()
	if self[15]~= 0 then
		return "dotratio:" .. self[15]/100 .."%"
	end
end

--special_type
function SMT:GetSpeType()
	if self[16]~= 0 then 
		return "specialtype:" .. self[16]
	end 
end

--special_value
function SMT:GetSpeValue(  )
	if self[17]~= 0 then 
		return "specialvalue:" .. self[17]
	end
end

--addbufftimes 		//被动加属性最多可加次数
function SMT:GetAddBuffTimes(  )
	if self[18]~=0 then 
		return "被动buff叠加次数:" .. self[18]
	end
end

--buff_rate
function SMT:GetBuffRate()
	print("###### 技能释放时触发的特殊效果 #######")
	if self[19]~=0 then 
		return self[19]/100
	else 
		return "0,不会触发下方任何效果"
	end
end

--buff_target
function SMT:GetBuffTarget()
	return self[20]
end

--add_attr  //buff补充属性
function addattr(t)
	local attr={"攻击","暴击","韧性","命中","闪避","吸血","反弹","击晕","抗晕","普攻","普防","特攻","特防","掉血抗性","基础攻击加成","最终伤害减免","最终伤害加成",}
	local attrstr = {}
	for i,v in ipairs(t) do
		if i>1 and v ~= 0 then
			attrnum  = v 
			if (i<11 and i ~=1) or i > 14 then 
				attrnum =attrnum/100
			end
			--print(i,attrnumi)
			table.insert(attrstr,attr[i-1] .. ":" .. attrnum)
		end
	end
	return table.concat(attrstr,";")
end

--buff_last //附加buff持续属性
function SMT:GetADDATTR()
	local bufftype = self[21][2]
	local cost = {"自身行动一回合减一","释放者行动一回合减一"}
	local buffcost = cost[self[21][4]]
	local bufflast = self[21][5]
	return "附加buff类型:" ..bufftype .."; 减少回合数条件:" .. buffcost .."; 持续回合数:"..bufflast
end

--buff_detail
function SMT:GetBuffDetail()
	local add_attr = addattr(self[21][8])
	local attr = {"按自身最大生命比例回血","最大血量加成","最大血量加成比例","增加怒气","增加怒气上限"}
	local attrstr = ""
	for i,v in ipairs(self[21]) do 
		if i >8 then 
			if v ~= 0 then
				attrnum = v 
				if i >=9 and i <= 11 then 
					attrnum = attrnum/100
				end
				--print(attrstr,attr[i-8],attrnum)
				attrstr = attrstr .. attr[i-8] .. ":" .. attrnum
			end
		end
	end

	return add_attr .. attrstr
end

--for i,v in ipairs(skill) do print(i,v) end
if arg[1] then print("") end
print("技能ID:",skill)
print("技能选择:",skill:GetTarSelc())
print("特殊状态(流血、眩晕等):",skill:GetBuffType())
print("伤害系数:",skill:GetDmgRatio())
print("技能类型:",skill:GetSkillType())
print("技能触发类型:",skill:GetReleaseType())
print("技能附加暴击:",skill:GetCrt())
print("技能附加吸血:",skill:GetAbsorb())
print("技能附加命中:",skill:GetDoom())
print("掉血dot持续回合:",skill:GetDotRound())
print("掉血dot伤害:",skill:GetDotRatio())
--print(skill:GetSpeType())
--print(skill:GetSpeValue())
--print(skill:GetAddBuffTimes())
print("附加特殊buff几率:",skill:GetBuffRate())
print("附加特殊buff的对象选择:",skill:GetBuffTarget())
print("附加特殊buff的属性:",skill:GetADDATTR())
--print("附加特殊buff持续回合数:")
print("附加特殊buff:",skill:GetBuffDetail())
print("")





