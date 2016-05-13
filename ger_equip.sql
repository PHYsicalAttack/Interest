BEGIN
#需要该角色不在线或停服后执行。
declare rId int DEFAULT 2000001; #需要插入的角色roleid。
dECLARE isGerNeed int DEFAULT 1;#是否需要插入精灵,1是需要，0是不需要。
declare gerIdstart int default 1039; #从雷伊开始插入。
declare gerIdend int default 1043;#插入精灵的结束id。
declare gerRank int default 0;
declare gerLevel int default 1;
declare gerEvolve int default 0;
declare singleNum int default 2; #每个精灵需要的数量.
DECLARE isEquipNeed int DEFAULT 1;#是否需要插入装备,1是需要，0是不需要。
DECLARE equipIdstart int default 2052;
declare equipIdend int DEFAULT 2054;
declare equipSingelnum int 10;
declare equipRank int 0;
declare equipLevel int 0;

declare speId BIGINT;
declare equipId bigint;
if isGerNeed=1 then
	while gerIdstart<=gerIdend do
		#SET	speId=(SELECT max(gerid) from seer1.gGer)+1;
		while (select count(typeid) from gGer where roleid=rId and typeid=gerIdstart) < singleNum do
		if (select count(gerid) from seer1.gGer)=0 THEN
			set speid=123456789;
		else SET speId=(SELECT MAX(gerid) from seer1.gGer)+1;
		end IF;
		#select gerIdstart as"12";
		insert into seer1.gGer(roleid,gerid,typeid,rank,level,exp,evolve,pos,state) values(rId,speId,gerIdstart,gerRank,gerLevel,2,gerEvolve,0,0);
		#	SET	speId=(SELECT MAX(gerid) from seer1.gGer)+1;
		end while;
		set gerIdstart=gerIdstart+1;
	#select gerId as "gerid";
	#select speId as "speID";
	end while;
end if;
if isEquipNeed=1 THEN
	while	equipIdstart<=equipIdend do 
		while (select count(typeid) from gequip where roleid=rId and typeid=equipIdstart)<equipSingelnum do
			if(select count(equipid) from seer1.gequip)=0 then
				set equipId=123456789;
			else set equipId=(select max(equipid) from seer1.gequip)+1;
			end if;
		insert into	seer1.gequip values(rId,equipId,0,equipIdstart,equipRank,equipLevel,0,0);
		end while;
		set equipIdstart=equipIdstart+1;
	end while;
end if;
END