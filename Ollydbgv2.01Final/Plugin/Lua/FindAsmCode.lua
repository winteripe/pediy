function DisasmAllCode(Base,Size)	
	local cmdsize	
	local mem
	local Text
	local tblAsm = {}
	local count = 0
	local asmcode 
	local dwBase,dwSize
	local cmd = ffi.new("char[?]",Od.CONST.MAXCMDSIZE)
	local da  = ffi.new("t_disasm")
	
	if Base == nil or Size == nil then
		local cBase = ffi.new("ulong[1]",0)
		local cSize = ffi.new("ulong[1]",0)
		Od.Getdisassemblerrange(cBase,cSize)
		dwBase,dwSize = cBase[0],cSize[0]
	else
		dwBase,dwSize = Base,Size
	end
	
	local index = dwBase 
	while index <= dwBase + dwSize do
		Od.Readcommand(index,cmd);
		cmdsize = Od.Disasm(cmd,Od.CONST.MAXCMDSIZE,index,nil,da,4,0)		
		asmcode = ffi.string(da.result)
		table.insert(tblAsm,{index,asmcode})
		Od.Progress(math.ceil((index-dwBase) * 1000 / dwSize),"Search:%d", ffi.new("int",count))
		index = index + cmdsize 		
	end
	Od.Progress(0,"$")
	return tblAsm
end

--搜索汇编指令
function FindAsm(reg)
	local flag,result = pcall(string.find,"",reg)
	if flag == false then
		Od.Addtolist(0,1,string.format("表达式不正确:%s",tostring(result)))
		return 
	end
	local tbl = DisasmAllCode()	
	for k,v in pairs(tbl) do
		if v[2]:find(reg) then
			Od.Addtolist(v[1],0,v[2])
		end
	end
end





