function FileSaveLoad()
      local file = io.open("/Users/0280102pc0102/Desktop/orgin.lua", "r");
      assert(file);
      local data = file:read("*a"); -- 读取所有内容
      file:close();
      for i=1,10 do 
      	file = io.open("/Users/0280102pc0102/Desktop/".. i .. ".lua", "w");
      	assert(file);
      	file:write(data);
      	file:close();
      end
end
FileSaveLoad()