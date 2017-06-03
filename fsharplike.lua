function func1(str)
    return function (str2)
        local output=string.format("[%s:]%s",str,str2) 
        print(output)
    end
end

debugp = func1("DEBUG")
debugp(123)