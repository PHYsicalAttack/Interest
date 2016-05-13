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
function pr (t, name, indent)   
    local tableList = {}   
    function table_r (t, name, indent, full)   
        local id = not full and name or type(name)~="number" and tostring(name) or '['..name..']'   
        local tag = indent .. id .. ' = '   
        local out = {}  -- result   
        if type(t) == "table" then   
            if tableList[t] ~= nil then   
                table.insert(out, tag .. '{} -- ' .. tableList[t] .. ' (self reference)')   
            else  
                tableList[t]= full and (full .. '.' .. id) or id  
                if next(t) then -- Table not empty   
                    table.insert(out, tag .. '{')   
                    for key,value in pairs(t) do   
                        table.insert(out,table_r(value,key,indent .. '|  ',tableList[t]))   
                    end   
                    table.insert(out,indent .. '}')   
                else table.insert(out,tag .. '{}') end   
            end   
        else  
            local val = type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"' or tostring(t)   
            table.insert(out, tag .. val)   
        end   
        return table.concat(out, '\n')   
    end   
    return table_r(t,name or 'Value',indent or '')   
end   
function print_r (t, name)   
    print(pr(t,name))   
end   
  
local a = {x=1, y=2, label={text='hans', color='blue'}, list={'a','b','c'}}  