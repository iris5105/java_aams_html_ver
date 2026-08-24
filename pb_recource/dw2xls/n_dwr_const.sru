forward
global type n_dwr_const from nonvisualobject
end type
end forward

global type n_dwr_const from nonvisualobject
end type
global n_dwr_const n_dwr_const

type variables
public:
/*
enum ErrorCode {
	OK = 0,  
	Failed,
	WorkbookFailed,
	WorkbookAccessDenied,
	WorkbookAlreadyExists,
	WorkbookFormatNotSupported
};
*/

constant long S_OK = 0
constant long E_Failed = 1
constant long E_WorkbookFailed = 2
constant long E_WorkbookAccessDenied = 3
constant long E_WorkbookAlreadyExists = 4
constant long E_WorkbookFormatNotSupported = 5

string E_MESSAGE[] = {&
	"Failed", &
	"Workbook: creation failed", &
	"Workbook: access denied", &
	"Workbook: already exists", &
	"Workbook: format not supported" &
}

constant long ALIGN_LEFT = 0
constant long ALIGN_RIGHT = 1
constant long ALIGN_CENTER = 2
constant long ALIGN_JUSTIFIED = 3

constant long ALIGN_BOTTOM = 2
constant long ALIGN_TOP = 0
constant long ALIGN_VCENTER = 1

constant long LANDSCAPE = 0
constant long PORTRAIT = 1


end variables

on n_dwr_const.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_const.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

