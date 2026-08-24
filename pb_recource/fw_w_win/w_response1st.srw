forward
global type w_response1st from window
end type
type ln_tempbutton from line within w_response1st
end type
type ln_tempstart from line within w_response1st
end type
type ln_templeft from line within w_response1st
end type
type ln_cond_start from line within w_response1st
end type
type ln_tempright from line within w_response1st
end type
type ln_cond1_yline from line within w_response1st
end type
type ln_dw1_yline from line within w_response1st
end type
end forward

global type w_response1st from window
integer width = 3611
integer height = 2108
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
string icon = "AppIcon!"
event wue_postopen ( )
event wue_lastopen ( )
event wue_lastinst ( )
event wue_postinst ( )
event wue_retrieve ( )
event type integer wue_update ( )
event type integer wue_delete ( )
event wue_close ( )
event type integer wue_confirmupdate4close ( )
event type boolean wue_components ( )
event wue_setdddw ( )
event wue_retrieve4lang ( )
event wue_cancel pbm_syscommand
event wue_clear ( )
event wue_retrieve2ready ( )
event type integer wue_copy ( )
event wue_print ( )
event wue_saveas ( )
ln_tempbutton ln_tempbutton
ln_tempstart ln_tempstart
ln_templeft ln_templeft
ln_cond_start ln_cond_start
ln_tempright ln_tempright
ln_cond1_yline ln_cond1_yline
ln_dw1_yline ln_dw1_yline
end type
global w_response1st w_response1st

type variables
// 공통 리턴값 상수
constant integer SUCCESS = 1
constant integer FAILURE = -1
constant integer NO_ACTION = 0

// 계속/중지 리턴값 상수
constant integer CONTINUE_ACTION = 1
constant integer PREVENT_ACTION = 0

private:
   pf_n_buttonrole inv_auth

Protected:
   windowobject      iwo_control[]
   DataWindowChild   idwc_dddw

   STRING	isdddwarg[], isdddwargnull[]
   STRING	isdefualt4dwobj = ''
   STRING	is_lang_ins     = 'lng_kor'

   fw_u_dwo    idw_u, idw_mm, idw_null

   Window   iw_parent

   n_menu   inv_menu

Public:
	boolean	ibconfirmlogs4stats		= false
	Boolean	ibconfirmerrorlogs4stats	= true
	BOOLEAN	ibconfirmupdate4closequery = TRUE
	STRING	isupdategb4appr            = ''
end variables

forward prototypes
public function string of_thisname ()
public subroutine of_getcontrols (graphicobject a_control, ref graphicobject a_controls[])
public function windowobject of_getwindowobjectbyname (string as_objname)
public function string of_getpgmno ()
public function integer of_setauthority (boolean ab_switch)
public function boolean of_getcommbtnvisible (string as_btnname)
public function integer of_getobjdwbyname (string as_dwobj)
public subroutine of_setmm2obj (fw_u_dwo adw_obj)
public function string of_getwindowtype ()
public subroutine of_setfocusdw (fw_u_dwo adw_dw)
public subroutine of_setwindowobjects (ref windowobject awo_object[])
public subroutine of_initsetting (fw_u_dwo adw_dw, string as_val1, string as_val2)
public function string of_gettaskgb ()
public function long of_setlang ()
public function integer of_confirmupdate4close (fw_u_dwo adw_upt[])
public subroutine of_setsorthide ()
public function fw_u_dwo of_getrefdw2obj (string as_dwobj)
public function integer of_update (adw_jtier adw_upt[])
public subroutine of_getnavi2pathtext ()
public function string of_getpgmnm ()
public function fw_u_dwo of_getmm2obj ()
public subroutine wf_setenabled ()
public function n_menu of_getwindowmenu ()
public function boolean of_getconfirmlogs4stats ()
end prototypes

event wue_postopen();This.Post Event wue_lastopen()
end event

event wue_lastopen();//wue_lastopen
end event

event wue_lastinst();fw_f_setparentwindowinit() /* gnv_vari.iwparent clear */

fw_f_messageclear() /* messageparm clear */

If gnv_vari.is_lang_type <> is_lang_ins and this.Classname() <> gnv_vari.w_home Then of_setlang()
end event

