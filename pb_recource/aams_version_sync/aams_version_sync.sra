forward
global type aams_version_sync from application
end type
global n_tr_a sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
string		gs_commandline = ''
string		gs_sys_id = ''
string		gs_getserverip = ''
string		gs_file4http = ''
string		gs_root_path = 'C'

string		gs_execute_yn = 'Y'

n_jtier_method		mo_
STR_AAMS		gaa
end variables

global type aams_version_sync from application
string appname = "aams_version_sync"
end type
global aams_version_sync aams_version_sync

type prototypes
/* directory api */
function ulong GetCurrentDirectoryA(ulong BufferLen, ref string currentdir) LIBRARY "kernel32.dll" alias for "GetCurrentDirectoryA;Ansi"
function ULong FindWindowA(ULong classname, String windowname) LIBRARY "user32.dll" alias for "FindWindowA;Ansi"
function boolean PostMessageA(ulong hwndle, UINT wmsg, ulong wParam, ulong lParam) Library "User32.dll"

function boolean CloseHandle(ulong h) library 'kernel32.dll'
function ulong CreateToolhelp32Snapshot(long dwFlags, long th32ProcessID) library 'kernel32.dll'

function ulong GetDesktopWindow( ) library "User32.dll"
function LONG ShellExecuteA( Long w_handle, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd ) library "shell32.dll" Alias for "ShellExecuteA;Ansi"

subroutine PathStripPath(Ref String pszPath) library "shlwapi.dll" Alias For "PathStripPathA;Ansi"

end prototypes

forward prototypes
public subroutine of_shellexecute ()
end prototypes

public subroutine of_shellexecute ();CONSTANT long SW_SHOWNOMAL = 1
string	ls_execute
long	ll_screen_hdl, ll_rtn

// 'C:\AAMS\kernel\aams.exe'
ls_execute = gs_root_path + '\kernel\aams.exe'
ll_screen_hdl = GetDesktopWindow()
ll_rtn = ShellExecuteA(ll_screen_hdl, 'open', ls_execute, '', '', SW_SHOWNOMAL)

//string	sFile, sParam, sDir
//post run('C:\ez.frame\kernel\ez_frame.ez_frame')
end subroutine

on aams_version_sync.create
appname="aams_version_sync"
message=create message
sqlca=create n_tr_a
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on aams_version_sync.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;string	ls_cur_dir
string	ls_parsing[]
long	ll_upper, ll_rtn
ulong	ull_length = 255

gs_root_path = commandline
gs_root_path = trim(gs_root_path)

mo_ = CREATE n_jtier_method

f_jtier_connect ()
IF	gaa.jtier_url='not connect'	Then
	messagebox ("확인", "jTier  환경설정 실패!", stopsign!)
	close(w_database_dn_state)
	DISCONNECT;
	HALT CLOSE  // System CLOSE
End IF

if trim(gs_root_path) = '' or isnull(gs_root_path) then
	gs_root_path = 'C:\AAMS.client'
end if
gaa.pbr = f_replace (GetCurrentDirectory (), 'kernel','')
gaa.config = gaa.pbr + 'kernel\aams_version_sync.ini'

openwithparm(w_database_dn_state, '')
gs_execute_yn = Message.stringparm
if gs_execute_yn = 'Y' then
	post of_shellexecute()
else
	HALT CLOSE
end if
end event

event close;mo_.Dynamic event destructor_pre()
DESTROY	mo_
end event

