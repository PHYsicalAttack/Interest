function NewCounter()
	local i = i or 0
	return function() 
		i=i+1 
		return i 
	end
end
c1=NewCounter()
print(c1(),c1())