event wue_postinst();If upperbound(iwo_control) = 0 Then This.of_getcontrols(this, iwo_control[]) // get window controls

// get window controls
if upperbound(iwo_control) = 0 then
	this.of_getcontrols(this, iwo_control[])
end if

If fw_f_nvls(isdefualt4dwobj, '') <> '' Then of_getobjdwbyname(isdefualt4dwobj)

This.Post Event wue_lastinst() // Call Post ancestor object clear 2st
end event

event wue_close();Close(This)
end event

event type integer wue_confirmupdate4close();If Event wue_update() = -1 Then Return 1

Return 0
end event

event type boolean wue_components();Return True
end event

event wue_cancel;// 윈도우 종료시 발생
//IF message.wordparm=61536	Then
// 취소버튼시 처리 routine 작성
end event

event wue_clear();//
end event

event wue_retrieve2ready();// main과 event 맞추기 위해.
Post Event wue_retrieve()
end event

public function string of_thisname ();return 'w_response1st'

end function

public subroutine of_getcontrols (graphicobject a_control, ref graphicobject a_controls[]);// 윈도우의 컨트롤을 배열형태로 구합니다. Tab, UserObject 컨트롤과 그 안에 위치한 컨트롤을 포함합니다.
// a_controls[] 는 반드시 초기화된 상태로 호출해야 합니다. 이 함수는 Recursive 형태로 구동되기 때문에 내부적으로 초기화하지 않습니다.

window lw_current
tab ltab_current
userobject luo_current
long ll_previous_elements, ll_total_elements, i

ll_previous_elements = UpperBound(a_controls)
ll_total_elements = ll_previous_elements

choose case a_control.TypeOf()
	case Window!
		lw_current = a_control
		for i = 1 to UpperBound(lw_current.Control)
			choose case lw_current.Control[i].classname()
				case 'pf_u_statictext', 'pf_u_commandbutton_overlay'
				case else
					ll_total_elements++
					a_controls[ll_total_elements] = lw_current.Control[i]
			end choose
		next
	case Tab!
		ltab_current = a_control
		for i = 1 to UpperBound(ltab_current.Control)
			choose case ltab_current.Control[i].classname()
				case 'pf_u_statictext', 'pf_u_commandbutton_overlay'
				case else
					ll_total_elements++
					a_controls[ll_total_elements] = ltab_current.Control[i]
			end choose
		next
	case UserObject!
		luo_current = a_control
		for i = 1 to UpperBound(luo_current.Control)
			choose case luo_current.Control[i].classname()
				case 'pf_u_statictext', 'pf_u_commandbutton_overlay'
				case else
					ll_total_elements++
					a_controls[ll_total_elements] = luo_current.Control[i]
			end choose
		next
	case else
		return
end choose

for i = ll_previous_elements + 1 to ll_total_elements
	choose case a_controls[i].TypeOf()
		case Window!, Tab!, UserObject!
			this.of_getcontrols(a_controls[i], a_controls)
	end choose
next

end subroutine

public function windowobject of_getwindowobjectbyname (string as_objname);// 윈도우가 포함하고있는 컨트롤 중에 as_objname과 동일한
// 명칭을 가지는 오브젝트를 리턴합니다.

integer i, li_cnter
windowobject lwo_ret

li_cnter  = upperbound(iwo_control)
for  i  = 1 to  li_cnter
	if  iwo_control[i].classname() = as_objname  then
		lwo_ret = iwo_control[i]
		exit
	end  if
next

return lwo_ret

end function

public function string of_getpgmno ();if isvalid(inv_menu) then
	return inv_menu.is_pgm_no
else
	return ''
end if

end function

public function integer of_setauthority (boolean ab_switch);integer	li_rc

// Check arguments
if IsNull (ab_switch) then
	return -1
end if

if ab_Switch then
	if not IsValid (inv_auth) then
		inv_auth = create pf_n_buttonrole
		inv_auth.of_registerparent(this)
	end if
else
	if IsValid (inv_auth) then
		destroy inv_auth
		li_rc = 1
	end if
end If

return li_rc

end function

public function boolean of_getcommbtnvisible (string as_btnname);Return True
end function

