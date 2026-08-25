forward
global type pf_u_commandbutton_overlay from picture
end type
end forward

global type pf_u_commandbutton_overlay from picture
integer width = 229
integer height = 96
string pointer = "HyperLink!"
string picturename = "..\img\controls\u_combtn\webst_btn.jpg"
boolean focusrectangle = false
event mousemove pbm_mousemove
event oue_mouseleave ( )
event oue_mouseover ( )
event oue_lbuttonup pbm_lbuttonup
event oue_lbuttondown pbm_lbuttondown
event timer pbm_timer
event oue_postopen ( )
end type
global pf_u_commandbutton_overlay pf_u_commandbutton_overlay

type prototypes
function boolean ReleaseCapture() library "user32.dll"
function long SetCapture(long hWnd) library "user32.dll"

Function Boolean TrackMouseEvent(Ref pf_s_TRACKMOUSEEVENT lpTrackMouseEvent) Library 'user32.dll' alias for "TrackMouseEvent;Ansi" 
Function Long GetLastError() Library 'Kernel32.dll' 

end prototypes

type variables
Constant String MOUSEOVER_SURFIX = "_hover"
Constant String CLICKED_SURFIX =  "_clicked"
Constant String DISABLED_SURFIX = "_disabled"

Private:
	window				iw_parent
	pf_u_commandbutton	icb_parent
	pf_n_timing			inv_timer
	pf_s_point			istr_point
	
	
	String		is_imagefile /* to-be */
	
	String		is_getuniqpicturename /* to-be */
	String		is_picturename
	String		is_normal_img
	String		is_mouseover_img
	String		is_clicked_img
	String		is_disabled_img
	boolean	ib_mouseover

end variables

forward prototypes
public function integer of_setpicturename (string as_picturename)
public function integer of_checkandcreateimage (string as_imagetype, string as_imagepath)
public function string of_thisname ()
public subroutine of_setenabled (boolean ab_enabled)
public subroutine of_setvisible (boolean ab_visible)
public subroutine of_settext (string as_text)
public subroutine of_bringtotop (boolean ab_bringtotop)
public subroutine of_initialize (pf_u_commandbutton acb_parent, window aw_parent, string as_imagefile)
end prototypes

event mousemove;if ib_mouseover = false then
	ib_mouseover = true
	this.event oue_mouseover()
	inv_timer.of_start()
end if

end event

event oue_mouseleave();if isnull(this.picturename) or this.picturename = '' then return
this.picturename = is_normal_img

end event

event oue_mouseover();if isnull(this.picturename) or this.picturename = '' then return
this.picturename = is_mouseover_img

end event

event oue_lbuttonup;if isnull(this.picturename) or this.picturename = '' then return
if ib_mouseover = true then
	this.picturename = is_mouseover_img
end if

end event

event oue_lbuttondown;if isnull(this.picturename) or this.picturename = '' then return
this.picturename = is_clicked_img

end event

event timer;if gnv_extfunc.GetCursorPos(istr_point) then
	if gnv_extfunc.ScreenToClient(handle(this), istr_point) then
		if istr_point.xpos >= 0 and istr_point.ypos >= 0 and istr_point.xpos <= unitstopixels(this.width, xunitstopixels!) and istr_point.ypos <= unitstopixels(this.height, yunitstopixels!) then
		else
			ib_mouseover = false
			inv_timer.stop()
			this.post event oue_mouseleave()
		end if
	end if
end if

end event

public function integer of_setpicturename (string as_picturename);string	ls_picture_dir, ls_picture_name, ls_picture_ext
string	ls_cbnmtext, ls_lessen4text
long ll_lastpos

If isnull(as_picturename) or as_picturename = '' Then
	is_getuniqpicturename	= ''
	is_picturename			= ''
	is_normal_img			= ''
	is_mouseover_img		= ''
	is_clicked_img			= ''
	is_disabled_img			= ''
	This.picturename		= ''
	return 0
end If

If gnv_vari.getclienttype = 'WEB' Then /* to-be igmage process 변경 */
	/* to-be pf_u_commandbutton_overlay.js; pf_u_commandbutton.js */
	If fw_f_nvls(gnv_vari.ModifyDT_commandbutton_overlay, '') = '' Then gnv_extfunc.of_getfilewritetime(gnv_vari.getcachedir + '\pf_u_commandbutton_overlay.js', gnv_vari.ModifyDT_commandbutton_overlay) /* to-be pf_u_commandbutton_overlay.js 변경일자를 pf_n_appsession variable 등록 */
	If fw_f_nvls(gnv_vari.ModifyDT_commandbutton, '') = '' Then gnv_extfunc.of_getfilewritetime(gnv_vari.getcachedir + '\pf_u_commandbutton.js', gnv_vari.ModifyDT_commandbutton) /* to-be pf_u_commandbutton.js 변경일자를 pf_n_appsession variable 등록 */
End If


/* to-be window,  icb_parent.classname(), icb_parent.text  merge */
String		ls_text
ls_text = icb_parent.text + '_' + String(icb_parent.width) + String(icb_parent.height)
ls_text = fw_f_text2revise(ls_text)

