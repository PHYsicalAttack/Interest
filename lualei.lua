0.lua的类
(1)lua的类实际上就是lua的 table ，类之间的继承实际上就是吧 table 连到一起了，调用方法和属性，
    就是先去第一个table搜索如果没有再去连在后面的table里搜索。
(2)lua里的self实际上就是table了，也能代表类名
(3)lua继承
local self = {}
setmetatable(self , classA)                      在表self基础上建立classA，classA是一个新表
setmetatable(classB , classA)                  在表classA基础上建立classB，classB是一个新表
(4)表唯一的标示
classA.__index = classA

1.类的属性
(1) classA = {x = 0, y = 0}
(2) classA = {}
      classA._x = 0
      classA._y = 0
两种声明属性都行，之后在方法里可以通过，self.x 调用

2.类的方法
function  classA:new()    
    隐藏传递 self ，默认第一个参数，可以通过 self.xxx 调用属性和方法
end
function  classA.new()     
    必须要传递 类名(self)， 否则不能调用 self
end
声明和调用方法都用 :、属性的调用全部用点号 .

3.创建类
classA = {} 
classA.__index = classA
    function  classA:new()                          
        local self = {}                                      实现了一个类有多个对象，创建一个对象跟谁着创建了一个元表 self ,
                                                                  如果前面的 local 去掉一个类只能有一个对象
        setmetatable(self , classA)       
    return self                                 
end

4.使用类
classA = {x = 0, y = 0}                              --{}可以声明属性 
classA.__index = classA

function  classA:new()                            --function 前面不能加 local，前面已经通过 classA限定范围了
      local self = {}                                    --创建新的表作为实例的对象
      setmetatable(self , classA)              --设置class为对象元表的__index
      return self                                        --返回该新表
end

function classA:func()
     print("classA : func")
end

function classA:createA(tag)                       
      print("classA : create   "..tag)
end

--local 
sa = classA:new()                              --实例化对象sa
sa:createA(122)
classA:createA(3)

5.类的继承
classB = {}
classB.__index = classB

function  classB:new()                            
       setmetatable(classB , classA)                  --父类放在后面。实际上就是把 classB 和 classA 连到一起先搜 classB 表有没有这个方法，
                                                                       --没有会向后搜索 classA 再没有会继续向后搜索，如果没有会返回 nil
      return classB                                   
end

function classB:createB(tag)                       
     print("classA : create   "..tag)
end

local sb = classB:new()
sb:createA(102)

6.2dx的lua继承
(1)class 是 cocos2d-x 的方法 path: ../cocos2d-x-3.1/cocos/scripting/lua-bindings/script/extern.lua
    class("A", B) A 继承 B，B必须是lua文件里的类
(2)setmetatable(A, B) 是 lua 的继承， A 继承 B
(3)通过 tolua 的继承 tolua.getpeer(target) target：cc.Sprite:create(img) 是C++的一个对象
    再通过 setmetatable(t, ChilSprite) 实现对 C++对象的继承
[plain] view plaincopy在CODE上查看代码片派生到我的代码片
local ParentOne = class("ParentOne")               
  
function ParentOne:testDemo()  
    print('ParentOne           demo')  
end  
  
  
--父类 ParentOne  
local ChilSprite = class("ChilSprite", ParentOne)  
ChilSprite.__index = ChilSprite  
  
function ChilSprite.extend(target)  
    local t = tolua.getpeer(target)                                 --tolua的继承  
    if not t then  
        t = {}  
        tolua.setpeer(target, t)  
    end  
    setmetatable(t, ChilSprite)  
    return target  
end  
  
function ChilSprite:createS(img)  
    local sprite = ChilSprite.extend(cc.Sprite:create(img))  
    return sprite  
end  
  
function ChilSprite:myFunc(img)  
    print("ChilSprite  myFunc   "..img)  
end  
  
function ChilSprite:goFunc()  
    print("ChilSprite  goFunc   ")  
end  
  
  
--父类 ChilSprite  
local ChilLayer = class("ChilLayer", ChilSprite)  
ChilLayer.__index = ChilLayer  
  
function ChilLayer.extend(target)  
    local t = tolua.getpeer(target)  
    if not t then  
        t = {}  
        tolua.setpeer(target, t)  
    end  
    setmetatable(t, ChilLayer)  
    return target  
end  
  
function ChilLayer:createL(img)  
    local sprite = ChilLayer.extend(cc.Sprite:create(img))  
    return sprite  
end  
  
function ChilLayer:myFunc(img)  
    print("ChilLayer  myFunc   "..img)  
end  
  
  
local function testBccLayer( scene )  
    local ball = ChilLayer:createL("Images/ball.png")  
    ball:setPosition(cc.p(VisibleRect:center().x - 110, VisibleRect:center().y - 110))  
    ball:setScale(3)  
    scene:addChild(ball, 1111)  
  
    local cball = ChilLayer:createS("Images/ball.png")       --调用父类的方法  
    cball:setPosition(cc.p(VisibleRect:center().x + 110, VisibleRect:center().y + 110))  
    cball:setScale(3)  
    scene:addChild(cball, 1111)  
  
    ball:myFunc("1235")                                      --调用自己的方法，覆盖父类的方法  
    ball:goFunc()                                            --调用父类的方法  
    ball:testDemo()                                          --调用父类的父类方法  
end  
  
  
function testBcc(scene)  
    testBccLayer(scene)  
end  


7.通过 class 继承 c++对象
具体可以看 extern.lua 里对继承 lua object 和 c++ object 进行了判断
testCcc = {};
testCcc = class("testCcc",function(img)
return cc.Sprite:create(img)
testCcc.__index = testCcc;


local ccc = testCcc.new("Images/ball.png");