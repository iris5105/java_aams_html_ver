forward
global type w_mdi4framelv2 from w_mdi4frame
end type
type st_vsplit from pf_u_splitbar_vertical within w_mdi4framelv2
end type
type uo_statusbar from fw_u_statebar4frame within w_mdi4framelv2
end type
type p_sheetwait from picture within w_mdi4framelv2
end type
type st_leftbar from pf_u_statictext within w_mdi4framelv2
end type
type p_leftbar from pf_u_picture within w_mdi4framelv2
end type
type p_hide from pf_u_imagebutton within w_mdi4framelv2
end type
type p_logout from pf_u_imagebutton within w_mdi4framelv2
end type
type p_1project from pf_u_imagebutton within w_mdi4framelv2
end type
type p_allnotice from pf_u_imagebutton within w_mdi4framelv2
end type
type p_print from pf_u_imagebutton within w_mdi4framelv2
end type
type p_msg from pf_u_imagebutton within w_mdi4framelv2
end type
type p_help from pf_u_imagebutton within w_mdi4framelv2
end type
type p_bookmark from pf_u_imagebutton within w_mdi4framelv2
end type
type p_menu from pf_u_imagebutton within w_mdi4framelv2
end type
type p_home from pf_u_imagebutton within w_mdi4framelv2
end type
type p_bell from pf_u_imagebutton within w_mdi4framelv2
end type
type uo_sheettab from fw_u_sheettab4frame within w_mdi4framelv2
end type
type uo_push4message from fw_u_push4message within w_mdi4framelv2
end type
type dw_pgm4info from adw_jtier within w_mdi4framelv2
end type
type dw_pgm_search from datawindow within w_mdi4framelv2
end type
type uo_bookmark from fw_u_bookmark4frame within w_mdi4framelv2
end type
type uo_xpmenu from fw_u_menu4frame within w_mdi4framelv2
end type
type p_right_logo from pf_u_picture within w_mdi4framelv2
end type
type uo_userinfo from fw_u_userinfo4frame within w_mdi4framelv2
end type
type p_frame_loading from picture within w_mdi4framelv2
end type
type uo_topmenu from fw_u_topmenu4frame within w_mdi4framelv2
end type
type p_kor from pf_u_imagebutton within w_mdi4framelv2
end type
type p_eng from pf_u_imagebutton within w_mdi4framelv2
end type
type p_chn from pf_u_imagebutton within w_mdi4framelv2
end type
type p_vit from pf_u_imagebutton within w_mdi4framelv2
end type
end forward

global type w_mdi4framelv2 from w_mdi4frame
boolean visible = false
integer width = 6894
integer height = 3268
string title = "AAMS"
string menuname = "m_hotkey"
long backcolor = 32567536
event wue_lastopen ( )
st_vsplit st_vsplit
uo_statusbar uo_statusbar
p_sheetwait p_sheetwait
st_leftbar st_leftbar
p_leftbar p_leftbar
p_hide p_hide
p_logout p_logout
p_1project p_1project
p_allnotice p_allnotice
p_print p_print
p_msg p_msg
p_help p_help
p_bookmark p_bookmark
p_menu p_menu
p_home p_home
p_bell p_bell
uo_sheettab uo_sheettab
uo_push4message uo_push4message
dw_pgm4info dw_pgm4info
dw_pgm_search dw_pgm_search
uo_bookmark uo_bookmark
uo_xpmenu uo_xpmenu
p_right_logo p_right_logo
uo_userinfo uo_userinfo
p_frame_loading p_frame_loading
uo_topmenu uo_topmenu
p_kor p_kor
p_eng p_eng
p_chn p_chn
p_vit p_vit
end type
global w_mdi4framelv2 w_mdi4framelv2

type variables
// to-be
constant Long	MainFrameWidth  = Long(PixelsToUnits(1500, XPixelsToUnits!))
constant Long	MainFrameHeight = Long(PixelsToUnits(772, YPixelsToUnits!))

Private:
	window	iw_home

	string	ispgmgostate = ''

	// SetWindowPos
	Constant Long HWND_TOPMOST = -1
	Constant Long HWND_NOTOPMOST = -2
	Constant Long HWND_TOP = 1
	Constant Long SWP_NOSIZE = 1
	Constant Long SWP_NOMOVE = 2
	Constant Long SWP_NOACTIVATE = 16
	Constant Long SWP_SHOWWINDOW = 64
	
	/* to-be dynamic push4message / statusbar*/	
	fw_n_animation	inv_animation
	fw_n_animate	inv_ani_search

	boolean	ibpush4message		= true
	boolean	ibpush4message2state	= false
	boolean	ib_mdi_setredraw = true
	
protected:
	graphicobject	igo_selected
	
	long		il_vsplit_xpos, il_normalmenuwidth, il_hiddenmenuwidth
	boolean	ib_leftmenu_visible

Public:
	boolean	ibbeonce4menu = true
	Long		il_return4sheetclosequery	= 0
	time		itmessagetime
	long		ilmessagecycle = 60
	string	iscurrentpgmno
end variables

forward prototypes
public subroutine of_openhomewindow ()
public subroutine of_logout_job ()
public function integer setmicrohelp (string t)
public function integer of_opensheet (string as_pgm_no, string as_pgm_id, string as_pgm_nm, string as_parameter1, string as_parameter2, string as_parameter3)
public subroutine of_logcreate ()
public subroutine of_framesetredraw (boolean ab_boolean)
public subroutine of_setpgmexpression (string as_pgm_no)
public function integer of_setresize (boolean ab_switch)
public subroutine of_setuserinfo ()
public function boolean of_getleftmenustatus ()
public function integer of_setmessagebox (string as_title, string as_content)
public function long of_setdynamicevent (string as_objectname, string as_eventname, n_menu anvo_menudata)
public function string of_thisname ()
public subroutine of_xpmenuhide4btn ()
public subroutine of_setpgm4info (string as_pgmno)
public subroutine of_sethotkey (string as_keygb)
public subroutine of_clicked4menu (string as_pgm_no)
public function integer of_lock4processing ()
public subroutine of_active4lang ()
public subroutine of_sheettab_setclose22hide ()
public function boolean of_sheettab_getclose22status ()
public subroutine of_setmmove4window (string as_classname)
public function integer setredraw (boolean f)
public function long of_getmdiclientwidth ()
public function long of_getmdiclientheight ()
public subroutine of_sheetwait (boolean ab_boolean)
public subroutine of_set_message (boolean ab_retrieve)
public subroutine uf_refresh_dimension ()
public subroutine of_loadingwait (boolean ab_boolean)
public function integer of_active_pgm_check ()
end prototypes

