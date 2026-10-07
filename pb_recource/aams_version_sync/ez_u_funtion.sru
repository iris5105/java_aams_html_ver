forward
global type ez_u_funtion from userobject
end type
type lstr_processentry32 from structure within ez_u_funtion
end type
type lstr_processinformation from structure within ez_u_funtion
end type
end forward

type lstr_processentry32 from structure
	unsignedlong		dwsize
	unsignedlong		cntusage
	unsignedlong		th32processid
	unsignedlong		th32defaultheapid
	unsignedlong		th32moduleid
	unsignedlong		cntthreads
	unsignedlong		th32parentprocessid
	long		pcpriclassbase
	unsignedlong		dwflags
	character		szexefile[256]
end type

type lstr_processinformation from structure
	unsignedlong		hprocess
	unsignedlong		hthread
	long		dwprocessid
	string		dwthreadid
end type

global type ez_u_funtion from userobject
integer width = 165
integer height = 88
long backcolor = 16777215
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_constructor1st ( )
end type
global ez_u_funtion ez_u_funtion

type prototypes
function boolean EnumProcesses(ref ulong lpidProcess[],  ulong cb, ref ulong cbneeded ) library 'psapi.dll'
function boolean EnumProcessModules(  ulong hProcess, ref ulong lphModule, ulong cb,  ref ulong lpcbNeeded  ) library 'psapi.dll'
function ulong GetModuleBaseName(ulong hProcess, ulong hModule, ref string lpBaseName, ulong nSize  ) alias for GetModuleBaseNameA library 'psapi.dll'

function boolean CloseHandle(ulong h) library 'kernel32.dll'
function ulong OpenProcess(ulong dwDesiredAccess,  boolean bInheritHandle, ulong dwProcessId ) library 'kernel32.dll'

function ulong CreateToolhelp32Snapshot(long dwFlags, long th32ProcessID) library 'kernel32.dll'
function boolean Process32First(ulong hSnapshot, ref lstr_PROCESSENTRY32 lppe) library 'kernel32.dll' Alias for "Process32First;Ansi"  
function boolean Process32Next(ulong hSnapshot, ref lstr_PROCESSENTRY32 lppe) library 'kernel32.dll' Alias for "Process32Next;Ansi"
Function ulong FindWindowA( ulong ClassName, String WindowName ) Library "user32.dll"
SUBROUTINE SetFocus(long objhandle) LIBRARY "User32.dll"
FUNCTION boolean BringWindowToTop(ulong w_handle) LIBRARY "User32.dll"
function ulong FindWindow ( ref string lpClassName, ref string lpWindowName) Library "USER32.DLL" 
Function int GetWindowTextA( Long hWindow, ref string windowtext, int length)  Library "USER32.DLL"
FUNCTION uInt GetWindow( uInt hWindow, Int nRelationShip) Library "user32.dll"
FUNCTION long SendMessageA(ulong hwndle,UINT wmsg,ulong wParam,ulong lParam) Library "User32.dll"
FUNCTION boolean PostMessageA(ulong hwndle,UINT wmsg,ulong wParam,ulong lParam) Library "User32.dll"

SUBROUTINE       ExitThread(ulong thandle) LIBRARY "kernel32.dll"

function ulong CreateMutexA (ulong lpMutexAttributes,  int bInitialOwner,  ref string lpName) library "kernel32.dll"
function ulong GetLastError () library "kernel32.dll"

function boolean TerminateProcess(ulong handle, uint exitcode) library "kernel32.dll"
function boolean ExitProcess(ulong handle) library "kernel32.dll"

end prototypes

type variables
long PROCESS_VM_READ = 16
long PROCESS_QUERY_INFORMATION = 1024
long TH32CS_SNAPPROCESS = 2
long il_timer

string	is_application = 'aams.exe'
end variables
forward prototypes
public function integer lf_getpresslist ()
public function integer lf_exefileclose (string as_filename)
public function integer lf_finepressid (string as_filename)
end prototypes

public function integer lf_getpresslist ();string		szText,Ls_Frame_Title
long		ll_row, ll_cnt = 0
long		hWindow, hNextWindow
ulong	 	lul_SnapShot
Boolean	rtn_chk
lstr_processentry32 lstr_ProcEntry

lul_SnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0)

if lul_SnapShot <> -1 then
	lstr_ProcEntry.dwSize = 296
	rtn_chk = Process32First(lul_SnapShot, lstr_ProcEntry)
	
	do while( rtn_chk )
		rtn_chk = Process32Next(lul_SnapShot, lstr_ProcEntry)		
		If Lower(lstr_ProcEntry.szexefile) = is_application Then
			ll_cnt++
		end if
	loop		
	CloseHandle(lul_SnapShot)
end if

return ll_cnt
end function

public function integer lf_exefileclose (string as_filename);ulong	lul_handle, lul_THandle

lul_handle = lf_finepressid(as_filename)

if lul_handle > 0 then	
	lul_THandle = OpenProcess(1, False, lul_handle )	
	TerminateProcess(lul_THandle, 0)	
	CloseHandle(lul_THandle)
	return 0
else
	return -1
end if



end function

public function integer lf_finepressid (string as_filename);string		szText,Ls_Frame_Title
long		hWindow,hNextWindow
ulong		ll_th32processid
ulong		lul_SnapShot
boolean	rtn_chk
lstr_processentry32 lstr_ProcEntry

ll_th32processid = 0

lul_SnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0)

IF lul_SnapShot <> -1 THEN
	lstr_ProcEntry.dwSize = 296
	rtn_chk = Process32First(lul_SnapShot, lstr_ProcEntry)
	
	DO WHILE( rtn_chk )

		if Upper(as_filename) = Upper(lstr_ProcEntry.szexefile) then
			ll_th32processid = lstr_ProcEntry.th32processid
			exit
		end if

		rtn_chk = Process32Next(lul_SnapShot, lstr_ProcEntry)		
	LOOP	
   CloseHandle(lul_SnapShot)
END IF

return ll_th32processid
end function

on ez_u_funtion.create
end on

on ez_u_funtion.destroy
end on

event constructor;post event ue_constructor1st()
end event

