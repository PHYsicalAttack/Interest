-----------------------------------
----Time:	2016-4-11
----File:	Interest.lua
----Author: Fallever
----Desc:	有时候难免会寂寞无聊，就用这些函数填补吧
--dofile("/Users/0280102pc0102/Desktop/what it means/aul/Interest.lua")
-----------------------------------
Interest={}
function Interest:Info()	--开始是时要调用这个函数
	os.execute("clear")
	local i=i or 1
	self.Desc ="Desc: 有时候难免会寂寞无聊，就用这些函数填补吧~!"
	self.times =10000		--万分无聊
	self.lycnames={								--歌曲目录
					[1]="November_Rain.lua",
					[2]="Demons.lua",
					[3]="ふわふわ时间.lua",
					[4]="天使にふれたよ!.lua",
					[5]="Don’t say “lazy”.lua",
					[6]="U&I(映画｢けいおん!｣Mix).lua",
					[7]="わたしの恋はホッチキス.lua",
					[8]="Only my railgun.lua",
					[9]="Don't cry.lua",
					[10] = "家.lua",
				}
	self.picnames={
					[1]="御坂美琴.lua",
					[2]="呆唯.lua",
					[3]="康娜.lua",
				}
	self.path ="/Users/0280102pc0102/Desktop/whatitmeans/aul/Interest.lua"
	self.height = 34   --34
	self.width = self.height *3
	self.screen_t = {} 							--屏幕
	print(self.Desc)
	for k,v in pairs(self) do
		local func_var="()"
		if type(v) == "function" then 
			if tostring(k) =="PrintTime" then 
				func_var = "(times,sec)"
			elseif tostring(k) == "PlayLyc" then 
				func_var = "(nlyc,times,sec)"
			elseif tostring(k) == "Delay" then
				func_var ="(tinysec)"
			elseif tostring(k) == "DecFloor" then
				func_var = "(num)"
			elseif tostring(k) == "OrderPlayLyc" then
				func_var ="(order,times)"
			elseif tostring(k) == "PlayPicture" then
				func_var ="(npic,speway)"
			end	
			print(i .. ". " .. type(v) .. ": " ..k .. func_var)
			i=i+1
		end
	end
	self:Index()
end

function Interest:Index()
	print("【歌曲目录】")
	for i,v in ipairs(self.lycnames) do
		print(i .. "." ..string.sub(v,1,-5))
	end
	print("【图片目录】")
	for i,v in ipairs(self.picnames) do
		print(i .. "." ..string.sub(v,1,-5))
	end
end

function Interest:PrintTime(times,sec)
	local times = times or self.times	
	local sec =sec or 0
	local sec =math.max(sec-1,0)
	for i =1,times do 
		local pre =os.time()
		repeat
			local	now =os.time()
		until now>pre+sec
		print(os.date("Now is: %c",now))
	end
end

