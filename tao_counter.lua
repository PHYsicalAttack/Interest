basetao=100
hu=basetao
while hu>=3 do
	tao=math.floor(hu/3)
	shu=hu-tao*3
	hu=tao
	basetao=basetao+tao	
	hu=hu+shu
end
print(basetao)
print(hu)


local beer=5
local price_beer_bottle=2
local price_beer_can=4
local bottle=0
local can =0
repeat 
	bottle = bottle +beer
	can  = can +beer

	beer_bottle= math.floor(bottle/price_beer_bottle)
	beer_can =math.floor(can/price_beer_can)

	bottle = bottle%price_beer_bottle
	can =can% price_beer_can

	beer= beer_bottle+beer_can
	print("bottle=" .. bottle,"can=" .. can,"beer=" .. beer)
until beer<=0

