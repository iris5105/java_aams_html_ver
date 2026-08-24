forward
global type fw_n_create4folder from nonvisualobject
end type
type filetime from structure within fw_n_create4folder
end type
type large_integer from structure within fw_n_create4folder
end type
type systemtime from structure within fw_n_create4folder
end type
type win32_find_data from structure within fw_n_create4folder
end type
end forward

type filetime from structure
	unsignedlong		dwlowdatetime
	unsignedlong		dwhighdatetime
end type

type large_integer from structure
	unsignedlong		low_part
	unsignedlong		high_part
end type

type systemtime from structure
	unsignedinteger		wyear
	unsignedinteger		wmonth
	unsignedinteger		wdayofweek
	unsignedinteger		wday
	unsignedinteger		whour
	unsignedinteger		wminute
	unsignedinteger		wsecond
	unsignedinteger		wmilliseconds
end type

type win32_find_data from structure
	unsignedlong		dwfileattributes
	filetime		ftcreationtime
	filetime		ftlastaccesstime
	filetime		ftlastwritetime
	unsignedlong		nfilesizehigh
	unsignedlong		nfilesizelow
	unsignedlong		dwreserved0
	unsignedlong		dwreserved1
	character		cfilename[260]
	character		calternatefilename[14]
end type

global type fw_n_create4folder from nonvisualobject
end type
global fw_n_create4folder fw_n_create4folder

type prototypes
PRIVATE FUNCTION LONG GetDesktopWindow ( ) LIBRARY "user32.dll"
PRIVATE FUNCTION LONG ShellExecuteA( Long w_handle, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd ) LIBRARY "shell32.dll" Alias for "ShellExecuteA;Ansi"

Function ulong GetLogicalDrives() Library "kernel32.dll" Alias For "GetLogicalDrives"
Function uint GetDriveType( string lpBuffer ) Library "kernel32.dll" Alias For "GetDriveTypeW"
Function ulong WNetGetConnection( string lpszLocalName, ref string lpszRemoteName, ref ulong buflen ) Library "mpr.dll" Alias For "WNetGetConnectionW"
Function ulong GetVolumeInformation( Ref string lpRootPathName, Ref string lpVolumeNameBuffer, long nVolumeNameSize, Ref string lpVolumeSerialNumber, long lpMaximumComponentLength, long lpFileSystemFlags, Ref string lpFileSystemNameBuffer, long nFileSystemNameSize ) Library "kernel32.dll" Alias For "GetVolumeInformationW"
Function long FindFirstFile( Ref string filename, Ref win32_find_data findfiledata ) Library "kernel32.dll" Alias For "FindFirstFileW"
Function boolean FindNextFile( ulong handle, Ref win32_find_data findfiledata ) Library "kernel32.dll" Alias For "FindNextFileW"
Function boolean FindClose( ulong handle ) Library "kernel32.dll" Alias For "FindClose"
Function boolean FileTimeToLocalFileTime( Ref filetime lpFileTime, Ref filetime lpLocalFileTime ) Library "kernel32.dll" Alias For "FileTimeToLocalFileTime"
Function boolean FileTimeToSystemTime( Ref filetime lpFileTime, Ref systemtime lpSystemTime ) Library "kernel32.dll" Alias For "FileTimeToSystemTime"
Function boolean GetDiskFreeSpaceEx( string lpDirectoryName, Ref large_integer lpFreeBytesAvailable, Ref large_integer lpTotalNumberOfBytes, Ref large_integer lpTotalNumberOfFreeBytes ) Library "kernel32.dll" Alias For "GetDiskFreeSpaceExW"
Function int GetTempPath( int nBufferLength, Ref string lpBuffer ) Library "kernel32.dll" Alias For "GetTempPathW"
Function boolean SetFileAttributes( string lpFileName, ulong dwFileAttributes ) Library "kernel32.dll" Alias For "SetFileAttributesW"
Function long SHGetFolderPath( long hwndOwner, long nFolder, long hToken, long dwFlags, Ref string pszPath ) Library "shell32.dll" Alias For "SHGetFolderPathW"

end prototypes

type variables
statictext ist_msg
end variables

forward prototypes
public function boolean of_checkbit (long al_number, unsignedinteger ai_bit)
public function integer of_wait (long al_wait)
public function datetime of_filedatetimetopb (filetime astr_filetime)
public subroutine of_setcreate4folder (string as_folder, ref string as_files[])
public function integer of_setcreate4folder_1sub (string as_filespec, ref string as_name[], ref boolean ab_subdir[])
public function integer of_setcreate4folder_2sub (string as_filespec, boolean ab_hidden, ref string as_name[], ref double ad_size[], ref datetime adt_writedate[], ref boolean ab_subdir[])
public function integer of_setcreate4folder_etc (string as_filespec, ref string as_name[], ref double ad_size[], ref datetime adt_writedate[])
end prototypes