event wue_lastopen();ib_mdi_setredraw = true
IF	gaa.bookmark	Then
	p_bookmark.post event clicked()
Else
	p_menu.post event clicked()
End IF
end event

public subroutine of_openhomewindow ();If Isvalid(iw_home) Then
	iw_home.bringtotop = true
	Return
End If

window	lw_home

gnv_menu.is_pgm_no	= upper(gnv_vari.w_home)
gnv_menu.is_pgm_id	= gnv_vari.w_home
gnv_menu.is_pgm_nm	= 'WELCOME'

st_mdiclient.show()
Opensheet(lw_home, gnv_menu.is_pgm_id, This, 0, Original!)
st_mdiclient.hide()
iw_home = GetActiveSheet ( )

title = gaa.title + ' - 작업일자 '+ gnv_vari.of_getprofile("login.corp.aams.dt", string (datetime (today ()),'yyyy.mm.dd'))
end subroutine

public subroutine of_logout_job ();// LEFT 메뉴 숨김상태를 보관해서
// 다음 오픈 시 동일한 상태를 유지한다.
boolean lb_leftmenu_visible

if gnv_vari.of_getprofile("mdi.leftmenu.visible", "true") = "true" then
	lb_leftmenu_visible = true
end if

if lb_leftmenu_visible <> ib_leftmenu_visible then
	gnv_vari.of_setprofile("mdi.leftmenu.visible", string (ib_leftmenu_visible))
end if

end subroutine

public function integer setmicrohelp (string t);uo_statusbar.of_setmessage(t)
inv_animation.of_slide_up(uo_statusbar, This.Workspaceheight( ), (This.Workspaceheight( ) - uo_statusbar.Height), 0.2)
Return 1
end function

public function integer of_opensheet (string as_pgm_no, string as_pgm_id, string as_pgm_nm, string as_parameter1, string as_parameter2, string as_parameter3);If of_lock4processing() = -1 Then Return -1

String	ls_systemdiv, ls_activepgmno

/* opensheet init window instance variable */
iw_mwindow	= null_w
iw_mchild	= null_w

/* activesheet  check 후 중복실행 방지 */
iw_mgetactivesheet = This.GetActiveSheet ( )
If Isvalid(iw_mgetactivesheet) Then ls_activepgmno = iw_mgetactivesheet.Dynamic of_getpgmno()

If as_pgm_no = ls_activepgmno Then Return -1

/* to-be  활성화된 sheet메뉴를 선택하지 않고 비활성화된 sheet 메뉴를 선택할 시 */
If uo_sheettab.of_isOpenedSheet(as_pgm_no) = True Then
	uo_sheettab.of_SheetSetfocus(as_pgm_no)
	Return -1
End If

/* 윈도우 갯수 제한 */
long li_tab_result
If uo_sheettab.of_tablimit() > 9 Then
	li_tab_result = uo_sheettab.of_sheetsetfocus(as_pgm_no)
	If li_tab_result = -1 Then
		This.of_setpgmexpression('') /* 선택 취소로 empty value */	
		MessageBox( 'Notice!', "Program tabs can not exceed 10.~r~nPlease close the open program and select it." )
		iw_mgetactivesheet.setfocus()
		Return -1
	End If
End If

TRY
	iw_mwindow = Create using as_pgm_id
CATCH  (RuntimeError rte)
	messagebox('Notice', '[' + as_pgm_nm + '] The program you selected is currently under development.~r~nPlease check back later')
	This.of_setpgmexpression('') /* 선택 취소로 empty value */
	Return -1
END TRY
If gnv_vari.getclienttype = 'WEB' Then
	If Not IsValid(iw_mwindow) Then
		messagebox('Notice', '[' + as_pgm_nm + '] The program you selected is currently under development.~r~nPlease check back later')
		This.of_setpgmexpression('') /* 선택 취소로 empty value */
		Return -1
	End If
End If

If iw_mwindow.windowtype <> main! Then
	This.of_setpgmexpression('') /* 선택 취소로 empty value */	
	Open(iw_mchild, as_pgm_id)	
	setpointer(arrow!)
	Return -1
End If

gnv_menu.is_pgm_no		= as_pgm_no
gnv_menu.is_pgm_id		= as_pgm_id
gnv_menu.is_pgm_nm		= as_pgm_nm
gnv_menu.is_parameter1	= as_parameter1
gnv_menu.is_parameter2	= as_parameter2
gnv_menu.is_parameter3	= as_parameter3
// 시트 윈도우 오픈
If uo_sheettab.of_isOpenedSheet(as_pgm_no) = false Then
	fw_f_setparentwindowinit()
	fw_f_messageclear()
	/* delaytime start; windelaytime init */
	gnv_vari.windelaytime = 0
	gnv_vari.windelaytime = cpu()
	
	of_loadingwait(true)//st_mdiclient.show()
	OpenSheet (iw_mchild, gnv_menu.is_pgm_id, This, 0, Original!)
//	of_sheetwait (True)
End If

Return 1
end function

public subroutine of_logcreate ();
end subroutine

public subroutine of_framesetredraw (boolean ab_boolean);setredraw (ab_boolean)
end subroutine

public subroutine of_setpgmexpression (string as_pgm_no);If fw_f_nvls(as_pgm_no, '') = '' Then
	Window	lw_activesheet
	lw_activesheet = This.GetActiveSheet()
	If IsValid(lw_activesheet) Then
		If lw_activesheet.triggerevent('wue_components') = 1 then
			as_pgm_no = lw_activesheet.Dynamic of_getpgmno()
		End If
	End If
End If

iscurrentpgmno = as_pgm_no
If uo_xpmenu.visible = True Then uo_xpmenu.of_setpgmexpression(as_pgm_no)
If uo_bookmark.visible = True Then uo_bookmark.of_setpgmexpression(as_pgm_no)
end subroutine

public function integer of_setresize (boolean ab_switch);integer	li_rc

//messagebox(string(PixelsToUnits(783, XPixelsToUnits!)), Long(UnitsToPixels(3132, YUnitsToPixels!)))
//messagebox(string(UnitsToPixels(6857, XUnitsToPixels!)), Long(UnitsToPixels(3088, YUnitsToPixels!)))
// Check arguments
If IsNull (ab_switch) then
	return -1
End If

If ab_Switch then
	If not IsValid (inv_resize) Then
		inv_resize = create pf_n_resize
		inv_resize.of_SetOrigSize(MainFrameWidth, MainFrameHeight) //(This.WorkSpaceWidth(), This.WorkSpaceHeight())//(This.Width, This.Height)
		inv_resize.of_SetMinSize(Long(PixelsToUnits(1024, XPixelsToUnits!)), Long(PixelsToUnits(768, YPixelsToUnits!)))
		inv_resize.of_AutoResizeRegister(this)
		li_rc = 1
	End If
