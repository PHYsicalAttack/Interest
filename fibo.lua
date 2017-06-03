function fibo(n)
   if n <3 then 
        return 1
    else 
        return fibo(n-2) +fibo(n-1)
    end
end
print(fibo(40))