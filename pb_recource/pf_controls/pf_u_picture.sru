forward
global type pf_u_picture from picture
end type
end forward

global type pf_u_picture from picture
integer width = 320
integer height = 168
boolean originalsize = true
boolean focusrectangle = false
event type boolean oue_components ( )
event resize pbm_size
event oue_lastopen ( )
event oue_postopen ( )
end type
global pf_u_picture pf_u_picture

type prototypes
Function ulong CreateCompatibleDC (ulong hdc) LIBRARY "gdi32.dll"
Function ulong CreateBitmap (ulong nWidth, ulong nHeight, ulong nPlanes, ulong nBitCount, ulong lpBits) LIBRARY "gdi32.dll"
Function ulong CreateCompatibleBitmap (ulong hdc, ulong nWidth, ulong nHeight) LIBRARY "gdi32.dll"
Function ulong SelectObject (ulong hdc, ulong hObject) LIBRARY "gdi32.dll"
Function ulong SetBkColor (ulong hdc, ulong crColor) LIBRARY "gdi32.dll"
Function ulong BitBlt (ulong hDestDC, ulong xpos, ulong ypos, ulong nWidth, ulong nHeight, ulong hSrcDC, ulong xSrc, ulong ySrc, ulong dwRop) LIBRARY "gdi32.dll"
Function ulong DeleteObject (ulong hObject) LIBRARY "gdi32.dll"
Function ulong DeleteDC (ulong hdc) LIBRARY "gdi32.dll"
Function ulong GetDC (ulong hwnd) LIBRARY "user32.dll"
Function ulong ReleaseDC (ulong hwnd, ulong hdc) LIBRARY "user32.dll"
Function ulong LoadImage (ulong hInst, ref string lpsz, ulong un1, ulong n1, ulong n2, ulong un2) LIBRARY "user32.dll" ALIAS FOR "LoadImageA;Ansi" 

end prototypes

type variables
private:
	window iw_parent
	string is_picturename
	string is_normalpicture
	string is_resizedpicture
	string is_compositedpicture
	picture lnv_dest
	
public:
	boolean	i----------------------------------------------------line0/* empty Object */
	boolean		ExtendImageWithResize
	integer			BaseXpos, BaseYpos
	
	boolean		SetBringToTop		= False
	boolean		FixedToRight
	boolean		FixedToBottom
	boolean		ScaleToRight
	boolean		ScaleToBottom

end variables

forward prototypes
public function integer of_setpicturename (string as_picturename)
public function long of_cropimage (string as_outputfilepath, long ll_left, long ll_top, long ll_width, long ll_height)
public function long of_extendimage (long al_basexpos, long al_baseypos, long al_extendwidth, long al_extendheight)
public function long of_extendimage (long al_extendwidth, long al_extendheight)
public function integer of_compositebackgroundimage (string as_backgroundpath, long al_bgleft, long al_bgtop)
public function string of_thisname ()
public subroutine of_transparency ()
public function boolean of_settransparentbackground ()
public subroutine of_getclipboardimage ()
end prototypes

event type boolean oue_components();return true

end event

event resize;if ExtendImageWithResize = true then
	this.of_extendimage(newwidth, newheight)
end if

end event

event oue_lastopen();If SetBringToTop = True Then This.BringtoTop = True
end event

event oue_postopen();This.Post Event oue_lastopen()
end event

public function integer of_setpicturename (string as_picturename);if isnull(as_picturename) or len(trim(as_picturename)) = 0 then
	is_picturename = ''
	is_normalpicture = ''
	is_resizedpicture = ''
	is_compositedpicture = ''
	this.picturename = ''
	return 0
end if

if is_picturename = as_picturename then return 0

is_normalpicture = pf_f_getimagepathappeon(as_picturename)
is_resizedpicture = gnv_vari.is_tempdirectory + gnv_extfunc.of_getuniqpicturename(this) + "_resized.jpg"
is_compositedpicture = gnv_vari.is_tempdirectory + gnv_extfunc.of_getuniqpicturename(this) + "_composited.jpg"

is_picturename = as_picturename
if gnv_vari.getclienttype = 'WEB' then
	this.picturename = is_normalpicture
end if

return 1

end function

public function long of_cropimage (string as_outputfilepath, long ll_left, long ll_top, long ll_width, long ll_height);long ll_retval

ll_retval = gnv_extfunc.biz_cropimage(this.picturename, as_outputfilepath, ll_left, ll_top, ll_width, ll_height)

return ll_retval

end function

public function long of_extendimage (long al_basexpos, long al_baseypos, long al_extendwidth, long al_extendheight);long ll_retval

ll_retval = gnv_extfunc.of_extendimage(is_normalpicture, is_resizedpicture, al_basexpos, al_baseypos, al_extendwidth, al_extendheight)
this.picturename = is_resizedpicture

return ll_retval

end function

public function long of_extendimage (long al_extendwidth, long al_extendheight);return this.of_extendimage(basexpos, baseypos, al_extendwidth, al_extendheight)

end function

public function integer of_compositebackgroundimage (string as_backgroundpath, long al_bgleft, long al_bgtop);long ll_retval

ll_retval = gnv_extfunc.biz_compositebackdropimg(is_normalpicture, is_compositedpicture, as_backgroundpath, al_bgleft, al_bgtop)
this.picturename = is_compositedpicture

return ll_retval

end function

public function string of_thisname ();return 'pf_u_picture'

end function