else
	If IsValid (inv_resize) Then
		destroy inv_resize
		li_rc = 1
	End If
End If

Return li_rc
end function

public subroutine of_setuserinfo ();// db  구분표시 : R / T
if gnv_vari.is_dbconnect = 'T' then
	uo_userinfo.object.p_bg.filename = ''
end if
// 고객정보 설정
String	ls_role_remark
Long	ll_rolecnt, ll_i

uo_userinfo.insertrow(0)
uo_userinfo.setitem(1, 'user_name', gnv_vari.is_user_nm + ' 님')
uo_userinfo.setitem(1, 'dept_name',  gnv_vari.is_dept_cd)
uo_userinfo.setitem(1, 'logintime', gnv_vari.idtm_login)

ll_rolecnt = UpperBound(gnv_vari.role_no)
ls_role_remark = ''
If ll_rolecnt > 1 Then ls_role_remark = ' more'
For ll_i = 1 To ll_rolecnt
	If fw_f_nvls(gnv_vari.role_no[ll_i], '') <> '' Then
		uo_userinfo.setitem(1, 'role_no',  gnv_vari.role_no[ll_i])
		uo_userinfo.setitem(1, 'role_nm',  gnv_vari.role_nm[ll_i] + ls_role_remark)
		Exit
	End If
Next

ls_role_remark = ''
For ll_i = 1 To ll_rolecnt
	If fw_f_nvls(gnv_vari.role_no[ll_i], '') = '' Then Continue
	Choose Case ll_i
		Case ll_rolecnt
			ls_role_remark += gnv_vari.role_nm[ll_i]
		Case Else
			ls_role_remark += gnv_vari.role_nm[ll_i] + ', '
	End Choose
Next

If fw_f_nvls(ls_role_remark, '') <> '' Then uo_userinfo.setitem(1, 'role_nmlist',  ls_role_remark)
end subroutine

public function boolean of_getleftmenustatus ();Return ib_leftmenu_visible
end function

public function integer of_setmessagebox (string as_title, string as_content);String	ls_return
Long	ll_return

fw_s_msgbox	lstr_msgbox

lstr_msgbox.title	= as_title
lstr_msgbox.content	= as_content
OpenWithParm(fw_w_messagebox, lstr_msgbox)
ls_return = message.stringparm

fw_f_messageclear()

ll_return = Long(ls_return)

Return ll_return
end function

public function long of_setdynamicevent (string as_objectname, string as_eventname, n_menu anvo_menudata);Integer				i, li_retval
dragobject			ldo_target

window	lw_window

li_retval = 0
Choose Case as_objectname
	Case 'fw_u_sheettab4frame'
		Choose Case as_eventname
			Case 'oue_addsheettab'
				li_retval	= uo_sheettab.Event oue_addsheettab(anvo_menudata)
				Return li_retval
			Case 'oue_closesheettab'
				li_retval	= uo_sheettab.Event oue_closesheettab(anvo_menudata)
				Return li_retval				
			Case 'oue_selectsheettab'
				lw_window = GetActiveSheet ( )
				if lw_window.classname() = gnv_vari.w_home then
					li_retval	= uo_sheettab.dynamic of_deselecttab()
				else
					li_retval	= uo_sheettab.Event oue_selectsheettab(anvo_menudata)
				end if
				Return li_retval
			Case 'oue_deselectsheettab'
				li_retval = uo_sheettab.Event oue_deselectsheettab(anvo_menudata)
				Return li_retval
			Case 'of_setpgmexpression'
				uo_sheettab.of_setpgmexpression('')
			Case Else
				//
		End Choose
	Case 'fw_u_bookmark4frame'
		Choose Case as_eventname
			Case 'oue_refreshmenu'
				uo_bookmark.Event oue_refreshmenu()
		End Choose
	Case 'fw_u_statebar4frame'
		Choose Case as_eventname
			Case 'oue_setwindowname'
				uo_statusbar.Event oue_setwindowname(anvo_menudata.is_statusbar_id)
		End Choose
End Choose

Return li_retval
end function

public function string of_thisname ();return 'uo_treemenu'

end function

public subroutine of_xpmenuhide4btn ();If Pos(p_hide.picturename, 'hide_btn') > 0 Then
	p_hide.of_setpicturename("..\img\mainframe\mdi4comm\view_btn.jpg")
Else
	p_hide.of_setpicturename("..\img\mainframe\mdi4comm\hide_btn.jpg")
End If
end subroutine

public subroutine of_setpgm4info (string as_pgmno);String	ls_pgmnm, ls_pgmicon

ls_pgmnm = gnv_rolemenu.of_getpgmnm(as_pgmno)
ls_pgmicon = gnv_rolemenu.of_getpgmicon(as_pgmno)

IF	fw_f_nvls(ls_pgmnm, '')<>''	Then
	CHOOSE CASE LENA (ls_pgmnm)
		CASE IS >= 21
			dw_pgm4info.MODIFY ('t_groupnm.font.height="-12"')
		CASE IS >= 16
			dw_pgm4info.MODIFY ('t_groupnm.font.height="-14"')
		CASE ELSE
			dw_pgm4info.MODIFY ('t_groupnm.font.height="-18"')
	END CHOOSE
	dw_pgm4info.Object.t_groupnm.text = ls_pgmnm
End IF

IF  (fw_f_nvls(ls_pgmicon, '') = '') OR (NOT FileExists (ls_pgmicon)) THEN
	ls_pgmicon = "..\img\mainframe\mdi4topmenu\topmenu_default.jpg"
END IF

dw_pgm4info.Object.p_icon4bg.filename = ls_pgmicon
end subroutine

public subroutine of_sethotkey (string as_keygb);window	lw_window
Choose Case as_keygb
	Case 'F1'
		dw_pgm4info.SetColumn('pgm_go')
		dw_pgm4info.SetFocus()
	Case 'F2'
		p_hide.PostEvent('Clicked')
	Case 'F4'
		lw_window = This.GetActiveSheet ( )
		uo_sheettab.p_pgm4close1.PostEvent('Clicked')
	Case 'F3','F5','F6','F7','F8','F9','A','i','B','D','F','S','T','P','Q'
		lw_window = This.GetActiveSheet ( )
		If lw_window.triggerevent('wue_components') = 1 then
			lw_window.dynamic of_sethotkey(as_keygb)
		End If
End Choose
end subroutine

public subroutine of_clicked4menu (string as_pgm_no);Long	ll_lvl4topmenu

