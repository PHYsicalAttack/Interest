local results = {}
setmetatable(results,{__mode = "v"})
-- setmetatable(results,{__mode = "kv"})
function mem_loadstring( s )
	local res = results[s]
	if not res then
		res  = assert(loadstring(s))
		results[s] = res
	end
	return res
end