forward
global type pf_u_imagebutton from picture
end type
end forward

global type pf_u_imagebutton from picture
integer width = 402
integer height = 112
string pointer = "HyperLink!"
boolean focusrectangle = false
event mousemove pbm_mousemove
event oue_mouseleave ( )
event oue_mouseover ( )
event oue_lbuttonup pbm_lbuttonup
event oue_lbuttondown pbm_lbuttondown
event oue_enablechanged pbm_enable
event oue_picturenamechanged ( )
event type boolean oue_components ( )
event oue_postopen ( )
event timer pbm_timer
event oue_lastopen ( )
end type
global pf_u_imagebutton pf_u_imagebutton

type prototypes
function boolean ReleaseCapture() library "user32.dll"
function long SetCapture(long hWnd) library "user32.dll"

function Boolean TrackMouseEvent(Ref pf_s_TRACKMOUSEEVENT lpTrackMouseEvent) Library 'user32.dll' alias for "TrackMouseEvent;Ansi" 
function Long GetLastError() Library 'Kernel32.dll' 

Function Long SetTimer(Long hwnd, long idTimer, Long uTimeOut, Long tmprc) Library "user32.dll"
Function Long KillTimer(Long hwnd, Long idEvent) Library "user32.dll" 

end prototypes

type variables
Constant string MOUSEOVER_SURFIX = "_hover"
Constant string CLICKED_SURFIX =  "_clicked"
Constant string DISABLED_SURFIX = "_disabled"

private:
	window		iw_parent
	pf_n_timing	inv_timer
	
	fw_u_imgbtndefault		ibtn_default
	fw_u_imgbtncancel		ibtn_cancel
	Boolean	ibcancel	= false /* default와 동시 구현 안됨 */
	
	String		isMainImageFiletime = ''
	
	integer	ii_referencedobjectcnt	
	String		is_picturename
	String		is_normal_img
	String		is_mouseover_img
	String		is_clicked_img
	String		is_disabled_img
	boolean	ib_mouseover
	pf_s_point istr_point

public:
	powerobject	ipo_referencedobject[]
	boolean	i----------------------------------------------------line0	/* empty Object */
	Boolean		ibdefault	= false
	boolean	i----------------------------------------------------line1	/* empty Object */
	boolean		SetBringToTop		= False
	boolean	i----------------------------------------------------line2	/* empty Object */
	boolean		FixedToRight
	boolean		FixedToBottom
	boolean		ScaleToRight
	boolean		ScaleToBottom

	string ReferencedObject
	string OnClickCallEvent
	string DatawindowAction

end variables

forward prototypes
public function integer of_checkandcreateimage (string as_imagetype, string as_imagepath)
public function string of_thisname ()
public subroutine of_setenabled (boolean ab_enabled)
public function integer of_picturenamechanged (string as_picturename)
public subroutine of_setpicturename (string as_picturename)
public subroutine setdefault (boolean ab_default)
public subroutine setcancel (boolean ab_cancel)
end prototypes

event mousemove;if ib_mouseover = false then
	ib_mouseover = true
	this.event oue_mouseover()
	inv_timer.of_start()
	//SetTimer(Handle(This), 1, 300, 0)
	//inv_propmon.of_register('mouseleave', 'oue_mouseleave' )
	//gnv_extfunc.SetTimer(Handle(This), 1, 300, 0)
end if

end event

event oue_mouseleave();choose case this.enabled
	case true
		this.picturename = is_normal_img
	case false
		this.picturename = is_disabled_img
end choose

//if ib_mouseover = true then
//	ib_mouseover = false
//	inv_propmon.of_unregister('mouseleave')
//	this.picturename = is_normal_img
//end if

end event

event oue_mouseover();if isnull(this.picturename) or this.picturename = '' then return
this.picturename = is_mouseover_img

end event

event oue_lbuttonup;if isnull(this.picturename) or this.picturename = '' then return
this.picturename = is_mouseover_img

end event

event oue_lbuttondown;if isnull(this.picturename) or this.picturename = '' then return
this.picturename = is_clicked_img

end event

