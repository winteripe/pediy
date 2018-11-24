function SaveBreakPoint()
	local BreakPointTable = ffi.cast("t_table *",Od.Plugingetvalue(Od.CONST.VAL_BREAKPOINTS))
	local ProcessName	  = ffi.string(ffi.cast("char *",Od.Plugingetvalue(Od.CONST.VAL_PROCESSNAME)))
	local n = BreakPointTable.data.n
	
	local SaveBreak = {}	
	if n > 0 then
		for i=0,n - 1 do
			local data = Od.Getsortedbyselection(BreakPointTable.data,i)
			local head = ffi.cast("int *",data)
			--addr = {type,asmcode}
			SaveBreak[head[0]] = {head[2],head[3]}
		end
		
		-- 保存表到文件
		local strtbl = "{"
		for k,v in pairs(SaveBreak) do
			strtbl = strtbl .. string.format("[%s] = {%s},",k,table.concat(v,","))
		end
		strtbl = strtbl .. "}"

		file = io.open(ProcessName .. ".breakpoint","w")
		file:write(strtbl)
		file:close()
	end
end
-- SaveBreakPoint()
--读取断点
function LoadBreakPoint(FileName)
	FileName = FileName or ffi.string(ffi.cast("char *",Od.Plugingetvalue(Od.CONST.VAL_PROCESSNAME))) .. ".breakpoint"
	local file = assert(io.open(FileName,"r"))
	local strtbl = file:read("*all")
	file:close()
	local breaktbl = loadstring(string.format("return %s",strtbl))()
	for k,v in pairs(breaktbl) do
		Od.Setbreakpoint(k,Od.CONST.TY_ACTIVE,0)
		Od.Broadcast(WM_USER_CHALL, nil, nil)
	end
end