public function boolean of_checkbit (long al_number, unsignedinteger ai_bit);If Int(Mod(al_number / (2 ^(ai_bit - 1)), 2)) > 0 Then
	Return True
End If

Return False
end function

public function integer of_wait (long al_wait);long ll_start
ll_start = cpu() + al_wait
Do while ll_start > cpu()
	Yield()
Loop
return 1
end function

public function datetime of_filedatetimetopb (filetime astr_filetime);String			ls_time
DateTime		ldt_filedate
FILETIME		lstr_localtime
SYSTEMTIME	lstr_systime
Date			ld_fdate
Time			lt_ftime

SetNull(ldt_filedate)

If Not FileTimeToLocalFileTime(astr_FileTime, lstr_localtime) Then Return ldt_filedate

If Not FileTimeToSystemTime(lstr_localtime, lstr_systime) Then Return ldt_filedate

ld_fdate = Date(lstr_systime.wYear, lstr_systime.wMonth, lstr_systime.wDay)

ls_time = String(lstr_systime.wHour) + ":" + &
		 String(lstr_systime.wMinute) + ":" + &
		 String(lstr_systime.wSecond) + ":" + &
		 String(lstr_systime.wMilliseconds)
lt_ftime = Time(ls_Time)

ldt_filedate = DateTime(ld_fdate, lt_ftime)

Return ldt_filedate

end function

public subroutine of_setcreate4folder (string as_folder, ref string as_files[]);String		ls_name[], ls_Folder
long		ll_i, ll_total
Boolean	lb_subdir[]

//ll_total = of_setcreate4folder_1sub(as_folder, ls_name, lb_subdir)
For ll_i = 1 To ll_total
	If lb_subdir[ll_i] Then
		if Right(as_folder,1) <> '\' then
			ls_Folder = as_folder +'\'+ ls_name[ll_i]
		else
			ls_Folder = as_folder + ls_name[ll_i]
		end if
		of_setcreate4folder( ls_Folder, as_files )
	else
		if Right(as_folder,1) <> '\' then
			as_files[ UpperBound(as_files) + 1] = as_folder +'\'+ ls_name[ll_i]
		else
			as_files[ UpperBound(as_files) + 1] = as_folder + ls_name[ll_i]
		end if
	End If
Next


end subroutine

public function integer of_setcreate4folder_1sub (string as_filespec, ref string as_name[], ref boolean ab_subdir[]);Double		ld_size[]
DateTime	ldt_writedate[]

Return of_setcreate4folder_2sub(as_filespec, True, as_name, ld_size, ldt_writedate, ab_subdir)
end function

public function integer of_setcreate4folder_2sub (string as_filespec, boolean ab_hidden, ref string as_name[], ref double ad_size[], ref datetime adt_writedate[], ref boolean ab_subdir[]);String		ls_filename
Integer		li_file
Long		ll_Handle
Boolean	lb_found, lb_hidden, lb_system
win32_find_data lstr_fd

If Right(as_filespec, 1) = "\" Then
	as_filespec += "*.*"
Else
	as_filespec += "\*.*"
End If
ll_Handle = FindFirstFile(as_filespec, lstr_fd)
If ll_Handle < 1 Then Return -1
Do
	of_wait(2)
	ls_filename = String(lstr_fd.cFilename)
	If ls_filename = "." Or ls_filename = ".." Then
	Else
		lb_hidden = of_checkbit(lstr_fd.dwFileAttributes, 2)
		lb_system = of_checkbit(lstr_fd.dwFileAttributes, 3)
		If ( lb_hidden Or lb_system ) And &
			( ab_hidden = False ) Then
		Else
			li_file++
			as_name[li_file]  = ls_filename
			ad_size[li_file] = (lstr_fd.nFileSizeHigh * (2.0 ^ 32)) + lstr_fd.nFileSizeLow
			adt_writedate[li_file] = of_filedatetimetopb(lstr_fd.ftlastwritetime)
			ab_subdir[li_file] = of_checkbit(lstr_fd.dwFileAttributes, 5)
		End If
	End If
	lb_Found = FindNextFile(ll_Handle, lstr_fd)
Loop Until Not lb_Found
FindClose(ll_Handle)
Return li_file

end function

public function integer of_setcreate4folder_etc (string as_filespec, ref string as_name[], ref double ad_size[], ref datetime adt_writedate[]);boolean	lb_subdir[]

Return of_setcreate4folder_2sub(as_filespec, True, as_name, ad_size, adt_writedate, lb_subdir)
end function

event constructor;//
end event

on fw_n_create4folder.create
call super::create
TriggerEvent( this, "constructor" )
end on

on fw_n_create4folder.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