ll_lvl4topmenu = 2

uo_xpmenu.setredraw(False)
If uo_xpmenu.of_setmenudepth(ll_lvl4topmenu) = -1 Then Return

// 하위메뉴 조회
uo_xpmenu.of_drawmenu(as_pgm_no)
uo_xpmenu.setredraw(True)

If uo_xpmenu.visible = false Then p_menu.post event clicked()
end subroutine

public function integer of_lock4processing ();If p_sheetwait.Visible	Then
	SetMicroHelp ('The system is processing. Please wait a moment.')
	Return -1
End If

n_loading	lu_bar
n_loadingyield	lu_yield

lu_bar = CREATE n_loading
lu_yield = CREATE n_loadingyield

IF	SharedObjectGet ('loadingopen', lu_bar)=Success!     THEN RETURN -1
IF	SharedObjectGet ('loadingpage', lu_bar)=Success!     THEN RETURN -1
IF	SharedObjectGet ('loadingrd', lu_bar)=Success!       THEN RETURN -1
IF	SharedObjectGet ('loadingretrieve', lu_bar)=Success! THEN RETURN -1
IF	SharedObjectGet ('loadingyield', lu_yield)=Success!  THEN RETURN -1

return 1
end function

public subroutine of_active4lang ();long	ll_rtn
gnv_lang.ids_langcvt.settransobject(sqlca)
ll_rtn = gnv_lang.ids_langcvt.retrieve(gnv_vari.is_sys_id, '01')
end subroutine

public subroutine of_sheettab_setclose22hide ();uo_sheettab.of_setclose22hide()
end subroutine

public function boolean of_sheettab_getclose22status ();boolean	lb_b
lb_b = uo_sheettab.of_getclose22status()
return uo_sheettab.of_getclose22status()
end function

public subroutine of_setmmove4window (string as_classname);window lw_activesheet

lw_activesheet = This.GetActiveSheet()
If IsValid(lw_activesheet) Then
	If pos(as_classname, 'sort2off') = 0 Then
		If lw_activesheet.triggerevent('wue_components') = 1 then lw_activesheet.Event mousemove(0, 0, 0)
	End If	
	If pos(as_classname, 'setclose22hide') = 0 Then
		If of_sheettab_getclose22status() = true Then of_sheettab_setclose22hide()
	End If
End If
end subroutine

public function integer setredraw (boolean f);int	r = 1
if ib_mdi_setredraw then
	return super::setredraw(f)
else
	this.enabled = f
end if
return r
end function

public function long of_getmdiclientwidth ();return long(st_mdiclient.width)
end function

public function long of_getmdiclientheight ();return long(st_mdiclient.height)
end function

public subroutine of_sheetwait (boolean ab_boolean);Choose Case ab_boolean
	Case True
		p_sheetwait.visible = True
		p_sheetwait.show()
	Case False
		p_sheetwait.visible = False
		p_sheetwait.hide()
End Choose
end subroutine

public subroutine of_set_message (boolean ab_retrieve);//알림이 있는지 확인할 때 실행
//알림이 있으면 이미지 변경
IF ab_retrieve	THEN uo_push4message.of_retrieve()

IF uo_push4message.dw_push.rowcount()>0	Then
	//깜박거림제거
	IF p_bell.picturename<>'..\img\mainframe\mdi4comm\fw_top_bell.jpg'	Then
		p_bell.of_setpicturename('..\img\mainframe\mdi4comm\fw_top_bell.jpg')
	End IF
Else
	IF p_bell.picturename<>'..\img\mainframe\mdi4comm\fw_top_bell_off.jpg'	Then
		p_bell.of_setpicturename('..\img\mainframe\mdi4comm\fw_top_bell_off.jpg')
	End IF
End IF
p_bell.setredraw(TRUE)
end subroutine

public subroutine uf_refresh_dimension ();iw_home.dynamic uf_corp_gr ()
p_bookmark.event clicked()
end subroutine

public subroutine of_loadingwait (boolean ab_boolean);choose case ab_boolean
	case true
		st_mdiclient.show()
		p_frame_loading.visible = true
		p_frame_loading.show()
		ez_f_delaytime(500)
	case false		
		p_frame_loading.visible = false
		p_frame_loading.hide()
		st_mdiclient.hide()
end choose
end subroutine

public function integer of_active_pgm_check ();iw_mgetactivesheet = this.getactiveSheet ( )

if Not Isvalid(iw_mgetactivesheet) then
	//Messagebox('Check', '프로그램이 활성화 되지 않았습니다.')
	return -1
end if

string	ls_menu_sn
ls_menu_sn = iw_mgetactivesheet.dynamic of_getpgmno()
if fw_f_nvls(ls_menu_sn, '') = '' then
	return -1
end if

return 1
end function

on w_mdi4framelv2.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_hotkey" then this.MenuID = create m_hotkey
this.st_vsplit=create st_vsplit
this.uo_statusbar=create uo_statusbar
this.p_sheetwait=create p_sheetwait
this.st_leftbar=create st_leftbar
this.p_leftbar=create p_leftbar
this.p_hide=create p_hide
this.p_logout=create p_logout
this.p_1project=create p_1project
this.p_allnotice=create p_allnotice
this.p_print=create p_print
this.p_msg=create p_msg
this.p_help=create p_help
this.p_bookmark=create p_bookmark
this.p_menu=create p_menu
this.p_home=create p_home
this.p_bell=create p_bell
this.uo_sheettab=create uo_sheettab
this.uo_push4message=create uo_push4message
this.dw_pgm4info=create dw_pgm4info
this.dw_pgm_search=create dw_pgm_search
this.uo_bookmark=create uo_bookmark
this.uo_xpmenu=create uo_xpmenu
this.p_right_logo=create p_right_logo
this.uo_userinfo=create uo_userinfo
this.p_frame_loading=create p_frame_loading
this.uo_topmenu=create uo_topmenu
this.p_kor=create p_kor
this.p_eng=create p_eng
this.p_chn=create p_chn
this.p_vit=create p_vit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_vsplit
this.Control[iCurrent+2]=this.uo_statusbar
this.Control[iCurrent+3]=this.p_sheetwait
this.Control[iCurrent+4]=this.st_leftbar
this.Control[iCurrent+5]=this.p_leftbar
this.Control[iCurrent+6]=this.p_hide
this.Control[iCurrent+7]=this.p_logout
this.Control[iCurrent+8]=this.p_1project
this.Control[iCurrent+9]=this.p_allnotice
this.Control[iCurrent+10]=this.p_print
this.Control[iCurrent+11]=this.p_msg
this.Control[iCurrent+12]=this.p_help
this.Control[iCurrent+13]=this.p_bookmark
this.Control[iCurrent+14]=this.p_menu
this.Control[iCurrent+15]=this.p_home
this.Control[iCurrent+16]=this.p_bell
this.Control[iCurrent+17]=this.uo_sheettab
this.Control[iCurrent+18]=this.uo_push4message
this.Control[iCurrent+19]=this.dw_pgm4info
this.Control[iCurrent+20]=this.dw_pgm_search
this.Control[iCurrent+21]=this.uo_bookmark
this.Control[iCurrent+22]=this.uo_xpmenu
this.Control[iCurrent+23]=this.p_right_logo
this.Control[iCurrent+24]=this.uo_userinfo
this.Control[iCurrent+25]=this.p_frame_loading
this.Control[iCurrent+26]=this.uo_topmenu
this.Control[iCurrent+27]=this.p_kor
this.Control[iCurrent+28]=this.p_eng
this.Control[iCurrent+29]=this.p_chn
this.Control[iCurrent+30]=this.p_vit
end on

