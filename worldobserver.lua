--worldobserver.lua				[[DESC:]]
--主题类
local subject = {}
subject.__index = subject

function subject:new()
	local newsubject = {}
	newsubject.topiclist = {}
	newsubject.topicob = {}
	setmetatable(newsubject,subject)
	return newsubject
end

function subject:register(observer)
	for k,ob in pairs(self.topicob) do 
		if ob ==observer then
			return 
		end
	end
	table.insert(self.topicob,observer)
	return true
end

function  subject:unregister(observer)
	for k,ob in pairs(self.topicob) do
		if ob == observer then
			self.topicob[k] = nil
			return true
		end
	end
	return false
end

function subject:update(topic,context)
	self.topiclist[topic] = context
	self:notifyobserver(topic,context)
end

function subject:notifyobserver(topic,context)
	for _,ob in pairs(self.topicob) do 
		--notice observer who concern this topic
		if ob.concern[topic] then
			ob.recive(topic,context)
		end
	end
end

--观察者
local observer = {}
observer.__index = observer

function observer:new(concernlist,dealfunc)
	local newobserver = {}
	newobserver.concern = {}
	for _,obtopic in pairs(concernlist) do
		newobserver.concern[obtopic] = true
	end
	newobserver.recive = dealfunc
	setmetatable(newobserver,observer)
	return newobserver
end

weather = subject:new()
xiaohong = observer:new({"temp","sun","rain"},function (topic,context)
	if topic == "temp" then 
		if context == -1 then 
			print("xiaohong: I think it's too cold!")
		else
			print("xiaohong: not bad today!")
		end
	end

	if topic == "sun" then 
		print("xiaohong: sun is " .. context)
	end

	if topic == "rain" then
		print("xiaohong: rain is " .. context )
	end
end)
xiaolv = observer:new({"sun"},function (topic,context)
	if context == -1 then
		print("xiaolv: Is xiaohong hate cloudy?")
	else 
		print("xiaolv: Sun! I love sun!")
	end
end)

xiaolan = observer:new({"temp","rain"},function (topic,context)
	if topic == "temp" then 
		if context == -1 then
			print("xiaolan: Is xiaohong hate cold?")
		else
			print("xiaolan: It's warm today!")
		end
	end
	if topic == "rain" then
		if context == -1 then
			print("xiaolan: Rain  is romantic!")
		else 
			print("xiaolan: It isn't rain today")
		end
	end
end)

weather:register(xiaohong)
weather:register(xiaolv)
weather:register(xiaolan)

--weather:update("temp",1)
--weather:update("sun",1)
weather:update("rain",1)





















