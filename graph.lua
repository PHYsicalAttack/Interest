local function name2node(graph,name)
	if not graph[name] then
		graph[name] = {name = name,adj = {}}
	end
	return graph[name]
end

function readgraph()
	local graph = {}
	for line in io.lines() do
		local namefrom,nameto =string.match(line,"(%S+)%s+(%S+)")
		local from = name2node(graph,namefrom)
		local to = name2node(graph,nameto)
		--将 'to' 添加到 'from'的领结集合
		from.adj[to] =true
	end
	return graph
end


function findpath( curr,to,path,visited )
	path = path or {}
	visited = visited or {}
	if visited[curr] then 
		return nil
	end

	visited[curr] = true
	path[#path+1] = curr

	if curr == to then 
		return path
	end

	for node in pairs(curr.adj) do
		local p = findpath(node,to,path,visited)
		if p then return p end
	end

	path[#path] = nil

end


function printpath(path)
	for i =1 ,#path do 
		print(path[i].name)
	end
end

g = readgraph()

a = name2node(g,"a")
b = name2node(g,"b")

p = findpath(a,b)

if p then printpath(p) end


---------
a b 
b c
b f 
c d
c f
d e
f g
g h
f i
i j
j c
j k
i l
c k 
k l
---------
Graph = {}
--生成图节点
function Graph.newNode(graph, name)
	if not graph[name] then
		graph[name] = {name = name, adj={}} --创建一个新的图结点
	end
	return graph[name]
end

--生成图
function Graph.gen(s)
	local graph = {}
	for line in io.lines(s) do
		--匹配起始，通往结点
		local namefrom, nameto = string.match(line, "(%S+)%s(%S+)")
		local from = Graph.newNode(graph, namefrom) --生成起始结点
		local to = Graph.newNode(graph, nameto)   --生成通往结点
		local path = from.adj       --得到路径表
		path[#path + 1] = to 		--连接图结点路径
	end
	return graph
end

function Graph.findpath(curr, to, path, visited)
--参数：当前结点， 目的结点， 保存路径的集合， 已访问结点集合(可退化)
--关于退化：这里的退化概念是自己提出的，意思是对得到一条通路上的结点
--往前回溯取消记录，以致于另一个递归搜素分支可以找到这条路径，同时，
--对于已压栈函数记录的结点和无通路径上的结点保存记录以至于递归函数
--直接返回

	path = path or {}         --path作为table来记录所有保存的路径
	visited = visited or {}   --visited为保存记录结点的表
	if visited[curr] then     --对记录结点直接返回
		return nil 
	end 
	visited[curr] = true      --记录访问节点
	path["name"] = curr["name"]  --记录路径
	if curr == to then        --找到终点，构成一条路径，返回
		visited[curr] = nil   --退化(取消该终点的记录)
		return path          
	end 
	
	local p
	for i,from in ipairs(curr.adj) do 
		path[i] = {father = path}    --保存一个能找到父结点的字段
		--递归搜索路径
		local rightPath = Graph.findpath(from, to, path[i], visited)
		if not rightPath then path[i] = nil end --找不到，取消一个子table
		p = rightPath or p   --有路径时记录最后一条通路返回，否则返回nil
	end
	
	if p then 
		visited[curr] = nil       --退化该路径节点
		return p["father"] 		  --返回该路径的father,即本结点
	end    							

	path = nil                	  --没找到，删除该节点
end

--打印所有图路径
function Graph.printPath(path, visited)
--路径结点集合， 已访问结点集合（可退化）
	path = path or {}           
	visited = visited or {}
		
	if path then 
		visited[#visited + 1] = path  --以数组形式保存访问过的路径
		io.write(path.name, " ")      --打印本结点名字和空格符
	end
	
	local maxn = table.maxn(path)     --取可行支路中的最大编号
	if maxn == 0 then 				  --不存在支路（即终点）时
		visited[#visited] = nil       --退化，取消记录该结点
		io.write("\n")                --该条路径已完全输出，换行
		return 
	end 							  --终点，返回
	
	local count = 0                   --统计支路的数目
	for i = 1, maxn do 
		if path[i] then				  --该条编号的支路存在
			count = count + 1		  --递增支路数
			if count > 1 then         		  --除第一条支路之外，
				for i,v in ipairs(visited) do --对已记录的根路结点进行打印
					io.write(v.name, " ")
				end
			end
			Graph.printPath(path[i], visited) --然后再次递归搜索下一条支路
		end
	end
	visited[#visited] = nil           --支路已搜索完毕，此分支不再搜索，退化
end

local graph = Graph.gen("./lua/graph.lua")         --生成图
local path = Graph.findpath(graph["a"], graph["l"]) --寻找图路径
Graph.printPath(path)								--输出图路径


