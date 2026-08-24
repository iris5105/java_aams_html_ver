forward
global type uo_dw2xls_service from nonvisualobject
end type
type os_size from structure within uo_dw2xls_service
end type
type os_printer_defaults from structure within uo_dw2xls_service
end type
type devmode from structure within uo_dw2xls_service
end type
type st_datetime from structure within uo_dw2xls_service
end type
type os__ofstruct from structure within uo_dw2xls_service
end type
type os_ofstruct from structure within uo_dw2xls_service
end type
type os_systemtime from structure within uo_dw2xls_service
end type
type browseinfo from structure within uo_dw2xls_service
end type
type st_security_attributes from structure within uo_dw2xls_service
end type
end forward

type os_size from structure
	long		l_cx
	long		l_cy
end type

type os_PRINTER_DEFAULTS from structure
	string		pDatatype
	ulong		pDevMode
	long		DesiredAccess
end type

type devmode from structure
 string  dmdevicename
 long  dmspecversion
 long  dmdriverversion
 long  dmsize
 long  dmdriverextra
 unsignedlong  dmfields
 integer  dmorientation
 integer  dmpapersize
 integer  dmpaperlength
 integer  dmpaperwidth
 integer  dmscale
 integer  dmcopies
 integer  dmdefaultsource
 integer  dmprintquality
 integer  dmcolor
 integer  dmduplex
 integer  dmyresolution
 integer  dmttoption
 integer  dmcollate
 string  dmformname
 long  dmlogpixels
 unsignedlong  dmbitsperpel
 unsignedlong  dmpelswidth
 unsignedlong  dmpelsheight
 unsignedlong  dmdisplayflags
 unsignedlong  dmdisplayfrequency
 unsignedlong  dmicmmethod
 unsignedlong  dmicmintent
 unsignedlong  dmmediatype
 unsignedlong  dmdithertype
 unsignedlong  dmreserved1
 unsignedlong  dmreserved2
end type

type st_datetime from structure
	ulong		d1
	ulong		d2
end type

type os__OFSTRUCT from structure
	character		cBytes
	character		fFixedDisk
	uint		nErrCode
	uint		Reserved1
	uint		Reserved2
	character		szPathName[]
end type

type os_ofstruct from structure
	character		cbytes
	character		ffixeddisk
	unsignedinteger		nerrcode
	unsignedinteger		reserved1
	unsignedinteger		reserved2
	character		szpathname[128]
end type

type os_systemtime from structure
	uint		wYear
	uint		wMonth
	uint		wDayOfWeek
	uint		wDay
	uint		wHour
	uint		wMinute
	uint		wSecond
	uint		wMilliseconds
end type

type browseinfo from structure
	long		hwndowner
	long		pidlroot
	string		pszdisplayname
	string		lpsztitle
	unsignedinteger		ulflags
	long		lpfn
	long		lparam
	integer		iimage
end type

type st_SECURITY_ATTRIBUTES from structure
	ulong		nLength
	ulong		lpSecurityDescription
	boolean		bInheritHandle
end type

global type uo_dw2xls_service from nonvisualobject autoinstantiate
end type

type prototypes



Function boolean GetTextExtentPoint32A(LongPtr hdcr, string lpString, long nCount, ref os_size size) Library "GDI32.DLL"




Function LongLong SelectObject(LongPtr hdc, LongPtr hWnd) Library "GDI32.DLL"




Function LongLong GetDC(LongPtr hWnd) Library "USER32.DLL"




Function long ReleaseDC(LongPtr hWnd, LongPtr hdcr) Library "USER32.DLL"


end prototypes

type variables
uint WM_WININICHANGE = 26
uint HWND_BROADCAST = 65535
end variables

forward prototypes
public function integer f_gettextwidth (ref dragobject a_obj, string as_text)
public function integer f_gettextsize (ref window aw_obj, string as_text, string as_fontface, integer ai_fontsize, boolean ab_bold, boolean ab_italic, boolean ab_underline, ref integer ai_height, ref integer ai_width)
public function integer f_gettextheight (ref dragobject a_obj, string as_text)
end prototypes

public function integer f_gettextwidth (ref dragobject a_obj, string as_text);//	Function:  f_GetTextSize
//
//	Access:  public
//
//	Arguments:  
//	aw_obj:  Window where temporary text will be created
//	as_Text						The text to be sized.
//	as_FontFace				The font used.
//	ai_FontSize				The point size of the font.
//	ab_Bold						True - Bold, False - Normal.
//	ab_Italic					True - Yes, False - No.
//	ab_Underline				True - Yes, False - No.
//	ai_Height					the height of the object in pixels
//	ai_Width					the width of the object in pixels
//
//
//	Returns:  Integer			1 if successful, -1 if an error occurrs
//	
//
//	Description:  Calculates the size of a text object in pixels
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//	5.0.03	Changed Uint variables to Ulong for NT4.0 compatibility
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Integer		li_Size, li_Len, li_Return, &
				li_WM_GETFONT = 49 	//  hex 0x0031


LongPtr lul_Hdc, lul_Handle, lul_hFont

integer a_mode
os_size 		lstr_Size
os_printer_defaults pr_def
ulong printer_hdc
string sdev, sdrv,sout
devmode dm

setnull(sout)
li_Len = Len(as_Text)

// Get the handle of the Object and create a Device Context
lul_Handle = Handle(a_obj)
lul_Hdc = GetDC(lul_Handle) 

//sdev = 'Brother HL-1240 series'
//sdrv = 'WINSPOOL'
//printer_hdc = createdca(sdrv, sdev, sout, dm)
//printer_hdc = Get_Printer_Handle(sdev)
//messagebox('dd', printer_hdc)