public function integer of_getobjdwbyname (string as_dwobj);Int	li_cnt, i

// get window controls
If upperbound(iwo_control) = 0 Then
	this.of_getcontrols(this, iwo_control[])
End If

li_cnt = UpperBound(iwo_control)
For i = 1 To li_cnt
	If iwo_control[i].TypeOf() = Datawindow! Then
		If iwo_control[i].Classname() = as_dwobj Then
			idw_u = iwo_control[i]
			Return 1
		End If
	End If
Next

idw_u = idw_null

Return -1
end function

public subroutine of_setmm2obj (fw_u_dwo adw_obj);idw_mm = adw_obj
end subroutine

public function string of_getwindowtype ();Return 'response'
end function

public subroutine of_setfocusdw (fw_u_dwo adw_dw);If IsValid(idw_u) Then
	IF	idw_u.classname()<>adw_dw.classname()	Then
		idw_u.of_setborderfocuscolor(False)
//		adw_dw.setfocus()
		idw_u = adw_dw
		idw_u.of_setborderfocuscolor(True)
	End If
Else
//	adw_dw.setfocus()
	idw_u = adw_dw
	idw_u.of_setborderfocuscolor(True)
End If
end subroutine

public subroutine of_setwindowobjects (ref windowobject awo_object[]);// get window controls
if upperbound(iwo_control) = 0 then
	this.of_getcontrols(this, awo_object[])
end if
end subroutine

public subroutine of_initsetting (fw_u_dwo adw_dw, string as_val1, string as_val2);
end subroutine

public function string of_gettaskgb ();Return ''
end function

public function long of_setlang ();String		ls_obj[]
String		ls_objlist, ls_colname, ls_coltype, ls_text, ls_trans
String		ls_topmenu
Long		ll_i, ll_objcnt, ll_dwobjcnt
object		lo_type

