--批量重命名文件，文件名是连续数字
local targetfile="2016"
local movetofile="2016-6-17"
local fileformat =".jpg"

local filestartnum=1     --已有文件名+1

for i = 0,500 do
	if   os.rename(os.getenv("HOME").."/Desktop/" .. targetfile .. "/" .. i .. fileformat,
					os.getenv("HOME").. "/Desktop/" .. movetofile .. "/" .. filestartnum .. fileformat) then 
		--break 

		filestartnum = filestartnum +1
	end
end