// Get the font in use on the Static Text
lul_hFont = Send(lul_Handle, li_WM_GETFONT, 0, 0)

// Select it into the device context
SelectObject(lul_Hdc, lul_hFont)
//SelectObject(printer_hdc, lul_hFont)

//a_mode = GetMapMode(lul_Hdc)
//messagebox('ss', a_mode)
//SetMapMode(lul_Hdc, 3)

// Get the size of the text.
If Not GetTextExtentpoint32A(lul_Hdc, as_Text, li_Len, lstr_Size ) Then Return -1
//If Not GetTextExtentpoint32A(printer_hdc, as_Text, li_Len, lstr_Size ) Then Return -1

//LPtoDP(lul_Hdc, lstr_Size, 1)
//SetMapMode(lul_Hdc, 6)
//LPtoDP(lul_Hdc, lstr_Size, 1)
//DPtoLP(lul_Hdc, lstr_Size, 1)

//ai_Height = lstr_Size.l_cy
//ai_Width = lstr_Size.l_cx

ReleaseDC(lul_Handle, lul_Hdc)
//DeleteDC(printer_hdc)

//return lstr_Size.l_cx

Return PixelstoUnits(lstr_Size.l_cx, XPixelsToUnits!)

end function

public function integer f_gettextsize (ref window aw_obj, string as_text, string as_fontface, integer ai_fontsize, boolean ab_bold, boolean ab_italic, boolean ab_underline, ref integer ai_height, ref integer ai_width);//	Function:  f_GetTextSize
//
//	Access:  public
//
//	Arguments:  
//	aw_obj:  Window where temporary text will be created
//	as_Text						The text to be sized.
//	as_FontFace				The font used.
//	ai_FontSize				The point size of the font.
//	ab_Bold						True - Bold, False - Normal.
//	ab_Italic					True - Yes, False - No.
//	ab_Underline				True - Yes, False - No.
//	ai_Height					the height of the object in pixels
//	ai_Width					the width of the object in pixels
//
//
//	Returns:  Integer			1 if successful, -1 if an error occurrs
//	
//
//	Description:  Calculates the size of a text object in pixels
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Integer		li_Size, li_Len, li_Return, &
				li_WM_GETFONT = 49 	//  hex 0x0031


LongPtr lul_Hdc, lul_Handle, lul_hFont

StaticText	lst_Temp
os_size 		lstr_Size

// Datawindow syntax specifies font point size is negative
li_Size = -1 * ai_FontSize

if IsNull(aw_obj) Or Not IsValid (aw_obj) then
	return -1
end if

// Create a dummy StaticText Object on the window
// containing text with the desired characteristics
li_Return = aw_obj.OpenUserObject(lst_Temp)
If li_Return = 1 Then
	lst_Temp.FaceName = as_FontFace
	lst_Temp.TextSize = li_Size
	If ab_Bold Then
		lst_Temp.Weight = 700
	Else
		lst_Temp.Weight = 400
	End If
	lst_Temp.Italic = ab_Italic
	lst_Temp.Underline = ab_Underline

	li_Len = Len(as_Text)

	// Get the handle of the StaticText Object and create a Device Context
	lul_Handle = Handle(lst_Temp)
	lul_Hdc = GetDC(lul_Handle) 

	// Get the font in use on the Static Text
	lul_hFont = Send(lul_Handle, li_WM_GETFONT, 0, 0)

	// Select it into the device context
	SelectObject(lul_Hdc, lul_hFont)

	// Get the size of the text.
	If Not GetTextExtentpoint32A(lul_Hdc, as_Text, li_Len, lstr_Size ) Then Return -1

	ai_Height = lstr_Size.l_cy
	ai_Width = lstr_Size.l_cx

	ReleaseDC(lul_Handle, lul_Hdc)

	li_Return = aw_obj.CloseUserObject(lst_Temp)
End if

Return li_Return

end function

public function integer f_gettextheight (ref dragobject a_obj, string as_text);//	Function:  f_GetTextSize
//
//	Access:  public
//
//	Arguments:  
//	aw_obj:  Window where temporary text will be created
//	as_Text						The text to be sized.
//	as_FontFace				The font used.
//	ai_FontSize				The point size of the font.
//	ab_Bold						True - Bold, False - Normal.
//	ab_Italic					True - Yes, False - No.
//	ab_Underline				True - Yes, False - No.
//	ai_Height					the height of the object in pixels
//	ai_Width					the width of the object in pixels
//
//
//	Returns:  Integer			1 if successful, -1 if an error occurrs
//	
//
//	Description:  Calculates the size of a text object in pixels
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//	5.0.03	Changed Uint variables to Ulong for NT4.0 compatibility
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Integer		li_Size, li_Len, li_Return, &
				li_WM_GETFONT = 49 	//  hex 0x0031


LongPtr lul_Hdc, lul_Handle, lul_hFont

os_size 		lstr_Size

li_Len = Len(as_Text)

// Get the handle of the Object and create a Device Context
lul_Handle = Handle(a_obj)
lul_Hdc = GetDC(lul_Handle) 

// Get the font in use on the Static Text
lul_hFont = Send(lul_Handle, li_WM_GETFONT, 0, 0)

// Select it into the device context
SelectObject(lul_Hdc, lul_hFont)

// Get the size of the text.
If Not GetTextExtentpoint32A(lul_Hdc, as_Text, li_Len, lstr_Size ) Then Return -1

//ai_Height = lstr_Size.l_cy
//ai_Width = lstr_Size.l_cx

ReleaseDC(lul_Handle, lul_Hdc)


Return PixelstoUnits(lstr_Size.l_cy, YPixelsToUnits!)

end function

on uo_dw2xls_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_dw2xls_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

