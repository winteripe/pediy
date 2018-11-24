
--获取模块导出表函数
function GetModuleEAT(mBase)
	local tbl = {}
	local base  	= mBase or ffi.cast("char *",ffi.C.GetModuleHandleA(nil))
	local PDOS  	= ffi.cast("PIMAGE_DOS_HEADER",base)
	local PNT   	= ffi.cast("PIMAGE_OPTIONAL_HEADER32",base + (PDOS.e_lfanew + 24))
	local PEXPORT   = ffi.cast("PIMAGE_EXPORT_DIRECTORY",base + PNT.DataDirectory[0].VirtualAddress)

	local pAddressOfFuns  		 = ffi.cast("DWORD *",base + PEXPORT.AddressOfFunctions)
	local pAddressOfNames 		 = ffi.cast("DWORD *",base + PEXPORT.AddressOfNames)
	local pAddressOfNameOrdinals = ffi.cast("WORD  *",base + PEXPORT.AddressOfNameOrdinals)

	for i= 0,PEXPORT.NumberOfNames -1 do
		local index = pAddressOfNameOrdinals[i]
		local addr  = pAddressOfFuns[index];
		local pFuncName = ffi.cast("char *",base + pAddressOfNames[i])
		tbl[ffi.string(pFuncName)] = base + addr
	end
	return tbl
end
--获取导入表
function GetModuleIAT(mBase)
	local tbl = {}
	local base  	= mBase or ffi.cast("char *",ffi.C.GetModuleHandleA(nil))
	local PDOS  	= ffi.cast("PIMAGE_DOS_HEADER",base)
	local PNT   	= ffi.cast("PIMAGE_OPTIONAL_HEADER32",base + (PDOS.e_lfanew + 24))
	local PEXPORT   = ffi.cast("PIMAGE_EXPORT_DIRECTORY",base + PNT.DataDirectory[0].VirtualAddress)

	local pAddressOfFuns  		 = ffi.cast("DWORD *",base + PEXPORT.AddressOfFunctions)
	local pAddressOfNames 		 = ffi.cast("DWORD *",base + PEXPORT.AddressOfNames)
	local pAddressOfNameOrdinals = ffi.cast("WORD  *",base + PEXPORT.AddressOfNameOrdinals)

	for i= 0,PEXPORT.NumberOfNames -1 do
		local index = pAddressOfNameOrdinals[i]
		local addr  = pAddressOfFuns[index];
		local pFuncName = ffi.cast("char *",base + pAddressOfNames[i])
		tbl[ffi.string(pFuncName)] = base + addr
	end
	return tbl
end

function LoopEBPLDR()
	local PEB = "\x64\xA1\x30\x00\x00\x00\xC3"
	local GetPEB = ffi.cast("int (*)()",PEB)
	Od.Message(GetPEB(),"PEB")
	-- print(bit.tohex(GetPEB()))
end

--获取所有模块导出表函数
function GetAllModuleFunc()
	local MODULES = ffi.cast("t_table *",Od.Plugingetvalue(Od.CONST.VAL_MODULES))
	local n = MODULES.data.n
	local tbl_Funcs = {}	
	if n > 0 then
		for i=0,n - 1 do
			local data = Od.Getsortedbyselection(MODULES.data,i)
			local head = ffi.cast("t_sortheader *",data)
			local data = ffi.cast("int *",data)
			local functbl = GetModuleEAT(head.addr)
			for k,v in pairs(functbl) do
				tbl_Funcs[k] = v
				Od.Message(v,k)
			end			
		end
	end
	return tbl_Funcs
end