ls_cbnmtext = icb_parent.classname() + '_' + ls_text
If len(ls_cbnmtext) >= 20 Then
	ls_lessen4text = mid(ls_cbnmtext, 1, 6) + 'A_' +  mid(ls_text, 1, 6) + 'B_' + string(len(ls_cbnmtext))
Else
	ls_lessen4text = ls_cbnmtext
End If
is_getuniqpicturename = iw_parent.classname() + '_' + ls_lessen4text

is_normal_img = pf_f_getimagepathappeon(as_picturename)

ll_lastpos = lastpos(is_normal_img, "\")
If ll_lastpos > 0 Then
	ls_picture_dir = left(is_normal_img, ll_lastpos)
	ls_picture_name = mid(is_normal_img, ll_lastpos + 1)
Else
	ls_picture_dir = ""
	ls_picture_name = is_normal_img
end If

ll_lastpos = lastpos(ls_picture_name, ".")
If ll_lastpos > 0 Then
	ls_picture_ext = mid(ls_picture_name, ll_lastpos)
	ls_picture_name = left(ls_picture_name, ll_lastpos - 1)
Else
	ls_picture_ext = ""
end If
/* to-be */
If fw_f_nvls(gnv_vari.ModIfyDT_button_normal_img, '') = '' Then gnv_extfunc.of_getfilewritetime(is_normal_img, gnv_vari.ModIfyDT_button_normal_img) /* is_normal_img 변경일자를 appsession variable 등록 */
This.of_checkandcreateimage('normal', is_normal_img)

is_mouseover_img = ls_picture_dir + ls_picture_name + MOUSEOVER_SURFIX + ls_picture_ext
If fw_f_nvls(gnv_vari.ModIfyDT_button_mouseover_img, '') = '' Then gnv_extfunc.of_getfilewritetime(is_mouseover_img, gnv_vari.ModIfyDT_button_mouseover_img) /* is_mouseover_img 변경일자를 appsession variable 등록 */
This.of_checkandcreateimage('mouseover', is_mouseover_img)

is_clicked_img = ls_picture_dir + ls_picture_name + CLICKED_SURFIX + ls_picture_ext
If fw_f_nvls(gnv_vari.ModIfyDT_button_clicked_img, '') = '' Then gnv_extfunc.of_getfilewritetime(is_clicked_img, gnv_vari.ModIfyDT_button_clicked_img) /* is_clicked_img 변경일자를 appsession variable 등록 */
This.of_checkandcreateimage('clicked', is_clicked_img)

is_disabled_img = ls_picture_dir + ls_picture_name + DISABLED_SURFIX + ls_picture_ext
If fw_f_nvls(gnv_vari.ModIfyDT_button_disabled_img, '') = '' Then gnv_extfunc.of_getfilewritetime(is_disabled_img, gnv_vari.ModIfyDT_button_disabled_img) /* is_disabled_img 변경일자를 appsession variable 등록 */
This.of_checkandcreateimage('disabled', is_disabled_img)

is_picturename = as_picturename
If icb_parent.enabled = True Then
	This.picturename = ''
	This.picturename = is_normal_img
Else
	This.enabled = False
	This.picturename = is_disabled_img
end If

Return 1

end function

public function integer of_checkandcreateimage (string as_imagetype, string as_imagepath);string ls_tempfilepath

// 임시로 사용될 파일명(JPG)
ls_tempfilepath = gnv_vari.is_tempdirectory + gnv_vari.mswindowrate + "_" + is_getuniqpicturename + "_" + as_imagetype + ".bmp"
If fw_f_nvls(ls_tempfilepath, '') = '' Then Return -1

If gnv_vari.getclienttype = 'WEB' Then /* to-be igmage process 변경 */
	String		ls_tempfilepathdt
	
	Choose case as_imagetype
		Case 'normal'
			If FileExists(ls_tempfilepath) Then
				gnv_extfunc.of_getfilewritetime(ls_tempfilepath, ls_tempfilepathdt)
				If	gnv_vari.ModifyDT_button_normal_img <= ls_tempfilepathdt and gnv_vari.ModifyDT_commandbutton_overlay <= ls_tempfilepathdt and gnv_vari.ModifyDT_commandbutton <= ls_tempfilepathdt Then
					is_normal_img = ls_tempfilepath
					Return 1
				End If
			End If
		Case 'mouseover'
			If FileExists(ls_tempfilepath) Then
				gnv_extfunc.of_getfilewritetime(ls_tempfilepath, ls_tempfilepathdt)
				If gnv_vari.ModifyDT_button_mouseover_img <= ls_tempfilepathdt  and gnv_vari.ModifyDT_commandbutton_overlay <= ls_tempfilepathdt and gnv_vari.ModifyDT_commandbutton <= ls_tempfilepathdt Then
					is_mouseover_img = ls_tempfilepath
					Return 1
				End If
			End If		
		Case 'clicked'
			If FileExists(ls_tempfilepath) Then
				gnv_extfunc.of_getfilewritetime(ls_tempfilepath, ls_tempfilepathdt)
				If gnv_vari.ModifyDT_button_clicked_img <= ls_tempfilepathdt  and gnv_vari.ModifyDT_commandbutton_overlay <= ls_tempfilepathdt and gnv_vari.ModifyDT_commandbutton <= ls_tempfilepathdt Then
					is_clicked_img = ls_tempfilepath
					Return 1
				End If
			End If		
		Case 'disabled'
			If FileExists(ls_tempfilepath) Then
				gnv_extfunc.of_getfilewritetime(ls_tempfilepath, ls_tempfilepathdt)
				If gnv_vari.ModifyDT_button_disabled_img <= ls_tempfilepathdt and gnv_vari.ModifyDT_commandbutton_overlay <= ls_tempfilepathdt and gnv_vari.ModifyDT_commandbutton <= ls_tempfilepathdt Then
					is_disabled_img = ls_tempfilepath
					Return 1
				End If
			End If
	End Choose
End If

// 임시파일 신규 생성
ulong lul_fontcolor
string ls_prefixiconfile

lul_fontcolor = icb_parent.Dynamic of_getfontcolor(as_imagetype)

ls_prefixiconfile = icb_parent.Dynamic of_getprefixiconfile()
If fw_f_nvls(ls_prefixiconfile, '') = '' Then
	Choose Case as_imagetype
		Case 'normal'
			gnv_extfunc.of_setcommandbtnoverlayimgw(icb_parent, is_normal_img, ls_tempfilepath, lul_fontcolor)
			is_normal_img = ls_tempfilepath
		Case 'mouseover'
			gnv_extfunc.of_setcommandbtnoverlayimgw(icb_parent, is_mouseover_img, ls_tempfilepath, lul_fontcolor)
			is_mouseover_img = ls_tempfilepath
		Case 'clicked'
			gnv_extfunc.of_setcommandbtnoverlayimgw(icb_parent, is_clicked_img, ls_tempfilepath, lul_fontcolor)
			is_clicked_img = ls_tempfilepath
		Case 'disabled'
			gnv_extfunc.of_setcommandbtnoverlayimgw(icb_parent, is_disabled_img, ls_tempfilepath, lul_fontcolor)
			is_disabled_img = ls_tempfilepath
	End Choose
Else
	ls_prefixiconfile = pf_f_getimagepathappeon(ls_prefixiconfile)
	Choose Case as_imagetype
		Case 'normal'
			gnv_extfunc.of_setcommandbtnoverlayimgw(icb_parent, is_normal_img, ls_tempfilepath, lul_fontcolor, ls_prefixiconfile)
			is_normal_img = ls_tempfilepath
		Case 'mouseover'
			gnv_extfunc.of_setcommandbtnoverlayimgw(icb_parent, is_mouseover_img, ls_tempfilepath, lul_fontcolor, ls_prefixiconfile)
			is_mouseover_img = ls_tempfilepath
		Case 'clicked'
			gnv_extfunc.of_setcommandbtnoverlayimgw(icb_parent, is_clicked_img, ls_tempfilepath, lul_fontcolor, ls_prefixiconfile)
			is_clicked_img = ls_tempfilepath
		Case 'disabled'
			gnv_extfunc.of_setcommandbtnoverlayimgw(icb_parent, is_disabled_img, ls_tempfilepath, lul_fontcolor, ls_prefixiconfile)
			is_disabled_img = ls_tempfilepath
	End Choose
End If

Return 1

end function

public function string of_thisname ();return 'pf_u_commandbutton_overlay'

end function

public subroutine of_setenabled (boolean ab_enabled);choose case ab_enabled
	case true
		this.picturename = is_normal_img
	case false
		this.picturename = is_disabled_img
end choose

this.enabled = ab_enabled
return

end subroutine

public subroutine of_setvisible (boolean ab_visible);this.visible = ab_visible

end subroutine

public subroutine of_settext (string as_text);this.of_setpicturename(is_picturename)

end subroutine

public subroutine of_bringtotop (boolean ab_bringtotop);This.BringToTop = ab_bringtotop
end subroutine

public subroutine of_initialize (pf_u_commandbutton acb_parent, window aw_parent, string as_imagefile);icb_parent	= acb_parent
iw_parent		= aw_parent
is_imagefile	= as_imagefile

// damn it! This constructor event runs twice when using openuserobject()
If NOT Isvalid(icb_parent) Then Return

This.width = icb_parent.width - PixelsToUnits(1, XPixelsToUnits!)
This.height = icb_parent.height - PixelsToUnits(1, YPixelsToUnits!)

// set picturename
If fw_f_nvls(is_imagefile, '') <> '' Then
	This.picturename = is_imagefile
end If

// init each button picture names
This.of_setpicturename(This.picturename)

// properties monitor
inv_timer = create pf_n_timing
inv_timer.of_initialize(This)
end subroutine

on pf_u_commandbutton_overlay.create
end on

on pf_u_commandbutton_overlay.destroy
end on

event constructor;This.Post Event oue_postopen()
end event

event clicked;if isvalid(icb_parent) then
	icb_parent.event clicked()
end if

end event

