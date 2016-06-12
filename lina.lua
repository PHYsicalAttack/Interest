--模仿一下lina被动计时叠加buff
--后记:没有实现像dota里面那样的动态更新buff的功能，有难度啊！

DURATION=8.0
MAX_STACK= 5
buff={}
function buff:create()
	self.stack = self.stack or 0 
	self.alive=true
	if self.stack < MAX_STACK+1 then
		self.stack = self.stack +1 
	else
		self.stack =MAX_STACK
	end
	self.last = DURATION
	self:run()
end

function buff:run()
	while self.stack > 0 do
		self:timer(1,self.des_time)
		if self.last<1 then 
			self:destory()
			self:output()
			return false
		end
		self:output()
	end
end

function buff:timer(t,fun)
	local a=os.time()
	repeat 
		local b =os.time()
	until b>a+t-1
	fun()
end

function buff:des_stack()
	if buff.stack > 0 then 
		buff.stack = buff.stack -1
	end
end

function buff:des_time()
	if buff.last > 0 then
		buff.last =buff.last -1
	end
end

function buff:destory()
	self.alive = false
	self.stack = 0
end

function buff:output()
	print(string.format("Now buff_stack is %d ,last_time is %d , is alive %s",self.stack,self.last,self.alive))
end

buff:create()
buff:create()