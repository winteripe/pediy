if ffi == nil then
	ffi = require("ffi")
end
ffi.cdef
[[
	typedef unsigned char  uchar;
	typedef unsigned short ushort;
	typedef unsigned int    uint; 
	typedef unsigned int    UINT; 
	typedef unsigned long   ulong;
	typedef unsigned short  WORD;
	typedef long  LONG;
	typedef unsigned long DWORD;
	typedef unsigned char BYTE;
	typedef unsigned char BYTE;
	typedef void *HWND;
	typedef void *HANDLE;	
	typedef void *HINSTANCE;
	typedef long * WPARAM;
	typedef long * LPARAM;	
	
	typedef long (__stdcall * WNDPROC)(HWND, UINT, WPARAM, LPARAM);
	
	typedef struct t_sortheader {          // Header of sorted data field
		ulong          addr;                 // Base address of the entry
		ulong          size;                 // Size address of the entry
		ulong          type;                 // Entry type, TY_xxx
	} t_sortheader;
	
	typedef int  SORTFUNC(const t_sortheader *,const t_sortheader *,const int);
	typedef int  DRAWFUNC(char *,char *,int *,t_sortheader *,int);
	typedef void DESTFUNC(t_sortheader *);
	
	typedef struct _IMAGE_DOS_HEADER 
	{      // DOS .EXE header
		WORD   e_magic;                     // Magic number
		WORD   e_cblp;                      // Bytes on last page of file
		WORD   e_cp;                        // Pages in file
		WORD   e_crlc;                      // Relocations
		WORD   e_cparhdr;                   // Size of header in paragraphs
		WORD   e_minalloc;                  // Minimum extra paragraphs needed
		WORD   e_maxalloc;                  // Maximum extra paragraphs needed
		WORD   e_ss;                        // Initial (relative) SS value
		WORD   e_sp;                        // Initial SP value
		WORD   e_csum;                      // Checksum
		WORD   e_ip;                        // Initial IP value
		WORD   e_cs;                        // Initial (relative) CS value
		WORD   e_lfarlc;                    // File address of relocation table
		WORD   e_ovno;                      // Overlay number
		WORD   e_res[4];                    // Reserved words
		WORD   e_oemid;                     // OEM identifier (for e_oeminfo)
		WORD   e_oeminfo;                   // OEM information; e_oemid specific
		WORD   e_res2[10];                  // Reserved words
		LONG   e_lfanew;                    // File address of new exe header
	} IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;
  
	typedef struct _IMAGE_EXPORT_DIRECTORY {
		DWORD   Characteristics;
		DWORD   TimeDateStamp;
		WORD    MajorVersion;
		WORD    MinorVersion;
		DWORD   Name;
		DWORD   Base;
		DWORD   NumberOfFunctions;
		DWORD   NumberOfNames;
		DWORD   AddressOfFunctions;     // RVA from base of image
		DWORD   AddressOfNames;         // RVA from base of image
		DWORD   AddressOfNameOrdinals;  // RVA from base of image
	} IMAGE_EXPORT_DIRECTORY, *PIMAGE_EXPORT_DIRECTORY;
	
	typedef struct _IMAGE_DATA_DIRECTORY 
	{
		DWORD   VirtualAddress;
		DWORD   Size;
	} IMAGE_DATA_DIRECTORY, *PIMAGE_DATA_DIRECTORY;
	
	typedef struct _IMAGE_OPTIONAL_HEADER 
	{
		WORD    Magic;
		BYTE    MajorLinkerVersion;
		BYTE    MinorLinkerVersion;
		DWORD   SizeOfCode;
		DWORD   SizeOfInitializedData;
		DWORD   SizeOfUninitializedData;
		DWORD   AddressOfEntryPoint;
		DWORD   BaseOfCode;
		DWORD   BaseOfData;
		DWORD   ImageBase;
		DWORD   SectionAlignment;
		DWORD   FileAlignment;
		WORD    MajorOperatingSystemVersion;
		WORD    MinorOperatingSystemVersion;
		WORD    MajorImageVersion;
		WORD    MinorImageVersion;
		WORD    MajorSubsystemVersion;
		WORD    MinorSubsystemVersion;
		DWORD   Win32VersionValue;
		DWORD   SizeOfImage;
		DWORD   SizeOfHeaders;
		DWORD   CheckSum;
		WORD    Subsystem;
		WORD    DllCharacteristics;
		DWORD   SizeOfStackReserve;
		DWORD   SizeOfStackCommit;
		DWORD   SizeOfHeapReserve;
		DWORD   SizeOfHeapCommit;
		DWORD   LoaderFlags;
		DWORD   NumberOfRvaAndSizes;
		IMAGE_DATA_DIRECTORY DataDirectory[16];
	} IMAGE_OPTIONAL_HEADER32, *PIMAGE_OPTIONAL_HEADER32;

	typedef struct t_memory 
	{              
		ulong          base;           
		ulong          size;           
		ulong          type;           
		ulong          owner;          
		ulong          initaccess;     
		ulong          access;         
		ulong          threadid;       
		char           sect[8]; 
		uchar          *copy;          
		ulong          reserved[8];    
	}t_memory;

	typedef struct t_operand 
	{             							 // Full decription of command's operand
		char           optype;               // DEC_xxx (mem) or DECR_xxx (reg,const)
		char           opsize;               // Size of operand
		char           regscale[8];          // Scales of registers
		char           seg;                  // Segment register
		ulong          opconst;              // Constant
	} t_operand;

	typedef struct t_disasm 
	{              
		ulong          ip;               
		char           dump[256];        
		char           result[256];      
		char           comment[256];     
		char           opinfo[3][256];   
		int            cmdtype;          
		int            memtype;         
		int            nprefix;          
		int            indexed;          
		ulong          jmpconst;         
		ulong          jmptable;         
		ulong          adrconst;         
		ulong          immconst;         
		int            zeroconst;        
		int            fixupoffset;      
		int            fixupsize;           
		ulong          jmpaddr;             
		int            condition;           
		int            error;                
		int            warnings;             
		int            optype[3];            
		int            opsize[3];            
		int            opgood[3];            
		ulong          opaddr[3];            
		ulong          opdata[3];            
		t_operand      op[3];                
		ulong          regdata[8];           
		int            regstatus[8];         
		ulong          addrdata;             
		int            addrstatus;           
		ulong          regstack[32];  
		int            rststatus[32]; 
		int            nregstack;            
		ulong          reserved[29];         
	}t_disasm;
	
	typedef struct t_sorted {              // Descriptor of sorted table
		char           name[260];       // Name of table, as appears in error
		int            n;                    // Actual number of entries
		int            nmax;                 // Maximal number of entries
		int            selected;             // Index of selected entry or -1
		ulong          seladdr;              // Base address of selected entry
		int            itemsize;             // Size of single entry
		ulong          version;              // Unique version of table
		void           *data;                // Entries, sorted by address
		SORTFUNC       *sortfunc;            // Function which sorts data or NULL
		DESTFUNC       *destfunc;            // Destructor function or NULL
		int            sort;                 // Sorting criterium (column)
		int            sorted;               // Whether indexes are sorted
		int            *index;               // Indexes, sorted by criterium
		int            suppresserr;          // Suppress multiple overflow errors
	}t_sorted;
	
	typedef struct t_bar {
		int            nbar;                 // Number of active columns
		int            font;                 // Font used for bar segments
		int            dx[17];             // Actual widths of columns, pixels
		int            defdx[17];          // Default widths of columns, chars
		char           *name[17];          // Column names (may be NULL)
		uchar          mode[17];           // Combination of BAR_xxx bits
		int            captured;             // One of CAPT_xxx, set to CAPT_FREE
		int            active;               // Info about how mouse is captured
		int            prevx;                // Previous mouse coordinate
	} t_bar;

	typedef struct t_table {               // Window with sorted data and bar
		HWND           hw;                   // Handle of window or NULL
		t_sorted       data;                 // Sorted data
		t_bar          bar;                  // Description of bar
		int            showbar;              // Bar: 1-displayed, 0-hidden, -1-absent
		short          hscroll;              // Horiz. scroll: 1-displayed, 0-hidden
		short          colsel;               // Column in TABLE_COLSEL window
		int            mode;                 // Combination of bits TABLE_xxx
		int            font;                 // Font used by window
		short          scheme;               // Colour scheme used by window
		short          hilite;               // Syntax highlighting used by window
		int            offset;               // First displayed row
		int            xshift;               // Shift in X direction, pixels
		DRAWFUNC       *drawfunc;            // Function which decodes table fields
	}t_table;
	
	typedef struct t_result {              // Result of expression's evaluation
		int            type;                 // Type of expression, DEC(R)_xxx
		int            dtype;                // Type of data, DEC_xxx
		//union {
		uchar        data[10];             // Binary form of expression's value
		//ulong        u;                    // Value as unsigned integer
		//long         l;                    // Value as signed integer
		//long double  f; };                 // Value as 80-bit float
		union {
		char         value[256];       // ASCII form of expression's value
		wchar_t      wvalue[128]; }; // UNICODE form of expression's value
		ulong          lvaddr;               // Address of lvalue or NULL
	} t_result;

	int __stdcall MultiByteToWideChar(int cp, int flag, const char* src, int srclen, char* dst, int dstlen);
	int __stdcall WideCharToMultiByte(int cp, int flag, wchar_t *src, int srclen, char* dst, int dstlen, const char* defchar, int* used);
	int __stdcall MessageBoxA(void * hWnd,const char *lpText,const char *lpCaption,uint uType);
	uint __stdcall GetModuleHandleA(const char* lpModuleName); 
	long __stdcall DefMDIChildProcA(HWND hWnd,UINT uMsg,WPARAM wParam,LPARAM lParam);
	long __stdcall DefMDIChildProcW(HWND hWnd,UINT uMsg,WPARAM wParam,LPARAM lParam);
	int __stdcall InvalidateRect(HWND hWnd,const void *lpRect,int bErase);	
	typedef DWORD (__stdcall *PTHREAD_START_ROUTINE)(void * lpThreadParameter);
	void* __stdcall CreateThread(void *,long,PTHREAD_START_ROUTINE,void *,DWORD,DWORD *);
	typedef void * HMENU; 
	HMENU __stdcall CreatePopupMenu(void);
	int __stdcall AppendMenuA(HMENU hMenu,UINT uFlags,UINT uIDNewItem,const char *lpNewItem);
	int __stdcall DestroyMenu(HMENU hMenu);
	char * __stdcall GetCommandLineA(void);
	short __stdcall GetKeyState(int nVirtKey);
	int __stdcall AllocConsole();
	HANDLE __stdcall GetStdHandle(DWORD nStdHandle);
	
	typedef struct t_reg {                 // Excerpt from context
		int            modified;             // Some regs modified, update context
		int            modifiedbyuser;       // Among modified, some modified by user
		int            singlestep;           // Type of single step, SS_xxx
		ulong          r[8];                 // EAX,ECX,EDX,EBX,ESP,EBP,ESI,EDI
		ulong          ip;                   // Instruction pointer (EIP)
		ulong          flags;                // Flags
		int            top;                  // Index of top-of-stack
		long double    f[8];                 // Float registers, f[top] - top of stack
		char           tag[8];               // Float tags (0x3 - empty register)
		ulong          fst;                  // FPU status word
		ulong          fcw;                  // FPU control word
		ulong          s[6];                 // Segment registers ES,CS,SS,DS,FS,GS
		ulong          base[6];              // Segment bases
		ulong          limit[6];             // Segment limits
		char           big[6];               // Default size (0-16, 1-32 bit)
		ulong          dr6;                  // Debug register DR6
		ulong          threadid;             // ID of thread that owns registers
		ulong          lasterror;            // Last thread error or 0xFFFFFFFF
		int            ssevalid;             // Whether SSE registers valid
		int            ssemodified;          // Whether SSE registers modified
		char           ssereg[8][16];        // SSE registers
		ulong          mxcsr;                // SSE control and status register
		int            selected;             // Reports selected register to plugin
		ulong          drlin[4];             // Debug registers DR0..DR3
		ulong          dr7;                  // Debug register DR7
	} t_reg;
]]
-- end
if Od == nil then
	Od = {}