event oue_enablechanged;choose case this.enabled
	case true
		this.picturename = is_normal_img
	case false
		this.picturename = is_disabled_img
end choose

end event

event oue_picturenamechanged();choose case this.picturename
	case is_normal_img
	case is_mouseover_img
	case is_clicked_img
	case is_disabled_img
	case else
		this.of_picturenamechanged(this.picturename)
end choose

end event

event type boolean oue_components();return true

end event

event oue_postopen();// properties monitor
inv_timer = create pf_n_timing
inv_timer.of_initialize(this)

If ibdefault = True Then this.setdefault(ibdefault)
If ibcancel = True and ibdefault = False Then this.setcancel(ibcancel)

This.post event oue_lastopen()

If fw_f_nvls(ReferencedObject, '') = '' Then Return

// get referenced object
string ls_refobj[]
integer li_objcnt, i

li_objcnt = fw_f_obj2array(ReferencedObject, ';', ls_refobj)
For i = 1 to li_objcnt
	If len(ls_refobj[i]) > 0 Then
		ii_referencedobjectcnt ++
		Choose Case lower(ls_refobj[i])
			Case 'This'
				ipo_referencedobject[ii_referencedobjectcnt] = This
			Case 'parent'
				ipo_referencedobject[ii_referencedobjectcnt] = parent
			Case iw_parent.classname()
				ipo_referencedobject[ii_referencedobjectcnt] = iw_parent
			Case Else
				ipo_referencedobject[ii_referencedobjectcnt] = iw_parent.dynamic of_getwindowobjectbyname(ls_refobj[i])
				If not isvalid(ipo_referencedobject[ii_referencedobjectcnt]) Then
					messagebox('[' + This.classname() + '] 알림', '[' + ls_refobj[i] + '] 참조 오브젝트가 존재하지 않습니다')
				End If
		End Choose
	End If
Next
end event

event timer;if gnv_extfunc.GetCursorPos(istr_point) then
	if gnv_extfunc.ScreenToClient(handle(this), istr_point) then
		if istr_point.xpos >= 0 and istr_point.ypos >= 0 and istr_point.xpos <= unitstopixels(this.width, xunitstopixels!) and istr_point.ypos <= unitstopixels(this.height, yunitstopixels!) then
		else
			ib_mouseover = false
			inv_timer.stop()
			//gnv_extfunc.KillTimer(Handle(this), 1)
			//KillTimer(Handle(this), 1)
			this.post event oue_mouseleave()
		end if
	end if
end if

end event

event oue_lastopen();If SetBringToTop = True Then This.BringToTop = True
end event

public function integer of_checkandcreateimage (string as_imagetype, string as_imagepath);//// 해당 파일이 존재하면 리턴
If fileexists(as_imagepath) Then Return 0

/* as-is */
//// Appeon 환경일 경우 URL 체크
//If gnv_vari.getclienttype = 'WEB' Then
//	If gnv_extfunc.of_getappeonimagefile(as_imagepath) = 0 Then Return 0
//End If

string ls_tempfilepath
long ll_lastpos

// Output 확장자는 jpg, png to-be
ll_lastpos = lastpos(as_imagepath, ".")
If ll_lastpos > 0 Then
	If pos(as_imagepath, ".jpg") > 0 Then as_imagepath = left(as_imagepath, ll_lastpos) + "jpg"
End If

// 임시로 사용될 파일명
ls_tempfilepath = gnv_vari.is_tempdirectory + gnv_extfunc.of_pathstrippath(as_imagepath)

Choose Case as_imagetype
	Case 'mouseover'
		is_mouseover_img = ls_tempfilepath
	Case 'clicked'
		is_clicked_img = ls_tempfilepath
	Case 'disabled'
		is_disabled_img = ls_tempfilepath
End choose

// 임시파일이 존재하면 수정일자 비교, 동일하면 리턴
String ls_newfilewritetime
If fileexists(ls_tempfilepath) Then
	 gnv_extfunc.of_getfilewritetime(ls_tempfilepath, ls_newfilewritetime)
	 If isMainImageFiletime <= ls_newfilewritetime Then Return 0
