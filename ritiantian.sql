BEGIN



declare K int DEFAULT NULL;


declare accIDB int DEFAULT 1000006;          
declare roleIDB int default 2010006;
declare roleIDE int default 2010006;


declare i bigint DEFAULT 1;


declare roleIDNum int DEFAULT 1;             
declare _Name VARCHAR(20);
DECLARE _Accid bigint(30);
declare roleL int default 70;
DECLARE roleV int DEFAULT 7;


declare	gerIDB bigint DEFAULT 1;
declare Pos int default 1;
declare gerType int default 7010;
declare gerR int default 20;
declare gerL int default (roleL - 1);

declare one int default 1;



	set gerIDB = (select MAX(gerID) from gGer) + 1;

	if gerIDB is NULL then
		set gerIDB = (ROUND(roleIDB/1000000))* 1000000000000 + 1;
	end if;
	







set i = (ROUND(roleIDB/1000000))* 10000000000;

while roleIDB <= roleIDE do



if K then 
	set roleL = (select FLOOR(RAND()*100) + 20);
	set roleV = (select FLOOR(RAND()*16) + 1);

end if;



	set _Name = CONCAT('p',roleIDNum);	
	set _Accid = i + accIDB;

		insert into gRole (roleID,accid,roleName,
				   isMale,level,exp,
				   coin,reputation,
				   gold,goldBonus,goldUsed,unioncoin,
				   vipLevel,goldTotalPaid,title,
				   fightPower,lastLogoutTime,familyID,
				   lastJoinFamily,head,payExtReward,extRdActTime,
				   location,isFailed,devid,srcType)
				   values 
				   (roleIDB,_Accid,_Name,
					   1,roleL,0,
					   100000,100000,
					   100000,0,0,5000,
					   roleV,0,0,
					   828,0,0,
					   0,0,213,0,
					   '',0,'',1);

	while one < 7 do 


		if K then 
	
			set Pos = (select FLOOR(RAND()*6)+1);
			set gerR = (select FLOOR(RAND()*20)+1);
			set gerL = (SELECT FLOOR(RAND()*roleL)+1);

		end if;
	
			insert into gGer (gerID,roleID,gerTypeID,
				gerLevel,gerExp,gerRank,
				gerPos)
				values
				(gerIDB,roleIDB,gerType,
					gerL,1,gerR,
					Pos);
					
			set gerIDB = gerIDB + 1;
			
	
		
		if one THEN

			set one = one + 1;
			set gerType = gerType + 10;
			set Pos = Pos + 1;
		end if;
	
	end while;
	
	if one then 
		set one = 1;
		set Pos = 1;
		set gerType = 7010;
	end if;
	

	set roleIDNum = roleIDNum + 1;
	set roleIDB = roleIDB + 1;
	set accIDB = accIDB + 1;

end while;

END