if not isvalid(gnv_lang) then return -1
if upperbound(iwo_control[]) < 1 Then of_setwindowobjects(iwo_control[])
if fw_f_nvls(is_lang_ins, '') = '' Then is_lang_ins = 'lng_kor'
if not IsValid(gnv_lang.ids_langcvt) Then
	gnv_extfunc.biznode1te(149, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
	gnv_lang.TriggerEvent(gnv_extfunc.is_nodevalue)
	gw_mdi.of_active4lang()
end if
gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01	= gnv_vari.is_sys_id
gnv_extfunc.istr_node4value.cstr02	= gnv_vari.is_lang_type
gnv_extfunc.istr_node4value.cstr03	= is_lang_ins
gnv_extfunc.biznode11te(112, handle(this), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

choose case gnv_vari.is_lang_type
	case lower(gnv_extfunc.istr_node4value.cstr11), lower(gnv_extfunc.istr_node4value.cstr12), lower(gnv_extfunc.istr_node4value.cstr13), lower(gnv_extfunc.istr_node4value.cstr14), lower(gnv_extfunc.istr_node4value.cstr15)
		gw_mdi.of_sheetwait(True)
		this.SetRedraw(false)
		if gnv_vari.is_lang_type = is_lang_ins Then
			this.SetRedraw(True)
			gw_mdi.of_sheetwait(false)
			Return 1
		end if
		this.Event wue_setdddw()		
		ll_objcnt = upperbound(iwo_control[])
		For ll_i = 1 to ll_objcnt
			lo_type = iwo_control[ll_i].typeof()			
			if lo_type = Datawindow! then
				datawindow	ldw_dw
				ldw_dw = iwo_control[ll_i]
				gnv_lang.of_setlangchange(ldw_dw, is_lang_ins, gnv_lang.ids_langcvt)
			Else
				gnv_lang.of_setlangchange(iwo_control[ll_i], is_lang_ins, gnv_lang.ids_langcvt)
			end if
		Next		
		this.Event wue_retrieve4lang()
		is_lang_ins = gnv_vari.is_lang_type
		this.SetRedraw(True)
		gw_mdi.of_sheetwait(false)
end choose

Return 1
end function

public function integer of_confirmupdate4close (fw_u_dwo adw_upt[]);Long		ll_cnt, ll_ii, ll_rtn

ll_cnt = UpperBound(adw_upt)
For ll_ii= 1 To ll_cnt
	adw_upt[ll_ii].AcceptText()
	If adw_upt[ll_ii].Modifiedcount() + adw_upt[ll_ii].Deletedcount() > 0 Then		
		ll_rtn = fw_f_message('Q01', this.title, '')
		Return ll_rtn
		Exit
	End If
Next
Return 0
end function

public subroutine of_setsorthide ();If IsValid(idw_mm) Then
	idw_mm.of_stc2off()
	idw_mm = idw_null
End If
end subroutine

public function fw_u_dwo of_getrefdw2obj (string as_dwobj);Int					li_cnt, i
fw_u_dwo		ldw_obj

// get window controls
If upperbound(iwo_control) = 0 Then
	this.of_getcontrols(this, iwo_control[])
End If

li_cnt = UpperBound(iwo_control)
For i = 1 To li_cnt
	If iwo_control[i].TypeOf() = Datawindow! Then
		If iwo_control[i].Classname() = as_dwobj Then
			ldw_obj = iwo_control[i]
			Return ldw_obj
		End If
	End If
Next

Return ldw_obj

end function

public function integer of_update (adw_jtier adw_upt[]);Long	ll_cnt, ll_ii, ll_rtn

ll_rtn = of_confirmupdate4close(adw_upt)
Choose Case ll_rtn
	Case 0
		Return 0
	Case 1
		//
	Case 2
		Return 2
		//Return 0
	Case 3
		Return -1
End Choose

ll_cnt = UpperBound(adw_upt)
For ll_ii= 1 To ll_cnt
	adw_upt[ll_ii].AcceptText()
	If adw_upt[ll_ii].TriggerEvent('oue_components') = 1 Then
		IF adw_upt[ll_ii].dynamic Event oue_setupdatecheck() < 1 Then Return -1
	End If
Next

For ll_ii= 1 To ll_cnt
	adw_upt[ll_ii].SetTransObject( sqlca )
	gnv_vari.ilupdate4error2num = ll_ii
	If adw_upt[ll_ii].update () < 1 Then
		rollbackJ ()
		return -1
	End If
Next

For ll_ii= 1 To ll_cnt
	If adw_upt[ll_ii].TriggerEvent('oue_components') = 1 Then
		commitJ ()
	End If
Next
if ibconfirmlogs4stats = true then
	fw_f_setlog4pgm('sy1001010', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'response', '', 'datawindow')
end if
fw_f_message('U01', '', '')

Return 0
end function

public subroutine of_getnavi2pathtext ();if isvalid(gw_mdi) then
	window lw_window
	lw_window = gw_mdi.GetActiveSheet( )
	lw_window.dynamic of_getnavi2pathtext()
	gnv_vari.iserror2navi += ' -> ' + this.classname()
	gnv_vari.iserror2pgmno = trim(left(this.classname(), 16))
else
	gnv_vari.iserror2navi = this.classname()
	gnv_vari.iserror2pgmno = trim(left(this.classname(), 16))
end if
end subroutine

public function string of_getpgmnm ();if isvalid(inv_menu) then
	return inv_menu.is_pgm_nm
else
	return ''
end if
end function

public function fw_u_dwo of_getmm2obj ();return idw_mm
end function

public subroutine wf_setenabled ();
end subroutine

public function n_menu of_getwindowmenu ();return inv_menu
end function

public function boolean of_getconfirmlogs4stats ();return ibconfirmlogs4stats
end function

on w_response1st.create
this.ln_tempbutton=create ln_tempbutton
this.ln_tempstart=create ln_tempstart
this.ln_templeft=create ln_templeft
this.ln_cond_start=create ln_cond_start
this.ln_tempright=create ln_tempright
this.ln_cond1_yline=create ln_cond1_yline
this.ln_dw1_yline=create ln_dw1_yline
this.Control[]={this.ln_tempbutton,&
this.ln_tempstart,&
this.ln_templeft,&
this.ln_cond_start,&
this.ln_tempright,&
this.ln_cond1_yline,&
this.ln_dw1_yline}
end on

on w_response1st.destroy
destroy(this.ln_tempbutton)
destroy(this.ln_tempstart)
destroy(this.ln_templeft)
destroy(this.ln_cond_start)
destroy(this.ln_tempright)
destroy(this.ln_cond1_yline)
destroy(this.ln_dw1_yline)
end on

event open;// get pgm_no of this window
inv_menu = create n_menu

if gnv_rolemenu.of_getmenudata_by_pgmid(upper(this.classname()), inv_menu) = 0 then
	inv_menu.is_pgm_id = this.classname()
	
	if len(trim(this.title)) > 0 then
		inv_menu.is_pgm_nm = this.title
	else
		inv_menu.is_pgm_nm = this.classname()
	end if
end if

iw_parent = This
if ibconfirmerrorlogs4stats = true then gnv_vari.iwerror2window = this

if ibconfirmlogs4stats = true then	
	fw_f_setlog4pgm('sy1001003', inv_menu.is_pgm_id, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'response', '', '')
end if
//// Button Autority 설정
//if inv_menu.is_pgm_no <> '' then
//	this.of_setauthority(true)
//	inv_auth.of_registerbuttonarr('retrieve', { 'cb_retrieve', 'cb_ret', 'cb_inq', 'p_retrieve', 'p_ret', 'p_inq' })
//	inv_auth.of_registerbuttonarr('insert', { 'cb_insert', 'cb_ins', 'cb_input', 'cb_insertrow', 'cb_add', 'p_insert', 'p_ins', 'p_input', 'p_insertrow', 'p_add' })
//	inv_auth.of_registerbuttonarr('delete', { 'cb_delete', 'cb_del', 'p_delete', 'p_del' })
//	inv_auth.of_registerbuttonarr('update', { 'cb_update', 'cb_upd', 'cb_save', 'cb_modify', 'p_update', 'p_upd', 'p_update', 'p_modify' })
//	inv_auth.of_registerbuttonarr('print', { 'cb_print', 'cb_prt', 'cb_printer', 'p_print', 'p_prt', 'p_printer' })
//end if

///* to-be logs create */
//String		ls_data
//ls_data = mid(This.Classname(), Pos(This.Classname(), '_') + 1, 4)
//If match(ls_data, '^[A-Za-z][A-Za-z][0-9][0-9]') = True Then
//	f_logscreate(inv_menu.is_pgm_id, inv_menu.is_pgm_no, 'reponse', '')
//End If

fw_f_getiehandlebyposition(This)

This.Post Event wue_postinst() // Call Post ancestor object clear 1st

This.Post Event wue_setdddw() // dddw setting

This.Post Event wue_postopen() // Call Post Open Event
end event

event activate;if ibconfirmerrorlogs4stats = true then gnv_vari.iwerror2window = this
// CurrentDirectory 변경여부 확인, 디폴트 폴더로 원복처리
If gnv_vari.getclienttype = 'PB' then
	If getcurrentdirectory() <> gnv_vari.basepath then
		changedirectory(gnv_vari.basepath)
	End If
End If
end event

event mousemove;of_setsorthide()

end event

event closequery;If ibconfirmupdate4closequery = true Then
	Long	ll_rtn
	ll_rtn = Event wue_confirmupdate4close()
	Return ll_rtn
End If
Return 0

end event

event close;if ibconfirmlogs4stats = true then
	fw_f_setlog4pgm('sy1001004', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'response', '', '')
end if
end event

type ln_tempbutton from line within w_response1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 24
integer endx = 4722
integer endy = 24
end type

type ln_tempstart from line within w_response1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 128
integer endx = 4722
integer endy = 128
end type

type ln_templeft from line within w_response1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 50
integer endx = 50
integer endy = 3140
end type

type ln_cond_start from line within w_response1st
boolean visible = false
long linecolor = 255
integer linethickness = 4
integer beginy = 156
integer endx = 4722
integer endy = 156
end type

type ln_tempright from line within w_response1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 3566
integer endx = 3566
integer endy = 3140
end type

type ln_cond1_yline from line within w_response1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 316
integer endx = 4873
integer endy = 316
end type

type ln_dw1_yline from line within w_response1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 348
integer endx = 4873
integer endy = 348
end type

