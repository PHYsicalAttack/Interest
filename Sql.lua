--点亮所有关卡的命令,可以在gDungeon插入使副本可扫荡--
--update gRoleExtra set battleProgress = 30400,battleProgressHard=10400 where roleID=角色id
---注入装备（itemUID,roleID,itemTypeID,itemPos,itemLevel,itemRank,itemGerID,itemDecay,itemExp)--
--insert into gEquip values ( 228000013548964,  14010103 ,  10729, 0,   144,  10,0,0,0);
--10jie jingling,这个是注入所有精灵,可以改roleID,精灵等级品阶,12是精灵的经验值,--
--(gerID,roleID,gerTypeID,gerLevel,gerExp,gerRank,gerPos)--
--equipment(10719~10730)、trainer(15613~15618)、stones(5017~5028)、tranierstone(6040~6045)
function sqlzhuru()
	math.randomseed(os.time())
	j=math.random(1000,2000)
	local roleID =12010035
	local itemTypeID = 7180	--当做startGerID
	local itemTypeIDEnd = 7230 --当做endGerID
	local itemPos=0				--当做gerPos
	local itemLevel=1          --当做gerLevel
	local itemRank=20			--当做gerRank
	local itemGerID=0			
	local itemDecay = 0
	local itemExp = 2			--当做gerExp
	function sqlEquilp()
		for i=itemTypeID,itemTypeIDEnd do 
			io.write("insert into gEquip values(",100*j+i+14000000000000,",",roleID,",",i,",",itemPos,",",itemLevel,",",itemRank,",",itemGerID,",",itemDecay,",",itemExp,")",";","\10")
		end
	end
	function sqlStones()
		for i=itemTypeID,itemTypeIDEnd do 
			io.write("insert into gEquip values(",100*j+i+140000000000,",",roleID,",",i,",",itemPos,",",itemLevel,",",itemRank,",",itemGerID,",",itemDecay,",",itemExp,")",";","\10")
		end
	end
	function sqlGer()
		for i=itemTypeID,itemTypeIDEnd,10 do 
			io.write("insert into gGer values(",100*j+i+14000000000000,",",roleID,",",i,",",itemLevel,",",itemExp,",",itemRank,",",itemPos,")",";","\10")
		end
	end
	function sqlTrainer()
		for i=itemTypeID,itemTypeIDEnd do 
			io.write("insert into gEquip values(",100*j+i+14000000000000,",",roleID,",",i,",",itemPos,",",itemLevel,",",itemRank,",",itemGerID,",",itemDecay,",",itemExp,")",";","\10")
		end
	end
	function breakthrough()--注入转生材料 ID 20018-20025--
		l=math.random(1,1000)
		k=10000
		for i=20018,20025 do
			io.write("insert into gBagItem values(",l+i+14000000000000,",",roleID,",",i,",",k,");","\10")
		end
	end
	return sqlEquilp,sqlGer,sqlStones,sqlTrainer,breakthrough
end
local equip,ger,stones,trainer,bre= sqlzhuru()
ger()