on w_mdi4framelv2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_vsplit)
destroy(this.uo_statusbar)
destroy(this.p_sheetwait)
destroy(this.st_leftbar)
destroy(this.p_leftbar)
destroy(this.p_hide)
destroy(this.p_logout)
destroy(this.p_1project)
destroy(this.p_allnotice)
destroy(this.p_print)
destroy(this.p_msg)
destroy(this.p_help)
destroy(this.p_bookmark)
destroy(this.p_menu)
destroy(this.p_home)
destroy(this.p_bell)
destroy(this.uo_sheettab)
destroy(this.uo_push4message)
destroy(this.dw_pgm4info)
destroy(this.dw_pgm_search)
destroy(this.uo_bookmark)
destroy(this.uo_xpmenu)
destroy(this.p_right_logo)
destroy(this.uo_userinfo)
destroy(this.p_frame_loading)
destroy(this.uo_topmenu)
destroy(this.p_kor)
destroy(this.p_eng)
destroy(this.p_chn)
destroy(this.p_vit)
end on

event open;call super::open;This.of_framesetredraw (false) /* 해당 controls false */

title = gaa.title + ' - 작업일자 '+ gnv_vari.of_getprofile("login.corp.aams.dt", string (datetime (today ()),'yyyy.mm.dd'))
p_right_logo.PictureName = '..\img\mainframe\right_logo\fw_top_logo_right_' + gaa.corp_gr + '.jpg'

gw_mdi = this

// Background Color 설정
this.backcolor = gnv_vari.framebackcolor

fw_f_setlog4pgm('sy1001001', 'frame', 'frame', 'frame', 'frame', '', 'system open') /* log */

If fw_f_nvls(gnv_vari.is_lang_type, '')='' Then gnv_vari.is_lang_type = 'lng_kor'
end event

event close;call super::close;fw_f_setlog4pgm('sy1001002', 'frame', 'frame', 'frame', 'frame', '', 'system end') /* log */
this.of_logout_job()
end event

event resize;call super::resize;dw_pgm4info.height = height - 248
If uo_statusbar.visible = true Then inv_animation.post of_refresh(uo_statusbar) /* resize 시 position check가 안됨 refresh 상태 지정 */
end event

event activate;call super::activate;title = gaa.title + ' - 작업일자 '+ gnv_vari.of_getprofile("login.corp.aams.dt", string (datetime (today ()),'yyyy.mm.dd'))
end event

event wue_postopen;call super::wue_postopen;This.visible = true
This.WindowState = Maximized!

// Top 메뉴 조회
uo_topmenu.of_drawmenu('')

// 즐겨찾기 메뉴 활성화
if gnv_vari.of_getprofile("mdi.leftmenu.visible", "true") = "true" then
	ib_leftmenu_visible = true
else
	ib_leftmenu_visible = false
end if

il_normalmenuwidth = uo_bookmark.width
il_hiddenmenuwidth = uo_bookmark.width

// LEFT 메뉴 상태설정
if ib_leftmenu_visible = false then
	uo_xpmenu.visible = false
	ib_leftmenu_visible = true
	p_home.event clicked()
end if

of_setuserinfo()  /* to-be user info */
gnv_vari.is_last4topmenu = gnv_vari.of_getprofile("frame.last.topmenu", "t_menubg_01")

//gnv_vari.is_last4topmenu = gnv_vari.of_getprofile4topmenu("frame.last.topmenu", "t_menubg_01")
//gnv_vari.is_last4submenu = gnv_vari.of_getprofile4topmenu("frame.last.submenu", "t_menubg_01")
If fw_f_nvls(gnv_vari.is_last4topmenu, '') <> '' and ibbeonce4menu = true Then
	uo_topmenu.dynamic of_menuclicked(0, gnv_vari.is_last4topmenu)
Else
	uo_topmenu.event oue_initroleclicked() /* to-be init menu clicked */
End If

SetPointer(Arrow!)

//알림가져오기
itmessagetime = now()
of_set_message (TRUE)

post of_framesetredraw (True) /* 해당 controls true */
post of_openhomewindow() // HOME 윈도우 오픈
post of_active4lang()
post event wue_lastopen()
end event

