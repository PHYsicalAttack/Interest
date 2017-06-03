#! /usr/bin/env lua
-- fileheader 14bytes
-- infoheader 40bytes
-- 数据用小端储存方式
-- local fileheader = 
-- {
--     bfType = 2 byte,
--     bfSize = 4 byte,
--     bfReserved1 = 2 byte, must = 0,
--     bfReserved2 = 2 byte, must = 0,
--     bfOffBits = 4 byte,    

-- }
-- local infoheader = 
-- {
--     biSize = 4 byte, default = 40,
--     biWidth  = 4 byte,
--     biHeight  = 4 byte,
--     biPlanes = 2 byte, must =1,
--     biBitCount = 2 byte , 1/4/8/24/32
--     bitCompression = 4 byte
--     biSizeImage = 4 byte
--     biXPelsPerMeter = 4 byte    
--     biYPelsPerMeter = 4 byte
--     biClrUsed  = 4 byte 
--     biClrImortant = 4 byte
-- }

local BMP = {}
function BMP:new()
    local biBitCount = 24                -- 24bit/像素,也就是3byte/像素
    local biWidth = 512                  -- 默认256像素宽
    local biHeight = 512                 -- 默认256像素高
    local message  = string.format("生成24位位图,大小为 %d * %d ...",biWidth,biHeight)
    print(message)
    --  生成FHeader
    self:createFHeader(biWidth,biHeight,biBitCount)    
    --  生成IHeader
    self:createIHeader(biWidth,biHeight,biBitCount)
    local fname = "bmp_" .. os.date("%X"):gsub(":","") .. ".bmp"
    local file = io.open(fname,"wb")
    file:write(self.fheader)
    file:write(self.iheader)
    --  生成图像数据的方法,都是生成self.data(256*256的矩阵)

    --  空,随机生成各个像素点
    self:createRandomMap()
    
    if self.data then
        file:write(self.data)
    end
    file:close()
    os.execute("open " .. fname)  

    -- --  调用图像数据生成函数
    -- local bmp_data = self:creatSingleton()
    -- local function testBMP()
    --     local file = io.open("bmp.bmp","wb")
    --     file:write(self.fheader)
    --     file:write(self.iheader)
    --     file:write(bmp_data)
    --     file:close()
    -- end
    -- return testBMP
end

function BMP:createFHeader(biWidth,biHeight,biBitCount)
    self.bfType = 0x4D42
    self.bfSize = biWidth * biHeight * biBitCount/8 + 54     --写死54字节的header
    self.bfReserved1 = 0
    self.bfReserved2 = 0
    self.bfOffBits = 54                 -- 32位位图不要调色板,所以偏移54位后就是图像数据
    self.bfpackfmt = "<I2I4I2I2I4"
    print(string.format("文件大小为: %d ,文件头大小为: %d ",self.bfSize,string.packsize(self.bfpackfmt)))
    self.fheader = string.pack(self.bfpackfmt,self.bfType,self.bfSize,self.bfReserved1,self.bfReserved2,self.bfOffBits)
end


function BMP:createIHeader(biWidth,biHeight,biBitCount)
    self.biSize = 40                    -- infoheader头默认大小
    self.biWidth = biWidth
    self.biHeight = biHeight
    self.biPlanes = 1
    self.biBitCount = biBitCount
    self.bitCompression = 0
    self.biSizeImage = 0
    self.biXPelsPerMeter = 0
    self.biYPelsPerMeter = 0
    self.biClrUsed = 0
    self.biClrImortant = 0
    self.bipackfmt = "<I4I4i4I2I2I4I4I4I4I4I4"
    print(string.format("位图头大小为: %d ",string.packsize(self.bipackfmt)))   
    self.iheader = string.pack(self.bipackfmt,self.biSize,self.biWidth,self.biHeight,self.biPlanes,self.biBitCount,self.bitCompression,self.biSizeImage,self.biXPelsPerMeter,self.biYPelsPerMeter,self.biClrUsed,self.biClrImortant)
end

function BMP:createRandomData()
    local singlefmt  = "<I1I1I1"
    local tab_plex = {}
    math.randomseed(os.time())
    local b,g,r  = math.random(256)-1,math.random(256)-1,math.random(256)-1
    local randomspeed = 12800
    for i = 1, self.biWidth*self.biHeight,1 do
        if i%randomspeed == 0 then 
            b,g,r  = math.random(256)-1,math.random(256)-1,math.random(256)-1
        end
        table.insert(tab_plex,string.pack(singlefmt,b,g,r))
    end
    self.data = table.concat(tab_plex)
end

function BMP:createSingleData (b,g,r)
    local b = tonumber(b) or 0
    local g = tonumber(g) or 255
    local r = tonumber(r) or 0
    local singlefmt  = "<I1I1I1"
    local tab_plex = {}
    for i = 1, self.biWidth* self.biHeight,1 do
         table.insert(tab_plex,string.pack(singlefmt,b,g,r))
    end
    self.data = table.concat(tab_plex)
end

function BMP:creatFuncData (tab_arg)

end

function BMP:createRandomMap(diffcult)
    -- 一个点具有实际表示 4*4的像素
    local plex_per_cell = 4
    local clr_open = {255,255,255}
    local clr_close = {0,0,0}
    -- 要生成的是64*64的0/1矩阵,如果false就是堵住的点,如果是true是开服的点
    local row,column = self.biWidth/plex_per_cell,self.biHeight/plex_per_cell
    local map = {}
    local singlefmt  = "<I1I1I1"
    local tab_plex = {}
    local diffcult = diffcult or 5
    math.randomseed(os.time())
    for i = 1,row do 
        for j =1,column do 
            local var = math.random(10) 
            if var>diffcult then
                map[row*(i-1)+j] = true
            else
                map[row*(i-1)+j] = false
            end
        end
    end
    print()
    -- 开始生成self.data 表,通过map表坐标映射生成self.data
    for i,isopen in ipairs(map) do
        local map_column = i%(column)
        if map_column ==0 then map_column = column end
        local map_row = (i - map_column)//row +1
        --print(map_row,map_column)
        --  map_row,map_column  都乘以4映射一个数组出来,再根据数据算出在self.data中的索引
        local map_t ={}
        for k = (map_row-1)*plex_per_cell,map_row*plex_per_cell do
            for j = (map_column-1)*plex_per_cell,map_column*plex_per_cell do 
                -- print(map_row,map_column, "=> ",k,j )
                table.insert(map_t,{k,j})
            end
        end

        for _,pos in ipairs(map_t) do
            local k,j = table.unpack(pos)
            --print(k,j)
            if isopen then
                tab_plex[(k-1)*self.biWidth + j] = string.pack(singlefmt,clr_open[1],clr_open[2],clr_open[3])
            else
                tab_plex[(k-1)*self.biWidth + j] = string.pack(singlefmt,clr_close[1],clr_close[2],clr_close[3])
            end
        end
    end
    self.data = table.concat(tab_plex)
end


BMP:new()