End If

// 이미지 타입에 따라 임시파일 신규 생성
Choose Case as_imagetype
	Case 'mouseover'
		gnv_extfunc.biz_setmouseoverbtnimg(is_mouseover_img, ls_tempfilepath)
	Case 'clicked'
		gnv_extfunc.biz_setclickedbtnimg(is_clicked_img, ls_tempfilepath)
	Case 'disabled'
		gnv_extfunc.biz_setdisabledbtnimg(is_disabled_img, ls_tempfilepath)
End choose
//gnv_extfunc.of_setfilewritetime(ls_tempfilepath, ls_orgfilewritetime)

Return 1

end function

public function string of_thisname ();return 'pf_u_imagebutton'

end function

public subroutine of_setenabled (boolean ab_enabled);this.enabled = ab_enabled
this.SetPosition (ToTop!)
if gnv_vari.getclienttype = 'WEB' then 
	this.event oue_enablechanged(ab_enabled)
end if

end subroutine

public function integer of_picturenamechanged (string as_picturename);long ll_lastpos
string ls_picture_dir, ls_picture_name
string ls_picture_ext

If isnull(as_picturename) or as_picturename = '' then
	is_picturename = ''
	is_normal_img = ''
	is_mouseover_img = ''
	is_clicked_img = ''
	is_disabled_img = ''
	this.picturename = ''
	Return 0
End If

//as-is
//If is_picturename = as_picturename then Return 0

Long		ll_rtn /* to-be image file accept variable */

is_normal_img = pf_f_getimagepathappeon(as_picturename)

