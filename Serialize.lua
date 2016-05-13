--Serialize
function Serialize(t)
	if type(t)~="table" then return "error:table need!" end
	local  space =""
	function Dealfn(t)
		io.write("{\10")
		for k,v in pairs(t) do
			if type(v)~="table" then 
				if next(t,k) then
					io.write(space .. k .. "=" ..v .. ",\10")
				else 
					io.write(space .. k .. "=" ..v)
				end
			else 
				io.write(space ..k .. "=")
				space=space .. "	"
				Dealfn(v)
			end
		end
		space=string.sub(space,0,-5)
		io.write("}\10")
	end
	return Dealfn
end

t={
	name1={
		age=10,
		sex="female",
		isfat="yes"
	},
	name2={
		age=13,
		sex="male",
		isfat="no",
		family={
			son=0,
			daugter=1
		}
	},
	name3="xiaobi"
}
Serialize(t)(t)
