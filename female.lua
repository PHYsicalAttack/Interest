--F1,F2,F3,F4,为4个女人，M1,M2,M3,M4,为4个男人
--先把关系存在4个表里面--
female={
	F1={M4=4,M3=3,M1=2,M2=1},
	F2={M2=4,M1=3,M3=2,M4=1},
	F3={M1=4,M3=3,M4=2,M2=1},
	F4={M4=4,M3=3,M1=2,M2=1}
}
male={
	M1={F3=4,F2=3,F4=2,F1=1},
	M2={F2=4,F3=3,F1=2,F4=1},
	M3={F3=4,F1=3,F2=2,F4=1},
	M4={F3=4,F2=3,F4=2,F1=1}}
-- F1M4=female.F1.M4+male.M4.F1
--[[female={
    F1 = {M3=7,M4=6, M2=5 ,M1=4, M6 =3,M7=2, M5=1},
    F2 ={M6=7, M4 =6,M2 =5,M3 =4,M5 =3,M1=2, M7=1},
    F3 ={M6=7, M3 =6,M5 =5,M7 =4,M2 =3,M4=2, M1=1},
    F4 ={M1=7, M6 =6,M3 =5,M2 =4,M4 =3,M7=2, M5=1},
    F5 ={M1=7, M6 =6,M5 =5,M3 =4,M4 =3,M7=2, M2=1},
    F6 ={M1=7, M7 =6,M3 =5,M4 =4,M5 =3,M6=2, M2=1},
    F7 ={M5=7, M6 =6,M2 =5,M4 =4,M3 =3,M7=2, M1=1}
}
male={
    M1={F4=7,F5=6, F3=5 ,F7=4, F2 =3,F1=2, F6=1},
    M2 ={F5=7, F6 =6,F4 =5,F7 =4,F3 =3,F2=2, F1=1},
    M3 ={F1=7, F6 =6,F5 =5,F4 =4,F3 =3,F7=2, F2=1},
    M4 ={F3=7, F5 =6,F6 =5,F7 =4,F2 =3,F4=2, F1=1},
    M5 ={F1=7, F7 =6,F6 =5,F4 =4,F3 =3,F5=2, F2=1},
    M6 ={F6=7, F3 =6,F7 =5,F5 =4,F2 =3,F4=2, F1=1},
    M7 ={F1=7, F7 =6,F4 =5,F2 =4,F6 =3,F5=2, F3=1}
}
]]--
resTable={}
for i=1,4 do
	for j=1,4 do
		resTable[(i-1)*4+j]={}
		resTable[(i-1)*4+j]["comB"]="F" .. i .. "M" .. j
		resTable[(i-1)*4+j]["grade"]=female["F" .. i]["M" .. j]+male["M" .. j]["F" .. i]
        --print(i,j,resTable[(i-1)*7+j]["grade"])
	end
end
table.sort( resTable, function (a,b)
	return a.grade>b.grade

end )

local femaleStr = ""
local maleStr = ""
for i=1,#resTable do
	local femaleName = string.sub(resTable[i]["comB"],1,2)
	local maleName = string.sub(resTable[i]["comB"],3,4)
	local getGrade =resTable[i]["grade"]
	if string.find(femaleStr,femaleName)  ==nil and string.find(maleStr,maleName)==nil then
		print(femaleName .."和".. maleName .."是一对，得分：" .. getGrade)
		femaleStr=femaleStr .. femaleName
		maleStr=maleStr ..maleName
	end
end
--获得一个FiMi的最大值，然后移除表里面所有包含Fi、Mi的值
local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next
 
function print_r(root)
    local cache = {  [root] = "." }
    local function _dump(t,space,name)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
                tinsert(temp,"+" .. key .. " {" .. cache[v].."}")
            elseif type(v) == "table" then
                local new_key = name .. "." .. key
                cache[v] = new_key
                tinsert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. srep(" ",#key),new_key))
            else
                tinsert(temp,"+" .. key .. " [" .. tostring(v).."]")
            end
        end
        return tconcat(temp,"\n"..space)
    end
    print(_dump(root, "",""))
end
print_r(resTable)