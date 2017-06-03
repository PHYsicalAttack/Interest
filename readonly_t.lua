--readonly table实现
--因为表的__index 和 __newindex 元方法都是在索引不存在的情况下生效，所以需要对要访问的表创建一个空表作为代理

function readonly(t)
	local poxy = {}
	local mt ={
		__index = t,
		__newindex = function (t,k,v)
			print(tostring(t) .. "is a readonly table!")
			end
	}
	setmetatable(poxy,mt)
	return poxy
end


local test = readonly({11,22,33})
print(test[1])
test[1]=99

--然而感觉好蠢