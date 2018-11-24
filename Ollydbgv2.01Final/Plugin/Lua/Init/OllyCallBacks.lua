function ODBG_Plugininit()
	--初始化
	LuaWnd.InitWindow()
end

function ODBG_Pluginmenu(origin) -- must return the menu string to be used
	if (origin == 0) then
		return "1 &执行文件,2 执行脚本 ,3 &关于..."
	end
	return ""
end


function ODBG_Pluginaction(origin,action)
	if (action == 1) then
		local FileName = ffi.new("char[260]",0)
		local File = Od.Browsefilename(ffi.cast("char *","选择脚本"),FileName,ffi.cast("char *","*.lua"),0)
		if (File == 1) then
			dofile(ffi.string(FileName))
		end
		return
	end
	if (action == 2) then
		local TextToFind = ffi.new("char[256]")
		if Od.Gettext(ffi.cast("char *","输入lua代码"),TextToFind,0,Od.CONST.NM_COMMENT,Od.CONST.FIXEDFONT) > 0 then
			loadstring(ffi.string(TextToFind),"line")()
		end
		return
	end
	if (action == 3) then
		ffi.C.MessageBoxA(nil,"OD lua插件\n FishSeeWater 克隆版\n http://bbs.pediy.com/showthread.php?t=175457\njasonnbfan原版\nhttp://bbs.pediy.com/showthread.php?t=149214","OD lua插件",0)
		return
	end
	return
end

function ODBG_Pausedex(reason, reg)
	if Od.CONST.PP_INT3BREAK==reason then
		--ffi.C.MessageBoxA(nil,OdPath .. "LuaScripts\\ProcessInt3.lua","",0)
		dofile(OdPath.."LuaScripts\\ProcessInt3.lua")		
		ProcessInt3(reg)
	end	
	return 1 -- 1 禁止重绘
	
end

		--local treg = ffi.cast("t_reg *",reg)
		--if treg then		
		--	local retBuf=ffi.new("t_result",0)
		--	Od.Expression(retBuf,"string [[esp]]" ,0,0,nil,0,0,Od.Getcputhreadid());	
		--	ffi.C.MessageBoxA(nil,retBuf.value,"ODBG_Pausedex",0)
			
			--ffi.C.MessageBoxA(nil,"DWORD [esp+4]" ,"ODBG_Pausedex",0)
				
			--ffi.cast("char *","string [esp+4]")		
		--end

			--local Msg = Od.Expression("DWORD [esp + 08]")
			--local Key = Od.Expression("DWORD [esp + 04]")	
			--local retBuf=ffi.new("t_result",0)
			--Od.Expression(retBuf,ffi.cast("char *","string [esp]") ,0,0,nil,0,0,0);			
			--local lretBuf=ffi.cast("t_result *",retBuf);			
			--ffi.C.MessageBoxA(nil,string.format("%s",lretBuf.value),"ODBG_Pausedex",0)
			
			--local retBuf=ffi.new("t_result",0)			
			--Od.Readmemory(buf,treg.r[4]+0 ,4,0);
		
			--local buf1=ffi.string(buf,4);			
			--buf1=string.reverse(buf1);
			--ffi.C.MessageBoxA(nil,string.format("%s",buf1),"ODBG_Pausedex",0)	
			--local add = tonumber( buf1 )
			--ffi.C.MessageBoxA(nil,string.format("%X",add),"ODBG_Pausedex",0)		
			--//ffi.C.MessageBoxA(nil,string.format("%X",treg.ip),"ODBG_Pausedex",0)
			--Od.Sendshortcut(0,0,WM_KEYDOWN,0,0,0x78)			
