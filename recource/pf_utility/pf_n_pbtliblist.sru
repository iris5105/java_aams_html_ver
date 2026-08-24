forward
global type pf_n_pbtliblist from nonvisualobject
end type
end forward

global type pf_n_pbtliblist from nonvisualobject
end type
global pf_n_pbtliblist pf_n_pbtliblist

type prototypes
//Function long GetFullPathName(string lpFileName , long nBufferLength , ref string lpBuffer , string lpFilePart )   Library "kernel32.dll" Alias for "GetFullPathNameA;Ansi"
Function long GetFullPathName(string lpFileName , long nBufferLength , ref string lpBuffer , string lpFilePart )   Library "kernel32.dll" Alias for "GetFullPathNameW"

end prototypes

type variables
String		is_TargetName
String		is_AppName
String		is_AppLib
String		is_LibList[]
Long		il_LibCnt

end variables

forward prototypes
public subroutine of_settragetname (string as_targetname)
public subroutine of_setappname (string as_appname)
public function integer of_parsetarget (string as_targetfile)
protected function string of_getfullpathname (string as_filename, string as_path)
public function string of_getlibraryitems (string as_libname)
end prototypes

public subroutine of_settragetname (string as_targetname);is_TargetName = as_TargetName

end subroutine

public subroutine of_setappname (string as_appname);is_AppName = as_AppName

end subroutine

public function integer of_parsetarget (string as_targetfile);Long	ll_hndl
String ls_line, ls_path, ls_unescaped, ls_orgpath
Integer i

// Target File 오픈
ll_hndl = FileOpen(as_TargetFile, LineMode!, Read!, LockRead!, Replace!, EncodingAnsi!)
IF ll_hndl = -1 THEN Return -1

OleObject wsh
wsh = CREATE OleObject
wsh.ConnectToNewObject( "MSScriptControl.ScriptControl" )
wsh.language = "javascript"

DO WHILE FileReadEx(ll_hndl, ls_line) > 0
	CHOOSE CASE Lower(Left(ls_line, 7))
		CASE "appname"
			is_AppName = Mid(ls_line, 10, Pos(ls_line, '";') - 10)
		CASE "applib "
			is_AppLib = Mid(ls_line, 9, Pos(ls_line, '";') - 9)
		CASE "liblist"
			ls_path = left(as_TargetFile, LastPos(as_TargetFile, "\"))
			
			ls_orgpath = getcurrentdirectory()
			ChangeDirectory ( ls_path )
			
			ls_line = Mid(ls_line, 10, Pos(ls_line, '";') - 10)
			il_LibCnt = fw_f_obj2array(ls_line, ";", is_LibList)
			FOR i = 1 TO il_LibCnt
				ls_unescaped = space(512)
				//gnv_public.pf_http_unescape(is_LibList[i], ls_unescaped)
				//is_LibList[i] = ls_unescaped				
				is_LibList[i] = wsh.Eval("unescape('" + is_LibList[i] + "')")
				is_LibList[i] = This.of_GetFullPathName(is_LibList[i], ls_Path)
			NEXT
			
			ChangeDirectory ( ls_orgpath )
	END CHOOSE
LOOP

FileClose(ll_hndl)

//Integer  li_rc
//string ls_temp
//
//wsh = CREATE OleObject
//li_rc = wsh.ConnectToNewObject( "MSScriptControl.ScriptControl" )
//wsh.language = "javascript"
//
//ls_temp = wsh.Eval("escape('H e l l o')")
//
//MessageBox( "ESCAPE" , ls_temp)
//
//ls_temp = wsh.Eval("unescape('" + ls_temp + "')")
//
//MessageBox( "UNESCAPE" , ls_temp)

//messagebox('is_AppName', is_AppName)
//messagebox('is_AppLib', is_AppLib)
//messagebox('ls_path', ls_path)
//FOR i = 1 TO il_LibCnt
//	messagebox('is_LibList', is_LibList[i])
//NEXT

Return UpperBound(is_LibList)

end function

protected function string of_getfullpathname (string as_filename, string as_path);String ls_buffer

ls_buffer = Space(255)
GetFullPathName(as_FileName, Len(ls_buffer), ls_buffer, as_path)
Return ls_buffer

end function

public function string of_getlibraryitems (string as_libname);String ls_Entries 
Integer li_Pos

// Get Entries
ls_Entries=LibraryDirectoryEx(as_LibName,DirAll!)

li_Pos = Pos(ls_Entries, "~n")
DO WHILE li_Pos > 0
	ls_Entries = Replace(ls_Entries, li_Pos, 1, "~t" + as_LibName + "~n")
	li_Pos = Pos(ls_Entries, "~n", li_Pos + Len(as_LibName) + 2)
LOOP

Return ls_Entries

end function

on pf_n_pbtliblist.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_pbtliblist.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

