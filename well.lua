well=7
pos=3
nag=2
day=0
repeat 
	day=day+1
	well=well-pos+nag
until well<=pos
print(day+1)

well1=7
day1=0
while well1-pos>=0 do
	day1=day1+1
	well1=well1-pos+nag
end
print(day1 )