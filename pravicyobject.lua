function NewAccount( initalbalance )
	local self = {balance = initalbalance}

	local withdraw =function ( v )
		self.balance = self.balance -v 
	end 

	local deposit = function (v)
		self.balance = self.balance +v 
	end

	local getbalance = function () 
		return self.balance
	end

	return {
			withdraw = withdraw,
			deposit =deposit,
			getbalance = getbalance,
		}
end


acc1 = NewAccount(100)
acc1.withdraw (40)
print(acc1.getbalance())

print(acc1.balance) --无法访问 self.balance
---对象的私密性，这种方法创建的对象，在创建后self无法被访问。
--当newaccount返回后，就无法直接访问这个table了只能通过方法来访问