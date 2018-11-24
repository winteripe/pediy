function IsGBK(Buf)
-- GBK 亦采用双字节表示，总体编码范围为 8140-FEFE，
-- 首字节在 81-FE 之间，尾字节在 40-FE 之间，
-- 剔除 xx7F 一条线。总计 23940 个码位，共收入 21886 个汉字和图形符号，其中汉字（包括部首和构件）21003 个，图形符号 883 个。
	local size = ffi.sizeof(Buf)
	local high
	local low
	--汉字范围 B0A1—F7FE
	for i=0,size,2 do
		low  = Buf[i]
		high = Buf[i+1]
		if high == 0 then
			break
		end
		if (low <= 0x80 or low >= 0xFE) == true or (high <= 0x40 or high >= 0xFE) == true then
			return 0
		end

	end
	return 1
end

function IsASCII(Buf)
	local size = ffi.sizeof(Buf)
	for i=0,size -1 do
		if Buf[i] == 0 then break end
		if Buf[i] <= 0x21 and Buf[i] >= 0x7e then
			return 0
		end
	end
	return 1
end

function IsUnicode(Buf)
	-- 中文范围 4E00-9FBF：CJK 统一表意符号 (CJK Unified Ideographs)
	local wordbuf = ffi.cast("wchar_t *",Buf)	
	local size = ffi.sizeof(Buf) / 2
	for i=0,size -1 do
		if wordbuf[i] == 0 then break end
		if wordbuf[i] <= 0x2100 and wordbuf[i] >= 0x9fbf then
			return 0
		end
	end
	return 1
end

function GetString(Address)
	local buf = ffi.new("char[256]",0)
	local txt
	Od.Readmemory(buf, Address, 256, bit.bor(0x01,0x02));
	if buf then
		-- txt = ffi.cast("char *",buf)
		-- if IsUnicode(txt) == 1 then
			-- 做unicode 处理
			-- local ulen = ffi.C.WideCharToMultiByte(0,0,ffi.cast("void *",buf),-1,nil,0,nil,nil)
			-- if ulen > 1 then
				-- txt = ffi.new("char[?]",ulen)
				-- ffi.C.WideCharToMultiByte(0,0,ffi.cast("void *",buf),-1,txt,ulen,nil,nil)
				-- local str = tostring(ffi.string(txt))
				-- if str ~= "" then
					-- return "UNICODE\t\t\t" .. tostring(ffi.string(txt))
					-- buf = ffi.cast("char *",tostring(ffi.string(txt)))
				-- end
			-- end
		-- end
		txt = ffi.cast("char *",buf)
		if IsASCII(txt) == 1 or IsGBK(txt) == 1 then
			--做ANSI处理			
			local str = tostring(ffi.string(txt))
			if str ~= "" then
				return tostring(ffi.string(txt))
			end
		end
	end
	return ""
end

function FindString()
	local cBase = ffi.new("ulong[1]",0)
	local cSize = ffi.new("ulong[1]",0)
	local MAXCMDSIZE = 16	
	local cmdsize
	local cmd = ffi.new("char[?]",MAXCMDSIZE)
	local da  = ffi.new("t_disasm")
	local mem
	local Text
	local tblstr = {}
	local count = 0
	local asmcode 
	local immconst
 	
	Od.Getdisassemblerrange(cBase,cSize)
	local dwBase,dwSize = cBase[0],cSize[0]
	
	local index = dwBase 
	while index <= dwBase + dwSize do
		Od.Readcommand(index,cmd);
		cmdsize = Od.Disasm(cmd,MAXCMDSIZE,index,nil,da,4,0)		
		asmcode = ffi.string(da.result)
		immconst = 0
		if asmcode:find("mov") or asmcode:find("lea") or asmcode:find("push") then
			if da.immconst ~= 0 then
				immconst = da.immconst
			elseif da.adrconst ~= 0 then
				immconst = da.adrconst
			end			
			mem = ffi.cast("t_memory *",Od.Findmemory(immconst))			
			if mem then
				Text = GetString(immconst)
				if Text ~= "" then
					tblstr[index] = {asmcode,Text}
					count = count + 1					
				end
			end			
		end	
		Od.Progress(math.ceil((index-dwBase) * 1000 / dwSize),"Search:%d", ffi.new("int",count))
		index = index + cmdsize 
	end
	Od.Progress(0,"$")
	return tblstr
end

--窗口显示
function FindStringShowInWindow()
	local tblstring   = FindString()
	LuaWnd.FindString = nil
	LuaWnd.FindString = tblstring	
	LuaWnd.CreateWindow()
	local mark = ffi.new("t_sortheader")
	for k,v in pairs(tblstring) do
		mark.addr = k
		mark.size = 1
		mark.type = 0
		Od.Addsorteddata(LuaWnd.g_table.data,mark)
	end	
end




