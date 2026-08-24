forward
global type w_window1st from window
end type
type lb_dirlist from listbox within w_window1st
end type
type ln_templeft from line within w_window1st
end type
type ln_tempbuttom from line within w_window1st
end type
type ln_temptop from pf_u_line within w_window1st
end type
type ln_tempbutton from line within w_window1st
end type
type ln_tempstart from line within w_window1st
end type
type ln_cond1_yline from line within w_window1st
end type
type ln_dw1_yline from line within w_window1st
end type
type ln_cond2_yline from line within w_window1st
end type
type ln_dw2_yline from line within w_window1st
end type
type ln_tempright from line within w_window1st
end type
type uo_navi from fw_u_sheet4navi within w_window1st
end type
type ln_temptop_shadow from pf_u_line within w_window1st
end type
type st_windelaytime from pf_u_statictext within w_window1st
end type
type st_top_rect from pf_u_statictext within w_window1st
end type
end forward

global type w_window1st from window
integer width = 5509
integer height = 2884
boolean titlebar = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 16777215
boolean center = true
event wue_saveas ( )
event wue_postopen ( )
event wue_lastopen ( )
event wue_lastinst ( )
event wue_postinst ( )
event wue_retrieve2ready ( )
event wue_print ( )
event wue_setdddw ( )
event wue_retrieve4lang ( )
event wue_clear ( )
event type integer wue_update ( )
event type integer wue_delete ( )
event type boolean wue_components ( )
event type integer wue_confirmupdate4close ( )
event type integer wue_input ( )
event type integer wue_copy ( )
event wue_retrieve ( )
lb_dirlist lb_dirlist
ln_templeft ln_templeft
ln_tempbuttom ln_tempbuttom
ln_temptop ln_temptop
ln_tempbutton ln_tempbutton
ln_tempstart ln_tempstart
ln_cond1_yline ln_cond1_yline
ln_dw1_yline ln_dw1_yline
ln_cond2_yline ln_cond2_yline
ln_dw2_yline ln_dw2_yline
ln_tempright ln_tempright
uo_navi uo_navi
ln_temptop_shadow ln_temptop_shadow
st_windelaytime st_windelaytime
st_top_rect st_top_rect
end type
global w_window1st w_window1st

type variables
constant long SheetWidth   = long(PixelsToUnits(1197, XPixelsToUnits!))
constant long SheetHeight  = long(PixelsToUnits(695, YPixelsToUnits!))

Private:
   LONG	il_tab_seq
   LONG	il_sheet_seq
   LONG	il_tool_seq
   STRING	is_module
   STRING	is_classname
   BOOLEAN	ibclosequery2event   = FALSE
   BOOLEAN	ibretrieve2event     = FALSE
   BOOLEAN	ibrowchanged2event   = FALSE
   LONG	il_return4sheetclosequery = 0

Protected:
   BOOLEAN	ib_onceopened   = FALSE
   windowobject	iwo_control[]

   long	il_newwidth, il_newheight

Public:
   Window	iw_parent, iw_iwindow
   fw_u_dwo	idw_u, idw_mm, idw_null
   u_dw		idw_list

	pf_u_commandbutton	icmdbutton[]
   pf_n_resize				inv_resize

   n_menu			inv_menu, inv_clear4menu

   BOOLEAN	confirmsheetbackcolor      = TRUE
   BOOLEAN	ibconfirmupdate4closequery = FALSE
   BOOLEAN	ibconfirmupdate4message    = TRUE
   BOOLEAN	ibconfirmupdate4retrieve   = FALSE
   BOOLEAN	ibinputbtn4lastrow2gb		= TRUE
   BOOLEAN	ibconfirmlogs4stats			= TRUE

   STRING	isdddwarg[], isdddwargnull[]
   STRING	isdefualt4dwobj = ''     /* to-be */
   STRING	is_lang_ins     = 'lng_kor'  /* instance variable temp save */
   BOOLEAN	i----------------------------------------------------line2  /* empty Object */
end variables

forward prototypes
public function integer of_setresize (boolean ab_switch)
public function window of_getparentmdi ()
public function string of_thisname ()
public function integer of_setauthority (boolean ab_switch)
public function string of_getpgmno ()
public subroutine of_getcontrols (graphicobject a_control, ref graphicobject a_controls[])
public function windowobject of_getwindowobjectbyname (string as_objname)
public subroutine of_initbutton ()
public subroutine of_ctlssetredraw (boolean ab_boolean)
public subroutine of_btotopslave (graphicobject ag_object)
public subroutine of_btotopmst (windowobject aw_object)
public function boolean of_getcommbtnvisible (string as_btnname)
public function integer of_getobjdwbyname (string as_dwobj)
public function integer of_rtnmodifyrowbycheck (string as_status)
public subroutine of_setchtdatabysort (ref string as_dataarr[])
public function string of_getwindowtype ()
public subroutine of_setfocusdw (fw_u_dwo adw_dw)
public subroutine of_setmm2obj (fw_u_dwo adw_obj)
public subroutine of_setsorthide ()
public subroutine of_setwindowobjects (ref windowobject awo_object[])
public function long of_setlang ()
public subroutine of_initsetting (fw_u_dwo adw_dw, string as_val1, string as_val2)
public subroutine of_initsetting (fw_u_dwo adw_dw, long al_row, string as_val1, string as_val2)
public function integer of_confirmupdate4close (fw_u_dwo adw_upt[])
public subroutine of_setedittoken44 (string as_dw)
public subroutine of_sethotkey (string as_hotkey)
public subroutine of_confirmupdate4rowchanged ()
public function integer of_condcheck4idwu ()
public subroutine of_sethotkey4copy (string as_hotkey)
public function boolean of_confirmupdate4boolean ()
public subroutine of_setdefault4rowchanged2boolean ()
public function fw_u_dwo of_getrefdw2obj (string as_dwobj)
public subroutine of_ship4var2event (string as_event2variable, boolean ab_boolean)
public subroutine of_setsync4topmenu ()
public subroutine of_setsync4submenu ()
public function integer of_update (fw_u_dwo adw_upt[])
public subroutine of_setsplit4position ()
public subroutine of_getnavi2pathtext ()
public function integer of_updatecommit (fw_u_dwo adw_upt[])
public function long of_getobject2width (string as_objname)
public function string of_getpgmnm ()
public function fw_u_dwo of_getmm2obj ()
public subroutine of_initbutton_after ()
public subroutine wf_setenabled ()
public function integer of_update (datastore ads_upt[])
public function boolean of_getconfirmlogs4stats ()
public function n_menu of_getwindowmenu ()
end prototypes

