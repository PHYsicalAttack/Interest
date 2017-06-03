--找表中可组合的长度

function seekLen(t,len,rest)
    rest = rest or {}
    if len == 0 then 
        return rest
    elseif len < 0 then 
        return nil
    end
    local function copyt(t)
            local temp = {}
            for i,v in pairs(t) do
                temp[i]= v
            end
            return temp
    end
    --print(t)
    for i,v in ipairs(t) do 
        local temp2 = copyt(t)
        table.remove(temp2,i)
        local len2 = len -v
        local res2 = copyt(rest)
        table.insert(res2,v)
        local rrrr = seekLen(temp2,len2,res2)
        if rrrr then
            return rrrr
        end
    end
end
t = {1,3,5,7,9,11,13,15}
res = seekLen(t,30)
for i,v in ipairs(res) do
    print(i,v)
end