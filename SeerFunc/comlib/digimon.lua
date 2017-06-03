cc = {exports = {}}
function g_creatEnumTable (t) 
    local rt  = {}
    for i,v in ipairs(t) do 
        rt[v] = v
    end
    return rt
end