event wue_postopen();Post Event wue_lastopen()
end event

event wue_lastopen();If gnv_vari.is_lang_type <> is_lang_ins Then of_setlang()
end event

event wue_lastinst();fw_f_setparentwindowinit() /* gnv_vari.iwparent clear */

fw_f_messageclear() /* messageparm clear */

This.title = ''

If inv_menu.is_pgm_no <> this.classname()  Then
	gnv_vari.isprev4topmenu = gnv_rolemenu.of_getlevel4findmenu( inv_menu.is_pgm_no, 2 )
	gnv_vari.isprev4submenu = gnv_rolemenu.of_getlevel4findmenu( inv_menu.is_pgm_no, 3 )
End If

ib_onceopened = true
end event

event wue_postinst();/* delaytime processing */
gnv_vari.windelaytime = cpu() - gnv_vari.windelaytime
st_windelaytime.text = String(Truncate ( gnv_vari.windelaytime / 1000, 2 ))

// get window controls
if upperbound(iwo_control) = 0 then this.of_getcontrols(this, iwo_control[])
	
fw_f_setparentwindowinit()

If fw_f_nvls(isdefualt4dwobj, '') <> '' Then of_getobjdwbyname(isdefualt4dwobj)

Post Event wue_lastinst()
end event

event wue_retrieve2ready();If ibconfirmupdate4closequery = true and ibconfirmupdate4retrieve = true Then
	ibretrieve2event = true
	If This.Event wue_update() = -1 Then
		ibretrieve2event = false
		ibrowchanged2event = true
		return
	End If
	ibretrieve2event = false
	ibrowchanged2event = true
End If
Post Event wue_retrieve()
end event

