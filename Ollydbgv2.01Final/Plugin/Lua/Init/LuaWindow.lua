LuaWnd = {}
LuaWnd.g_table 		  = ffi.new("t_table")
LuaWnd.g_wndclassname = ffi.new("char[32]")
LuaWnd.WndTitle 	  = "字符串查询"
LuaWnd.FindString	  = {}

--处理Table窗口数据
function LuaWnd.DrawFunc(pc_s,pc_mark,pi_select,ph,column)
	local n = 0
	local buf = ffi.cast("char *",pc_s)
	if buf == nil then
		return n
	end
	if column == 0 then	
		local str = string.format("%08X",ph.addr)
		local addrbuf = ffi.cast("char *",str)
		ffi.copy(buf,addrbuf,#str)		
		n = #str
	elseif column == 1 and LuaWnd.FindString[ph.addr] then
		local str = LuaWnd.FindString[ph.addr][1]
		if str then
			local addrbuf = ffi.cast("char *",str)
			ffi.copy(buf,addrbuf,#str)	
			n = #str
		end
	elseif column == 2 and LuaWnd.FindString[ph.addr] then
		local str = LuaWnd.FindString[ph.addr][2]
		if str then
			local addrbuf = ffi.cast("char *",str)
			ffi.copy(buf,addrbuf,#str)	
			n = #str
		end
	end	
	return n
end

--lua查询
function LuaWnd.FilterString(Text)
	local fmt = ffi.cast("char *","%s")
	local ret,result
	if LuaWnd.FindString and Text then
		local tbl = LuaWnd.FindString
		for k,v in pairs(tbl) do
			ret,result = pcall(string.find,v[2],Text)
			if ret == true and result then
				Od.Addtolist(k,0,fmt,ffi.cast("char *",string.format("%-50s %s",v[1],v[2])))
			elseif ret == false then
				local errmsg = string.format("表达式不正确:%s",tostring(result))
				Od.Addtolist(k,2,fmt,ffi.cast("char *",errmsg))
				break
			end
		end
	end
end

function LuaWnd.Find(hWnd)
	local TextToFind = ffi.new("char[256]")
	if Od.Gettext(ffi.cast("char *","输出结果到log data窗口"),TextToFind,0,Od.CONST.NM_COMMENT,Od.CONST.FIXEDFONT) > 0 then
		LuaWnd.FilterString(ffi.string(TextToFind))
		Od.Createlistwindow()
	end
end

--消息回调
function LuaWnd.WndProc(hWnd,Msg,wParam,lParam)
	if Msg == WM_PAINT then		
		Od.Painttable(hWnd,LuaWnd.g_table,LuaWnd.DrawFuncCallBack)
		return 0
	elseif Msg == WM_USER_CHMEM
		or Msg == WM_USER_CHALL then
		ffi.C.InvalidateRect(hWnd,nil,0)
		return 0
	elseif  Msg == WM_DESTROY	
		 or Msg == WM_MOUSEMOVE
		 or Msg == WM_LBUTTONDOWN
		 or Msg == WM_LBUTTONDBLCLK
		 or Msg == WM_LBUTTONUP
		 or Msg == WM_RBUTTONDOWN
		 or Msg == WM_RBUTTONDBLCLK
		 or Msg == WM_HSCROLL
		 or Msg == WM_VSCROLL
		 or Msg == WM_TIMER
		 or Msg == WM_SYSKEYDOWN then
		Od.Tablefunction(ffi.cast("t_table *",LuaWnd.g_table),hWnd, Msg, wParam, lParam)
	elseif Msg == WM_USER_SCR
		or Msg == WM_USER_VABS
		or Msg == WM_USER_VREL
		or Msg == WM_USER_VBYTE
		or Msg == WM_USER_STS
		or Msg == WM_USER_CNTS
		or Msg == WM_USER_CHGS then	
		return Od.Tablefunction(LuaWnd.g_table,hWnd, Msg, wParam, lParam)
	elseif Msg == WM_WINDOWPOSCHANGED then
		return Od.Tablefunction(LuaWnd.g_table,hWnd, Msg, wParam, lParam)
	elseif Msg == WM_USER_DBLCLK then
		local ph = Od.Getsortedbyselection(LuaWnd.g_table.data,LuaWnd.g_table.data.selected)
		if ph then
			ph = ffi.cast("t_sortheader *",ph)
			Od.Setcpu(0,ph.addr,0,0,13)
		end
		return 1
	elseif Msg == WM_USER_MENU then
		--创建菜单
		local menu = ffi.C.CreatePopupMenu()
		local ph   = Od.Getsortedbyselection(LuaWnd.g_table.data,LuaWnd.g_table.data.selected)
		if menu and ph then	
            ffi.C.AppendMenuA(menu, 0, 1, "查询字符串,可使用Lua匹配模式\tCtrl+F")
		end
		local action = Od.Tablefunction(LuaWnd.g_table,hWnd,WM_USER_MENU,nil,menu)

		if menu then 
			ffi.C.DestroyMenu(menu)
		end
		if action == 1 then
			LuaWnd.Find(hWnd)
		end
		return 0
		
	elseif Msg == WM_KEYDOWN then
		local key = tonumber(ffi.cast("int",wParam))
		if key == 0x2D then
			LuaWnd.Find(hWnd)
		elseif key == 0x46 and ffi.C.GetKeyState(0x11) < 0  then
			--Ctrl+'F' or Ctrl+'f'
			LuaWnd.Find(hWnd)
		end	
		Od.Tablefunction(LuaWnd.g_table,hWnd, Msg, wParam, lParam)
	end
	return ffi.C.DefMDIChildProcA(hWnd,Msg,wParam,lParam)
end

--创建table窗口
function LuaWnd.CreateWindow()	
	
	if  LuaWnd.g_table.bar.nbar == 0 then
		LuaWnd.g_table.bar.name[0]  = ffi.cast("char *","地址")
		LuaWnd.g_table.bar.defdx[0] = 9
		LuaWnd.g_table.bar.mode[0]  = 0
		LuaWnd.g_table.bar.name[1]  =  ffi.cast("char *","反汇编")
		LuaWnd.g_table.bar.defdx[1] = 40
		LuaWnd.g_table.bar.mode[1]  = Od.CONST.BAR_NOSORT
		LuaWnd.g_table.bar.name[2]  = ffi.cast("char *","字符串")
		LuaWnd.g_table.bar.defdx[2] = 256
		LuaWnd.g_table.bar.mode[2]  = Od.CONST.BAR_NOSORT
		LuaWnd.g_table.bar.nbar     = 3

		LuaWnd.g_table.mode		  = bit.bor(Od.CONST.TABLE_COPYMENU,
											Od.CONST.TABLE_SORTMENU,
											Od.CONST.TABLE_APPMENU,
											Od.CONST.TABLE_SAVEPOS,
											Od.CONST.TABLE_ONTOP,
											Od.CONST.TABLE_HILMENU)
		LuaWnd.g_table.drawfunc = LuaWnd.DrawFuncCallBack
	end
	if LuaWnd.g_table.data.n > 0 then
		Od.Deletesorteddatarange(LuaWnd.g_table.data,0,0xFFFFFFFF)
	end
	
	Od.Quicktablewindow(
		LuaWnd.g_table,
        15,
        3,
        LuaWnd.g_wndclassname,
        ffi.cast("char *",LuaWnd.WndTitle)
    )	
end

--初始化窗口
function LuaWnd.InitWindow()
	local nRetCode	
	local cName = ffi.cast("char *","luasorted")
	local dllinst = ffi.C.GetModuleHandleA("LuaPlugin.dll")
	nRetCode = Od.Createsorteddata(
					LuaWnd.g_table.data,
					nil,
					ffi.sizeof("t_sortheader"),
					10,
					nil,
					nil
				)
	nRetCode = Od.Registerpluginclass(
					LuaWnd.g_wndclassname,
					nil,
					nil,
					LuaWnd.WndProc
				)
				
	--转成函数指针
	LuaWnd.DrawFuncCallBack = ffi.cast("DRAWFUNC *",LuaWnd.DrawFunc)
end