end


--常量
Od.CONST = 
{
 TEXTLEN       = 256,            
 ARGLEN        = 1024,           
 USERLEN       = 4096,           
 SHORTLEN      = 8,          
 BLACK         = 0,             
 BLUE          = 1,             
 GREEN         = 2,             
 CYAN          = 3,             
 RED           = 4,
 MAGENTA       = 5,
 BROWN         = 6,
 LIGHTGRAY     = 7,
 DARKGRAY      = 8,
 LIGHTBLUE     = 9,
 LIGHTGREEN    = 10,
 LIGHTCYAN     = 11,
 LIGHTRED      = 12,
 LIGHTMAGENTA  = 13,
 YELLOW        = 14,
 WHITE         = 15,
 MINT          = 16,
 SKYBLUE       = 17,
 IVORY         = 18,
 GRAY          = 19,
 NCOLORS       = 20,   
 BKTRANSP      = 0x00,            
 BKBLACK       = 0x10,
 BKGRAY        = 0x20,
 BKWHITE       = 0x30,
 BKCYAN        = 0x40,
 BKGREEN       = 0x50,
 BKRED         = 0x60,
 BKYELLOW      = 0x70,
 BLACKWHITE    = 0,              
 BLUEGOLD      = 1,
 SKYWIND       = 2,
 NIGHTSTARS    = 3,
 SCHEME4       = 4,
 SCHEME5       = 5,
 SCHEME6       = 6,
 SCHEME7       = 7,

 FIXEDFONT     = 0,               
 TERMINAL6     = 1,               
 FIXEDSYS      = 2,               
 COURIERFONT   = 3,
 LUCIDACONS    = 4,
 FONT5         = 5,
 FONT6         = 6,
 FONT7         = 7,
 MAINFONT      = 8,
 SYSFONT       = 9,
 INFOFONT      = 10,
 
 ADC_DEFAULT   = 0x0000,          
 ADC_DIFFMOD   = 0x0001,          
 ADC_NOMODNAME = 0x0002,          
 ADC_VALID     = 0x0004,          
 ADC_INMODULE  = 0x0008,          
 ADC_SAMEMOD   = 0x0010,          
 ADC_SYMBOL    = 0x0020,          
 ADC_JUMP      = 0x0040,          
 ADC_OFFSET    = 0x0080,          
 ADC_STRING    = 0x0100,          
 ADC_ENTRY     = 0x0200,          
 ADC_UPPERCASE = 0x0400,          
 ADC_WIDEFORM  = 0x0800,          
 ADC_NONTRIVIAL= 0x1000,          
 ADC_DYNAMIC   = 0x2000,          
 PLAINASCII    = 0x01,            
 DIACRITICAL   = 0x02,            
 RAREASCII     = 0x10,
 NBAR          = 17,              
 BAR_PRESSED   = 0x01,            
 BAR_DISABLED  = 0x02,            
 BAR_NOSORT    = 0x04,            
 BAR_NORESIZE  = 0x08,            
 BAR_BUTTON    = 0x10,            
 BAR_SHIFTSEL  = 0x20,            
 CAPT_FREE     = 0,               
 TABLE_DIR     = 0x0001,         
 TABLE_COPYMENU= 0x0002,         
 TABLE_SORTMENU= 0x0004,         
 TABLE_APPMENU = 0x0010,         
 TABLE_WIDECOL = 0x0020,         
 TABLE_USERAPP = 0x0040,         
 TABLE_USERDEF = 0x0080,         
 TABLE_NOHSCR  = 0x0100,         
 TABLE_SAVEPOS = 0x0200,         
 TABLE_CPU     = 0x0400,         
 TABLE_FASTSEL = 0x0800,         
 TABLE_COLSEL  = 0x1000,         
 TABLE_SAVEAPP = 0x2000,         
 TABLE_HILMENU = 0x4000,         
 TABLE_ONTOP   = 0x8000,         
 DRAW_NORMAL   = 0x0000,         
 DRAW_GRAY     = 0x0001,         
 DRAW_HILITE   = 0x0002,         
 DRAW_UL       = 0x0004,         
 DRAW_SELECT   = 0x0008,         
 DRAW_EIP      = 0x0010,         
 DRAW_BREAK    = 0x0020,         
 DRAW_GRAPH    = 0x0040,         
 DRAW_DIRECT   = 0x0080,         
 DRAW_MASK     = 0x0080,         
 DRAW_EXTSEL   = 0x0100,         
 DRAW_UNICODE  = 0x0200,         
 DRAW_TOP      = 0x0400,         
 DRAW_BOTTOM   = 0x0800,
 NM_COMMENT    = 0x36,
 TY_ACTIVE     = 0x00000200, 
 VAL_BREAKPOINTS = 44,
 VAL_PROCESSNAME = 25,
 VAL_MODULES     = 41,
 MAXCMDSIZE 	 = 16,

--// ODBG_Paused(), ODBG_Pausedex() and ODBG_Plugincmd().
PP_MAIN          =    0x0003,  	--// Mask to extract main reason
PP_EVENT         =    0x0000,  	--// Paused on debugging event
PP_PAUSE         =    0x0001,  	--// Paused on user's request
PP_TERMINATED    =    0x0002,  	--// Application terminated
--// Extended reasons in ODBG_Pausedex().
PP_BYPROGRAM     =      0x0004,  --// Debugging event caused by program
PP_INT3BREAK     =      0x0010,  --// INT3 breakpoint
PP_MEMBREAK      =      0x0020,  --// Memory breakpoint
PP_HWBREAK       =      0x0040,  --// Hardware breakpoint
PP_SINGLESTEP    =      0x0080,  --// Single-step trap
PP_EXCEPTION     =      0x0100,  --// Exception, like division by 0
PP_ACCESS        =      0x0200,  --// Access violation
PP_GUARDED       =      0x0400,  --// Guarded page
	
}
--消息
WM_USER	      = 0x400 