event wue_print();if ibconfirmlogs4stats = true then
	fw_f_setlog4pgm('sy1001012', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', '')
end if
end event

event wue_clear();if ibconfirmlogs4stats = true and ib_onceopened = true then
	fw_f_setlog4pgm('sy1001005', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', '')
end if
end event

event type integer wue_update();//Return of_update({dw_mast, dw_detl})
// 1 : 성공, 2 : 아니오, -1 : 실패.
//if of_update({dw_mast, dw_detl}) >= 0 then
//	return 0
//else
//	return -1
//end if

// return 값이 0 이면 성공, -1 이면 실패, 0, -1만 리턴 구분
Return 0
end event

event type integer wue_delete();If IsValid(idw_u) Then
	If of_condcheck4idwu() = -1 Then Return -1
	Long	ll_delrow, ll_rowcnt
	if ibconfirmlogs4stats = true then
		fw_f_setlog4pgm('sy1001011', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', '')
	end if
	idw_u.AcceptText()
	ll_delrow	= idw_u.getrow()
	If idw_u.DeleteRow(0) < 1 Then Return -1
	ll_rowcnt	= idw_u.rowcount()
	idw_u.SetFocus( )
	If idw_u.rowcount() > 0 Then
		If ll_delrow < ll_rowcnt Then
			idw_u.Event RowFocusChanged(ll_delrow)
		Else
			idw_u.Event RowFocusChanged(ll_rowcnt)
		End If
	End If	
End If
Return 1
end event

event type boolean wue_components();Return True
end event

event type integer wue_confirmupdate4close();If Event wue_update() = -1 Then Return 1
Return 0
end event

event type integer wue_input();If IsValid(idw_u) Then
	If of_condcheck4idwu() = -1 Then Return -1
	Long	ll_row, ll_getrow, ll_rowcnt
	if ibconfirmlogs4stats = true then
		fw_f_setlog4pgm('sy1001007', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', '')
	end if
	ll_rowcnt = idw_u.rowcount()
	If ll_rowcnt = 0 Then
		ll_row = idw_u.InsertRow(0)
	Else
		If ibinputbtn4lastrow2gb = true Then
			ll_row = idw_u.InsertRow(0)
		Else
			ll_getrow = idw_u.getrow()
			ll_row = idw_u.InsertRow(ll_getrow)
		End If
	End If
	idw_u.Post ScrollToRow(ll_row)
	idw_u.Post SetFocus()
End If
Return 1
end event

event wue_retrieve();if ibconfirmlogs4stats = true then
	fw_f_setlog4pgm('sy1001006', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', '')
end if
end event

public function integer of_setresize (boolean ab_switch);integer	li_rc

// Check arguments
if IsNull (ab_switch) then
	return -1
end if
//messagebox(string(UnitsToPixels(5970, XUnitsToPixels!)), Long(UnitsToPixels(2780, YUnitsToPixels!)))
if ab_Switch then
	if not IsValid (inv_resize) then
		inv_resize = create pf_n_resize
		//as-is inv_resize.of_SetOrigSize (this.WorkSpaceWidth(), this.WorkSpaceHeight())
		inv_resize.of_SetOrigSize (SheetWidth, SheetHeight)
		inv_resize.of_AutoResizeRegister(this)
		li_rc = 1
	end if
else
	if IsValid (inv_resize) then
		destroy inv_resize
		li_rc = 1
	end if
end If

return li_rc
end function

public function window of_getparentmdi ();window	lw_parent

lw_parent = this.parentwindow()
do until lw_parent.windowtype = mdi!
	lw_parent = lw_parent.parentwindow()
	if isnull(lw_parent) then exit
loop

return lw_parent
end function

public function string of_thisname ();return 'w_window1st'
end function

public function integer of_setauthority (boolean ab_switch);If ab_Switch Then
	If not IsValid (gnv_authorbtn) Then gnv_authorbtn = create pf_n_buttonrole
	gnv_authorbtn.of_registerparent(this)
End If

of_initbutton ()
of_initbutton_after ()

Return 1
end function

public function string of_getpgmno ();if isvalid(inv_menu) then
	return inv_menu.is_pgm_no
else
	return ''
end if
end function

public subroutine of_getcontrols (graphicobject a_control, ref graphicobject a_controls[]);// 윈도우의 컨트롤을 배열형태로 구합니다. Tab, UserObject 컨트롤과 그 안에 위치한 컨트롤을 포함합니다.
// a_controls[] 는 반드시 초기화된 상태로 호출해야 합니다. 이 함수는 Recursive 형태로 구동되기 때문에 내부적으로 초기화하지 않습니다.

window	lw_current

tab	ltab_current

userobject	luo_current

long	ll_previous_elements, ll_total_elements, i

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

integer			i, li_cnter
windowobject	lwo_ret

li_cnter  = upperbound(iwo_control)
if li_cnter = 0 then
	this.of_getcontrols(this, iwo_control)
	li_cnter = upperbound(iwo_control)
end if

for  i  = 1 to  li_cnter
	if  iwo_control[i].classname() = as_objname  then
		lwo_ret = iwo_control[i]
		exit
	end  if
next

return lwo_ret
end function

public subroutine of_initbutton ();
end subroutine

public subroutine of_ctlssetredraw (boolean ab_boolean);gw_mdi.uo_sheettab.setredraw (ab_boolean)
Choose Case ab_boolean
	Case True
		gw_mdi.of_loadingwait(false)
		uo_navi.p_icon.show()
		uo_navi.st_navi.show()
	Case False
		uo_navi.p_icon.hide()
		uo_navi.st_navi.hide()
End Choose
end subroutine

public subroutine of_btotopslave (graphicobject ag_object);integer	li_ctrlcnt, i
integer	li_tabctrlcnt, li_tabpagectrlcnt, ii, li_tapagei
integer	li_uoctrlcnt, iii

fw_u_dwo		ldw_data
Tab			ltab_control
Userobject	luo_control, ltabpage_control

li_ctrlcnt = upperbound(This.control)

For i = 1 to li_ctrlcnt
	Choose Case This.Control[i].typeof()
		Case DataWindow!
			ldw_data = This.Control[i]
			ldw_data.PostEvent('oue_bringtotop')
		Case Tab!
			ltab_control = This.Control[i]
			li_tabctrlcnt = upperbound(ltab_control.Control)
			For ii = 1 to li_tabctrlcnt
				ltabpage_control = ltab_control.Control[ii]
				li_tabpagectrlcnt = upperbound(ltabpage_control.Control)
				For li_tapagei = 1 to li_tabpagectrlcnt
					If ltabpage_control.Control[li_tapagei].typeof() = DataWindow! Then
						ldw_data = ltabpage_control.Control[li_tapagei]
						ldw_data.PostEvent('oue_bringtotop')
					End If
				Next
			Next
		Case UserObject!
			luo_control = This.Control[i]			
			li_uoctrlcnt = upperbound(luo_control.Control)
			For iii = 1 to li_uoctrlcnt
				If luo_control.Control[iii].typeof() = DataWindow! Then
					ldw_data = luo_control.Control[iii]
					ldw_data.PostEvent('oue_bringtotop')
				End If
			Next
	End Choose
Next
end subroutine

public subroutine of_btotopmst (windowobject aw_object);integer	li_ctrlcnt, i
integer	li_tabctrlcnt, li_tabpagectrlcnt, ii, li_tapagei
integer	li_uoctrlcnt, iii

fw_u_dwo	ldw_data

Tab	ltab_control

Userobject	luo_control, ltabpage_control

li_ctrlcnt = upperbound(This.control)

For i = 1 to li_ctrlcnt
	Choose Case This.Control[i].typeof()
		Case DataWindow!
			ldw_data = This.Control[i]
		Case Tab!
			ltab_control = This.Control[i]
			li_tabctrlcnt = upperbound(ltab_control.Control)
			For ii = 1 to li_tabctrlcnt
				ltabpage_control = ltab_control.Control[ii]
				li_tabpagectrlcnt = upperbound(ltabpage_control.Control)
				For li_tapagei = 1 to li_tabpagectrlcnt
					If ltabpage_control.Control[li_tapagei].typeof() = DataWindow! Then
						ldw_data = ltabpage_control.Control[li_tapagei]
					End If
				Next
			Next
		Case UserObject!
			luo_control = This.Control[i]			
			li_uoctrlcnt = upperbound(luo_control.Control)
			For iii = 1 to li_uoctrlcnt
				If luo_control.Control[iii].typeof() = DataWindow! Then
					ldw_data = luo_control.Control[iii]
				End If
			Next
	End Choose
Next

end subroutine

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

public function integer of_rtnmodifyrowbycheck (string as_status);Choose Case as_status
	Case 'UPT'
		If idw_u.rowcount() < 1 Then
			Messagebox("Check",  idw_u.classname() + "(이)가 Row가 존재하지 않습니다.")
			Return -1
		End If
	Case 'DEL'
		If idw_u.rowcount() > 0 Then
			Messagebox("Check",  idw_u.classname() + "(이)가 Row가 존재합니다.")
			Return -1
		End If
End Choose
Return 1
end function

public subroutine of_setchtdatabysort (ref string as_dataarr[]);String	ls_data[]
Long		ll_uppercnt, ll_i

fw_n_dso	lds_sort
lds_sort = Create fw_n_dso

lds_sort.dataobject = 'pf_d_chartbysort'

ll_uppercnt = upperbound(as_dataarr)

For ll_i = 1 To ll_uppercnt
	lds_sort.Insertrow(0)
	fw_f_obj2array(as_dataarr[ll_i], '~t', ls_data[])
	If ls_data[1] = '1sttitle' Then ls_data[1] = '-9999'
	lds_sort.SetItem(ll_i, 'obj_x', Long(ls_data[1]))
	lds_sort.SetItem(ll_i, 'obj_data', ls_data[2])
Next

lds_sort.SetSort("obj_x asc, obj_data asc")
lds_sort.Sort()

For ll_i = 1 To ll_uppercnt
	as_dataarr[ll_i] = lds_sort.GetItemString(ll_i, 'obj_data')
Next
end subroutine

public function string of_getwindowtype ();Return 'main'
end function

public subroutine of_setfocusdw (fw_u_dwo adw_dw);IF	IsValid(idw_u) THEN idw_u.of_setborderfocuscolor(FALSE)
idw_u = adw_dw
idw_u.of_setborderfocuscolor (TRUE)
IF idw_u.classname ()='dw_list' or idw_u.classname ()='dw_pagelist' THEN idw_list = idw_u
end subroutine

public subroutine of_setmm2obj (fw_u_dwo adw_obj);idw_mm = adw_obj
end subroutine

public subroutine of_setsorthide ();If IsValid(idw_mm) Then
	idw_mm.of_stc2off()
	idw_mm = idw_null
End If
end subroutine

public subroutine of_setwindowobjects (ref windowobject awo_object[]);// get window controls
if upperbound(iwo_control) = 0 then
	this.of_getcontrols(this, awo_object[])
end if
end subroutine

public function long of_setlang ();string	ls_obj[]
long	ll_i, ll_objcnt, ll_dwobjcnt
object	lo_type

if not isvalid(gnv_lang) then return -1
if upperbound(iwo_control[]) < 1 Then of_setwindowobjects(iwo_control[])
if fw_f_nvls(is_lang_ins, '') = '' Then is_lang_ins = 'lng_kor'
if not IsValid(gnv_lang.ids_langcvt) Then
	gnv_extfunc.biznode1te(149, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
	gnv_lang.Triggerevent(gnv_extfunc.is_nodevalue)
	gw_mdi.of_active4lang()
end if
gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01 = gnv_vari.is_sys_id
gnv_extfunc.istr_node4value.cstr02 = gnv_vari.is_lang_type
gnv_extfunc.istr_node4value.cstr03 = is_lang_ins
gnv_extfunc.biznode11te(112, handle(this), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
choose case gnv_vari.is_lang_type
	case lower(gnv_extfunc.istr_node4value.cstr11), lower(gnv_extfunc.istr_node4value.cstr12), lower(gnv_extfunc.istr_node4value.cstr13), lower(gnv_extfunc.istr_node4value.cstr14), lower(gnv_extfunc.istr_node4value.cstr15)
		gw_mdi.of_sheetwait(true)
		this.setredraw(false)
		if gnv_vari.is_lang_type = is_lang_ins Then
			this.setredraw(true)
			gw_mdi.of_sheetwait(false)
			return 1
		end if
		this.event wue_setdddw()
		ll_objcnt = upperbound(iwo_control[])
		For ll_i = 1 to ll_objcnt
			lo_type = iwo_control[ll_i].typeof()
			if lo_type = Datawindow! then
				datawindow	ldw_dw
				ldw_dw = iwo_control[ll_i]
				gnv_lang.of_setlangchange(ldw_dw, is_lang_ins, gnv_lang.ids_langcvt)
			else
				gnv_lang.of_setlangchange(iwo_control[ll_i], is_lang_ins, gnv_lang.ids_langcvt)
			end if
		Next
		this.event wue_retrieve4lang()
		if gw_mdi.uo_topmenu.of_getlangtype() <> gnv_vari.is_lang_type Then
			gnv_authority.of_setsystemuserrole(gnv_vari.is_user_id)
			gw_mdi.uo_topmenu.of_drawmenu('')
			gw_mdi.of_clicked4menu('00001')
			gw_mdi.uo_topmenu.post dynamic of_menuclicked(0, gw_mdi.is_obj4topmenu)
		end if
		is_lang_ins = gnv_vari.is_lang_type
		this.setredraw(true)
		gw_mdi.of_sheetwait(false)
end choose

return 1
end function

public subroutine of_initsetting (fw_u_dwo adw_dw, string as_val1, string as_val2);
end subroutine

public subroutine of_initsetting (fw_u_dwo adw_dw, long al_row, string as_val1, string as_val2);
end subroutine

public function integer of_confirmupdate4close (fw_u_dwo adw_upt[]);Long	ll_cnt, ll_ii, ll_rtn
ll_cnt = UpperBound(adw_upt)
For ll_ii= 1 To ll_cnt
	Yield ( )
//	adw_upt[ll_ii].AcceptText()
	If adw_upt[ll_ii].Modifiedcount() + adw_upt[ll_ii].Deletedcount() > 0 Then
		If of_confirmupdate4boolean() = true Then
			ll_rtn = fw_f_message('Q01', inv_menu.is_pgm_nm, '')
			Return ll_rtn
		Else
			Return 1
		End If
		Exit
	End If
Next
Return 0
end function

public subroutine of_setedittoken44 (string as_dw);fw_u_dwo	ldw_obj
ldw_obj = of_getrefdw2obj(as_dw)
If IsValid(ldw_obj) Then
	gnv_extfunc.biznode1te(147, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
	ldw_obj.TriggerEvent(gnv_extfunc.is_nodevalue)
End If
end subroutine

public subroutine of_sethotkey (string as_hotkey);
end subroutine

public subroutine of_confirmupdate4rowchanged ();If ibrowchanged2event = false Then
	ibrowchanged2event = true
	This.TriggerEvent("wue_update")
	ibrowchanged2event = false
End If
ibrowchanged2event = false
end subroutine

public function integer of_condcheck4idwu ();If idw_u.ibdesign4cond = true Then
	Messagebox('Check', 'The search condition DataWindow is not supported.~r~n Please select another DataWindow.')
	Return -1
End If
Return 1
end function

public subroutine of_sethotkey4copy (string as_hotkey);fw_s_parent	lstr_parent

String	ls_data

Long	ll_row_a, ll_row_b, ll_obj, ll_objcnt, ll_i, ll, ln

Choose Case as_hotkey
	Case 'F2'
		If not Isvalid(idw_u) Then Return
		If idw_u.rowcount() < 1 Then Return		
		If of_condcheck4idwu() = -1 Then Return
		ll_row_a	= idw_u.of_getcurrentrow() + 1
		ll_row_b	= ll_row_a - 1
		ll_obj	= idw_u.GetColumn()
		ls_data	= idw_u.Object.data[ll_row_b,ll_obj]
		idw_u.scrolltorow(ll_row_a)
		idw_u.SetText(ls_data)
		idw_u.AcceptText()
	Case 'F3'
		If not Isvalid(idw_u) Then Return
		If idw_u.rowcount() < 1 Then Return
		If of_condcheck4idwu() = -1 Then Return
		ll_row_a	= idw_u.of_getcurrentrow() + 1
		ll_row_a	= idw_u.Insertrow(ll_row_a)
		ll_row_b	= ll_row_a - 1
		ll_obj	= idw_u.GetColumn()
		ll_objcnt = Long(idw_u.Object.DataWindow.Column.Count)
		For ll_i = 1 To ll_objcnt
			If idw_u.describe("#"+String(ll_i)+".Visible") = '1' Then
				idw_u.Object.data[ll_row_a, ll_i] = idw_u.Object.data[ll_row_b, ll_i]
			End if
		Next
		ls_data = idw_u.Object.data[ll_row_b,ll_obj]
		idw_u.scrolltorow(ll_row_a)
		idw_u.SetText(ls_data)
		idw_u.AcceptText()
	Case 'Q'
		If not Isvalid(idw_u) Then Return
		IF	gaa.aams	Then
			messagebox ('clipboard', classname (idw_u) + ' select copy')
			::CLIPBOARD (idw_u.getsqlselectJ ())
		End IF
	Case 'S'
		If not Isvalid(idw_u) Then Return
		lstr_parent.w_obj = idw_u.iw_parent
		lstr_parent.dw_obj = idw_u
		OpenWithParm(pf_w_dwbymultisort, lstr_parent)
	Case 'T'
		If not Isvalid(idw_u) Then Return
		idw_u.dynamic event ue_saveas ()
	Case 'P'
		If not Isvalid(idw_u) Then Return
		idw_u.dynamic post event ue_print ()
	Case 'F'
		If not Isvalid(idw_u) Then Return
		IF	idw_u.classname()='dw_c' THEN RETURN
		lstr_parent.w_obj = idw_u.iw_parent
		lstr_parent.dw_obj = idw_u
		IF	idw_u.uf_filter ()	Then
			ll = idw_u.getrow ()
			OpenWithParm (w_set_filter, idw_u.ids_filter)
			IF	Message.StringParm<>'Cancel'	Then	// Filter
				IF	Message.StringParm='reset'	Then
					idw_u.SetFilter ('')
					idw_u.dynamic uf_constructor ()
				Else
					ls_data = Message.StringParm
					idw_u.setfilter (ls_data)
				End IF
				idw_u.Filter ()
				idw_u.GroupCalc ()	// 계산에 대한 Reset
				ln = idw_u.getrow ()
				IF ln=ll THEN idw_u.EVENT rowfocuschanged (ln)
			End IF
		Else
			OpenWithParm(pf_w_dwbyrbtnfilter, lstr_parent)
		End IF
	Case 'A'
		If not Isvalid(idw_u) Then Return
		IF	idw_u.eb_new_false=false THEN idw_u.dynamic event ue_insert (0)
	Case 'i'
		If not Isvalid(idw_u) Then Return
		IF	idw_u.eb_new_false=false THEN idw_u.dynamic event ue_insert (idw_u.getrow ())
	Case 'B'
		If not Isvalid(idw_u) Then Return
		IF	idw_u.eb_copy_false=false THEN idw_u.dynamic event ue_copyrow ()
	Case 'D'
		If not Isvalid(idw_u) Then Return
		IF	idw_u.eb_delete_false=false THEN idw_u.dynamic event ue_delete ()
End Choose
end subroutine

public function boolean of_confirmupdate4boolean ();If ibconfirmupdate4closequery = true and ibclosequery2event = true Then
	Return true
End If
If ibconfirmupdate4closequery = true and ibconfirmupdate4retrieve = true and ibretrieve2event = true Then
	Return true
End If
If ibconfirmupdate4message = true or ibrowchanged2event = true Then
	Return true
End If
Return false
end function

public subroutine of_setdefault4rowchanged2boolean ();ibrowchanged2event = false
end subroutine

public function fw_u_dwo of_getrefdw2obj (string as_dwobj);integer	li_cnt, i

fw_u_dwo	ldw_obj

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

public subroutine of_ship4var2event (string as_event2variable, boolean ab_boolean);Choose Case as_event2variable
	Case 'ibrowchanged2event'
		ibrowchanged2event = ab_boolean
End Choose
end subroutine

public subroutine of_setsync4topmenu ();//<임시> bookmark인 경우 sync안함
IF gw_mdi.uo_xpmenu.visible	Then
	gnv_vari.isnow4topmenu = gnv_rolemenu.of_getlevel4findmenu (inv_menu.is_pgm_no, 2)
	If gnv_vari.isprev4topmenu<>gnv_vari.isnow4topmenu	Then
		gw_mdi.uo_topmenu.dynamic of_setfind4menu2course(0, gnv_vari.isnow4topmenu)
		gnv_vari.isprev4topmenu = gnv_vari.isnow4topmenu
	End If
End IF
//Post of_setsync4submenu()
end subroutine

public subroutine of_setsync4submenu ();//<임시> bookmark인 경우 sync안함
//IF gw_mdi.uo_xpmenu.visible	Then
//	gnv_vari.isnow4submenu = gnv_rolemenu.of_getlevel4findmenu (inv_menu.is_pgm_no, 3)
//	If gnv_vari.isprev4submenu<>gnv_vari.isnow4submenu Then
//		gw_mdi.uo_submenu.dynamic of_setfind4menu2course(0, gnv_vari.isnow4submenu)
//		gnv_vari.isprev4submenu = gnv_vari.isnow4submenu
//	End If
//End IF
//gw_mdi.post of_setpgmexpression(inv_menu.is_pgm_no)
end subroutine

public function integer of_update (fw_u_dwo adw_upt[]);Long	ll_cnt, ll_ii, ll_rtn

ll_rtn = of_confirmupdate4close(adw_upt)
Choose Case ll_rtn
	Case 0
		Return 0
	Case 1
		//
	Case 2
		//Return 0
		// 아니오 return
		Return 2
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
	adw_upt[ll_ii].SetTransObjectJ( sqlca )
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
	fw_f_setlog4pgm('sy1001010', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', 'datadwindow')
end if
fw_f_message('U01', '', '')

Return 1
end function

public subroutine of_setsplit4position ();if IsValid(inv_resize) then inv_resize.of_setsplit4position()
end subroutine

public subroutine of_getnavi2pathtext ();gnv_vari.iserror2navi = uo_navi.st_navi.text
gnv_vari.iserror2pgmno = inv_menu.is_pgm_no
end subroutine

public function integer of_updatecommit (fw_u_dwo adw_upt[]);LONG	ll_cnt, ll_ii, ll_rtn

ll_cnt = UpperBound(adw_upt)
FOR  ll_ii = 1  TO  ll_cnt
   adw_upt[ll_ii].AcceptText ()
   IF adw_upt[ll_ii].Modifiedcount () + adw_upt[ll_ii].Deletedcount ()>0	Then
      IF adw_upt[ll_ii].dynamic EVENT oue_setupdatecheck()<1	Then RETURN -1
      gnv_vari.ilupdate4error2num = ll_ii
      IF adw_upt[ll_ii].update ()<1	Then
			rollbackJ ()
         return -1
      End IF
      commitJ ()
   End IF
Next

fw_f_message('U01', '', '')

Return 1
end function

public function long of_getobject2width (string as_objname);long		ll_width
integer	i, li_cnter

window		lw_current
tab			ltab_current
userobject	luo_current

ll_width = 0

li_cnter  = upperbound(iwo_control)
if li_cnter = 0 then
	this.of_getcontrols(this, iwo_control)
	li_cnter = upperbound(iwo_control)
end if

for  i  = 1 to  li_cnter
	if  iwo_control[i].classname() = as_objname  then
		choose case iwo_control[i].TypeOf()
			case Window!
				ll_width = this.width
			case Tab!
				ltab_current = iwo_control[i]
				ll_width = ltab_current.width
			case UserObject!
				luo_current = iwo_control[i]
				ll_width = luo_current.width
			case else
				ll_width = 0
		end choose
		exit
	end  if
next

return ll_width
end function

public function string of_getpgmnm ();if isvalid(inv_menu) then
	return inv_menu.is_pgm_nm
else
	return ''
end if
end function

public function fw_u_dwo of_getmm2obj ();return idw_mm
end function

public subroutine of_initbutton_after ();
end subroutine

public subroutine wf_setenabled ();
end subroutine

public function integer of_update (datastore ads_upt[]);Long		ll_cnt, ll_ii, ll_rtn

ll_cnt = UpperBound(ads_upt)

For ll_ii= 1 To ll_cnt
	ads_upt[ll_ii].SetTransObject( sqlca )
	gnv_vari.ilupdate4error2num = ll_ii
	if ads_upt[ll_ii].update(true, false) < 1 Then
		rollbackJ ()
		return -1
	end if
Next

commitJ ()

For ll_ii= 1 To ll_cnt
	ads_upt[ll_ii].ResetUpdate()
Next
if ibconfirmlogs4stats = true then
	fw_f_setlog4pgm('sy1001010', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', 'datastore')
end if
fw_f_message('U01', '', '')

return 0
end function

public function boolean of_getconfirmlogs4stats ();return ibconfirmlogs4stats
end function

public function n_menu of_getwindowmenu ();return inv_menu
end function

on w_window1st.create
this.lb_dirlist=create lb_dirlist
this.ln_templeft=create ln_templeft
this.ln_tempbuttom=create ln_tempbuttom
this.ln_temptop=create ln_temptop
this.ln_tempbutton=create ln_tempbutton
this.ln_tempstart=create ln_tempstart
this.ln_cond1_yline=create ln_cond1_yline
this.ln_dw1_yline=create ln_dw1_yline
this.ln_cond2_yline=create ln_cond2_yline
this.ln_dw2_yline=create ln_dw2_yline
this.ln_tempright=create ln_tempright
this.uo_navi=create uo_navi
this.ln_temptop_shadow=create ln_temptop_shadow
this.st_windelaytime=create st_windelaytime
this.st_top_rect=create st_top_rect
this.Control[]={this.lb_dirlist,&
this.ln_templeft,&
this.ln_tempbuttom,&
this.ln_temptop,&
this.ln_tempbutton,&
this.ln_tempstart,&
this.ln_cond1_yline,&
this.ln_dw1_yline,&
this.ln_cond2_yline,&
this.ln_dw2_yline,&
this.ln_tempright,&
this.uo_navi,&
this.ln_temptop_shadow,&
this.st_windelaytime,&
this.st_top_rect}
end on

on w_window1st.destroy
destroy(this.lb_dirlist)
destroy(this.ln_templeft)
destroy(this.ln_tempbuttom)
destroy(this.ln_temptop)
destroy(this.ln_tempbutton)
destroy(this.ln_tempstart)
destroy(this.ln_cond1_yline)
destroy(this.ln_dw1_yline)
destroy(this.ln_cond2_yline)
destroy(this.ln_dw2_yline)
destroy(this.ln_tempright)
destroy(this.uo_navi)
destroy(this.ln_temptop_shadow)
destroy(this.st_windelaytime)
destroy(this.st_top_rect)
end on

event open;If ib_onceopened = true Then return

//gw_mdi.st_mdiclient.show()
if gw_mdi.p_frame_loading.visible = true then
	gw_mdi.of_loadingwait(true)
end if
this.of_ctlssetredraw (False)

If ConfirmSheetBackColor = True Then This.BackColor = gnv_vari.sheetbackcolor

// Resize 설정
this.of_setresize(true)

If this.windowtype = main! Then
	iw_parent		= gw_mdi
	iw_iwindow		= This
	is_classname	= This.classname()
	gnv_vari.iwerror2window	= this
	// 파라미터 가져오기
	If fw_f_nvls(gnv_menu.is_pgm_id, '') <> '' Then
		inv_clear4menu = Create n_menu
		inv_menu = Create n_menu
		inv_menu.is_pgm_no	= gnv_menu.is_pgm_no
		inv_menu.is_pgm_id	= gnv_menu.is_pgm_id
		inv_menu.is_pgm_nm	= gnv_menu.is_pgm_nm
		inv_menu.is_parameter1	= gnv_menu.is_parameter1
		inv_menu.is_parameter2	= gnv_menu.is_parameter2
		inv_menu.is_parameter3	= gnv_menu.is_parameter3
		gnv_menu = inv_clear4menu
	End If

	// OpenSheet로 사용자가 윈도우 오픈한 경우(=파라미터 없음)
	If NOT Isvalid(inv_menu) Then
		// maximize 처리
		If this.WindowState <> Maximized! Then this.WindowState = Maximized!

		inv_menu = Create n_menu
		If gnv_rolemenu.of_getmenudata_by_pgmid(upper(this.classname()), inv_menu) = 0 Then
			inv_menu.is_pgm_id = this.classname()
			inv_menu.is_pgm_no = inv_menu.is_pgm_id
			If len(trim(this.title)) > 0 Then
				inv_menu.is_pgm_nm = this.title
			else
				inv_menu.is_pgm_nm = is_classname
			End If
		End If
	End If

	this.title = inv_menu.is_pgm_nm // set window title empty setting

	// to-be fullpath
	String	ls_pgm_path
	ls_pgm_path = gnv_rolemenu.of_getpgmpath(inv_menu.is_pgm_no)
	If isnull(ls_pgm_path) or ls_pgm_path = '' Then
		ls_pgm_path = inv_menu.is_pgm_nm
	End If
	inv_menu.is_pgm_path	= ls_pgm_path + '[ ' + this.classname() + ' ]'
	inv_menu.iw_sheet_ref	= iw_iwindow
	
	if ibconfirmlogs4stats = true then
		fw_f_setlog4pgm('sy1001003', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', '')
	end if

	If Pos(inv_menu.is_pgm_id, gnv_vari.w_home) > 0 Then
		uo_navi.p_icon.visible = false
	Else
		// sheet_tab_bar 컨트롤 설정
		il_tab_seq = gw_mdi.Dynamic of_setdynamicevent('fw_u_sheettab4frame', 'oue_addsheettab', inv_menu)
		inv_menu.ii_tabseq = il_tab_seq /* to-be */
		/* to-be */
		Choose Case Pos(inv_menu.is_pgm_path, '&')
			Case Is > 0
				uo_navi.st_navi.text = fw_f_replaceall(inv_menu.is_pgm_path, '&', '&&')
			Case Else
				uo_navi.st_navi.text = inv_menu.is_pgm_path
		End Choose
		uo_navi.of_setposition()
	End If
End If

If not gaa.admin Then st_windelaytime.visible = false

of_setauthority( True ) // Button Autority 설정

This.Post of_ctlssetredraw( True )

This.Post Event wue_postinst()	// Call Post ancestor object clear 1st

This.Post Event wue_setdddw()		// dddw setting

This.Post Event wue_postopen()	// Call Post Open Event

//gw_mdi.post of_sheetwait (False)
end event

event activate;IF	gaa.aams THEN debug_step [UPPERBOUND (debug_step) + 1] = classname () + ' activate'
gnv_vari.iwerror2window = this
// CurrentDirectory 변경여부 확인, 디폴트 폴더로 원복처리
fw_f_savepath('set', getcurrentdirectory())
If getcurrentdirectory() <> gnv_vari.basepath then changedirectory(gnv_vari.basepath)

If Isvalid(gw_mdi) then
	If this.windowtype = main! then
		If il_tab_seq > 0 then
			// sheettab 컨트롤
			gw_mdi.dynamic of_setdynamicevent('fw_u_sheettab4frame', 'oue_selectsheettab', inv_menu) /* to-be */

			// statusbar 컨트롤
			inv_menu.is_statusbar_id = inv_menu.is_pgm_id
			gw_mdi.dynamic of_setdynamicevent('fw_u_statebar4frame', 'oue_setwindowname', inv_menu) /* to-be */

			If gw_mdi.uo_push4message.visible = true Then gw_mdi.uo_push4message.show()
		End If
//<임시> 화면실행과 active가 중복처리되면서 메뉴클릭표시 버그가 발생하는 것으로 예상 20211019
//		If this.classname() = gnv_vari.w_home Then
//			//gw_mdi.of_setpgmexpression('')
//			//gw_mdi.dynamic of_setdynamicevent('fw_u_sheettab4frame', 'oue_selectsheettab', inv_menu) /* w_home 별도 처리 */
//		Else
//			If ib_onceopened = true and gnv_vari.il_return4closesheettab = 0 Then
//				of_setsync4topmenu()
//			Else
//				gnv_vari.il_return4closesheettab = 0
//			End If
//		End If
	End If
End If
end event

event resize;// WindowState = Maximized! 상태이면서 width, height 사이즈가
// 변경된 경우만 리사이즈 서비스 수행
IF This.Windowstate = Maximized! THEN
	IF il_newwidth <> newwidth OR il_newheight <> newheight THEN
		If IsValid (inv_resize) Then
			//inv_resize.Event pfc_Resize (sizetype, This.WorkSpaceWidth(), This.WorkSpaceHeight())
			inv_resize.Event pfc_Resize (sizetype, newwidth, newheight)
			il_newwidth = newwidth
			il_newheight = newheight
		END IF
	END IF
END IF
end event

event close;LONG	li

//<임시> currentdirectory가 바뀌어 이미지가 깨지는 경우가 있습니다. 20210727
changedirectory (gnv_vari.basepath)

If isvalid(gw_mdi) Then
	If this.windowtype = main! Then
		if ibconfirmlogs4stats = true then
			fw_f_setlog4pgm('sy1001004', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', '')
		end if
		If il_tab_seq > 0 Then
			// sheettab 컨트롤			
			gnv_vari.il_return4closesheettab = gw_mdi.dynamic of_setdynamicevent('fw_u_sheettab4frame', 'oue_closesheettab', inv_menu)
		End If
		// 윈도우 Open시 Close(This) 명령이 수행되면 WindowState가 Maximized -> Normal 상태로 변경됨
		//gw_mdi.Post of_checkactivesheetstate()
		// appeon 환경인 경우 sheet 종료 후 mdi_1.border가 복원됨
		If gnv_vari.getclienttype = 'WEB' Then gw_mdi.post of_setmdiclientborder(3)
	End If
End If
end event

event deactivate;If isvalid(gw_mdi) then
	If this.windowtype = main! Then
		If il_tab_seq > 0 then			
			gw_mdi.Dynamic of_setdynamicevent('fw_u_sheettab4frame', 'oue_deselectsheettab', inv_menu)
			inv_menu.is_statusbar_id = ''
			gw_mdi.Dynamic of_setdynamicevent('fw_u_statebar4frame', 'oue_setwindowname', inv_menu)
		End If
	End If
End If
end event

event mousemove;of_setsorthide()
end event

event closequery;gw_mdi.il_return4sheetclosequery = il_return4sheetclosequery
If ibconfirmupdate4closequery = true Then
	ibclosequery2event = true
	il_return4sheetclosequery = Event wue_confirmupdate4close()
	gw_mdi.il_return4sheetclosequery = il_return4sheetclosequery	
	ibclosequery2event = false
	Return gw_mdi.il_return4sheetclosequery
End If
Return gw_mdi.il_return4sheetclosequery
end event

type lb_dirlist from listbox within w_window1st
boolean visible = false
integer width = 242
integer height = 228
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
boolean border = false
boolean sorted = false
end type

type ln_templeft from line within w_window1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 50
integer beginy = -92
integer endx = 50
integer endy = 3048
end type

type ln_tempbuttom from line within w_window1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 2760
integer endx = 5970
integer endy = 2760
end type

type ln_temptop from pf_u_line within w_window1st
integer linethickness = 4
integer beginy = 124
integer endx = 5970
integer endy = 124
boolean scaletoright = true
end type

type ln_tempbutton from line within w_window1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 128
integer endx = 5970
integer endy = 128
end type

type ln_tempstart from line within w_window1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 156
integer endx = 5970
integer endy = 156
end type

type ln_cond1_yline from line within w_window1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 316
integer endx = 5970
integer endy = 316
end type

type ln_dw1_yline from line within w_window1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 348
integer endx = 5970
integer endy = 348
end type

type ln_cond2_yline from line within w_window1st
boolean visible = false
long linecolor = 134217856
integer linethickness = 4
integer beginy = 424
integer endx = 5970
integer endy = 424
end type

type ln_dw2_yline from line within w_window1st
boolean visible = false
long linecolor = 134217856
integer linethickness = 4
integer beginy = 456
integer endx = 5970
integer endy = 456
end type

type ln_tempright from line within w_window1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 5426
integer endx = 5426
integer endy = 3044
end type

type uo_navi from fw_u_sheet4navi within w_window1st
integer x = 1733
integer y = 28
boolean fixedtoright = true
end type

on uo_navi.destroy
call fw_u_sheet4navi::destroy
end on

type ln_temptop_shadow from pf_u_line within w_window1st
long linecolor = 33224176
integer linethickness = 8
integer beginy = 132
integer endx = 5970
integer endy = 132
boolean scaletoright = true
end type

type st_windelaytime from pf_u_statictext within w_window1st
integer x = 5303
integer width = 128
integer height = 40
boolean bringtotop = true
integer textsize = -6
fontcharset fontcharset = hangeul!
long textcolor = 19737901
long backcolor = 32238571
boolean enabled = false
alignment alignment = right!
boolean fixedtoright = true
end type

type st_top_rect from pf_u_statictext within w_window1st
integer width = 5495
integer height = 124
long backcolor = 32238571
boolean scaletoright = true
end type