type st_mdiclient from w_mdi4frame`st_mdiclient within w_mdi4framelv2
integer x = 1440
integer y = 384
integer width = 5408
integer height = 2700
end type

event st_mdiclient::resize;call super::resize;uo_sheettab.X = This.x
uo_sheettab.Width = This.Width
p_sheetwait.X = Long(PixelsToUnits(UnitsToPixels(This.X + Round(This.Width / 2.8, 0), XUnitsToPixels!), XPixelsToUnits!))
p_sheetwait.Y = Long(PixelsToUnits(UnitsToPixels(This.Y + Round(This.Height / 2.7, 0), XUnitsToPixels!), XPixelsToUnits!))

p_frame_loading.x = long(PixelsToUnits(UnitsToPixels(this.x + round((this.width - p_frame_loading.width) / 2, 0), XUnitsToPixels!), XPixelsToUnits!))
p_frame_loading.y = long(PixelsToUnits(UnitsToPixels(this.y + round(this.height / 4.5, 0), XUnitsToPixels!), XPixelsToUnits!))

end event

event st_mdiclient::move;call super::move;uo_sheettab.X = This.x
uo_sheettab.Width = This.Width
uo_push4message.X = This.x

p_sheetwait.X = Long(PixelsToUnits(UnitsToPixels(This.X + Round(This.Width / 2.8, 0), XUnitsToPixels!), XPixelsToUnits!))
p_sheetwait.Y = Long(PixelsToUnits(UnitsToPixels(This.Y + Round(This.Height / 2.7, 0), XUnitsToPixels!), XPixelsToUnits!))

p_frame_loading.x = long(PixelsToUnits(UnitsToPixels(this.x + round((this.width - p_frame_loading.width) / 2, 0), XUnitsToPixels!), XPixelsToUnits!))
p_frame_loading.y = long(PixelsToUnits(UnitsToPixels(this.y + round(this.height / 4.5, 0), XUnitsToPixels!), XPixelsToUnits!))

end event

type st_vsplit from pf_u_splitbar_vertical within w_mdi4framelv2
integer x = 1394
integer y = 248
integer width = 46
integer height = 3840
boolean bringtotop = true
long backcolor = 22830335
boolean setmainframecolor = true
boolean ib_autoresize = false
string leftdragobject = "dw_pgm4info;uo_xpmenu;uo_bookmark;p_hide"
string rightdragobject = "st_mdiclient;uo_statusbar"
end type

type uo_statusbar from fw_u_statebar4frame within w_mdi4framelv2
boolean visible = false
integer x = 1467
integer y = 3000
integer width = 5353
integer taborder = 80
boolean bringtotop = true
string text = ""
long tabtextcolor = 0
long picturemaskcolor = 0
boolean fixedtobottom = true
boolean scaletoright = true
end type

on uo_statusbar.destroy
call fw_u_statebar4frame::destroy
end on

type p_sheetwait from picture within w_mdi4framelv2
boolean visible = false
integer x = 2921
integer y = 1092
integer width = 320
integer height = 280
boolean bringtotop = true
boolean enabled = false
string picturename = "..\img\mainframe\loading\loadingchart.gif"
boolean focusrectangle = false
end type

type st_leftbar from pf_u_statictext within w_mdi4framelv2
integer width = 192
integer height = 3084
boolean bringtotop = true
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 21843277
boolean scaletobottom = true
end type

type p_leftbar from pf_u_picture within w_mdi4framelv2
integer y = 1644
integer width = 192
integer height = 1440
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\left_logo.jpg"
boolean fixedtobottom = true
end type

event clicked;call super::clicked;LONG	ll

STRING	ls_debug_step = ''

FOR  ll =  1  TO  UPPERBOUND (debug_step)
	ls_debug_step += debug_step [ll] + '~r~n'
NEXT

::clipboard (ls_debug_step)
messagebox ('focus', ls_debug_step)

debug_step = null_a
end event

type p_hide from pf_u_imagebutton within w_mdi4framelv2
event move pbm_move
integer x = 1394
integer y = 2328
integer width = 46
integer height = 160
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\hide_btn.jpg"
boolean fixedtobottom = true
end type

event move;this.bringtotop = true
end event

event clicked;call super::clicked;if not isvalid(igo_selected) then return

userobject	luo_temp

if ib_leftmenu_visible = true then
	//inv_animate.of_hide(igo_selected, inv_animate.lefttoright)
	igo_selected.visible = false
	
	luo_temp = igo_selected
	il_normalmenuwidth = luo_temp.width
	Post of_xpmenuhide4btn()
	
	il_vsplit_xpos = st_vsplit.x
	st_vsplit.x = st_leftbar.x + st_leftbar.width// + pixelstounits(1, xpixelstounits!)
	st_vsplit.of_arrange_objects()
	//st_vsplit.visible = true

//	dw_userinfo.width += pixelstounits(9, xpixelstounits!)
//	dw_userinfo.setredraw(true)
	
	ib_leftmenu_visible = false
else
	luo_temp = igo_selected
	il_hiddenmenuwidth = luo_temp.width
	
//	dw_userinfo.width -= pixelstounits(9, xpixelstounits!)
//	dw_userinfo.setredraw(true)
	
//	st_vsplit.visible = true
	st_vsplit.x = il_vsplit_xpos
	st_vsplit.of_arrange_objects()	
	Post of_xpmenuhide4btn()
	
	//inv_animate.of_show(igo_selected, inv_animate.lefttoright)
	igo_selected.visible = true	
	ib_leftmenu_visible = true
end if

end event

type p_logout from pf_u_imagebutton within w_mdi4framelv2
integer y = 1424
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic009.jpg"
end type

event clicked;call super::clicked;Close(Parent)

end event

type p_1project from pf_u_imagebutton within w_mdi4framelv2
integer y = 1256
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic012.jpg"
end type

event clicked;call super::clicked;gnv_rolemenu.of_setopensheet('00024')
end event

type p_allnotice from pf_u_imagebutton within w_mdi4framelv2
integer y = 1088
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic005.jpg"
end type

event clicked;call super::clicked;gnv_rolemenu.of_setopensheet('00023')
end event

type p_print from pf_u_imagebutton within w_mdi4framelv2
integer y = 920
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic015.jpg"
end type

event clicked;call super::clicked;printsetup()
end event

type p_msg from pf_u_imagebutton within w_mdi4framelv2
integer y = 752
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic008.jpg"
end type

event clicked;call super::clicked;p_bell.event clicked ()
end event

type p_help from pf_u_imagebutton within w_mdi4framelv2
integer y = 584
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic004.jpg"
end type

event clicked;call super::clicked;If of_lock4processing() = -1 Then Return

String	ls_pgmno, ls_pgm_id, ls_pgm_nm

iw_mgetactivesheet = Parent.GetActiveSheet ( )

If Not Isvalid(iw_mgetactivesheet) Then
	Messagebox('Check', '프로그램이 활성화 되지 않았습니다.')
	Return
End If

ls_pgmno = iw_mgetactivesheet.Dynamic of_getpgmno()
If fw_f_nvls(ls_pgmno, '') = '' or Pos(upper (ls_pgmno), upper (gnv_vari.w_home)) > 0 Then
	Messagebox('Check', '메뉴에 등록이 안된 프로그램은 지원하지 않습니다.')
	Return
End If
ls_pgm_id = gnv_rolemenu.of_getpgmid(ls_pgmno)
ls_pgm_nm = gnv_rolemenu.of_getpgmnm(ls_pgmno)

uo_sheettab.of_popup_ProgramHelp(ls_pgmno, ls_pgm_id, ls_pgm_nm)
end event

type p_bookmark from pf_u_imagebutton within w_mdi4framelv2
integer y = 416
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic002.jpg"
end type

event clicked;call super::clicked;If of_lock4processing() = -1 Then Return
// 즐겨찾기 선택시 retrieve
dw_pgm4info.MODIFY ('t_groupnm.font.height="-18"')
dw_pgm4info.object.t_groupnm.text = '즐겨찾기'
uo_bookmark.event oue_refreshmenu()

If ib_leftmenu_visible = true Then
	uo_xpmenu.visible		= false
	uo_bookmark.show()
	uo_bookmark.setredraw(true)
Else
	If uo_xpmenu.visible = True Then
		uo_xpmenu.width = il_hiddenmenuwidth
		uo_xpmenu.visible = false
	End If
	If uo_bookmark.visible = false Then p_hide.TriggerEvent('Clicked')
	uo_bookmark.show()
	uo_bookmark.setredraw(true)
End If
igo_selected = uo_bookmark
of_setpgmexpression('')
end event

type p_menu from pf_u_imagebutton within w_mdi4framelv2
integer y = 248
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic001.jpg"
end type

event clicked;call super::clicked;If of_lock4processing() = -1 Then Return
If ib_leftmenu_visible = true Then
	uo_bookmark.visible	= false
	uo_xpmenu.show()
	uo_xpmenu.setredraw(true)
Else
	If uo_bookmark.visible = True Then
		uo_bookmark.width = il_hiddenmenuwidth
		uo_bookmark.visible = false
	End If
	If uo_xpmenu.visible = false Then p_hide.TriggerEvent('Clicked')
	uo_xpmenu.show()
	uo_xpmenu.setredraw(true)
End If
igo_selected = uo_xpmenu
of_setpgmexpression('')
end event

type p_home from pf_u_imagebutton within w_mdi4framelv2
integer width = 192
integer height = 248
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\icon_home.jpg"
end type

event clicked;call super::clicked;If of_lock4processing() = -1 Then Return
Post of_openhomewindow()
end event

type p_bell from pf_u_imagebutton within w_mdi4framelv2
integer x = 210
integer y = 32
integer width = 201
integer height = 176
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\fw_top_bell_off.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;IF uo_push4message.visible	Then
	uo_push4message.visible=FALSE
	of_set_message (FALSE)
Else
	uo_push4message.of_retrieve ()
	uo_push4message.x = uo_userinfo.x + uo_userinfo.width + long(PixelstoUnits(1, xpixelstounits!))
	uo_push4message.visible=TRUE
End IF
end event

type uo_sheettab from fw_u_sheettab4frame within w_mdi4framelv2
integer x = 1440
integer y = 264
integer width = 5408
integer taborder = 50
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
boolean scaletoright = false
long underlinepencolor = 7958629
long underlinepenwidth = 2
end type

on uo_sheettab.destroy
call fw_u_sheettab4frame::destroy
end on

type uo_push4message from fw_u_push4message within w_mdi4framelv2
boolean visible = false
integer x = 1394
integer y = 248
integer taborder = 30
boolean bringtotop = true
boolean fixedtoright = true
end type

on uo_push4message.destroy
call fw_u_push4message::destroy
end on

type dw_pgm4info from adw_jtier within w_mdi4framelv2
event mousemove pbm_dwnmousemove
event oue_setpgmgo4empty ( integer al_row )
event ue_postconstructor ( )
event oue_keydown pbm_dwnkey
integer x = 192
integer y = 248
integer width = 1202
integer height = 152
integer taborder = 60
boolean bringtotop = true
string dataobject = "fw_d_mdi4pgmno"
boolean border = false
end type

event oue_setpgmgo4empty(integer al_row);this.setitem(al_row, 'pgm_go', '')
end event

event ue_postconstructor();inv_ani_search = create fw_n_animate

inv_ani_search.of_initialize( dw_pgm_search, inv_ani_search.TopDown)

IF gaa.aams	THEN dw_pgm_search.dataobject = 'fw_d_mdi4pgmno_find_aams'
gnv_rolemenu.of_getPgmSearchData(dw_pgm_search)

dw_pgm_search.setsort("fullpgmpath")
dw_pgm_search.sort()
end event

event oue_keydown;long	ll_cnt
if key = KeyEnter! OR key = KeyDownArrow! then
	ll_cnt = dw_pgm_search.rowcount()
	if ll_cnt = 1 then
		dw_pgm_search.setrow(1)
		dw_pgm_search.setfocus()		
		dw_pgm_search.Event ue_go_pgm(1)

	elseif ll_cnt > 1 then
		ispgmgostate = 'GO_SEARCH'
		dw_pgm_search.setrow(1)
		dw_pgm_search.setfocus()
	end if
end IF
end event

event constructor;Post Insertrow(0)
Post Event ue_postconstructor()
end event

event clicked;If row < 1 Then Return
Choose Case dwo.name
	Case 'p_find'
		//this.Post Event ue_search()
		long	ll_cnt

		ll_cnt = dw_pgm_search.rowcount()
		if ll_cnt = 1 then
			dw_pgm_search.setrow(1)
			dw_pgm_search.setfocus()		
			dw_pgm_search.Event ue_go_pgm(1)
		elseif ll_cnt > 1 then
			ispgmgostate = 'GO_SEARCH'
			dw_pgm_search.setrow(1)
			dw_pgm_search.setfocus()
		end if
End Choose
end event

event losefocus;IF ispgmgostate<>'GO_SEARCH' THEN dw_pgm_search.Post Event ue_go_pgm(0)
ispgmgostate = ''
end event

event editchanged;call super::editchanged;CONSTANT INT DW_ROWH = 96

LONG	ll_cnt

IF ROW<1 THEN RETURN
IF DWO.NAME<>'pgm_go' THEN RETURN

ispgmgostate = ''

IF len(data)>0  Then
   dw_pgm_search.setfilter ("upper (co_search_data) LIKE '%" + upper(data) + "%'")
   dw_pgm_search.filter()
   ll_cnt = dw_pgm_search.rowcount()
   IF ll_cnt > 0  Then
      dw_pgm_search.Modify ("search_t.text='" + data + "'")
      IF dw_pgm_search.VISIBLE = false Then
         IF ll_cnt > 25 Then
            dw_pgm_search.height = 24 * DW_ROWH + 8
         ELSE
            dw_pgm_search.height = ll_cnt * DW_ROWH + 8
         END IF
         dw_pgm_search.BringToTop = TRUE
         inv_ani_search.of_show()
      END IF
   END IF
ELSE
   IF STRING(data) = '' Then
      inv_ani_search.of_hide()
   END IF
END IF
end event

type dw_pgm_search from datawindow within w_mdi4framelv2
event ue_enter pbm_dwnprocessenter
event ue_go_pgm ( integer ai_row )
boolean visible = false
integer x = 219
integer y = 384
integer width = 3163
integer height = 828
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "fw_d_mdi4pgmno_find"
boolean vscrollbar = true
boolean livescroll = true
end type

event ue_enter;this.Event ue_go_pgm (this.getrow())
end event

event ue_go_pgm(integer ai_row);string	ls_pgm_no

if ai_row > 0 then
	if this.rowcount() > 0 then
		ls_pgm_no = this.getitemstring(ai_row, "pgm_no")
		If fw_f_nvls(ls_pgm_no, '')='' Then Return
		gnv_rolemenu.of_setopensheet(ls_pgm_no)
		dw_pgm4info.SetItem( 1, "pgm_go", "")
		hide ()
//		inv_ani_search.of_hide()
	end if
else
	dw_pgm4info.SetItem( 1, "pgm_go", "")
	hide ()
//	inv_ani_search.of_hide()
end if
end event

event rowfocuschanged;this.SelectRow(0, false)
this.SelectRow(currentrow, true)
end event

event clicked;this.Event ue_go_pgm(row)
end event

event losefocus;dw_pgm_search.Post Event ue_go_pgm(0)
end event

type uo_bookmark from fw_u_bookmark4frame within w_mdi4framelv2
integer x = 192
integer y = 400
integer height = 2688
integer taborder = 90
boolean scaletobottom = true
end type

on uo_bookmark.destroy
call fw_u_bookmark4frame::destroy
end on

event oue_menuclicked;call super::oue_menuclicked;Parent.of_opensheet(as_pgm_no, as_pgm_id, as_pgm_nm, as_parameter1, as_parameter2, as_parameter3)

if ib_leftmenu_visible = false then
	p_bookmark.post event clicked()
end if
end event

type uo_xpmenu from fw_u_menu4frame within w_mdi4framelv2
integer x = 192
integer y = 400
integer height = 2688
integer taborder = 80
boolean scaletobottom = true
end type

on uo_xpmenu.destroy
call fw_u_menu4frame::destroy
end on

event oue_menuclicked;call super::oue_menuclicked;Parent.of_opensheet(as_pgm_no, as_pgm_id, as_pgm_nm, as_parameter1, as_parameter2, as_parameter3)

if ib_leftmenu_visible = false then
	p_menu.post event clicked()
end if
end event

type p_right_logo from pf_u_picture within w_mdi4framelv2
integer x = 5499
integer width = 1349
integer height = 248
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = false
string picturename = "..\img\mainframe\right_logo\fw_top_logo_right.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;STRING ls_cur_corp_gr

If of_lock4processing() = -1 Then Return

IF gaa.admin OR gaa.aams	Then
	if gw_mdi.uo_sheettab.of_tablimit() > 0 Then
		messagebox('check', '프로그램을 모두 닫으시고 진행하십시요.')
		return
	end if
	ls_cur_corp_gr = gaa.corp_gr
	open (w_corp_change)
	IF	ls_cur_corp_gr<>gaa.corp_gr And gaa.bookmark THEN uf_refresh_dimension ()
End IF
end event

type uo_userinfo from fw_u_userinfo4frame within w_mdi4framelv2
integer x = 192
integer width = 1202
integer height = 248
integer taborder = 30
boolean setbringtotop = false
end type

event move;call super::move;p_bell.x = this.x + PixelsToUnits(4, XPixelsToUnits!)
end event

event resize;call super::resize;if this.width < p_bell.width then
	p_bell.visible = false
else
	p_bell.visible = true
end if
end event

event doubleclicked;call super::doubleclicked;//IF	dwo.name='user_name' And gaa.aams	Then
//	IF	gaa.password	Then
//		IF	f_messageBox ('I002','보안(컬럼)을 해제하시겠습니까?')=1	Then
//			gaa.password = FALSE
//			Object.user_name [1] = gnv_vari.is_user_nm + ' 님'
//		End IF
//	Else
//		gaa.password = TRUE
//		Object.user_name [1] = '*(' + gnv_vari.is_user_nm + ') 님'
//	End IF
//End IF
str_parameter	sp

sp.bo [1]  = false
sp.str [1] = gaa.corp_gr
sp.str [2] = gaa.login
sp.str [3] = '~r~n변경할 비밀번호를 입력하십시오.'

openwithparm (w_change_pwd, sp)
end event

type p_frame_loading from picture within w_mdi4framelv2
boolean visible = false
integer x = 2615
integer y = 996
integer width = 2469
integer height = 2000
boolean bringtotop = true
string picturename = "..\img\mainframe\loading\loading13.gif"
boolean focusrectangle = false
end type

type uo_topmenu from fw_u_topmenu4frame within w_mdi4framelv2
integer x = 1394
integer width = 4105
integer height = 248
integer taborder = 20
boolean scaletoright = true
boolean ibsubtopmenu = false
end type

on uo_topmenu.destroy
call fw_u_topmenu4frame::destroy
end on

event oue_clicked4menu;call super::oue_clicked4menu;If of_lock4processing() = -1 Then Return
/* to-be 중복 실행 체크 */
if as_menu_sn = uo_xpmenu.of_parentpgmno() then /* to-be left xpmenu check 후 action */
	if igo_selected.dynamic classname() <> 'uo_xpmenu' then
		if uo_xpmenu.visible = false then
			p_menu.post event clicked()
		end if
	end if
	return
end if
parent.of_clicked4menu(as_menu_sn)
post of_setpgm4info(as_menu_sn)


end event

type p_kor from pf_u_imagebutton within w_mdi4framelv2
integer y = 1592
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic018.jpg"
end type

event clicked;call super::clicked;gnv_vari.is_lang_type = 'lng_kor'

if of_active_pgm_check() = -1 then return
of_active4lang()
iw_mgetactivesheet.post dynamic of_setlang()
end event

type p_eng from pf_u_imagebutton within w_mdi4framelv2
integer y = 1760
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic019.jpg"
end type

event clicked;call super::clicked;gnv_vari.is_lang_type = 'lng_eng'

if of_active_pgm_check() = -1 then return
of_active4lang()
iw_mgetactivesheet.post dynamic of_setlang()
end event

type p_chn from pf_u_imagebutton within w_mdi4framelv2
integer y = 1928
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic020.jpg"
end type

event clicked;call super::clicked;gnv_vari.is_lang_type = 'lng_chn'

if of_active_pgm_check() = -1 then return
of_active4lang()
iw_mgetactivesheet.post dynamic of_setlang()
end event

type p_vit from pf_u_imagebutton within w_mdi4framelv2
integer y = 2096
integer width = 192
integer height = 168
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\ic021.jpg"
end type

event clicked;call super::clicked;gnv_vari.is_lang_type = 'lng_vit'

if of_active_pgm_check() = -1 then return
of_active4lang()
iw_mgetactivesheet.post dynamic of_setlang()
end event

