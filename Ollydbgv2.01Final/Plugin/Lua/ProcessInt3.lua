function ProcessInt3(reg)
	local treg = ffi.cast("t_reg *",reg)
	if treg then		
		local retBuf=ffi.new("t_result",0)
		Od.Expression(retBuf,"DWORD [esp+0C]" ,0,0,nil,0,0,Od.Getcputhreadid());
		Od.Addtolist(0,0,"This is test Log  "..ffi.string(retBuf.value))	
	end

end