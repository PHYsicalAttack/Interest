BEGIN

#create by myliycool
#=========批量生成账号及角色=========
# aName               账号名
# rName               角色名
# rNumeber            添加个数
# rLevel              角色等级
# rVip                VIP等级
# needMoney           是否需要资源,0表示不需要，1表示需要
# needGuilde          是否跳过新手引导,其他数值表示不跳过新手引导，1表示选择“秒娃种子”，2表示选择"小火龙"，3表示选择“杰尼龟”
#==================================

#==========根据服务器ID修改以下参数===========
#最多支持999以下的服务器ID

 #DECLARE serverID int DEFAULT 13;
#==========================================




declare sucessTimes int default 0;#记录成功次数

DECLARE _aName VARCHAR(15);#实际要插入的账户名
DECLARE _rName VARCHAR(10);#实际要插入的角色名

DECLARE i int DEFAULT 1;

DECLARE rID BIGINT DEFAULT 0;#实际要插入的角色ID
DECLARE initRID BIGINT DEFAULT 0;#初始角色ID
DECLARE rAID BIGINT DEFAULT 0;#实际要插入的账号ID
declare rgerID bigint default 0;#实际要插入的武将在表中的顺序ID

DECLARE rCoin BIGINT DEFAULT 0;#银两
DECLARE rGold BIGINT DEFAULT 0;#元宝
DECLARE rRep  BIGINT DEFAULT 0;#声望
declare rNumber int default 10;#默认插入的数量
declare rLevel int default 1;#默认插入的等级
declare rVip int default 1;#默认插入的vip等级
declare needMoney int default 0; #是否需要资源(0?1)





if rNumber > 0 and rLevel < 241 and rLevel > 0  and rVip < 21 and rVip > 0 and (needMoney = 0 or needMoney = 1) then
  #设置初始ID规则 
 # if serverID < 9 then 
    set initRID = 2000001;
 # elseif serverID < 99 then
  #  set initRID = (serverID + 1) * 100000;
  #elseif serverID < 999 then 
    #set initRID = (serverID + 1) * 10000;
  #end if; 

  #设置资源
  if needMoney = 1 then
    set rCoin = 999999999;
    set rGold = 10000000;
    set rRep  = 10000000; 
  end if;
  
	while i <= rNumber do
    #设置每次要添加的账号名及角色名
    set _aName = concat('c',i);
    set _rName = concat('bot',i);
 
    #判断表中是否有数据，设置rID
    if (select count(*) from gRole) = 0 then
      set rID =  initRID + 1;
    else
      set rID = (select max(roleID) from gRole) + 1;
    end if;    

    if (select count(*) from gRole where roleName like _rName) = 0 then
      if (select count(*) from seer_login.account where seer_login.account.accName like _aName) = 0 then
        #向账号数据库插入账号
        insert into seer_login.account (type,accountName,`password`,signTime) values (1,_aName,'0df2f9e1304a5c1663b5620b797768ae',now());
        commit;
      end if;
      #取出插入的账号ID并按规则转换为角色表中的账号ID
      set rAID = initRID * 10000 + (select seer_login.account.accountID from seer_login.account where seer_login.account.accountName like _aName);
      #向角色表中添加数据
      if needGuilde = 1 or needGuilde = 2 or needGuilde = 3 or needGuilde = 4 then 
         insert into gRole (roleID,accid,roleName,`level`,coin,reputation,gold,vipLevel,srcType) values (rID,rAID,_rName,rLevel,rCoin,rRep,rGold,rVip,1);
         commit;
      end if;
      set sucessTimes = sucessTimes + 1;
    set i = i + 1; 
  end while;
  select concat("成功添加",sucessTimes,"次") as "添加成功";
elseif rNumber <= 0 then 
   select "参数rNumber须大于0" as "输入参数错误"; 
elseif rLevel > 240 or rLevel <= 0 then 
   select "参数rLevel须大于0并小于241" as "输入参数错误";
elseif rVip > 21 or rLevel <= 0 then 
   select "参数rVip须大于0并小于21" as "输入参数错误";
else
   select "参数needMoney只能为0或1" as "输入参数错误";
end if;


END