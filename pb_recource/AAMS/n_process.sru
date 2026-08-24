forward
global type n_process from nonvisualobject
end type
end forward

global type n_process from nonvisualobject
end type
global n_process n_process

type prototypes
function ULong OpenProcess (ulong dwDesiredAccess,boolean bInherithandle,ulong dwProcessID) Library "kernel32.dll"
function Boolean GetExitCodeProcess (ULong hProcess,  Ref ULong lpExitCode ) Library "kernel32.dll"
function Boolean TerminateProcess (ULong hProcess, ULong uExitCode) Library "kernel32.dll"
end prototypes

type variables
constant ulong PROCESS_ALL_ACCESS = 2035711
end variables

forward prototypes
public function string getprocesslist (string arg_process)
public function integer killprocess (string arg_process)
public function integer getprocesscount (string arg_process)
end prototypes

public function string getprocesslist (string arg_process);// 실행중인 프로세스 리스트(Process ID)를 리턴합니다.
// as_exename: 검색할 프로세스의 명칭(예: pb125.exe)
// al_processId[]: 프로세스ID를 리턴받을 Array 변수
// return: 실행중인 프로세스 갯수

OleObject lole_wsh
integer li_rc
string ls_result

lole_wsh = create OleObject
li_rc = lole_wsh.ConnectToNewObject( "MSScriptControl.ScriptControl" )
if li_rc < 0 then
	return ''
end if

lole_wsh.language = "VBScript"
lole_wsh.AddCode('function processlist()~r~n ' + &
 'strComputer = "."~r~n ' + &
 'strProcList = ""~r~n ' + &
 'Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")~r~n ' + &
 'Set colItems = objWMIService.ExecQuery("Select processid from Win32_Process where name = ~'' + arg_process + '~'")~r~n ' + &
 'For Each colItem in colItems~r~n ' + &
 '   If Len(strProcList) > 0 Then strProcList = strProcList & ","~r~n ' + &
 '   strProcList = strProcList & colItem.processid~r~n ' + &
 'Next~r~n ' + &
 'processlist = strProcList~r~n ' + &
 'end function~r~n ')

ls_result = trim(string(lole_wsh.Eval("processlist")))

lole_wsh.DisconnectObject()
destroy lole_wsh

return ls_result
end function

public function integer killprocess (string arg_process);// 실행중인 프로세스가 있으면 강제 종료 합니다.
// arg_process: 종료할 프로세스 명칭(예: notepad.exe)
// return: -1=종료 실패, 0=실행중인 프로세스 없음, 1=종료 성공

ulong lul_processHndl
long ll_procCnt, i
string ls_result, la_processId[]
boolean lb

ls_result = getProcessList (arg_process)
if ls_result='' then return 0

ll_procCnt = f_get_array (ls_result, ',', la_processId)
for i = 1 to ll_procCnt
	lul_processHndl = OpenProcess(PROCESS_ALL_ACCESS, True, long(la_processId[i]))
	if lul_processHndl>0 then
//		 lb = GetExitCodeProcess (lul_processHndl, 0)
//		 messagebox ('',string (lb))
		if TerminateProcess(lul_processHndl, 0)=false then
			messagebox('알림', '프로세스 [' + arg_process + ']를 종료하지 못했습니다.')
			return -1
		end if
	end if
next

return 1
end function

public function integer getprocesscount (string arg_process);// 실행중인 프로세스 갯수를 리턴합니다.
// arg_process: 검색할 프로세스의 명칭(예: pb125.exe)
// return: 실행중인 프로세스 갯수

OleObject lole_wsh

integer li_rc
string ls_mesg

lole_wsh = create OleObject
li_rc = lole_wsh.ConnectToNewObject( "MSScriptControl.ScriptControl" )
if li_rc < 0 then
	return -1
end if

lole_wsh.language = "VBScript"
lole_wsh.AddCode('function processcount()~r~n ' + &
 'strComputer = "."~r~n ' + &
 'Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")~r~n ' + &
 'Set colItems = objWMIService.ExecQuery("Select name from Win32_Process where name = ~'' + arg_process + '~'")~r~n ' + &
 'processcount = colItems.count~r~n ' + &
 'end function~r~n ')

ls_mesg = string(lole_wsh.Eval("processcount"))

lole_wsh.DisconnectObject()
destroy lole_wsh

if isnumber(ls_mesg) then
	return integer(ls_mesg)
else
	return 0
end if
end function

on n_process.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_process.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