WM_SYSKEYDOWN 		= WM_USER
WM_PAINT      		= 0x00F
WM_WINDOWPOSCHANGED = 0x0047
WM_DESTROY 			= 0x002
WM_LBUTTONDOWN    	= 0x0201
WM_LBUTTONUP      	= 0x0202
WM_LBUTTONDBLCLK  	= 0x0203
WM_RBUTTONDOWN    	= 0x0204
WM_RBUTTONUP      	= 0x0205
WM_RBUTTONDBLCLK  	= 0x0206
WM_HSCROLL 			= 0x0114
WM_VSCROLL 			= 0x0115
WM_TIMER   			= 0x0113
WM_MOUSEMOVE 		= 0x0200
WM_KEYDOWN			= 0x100
WM_USER_DBLCLK 		= WM_USER + 111
WM_USER_CHMEM 		= WM_USER + 117
WM_USER_CHGS  		= WM_USER + 109
WM_USER_MENU 		= WM_USER + 101
WM_USER_SCR  		= WM_USER+102
WM_USER_VABS 		= WM_USER+104
WM_USER_VREL 		= WM_USER+105 
WM_USER_VBYTE 		= WM_USER+106
WM_USER_STS   		= WM_USER+107
WM_USER_CNTS  		= WM_USER+108
WM_USER_CHGS  		= WM_USER+109
WM_USER_CHALL 		= WM_USER+116