public subroutine of_transparency ();Long OrigColor      
Long OrigMode       
Long saveDC         
Long maskDC         
Long invDC          
Long resultDC       
Long hSaveBmp       
Long hMaskBmp       
Long hInvBmp        
Long hResultBmp     
Long hSavePrevBmp   
Long hMaskPrevBmp   
Long hInvPrevBmp    
Long hDestPrevBmp   
Long hsrcdc
Long hDestDC
Long nWidth, nHeight
Long transcolor
long ret, hBitmap
string ls_tmp
picture lnv_tmp

lnv_tmp = create picture

hsrcdc = CreateCompatibleDC (getdc (handle (this)))

hDestDC = getdc (handle (lnv_tmp))

nWidth = UnitsToPixels (this.width, XUnitsToPixels!)

nHeight = UnitsToPixels (this.height, YUnitsToPixels!)

// Here due to PB default PB UNIT unit, and unit of measure used API to deal with pixel units, therefore the need for unit conversion

transcolor = 0

// Here set to be transparent RGB color here is black;

//ls_tmp = "src =http://www.uudo.net/UpLoadFiles/Files/../UpPic/2006-9/17/0691723432791819.bmp"
ls_tmp = this.picturename

hBitmap = LoadImage (0, ls_tmp, 0, 0, 0, 16)

saveDC = CreateCompatibleDC (hDestDC)

maskDC = CreateCompatibleDC (hDestDC)

invDC = CreateCompatibleDC (hDestDC)

resultDC = CreateCompatibleDC (hDestDC)

hMaskBmp = CreateBitmap (nWidth, nHeight, 1, 1, 0)

hInvBmp = CreateBitmap (nWidth, nHeight, 1, 1, 0)

hResultBmp = CreateCompatibleBitmap (hDestDC, nWidth, nHeight)

hSaveBmp = CreateCompatibleBitmap (hDestDC, nWidth, nHeight)

ret = SelectObject (hsrcdc, hBitmap)

hSavePrevBmp = SelectObject (saveDC, hSaveBmp)

hMaskPrevBmp = SelectObject (maskDC, hMaskBmp)

hInvPrevBmp = SelectObject (invDC, hInvBmp)

hDestPrevBmp = SelectObject (resultDC, hResultBmp)

OrigColor = SetBkColor (hSrcDC, TransColor)

ret = BitBlt (maskDC, 0, 0, nWidth, nHeight, hSrcDC, 0, 0, 13369376)

// Note: 13369376 for the BitBlt function parameters-SRCCOPY, said the source rectangle directly to the target copy rectangular area

TransColor = SetBkColor (hSrcDC, OrigColor)

ret = BitBlt (invDC, 0, 0, nWidth, nHeight, maskDC, 0, 0, 3342344)

// Note: 3342244 for the BitBlt function parameters-NOTSRCCOPY, rectangular area, said the source color from the anti-copy to the target after the rectangular area

ret = BitBlt (resultDC, 0, 0, nWidth, nHeight, hDestDC, 0, 0, 13369376)

ret = BitBlt (resultDC, 0, 0, nWidth, nHeight, maskDC, 0, 0, 8913094)

// Note: 8913094 for the BitBlt function parameters-SRCAND, said that by using the AND (and) operator to the source and destination rectangle colors combined region

ret = BitBlt (saveDC, 0, 0, nWidth, nHeight, hSrcDC, 0,0, 13369376)

ret = BitBlt (saveDC, 0, 0, nWidth, nHeight, invDC, 0, 0, 8913094)

ret = BitBlt (resultDC, 0, 0, nWidth, nHeight, saveDC, 0, 0, 6684742)

// Note: 6684742 for the BitBlt function parameters-SRCINVERT, said that by using the Boolean XOR (exclusive or) operator to the source and destination rectangle colors merge

ret = BitBlt (hDestDC, 0, 0, nWidth, nHeight, resultDC, 0, 0, 13369376)

ret = SelectObject (saveDC, hSavePrevBmp)

ret = SelectObject (resultDC, hDestPrevBmp)

ret = SelectObject (maskDC, hMaskPrevBmp)

ret = SelectObject (invDC, hInvPrevBmp)

ret = DeleteObject (hSaveBmp)

ret = DeleteObject (hMaskBmp)

ret = DeleteObject (hInvBmp)

ret = DeleteObject (hResultBmp)

ret = DeleteDC (saveDC)

ret = DeleteDC (invDC)

ret = DeleteDC (maskDC)

ret = DeleteDC (resultDC)

ret = ReleaseDC (handle (this), hsrcdc)

ret = ReleaseDC (handle (lnv_tmp), hDestDC) 


end subroutine

public function boolean of_settransparentbackground ();boolean lb_retval

lb_retval = gnv_extfunc.of_setbackdroptransparent(this, is_compositedpicture)

return lb_retval

end function

public subroutine of_getclipboardimage ();string ls_temppath, ls_obj
integer li_rc
ls_obj = this.classname()
ls_temppath = gnv_extfunc.of_getsystemtemppath() + ls_obj + ".bmp"
li_rc = gnv_extfunc.biz_setclipboardtobitmap(ls_temppath)
if li_rc > 0 then
	this.picturename = ls_temppath
end if

end subroutine

on pf_u_picture.create
end on

on pf_u_picture.destroy
end on

event constructor;// get parent object
iw_parent = fw_f_obj4parentwindow(this)
// call oue_postopen event
This.Post Event oue_postopen()
end event