function Interest:PlayLyc(nlyc,times,sec) --play lyc
	local times = times or self.times
	local sec =sec or 0.88
	local nlyc=nlyc
	local lyc_file 
	if (not nlyc) or nlyc >#self.lycnames then
		 lyc_file =self.lycnames[math.random(#self.lycnames)]
	else
		lyc_file = self.lycnames[nlyc]
	end		
	local lyc_path= string.sub(self.path,string.find(self.path,"/.*/")) .. "cyl/" .. lyc_file
	local file = io.open(lyc_path)
	for i=1,times do	
		for l in file:lines() do
			self:Delay(sec)
			print(l)
		end
		print(string.rep("*",math.floor(string.len(lyc_path)/2)) .. "\n")
		file:seek("set")
	end
	file:close()
	--self:Index()
end

function Interest:OrderPlayLyc(order,times)				--1随机播放，2顺序播放，times实际相当于播放的歌曲数目
	local times = times or self.times
	local order =order or 1      					
	for k=1,times do
		if order == 1 then 
			self:PlayLyc(math.random(#self.lycnames),1)
		else
			local lyc_id = (k-1)%(#self.lycnames)+1
			self:PlayLyc(lyc_id,1)
		end
	end
end

function Interest:DecFloor(num,bit)		--小数取整，多带了一个bit参数，不要用bit参数，估计用不到，本来不想带的，太丑
	local bit =0.1^(bit or 2) 
	return num - num % bit
end

function Interest:Delay(tinysec) 		--延时程序
	local pre = Interest:DecFloor(os.clock())
	local tinysec = tinysec or 0.1
	local i = 10000
	while Interest:DecFloor(os.clock()) < pre+tinysec do
		 i= i + 10000
	end
	return tinysec	
end

function Interest:GreedySnake()
	--小蛇出生
	local snake={{1,1},}
	local pot_x,pot_y
	---调试用的cs次数
	local cs =0
	--动态
	while cs <self.times^2 do 
		--math.randomseed(os.time())
		--随机点生成,不能生成snake的坐标
		if not pot_x and not pot_y then
			pot_x= math.random(self.width)
			pot_y= math.random(self.height)
			while true do
				local stop = 0 
				for i,v in ipairs(snake) do
					local x,y = table.unpack(v)
					if pot_x == x and pot_y ==y then pot_y = math.random(self.height)  break end
					if i == #snake and (pot_x ~= x  or  pot_y ~= y) then stop=1 end
				end
				if stop== 1 then break end
			end
		end

		--自动方向控制
		local len_x = pot_x- snake[1][1];local len_y = pot_y - snake[1][2]
		if math.abs(len_x) > math.abs(len_y) then
			if len_x> 0 then
				self.control={1,0}		--运动控制，只允许改变一个方向
			else
				self.control={-1,0}
			end
		else
			if len_y>0 then
				self.control ={0,1}
			else
				self.control ={0,-1}
			end
		end
		--小蛇的下一个位置
		for i=#snake,1,-1 do
			if i ~= 1 then 	
				snake[i][1] = snake[i-1][1]
				snake[i][2] = snake[i-1][2]
			else 
				snake[i][1]=snake[i][1]+self.control[1]
				snake[i][2]=snake[i][2]+self.control[2]
			end
		end
		local snake_x,snake_y
		if snake[1][1] ==pot_x and snake[1][2] ==pot_y then 
			snake_x=pot_x;snake_y=pot_y
			pot_x=nil;pot_y=nil 
		end
		--自动控制不会死了
		--if snake[1][1] <=0 or snake[1][2]<=0 or snake[1][1]>self.width or snake[1][2]> self.height then return "Game Over" end

		--如果随机点存在则加入绘图
		local all_point = {}
		--复制snake至绘图点
		for i=1,#snake do 
			all_point[i] =snake[i]
		end

		if pot_x and pot_y then 
			table.insert(all_point,{pot_x,pot_y})
		end

		--清空屏幕记录表
		for i= 1,self.width do 						
			for j=1, self.height do
				self.screen_t[(j-1)*self.width + i] = 0 
			end
		end

		--将2维数组坐标位置的值设置为1
		for i,v in ipairs(all_point) do
			local x,y = table.unpack(v)
			--print(x,y)
			self.screen_t[(y-1)*self.width +x] =1
		end
		
		local screen_output=""
		local n_ctr=0
		for i,v in ipairs(self.screen_t) do
			if v==1 then 
				screen_output =screen_output .. "*"
			else 
				screen_output = screen_output .. " "
			end
			if (string.len(screen_output)-n_ctr)%self.width == 0 then 
				screen_output =screen_output .."\10" 
				n_ctr = n_ctr +1
			end
		end
		self:ScreenDraw(screen_output,0.1)
		cs=cs+1
		--print(cs) --print(snake_y,snake_x)
		if snake_y and snake_x then 
			table.insert(snake,{snake_x,snake_y})
		end
		if #snake == 2 then
			--print(#snake,snake[1][1],snake[2][1]) 
		end
	end	
end

function Interest:ScreenDraw(str,sec)
	self:Delay(sec)
	os.execute("clear")
	print(str)
end

function Interest:PlayPicture(npic,speway)
	local pic_file
	if (not npic) or npic >#self.picnames then 
		pic_file=self.picnames[math.random(#self.picnames)]
	else
		pic_file= self.picnames[npic]
	end
	local pic_path=string.sub(self.path,string.find(self.path,"/.*/")) .. "cyl/" .. pic_file
	local file = io.open(pic_path)
	local line_num=0
	for l in file:lines() do
		line_num = line_num +1
	end
	file:seek("set")
	if not speway then 
		local pic=file:read("*a")
		print(pic)
	else
		local pic=""
		local line=0
		while file:read("*l") do
			line=line+1
			file:seek("set")
			for i =1,line do
				local line_str=file:read("*l")
				pic= pic .. "\n".. line_str
			end
			local line_left = line_num -line 
			if line_left>0 then 
				for i=1,line_left do
			 		pic=pic .. "\n"
				end 
			end
			self:ScreenDraw(pic,0.1)
		end
	end
	file:close()
end 

function Interest:Star()
	
end
Interest:Info()
--return Interest