--获取导出函数
local base  	= ffi.cast("char *",ffi.C.GetModuleHandleA(nil))
local PDOS  	= ffi.cast("PIMAGE_DOS_HEADER",base)
local PNT   	= ffi.cast("PIMAGE_OPTIONAL_HEADER32",base + (PDOS.e_lfanew + 24))
local PEXPORT   = ffi.cast("PIMAGE_EXPORT_DIRECTORY",base + PNT.DataDirectory[0].VirtualAddress)

local pAddressOfFuns  		 = ffi.cast("DWORD *",base + PEXPORT.AddressOfFunctions)
local pAddressOfNames 		 = ffi.cast("DWORD *",base + PEXPORT.AddressOfNames)
local pAddressOfNameOrdinals = ffi.cast("WORD *",base + PEXPORT.AddressOfNameOrdinals)

for i= 0,PEXPORT.NumberOfNames -1 do
	local index = pAddressOfNameOrdinals[i]
	local addr  = pAddressOfFuns[index];
	local pFuncName = ffi.cast("char *",base + pAddressOfNames[i])
	Od[ffi.string(pFuncName)] = base + addr
end


-- 转换函数,_开头是导出表的函数地址，用ffi.cast 转换成函数
Od.Sendshortcut 		= ffi.cast("void __cdecl (*)(int where,ulong addr,int msg,int ctrl,int shift,int vkcode)",Od._Sendshortcut)
Od.Expression 			= ffi.cast("int __cdecl (*)(t_result *result,const char *expression,int a,int b,uchar *data,ulong database,ulong datasize,ulong threadid)",Od._Expression)
Od.Getcputhreadid 		= ffi.cast("ulong __cdecl (*)(void)",Od._Getcputhreadid)
Od.Browsefilename 		= ffi.cast("int __cdecl (*)(char *title,char *name,char *defext,int getarguments)",Od._Browsefilename)
Od.Addtolist 			= ffi.cast("void __cdecl (*)(long addr,int highlight,const char *format,...)",Od._Addtolist)
Od.Message 				= ffi.cast("void __cdecl (*)(long addr,const char *format,...)",Od._Message)
Od.Getdisassemblerrange = ffi.cast("void __cdecl (*)(ulong *pbase,ulong *psize)",Od._Getdisassemblerrange)
Od.Findmemory 			= ffi.cast("t_memory * __cdecl (*)(ulong addr)",Od._Findmemory)
Od.Readmemory 			= ffi.cast("ulong __cdecl (*)(void *buf,ulong addr,ulong size,int mode)",Od._Readmemory)
Od.Writememory 			= ffi.cast("ulong __cdecl (*)(void *buf,ulong addr,ulong size,int mode)",Od._Writememory)
Od.Readcommand 			= ffi.cast("ulong __cdecl (*)(ulong ip,char *cmd)",Od._Readcommand)
Od.Addsorteddata 		= ffi.cast("void * __cdecl (*)(t_sorted *sd,void *item)",Od._Addsorteddata)
Od.Disasm 				= ffi.cast("ulong __cdecl (*)(uchar *src,ulong srcsize,ulong srcip,uchar *srcdec,t_disasm *disasm,int disasmmode,ulong threadid)",Od._Disasm)
Od.Quicktablewindow 	= ffi.cast("HWND __cdecl (*)(t_table *pt,int nlines,int maxcolumns,char *winclass,char *wintitle)",Od._Quicktablewindow)
Od.Createsorteddata 	= ffi.cast("int __cdecl (*)(t_sorted *sd,char *name,int itemsize,int nmax,SORTFUNC *sortfunc,DESTFUNC *destfunc)",Od._Createsorteddata)
Od.Registerpluginclass 	= ffi.cast("int __cdecl (*)(char *classname,char *iconname,HINSTANCE dllinst,WNDPROC classproc)",Od._Registerpluginclass)
Od.Painttable 			= ffi.cast("void __cdecl (*)(HWND hwnd,t_table *pt,DRAWFUNC getline)",Od._Painttable)
Od.Tablefunction 		= ffi.cast("int __cdecl (*)(t_table *pt,HWND hw,UINT msg,WPARAM wp,LPARAM lp)",Od._Tablefunction)
Od.Createlistwindow 	= ffi.cast("HWND __cdecl (*)(void)",Od._Createlistwindow)
Od.Createwinwindow   	= ffi.cast("HWND __cdecl (*)(void)",Od._Createwinwindow)
Od.Insertname   		= ffi.cast("int __cdecl (*)(ulong addr,int type,char *name)",Od._Insertname)
Od.Addsorteddata   		= ffi.cast("void* __cdecl (*)(t_sorted *sd,void *item)",Od._Addsorteddata)
Od.Getsortedbyselection	= ffi.cast("void* __cdecl (*)(t_sorted *sd,int index)",Od._Getsortedbyselection)
Od.Setcpu		  		= ffi.cast("void  __cdecl (*)(ulong threadid,ulong asmaddr,ulong dumpaddr,ulong stackaddr,int mode)",Od._Setcpu)
Od.Progress		  		= ffi.cast("void  __cdecl (*)(int promille,const char *format,...)",Od._Progress)
Od.Deletesorteddatarange= ffi.cast("void  __cdecl (*)(t_sorted *sd,ulong addr0,ulong addr1)",Od._Deletesorteddatarange)
Od.Newtablewindow		= ffi.cast("void  __cdecl (*)(t_table *pt,int nlines,int maxcolumns,char *winclass,char *wintitle)",Od._Newtablewindow)
Od.Gettext				= ffi.cast("int  __cdecl (*)(char *title,char *text,char letter,int type,int fontindex)",Od._Gettext)
Od.Plugingetvalue		= ffi.cast("int  __cdecl (*)(int type)",Od._Plugingetvalue)
Od.Getsortedbyselection = ffi.cast("void*  __cdecl (*)(t_sorted *sd,int selection)",Od._Getsortedbyselection)
Od.Addsorteddata 		= ffi.cast("void*  __cdecl (*)(t_sorted *sd,void *item)",Od._Addsorteddata)
Od.Setbreakpoint 		= ffi.cast("int  __cdecl (*)(ulong addr,ulong type,uchar cmd)",Od._Setbreakpoint)
Od.Broadcast 			= ffi.cast("int  __cdecl (*)(UINT msg,WPARAM wp,LPARAM lp)",Od._Broadcast)
Od.Getcputhreadid		= ffi.cast("ulong __cdecl (*)(void)",Od._Getcputhreadid)


