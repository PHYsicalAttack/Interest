function eraseTerminal()
	io.write("\23[2J")
end


function mark(x,y)
	io.write(string.format("\27[%d;%dH*",math.floor(y),math.floor(x)))
end

Termsize = {w = 80 , h =24}

function plot( f )
	eraseTerminal()
	for i = 1,Termsize.w do 
		local x = (i/Termsize.w) *2 -1
		local y = (f(x)+1) /2 *Termsize.h 
		mark(i,y)
	end
	io.read()
end

plot(function (x)
	return math.sin(x*2*math.pi)
end)