ll_lastpos = lastpos(is_normal_img, "\")
If ll_lastpos > 0 then
	ls_picture_dir = left(is_normal_img, ll_lastpos)
	ls_picture_name = mid(is_normal_img, ll_lastpos + 1)
Else
	ls_picture_dir = ''
	ls_picture_name = is_normal_img
End If

ll_lastpos = lastpos(ls_picture_name, ".")
If ll_lastpos > 0 then
	ls_picture_ext = mid(ls_picture_name, ll_lastpos)
	ls_picture_name = left(ls_picture_name, ll_lastpos - 1)
End If

/* to-be */
//gnv_extfunc.of_getfilewritetime(is_normal_img, isMainImageFiletime) /* is_normal_img 생성일자 등록 */

//is_mouseover_img = ls_picture_dir + MOUSEOVER_PREFIX + ls_picture_name
is_mouseover_img = ls_picture_dir + ls_picture_name + MOUSEOVER_SURFIX + ls_picture_ext
//ll_rtn = pf_f_imagefilestorage(is_mouseover_img)
//If ll_rtn = 0 Then this.of_checkandcreateimage('mouseover', is_mouseover_img)

//is_clicked_img = ls_picture_dir + CLICKED_PREFIX + ls_picture_name
is_clicked_img = ls_picture_dir + ls_picture_name + CLICKED_SURFIX + ls_picture_ext
//ll_rtn = pf_f_imagefilestorage(is_clicked_img)
//If ll_rtn = 0 Then this.of_checkandcreateimage('clicked', is_clicked_img)

//is_disabled_img = ls_picture_dir + DISABLED_PREFIX + ls_picture_name
is_disabled_img = ls_picture_dir + ls_picture_name + DISABLED_SURFIX + ls_picture_ext
//ll_rtn = pf_f_imagefilestorage(is_disabled_img)
//If ll_rtn = 0 Then this.of_checkandcreateimage('disabled', is_disabled_img)

//messagebox('is_mouseover_img', is_mouseover_img)
//messagebox('is_clicked_img', is_clicked_img)
//messagebox('is_disabled_img', is_disabled_img)

//as-is
//is_picturename = as_picturename
If this.enabled  = true then
	If gnv_vari.getclienttype = 'WEB' Then This.picturename = is_normal_img
Else
	this.picturename = is_disabled_img
End If

Return 1

end function

public subroutine of_setpicturename (string as_picturename);this.picturename = as_picturename
this.event oue_picturenamechanged()

end subroutine

public subroutine setdefault (boolean ab_default);ibdefault = ab_default
If ibdefault Then
	If not IsValid(ibtn_default) Then		
		If IsValid(Message.PowerObjectParm) Then
			iw_parent.OpenUserObjectWithParm( ibtn_default, Message.PowerObjectParm, "fw_u_imgbtndefault", 32767, 32767)
		ELSE
			If Len(Message.StringParm) > 0 Then
				iw_parent.OpenUserObjectWithParm( ibtn_default, Message.StringParm, "fw_u_imgbtndefault", 32767, 32767)
			ELSE
				If Message.LongParm <> 0 Then
					iw_parent.OpenUserObjectWithParm( ibtn_default, Message.LongParm, "fw_u_imgbtndefault", 32767, 32767)
				End If
				If Message.DoubleParm <> 0 Then
					iw_parent.OpenUserObjectWithParm( ibtn_default, Message.DoubleParm, "fw_u_imgbtndefault", 32767, 32767)
				End If
				If Message.WordParm <> 0 Then
					iw_parent.OpenUserObjectWithParm( ibtn_default, Message.WordParm, "fw_u_imgbtndefault", 32767, 32767)
				End If
			End If
		End If		
		If not IsValid(ibtn_default) Then iw_parent.OpenUserObject( ibtn_default, 'fw_u_imgbtndefault', 32767, 32767)		
	End If	
	If IsValid(ibtn_default) Then
		ibtn_default.default = ibdefault 
		ibtn_default.setparent(this)
		ibtn_default.enabled = this.enabled
		//ibtn_default.x = 32767
	End If
End If
end subroutine

public subroutine setcancel (boolean ab_cancel);ibcancel = ab_cancel
If ibcancel Then
	If not IsValid(ibtn_cancel) Then		
		If IsValid(Message.PowerObjectParm) Then
			iw_parent.OpenUserObjectWithParm( ibtn_cancel, Message.PowerObjectParm, "fw_u_imgbtncancel", 32767, 32767)
		Else
			If Len(Message.StringParm) > 0 Then
				iw_parent.OpenUserObjectWithParm( ibtn_cancel, Message.StringParm, "fw_u_imgbtncancel", 32767, 32767)
			Else
				If Message.LongParm <> 0 Then
					iw_parent.OpenUserObjectWithParm( ibtn_cancel, Message.LongParm, "fw_u_imgbtncancel", 32767, 32767)
				End If
				If Message.DoubleParm <> 0 Then
					iw_parent.OpenUserObjectWithParm( ibtn_cancel, Message.DoubleParm, "fw_u_imgbtncancel", 32767, 32767)
				End If
				If Message.WordParm <> 0 Then
					iw_parent.OpenUserObjectWithParm( ibtn_cancel, Message.WordParm, "fw_u_imgbtncancel", 32767, 32767)
				End If
			End If
		End If		
		If not IsValid(ibtn_cancel) Then iw_parent.OpenUserObject( ibtn_cancel, 'fw_u_imgbtncancel', 32767, 32767)		
	End If	
	If IsValid(ibtn_cancel) Then
		ibtn_cancel.cancel = ibcancel
		ibtn_cancel.setparent(this)
		ibtn_cancel.enabled = this.enabled
		//ibtn_cancel.x = 32767
	End If
End If
end subroutine

on pf_u_imagebutton.create
end on

on pf_u_imagebutton.destroy
end on

event constructor;// get parent window
iw_parent = fw_f_obj4parentwindow(This)

// init each button picture names
This.of_setpicturename(this.picturename)

// postopen event
This.post event oue_postopen()

end event

event clicked;integer i

// 참조 오브젝트가 선언된 경우 해당 오브젝트의 이벤트를 호출합니다
if ii_referencedobjectcnt > 0 then
	for i = 1 to ii_referencedobjectcnt
		if len(OnClickCallEvent) > 0 then
			if not isvalid(ipo_referencedobject[i]) then continue
			if ipo_referencedobject[i].triggerevent(OnClickCallEvent) = -1 then exit
		end if
	next
end if

end event

