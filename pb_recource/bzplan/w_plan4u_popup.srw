forward
global type w_plan4u_popup from w_response1st
end type
type dw_notice from u_dw within w_plan4u_popup
end type
end forward

global type w_plan4u_popup from w_response1st
integer width = 1883
integer height = 684
boolean titlebar = false
boolean controlmenu = false
windowtype windowtype = child!
dw_notice dw_notice
end type
global w_plan4u_popup w_plan4u_popup

type variables
windowobject	iwo_parent

dwobject	idwo_parent

fw_s_home	istr_home
end variables

on w_plan4u_popup.create
int iCurrent
call super::create
this.dw_notice=create dw_notice
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_notice
end on

on w_plan4u_popup.destroy
call super::destroy
destroy(this.dw_notice)
end on

event open;call super::open;istr_home = Message.PowerObjectParm

If Not IsValid(istr_home) Then Return

// get pgm_no of this window
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

powerobject lpo_parent

Long	ll_xpos, ll_ypos

iwo_parent = istr_home.dw_obj

// 부모 컨트롤의 X,Y 좌표를 구합니다.
lpo_parent = iwo_parent.getparent()
do while isvalid(lpo_parent)
	choose case lpo_parent.typeof()
		case tab!
			tab ltab
			ltab = lpo_parent
			ll_xpos += ltab.x
			ll_ypos += ltab.y
		case userobject!
			userobject luo
			luo = lpo_parent
			ll_xpos += luo.x
			ll_ypos += luo.y
		case window!
			iw_parent = lpo_parent
			exit
	End choose
	lpo_parent = lpo_parent.getparent()
loop

If not isvalid(iw_parent) Then
	Messagebox('Notice(w_userplan_pop)', '부모 윈도우를 찾을 수 없습니다.')
	return
End If

// 오브젝트의 타입에 따라 달력 위치를 조절합니다.
string ls_date
date ld_date

choose case iwo_parent.typeof()
	case datawindow!
		datawindow ldw_parent
		
		ldw_parent = iwo_parent
		idwo_parent = istr_home.dwo_col

		If ldw_parent.dynamic of_getdesignstyle()  = 'freeform' Then
			ll_xpos += ldw_parent.x + Long(idwo_parent.x) + PixelsToUnits(15, xpixelstounits!)
			ll_ypos += ldw_parent.y + Long(idwo_parent.y) + (Long(idwo_parent.height) * 2)
		Else
			ll_xpos += ldw_parent.x + Long(idwo_parent.x) + PixelsToUnits(15, xpixelstounits!)
			ll_ypos += ldw_parent.y + ldw_parent.pointery()
		End If
		
		If gw_mdi.dynamic of_getleftmenustatus() = False Then ll_xpos -= Round(This.width / 2, 0)
	Case Else
		Messagebox('Notice', 'datawindow상태에서만 진행됩니다.')
		Return
End choose

// 부모 윈도우 크기에 맞게 위치 조정합니다.
integer li_direction

// 애니메이션 방향 설정
If ll_ypos + This.height > iw_parent.workspaceheight() Then
	ll_ypos -= pixelstounits(25, ypixelstounits!) //This.height
End If

This.x = ll_xpos
This.y = ll_ypos

This.width -= pixelstounits(2, xpixelstounits!)
This.height -= pixelstounits(4, ypixelstounits!)	

dw_notice.setredraw(true)
dw_notice.setfocus()

post event wue_postopen()
end event

event wue_postopen;call super::wue_postopen;String	ls_ymd
Long		ll_rtn

ls_ymd = istr_home.ymd

dw_notice.SetTransObject (sqlca)

dw_notice.uf_setcolumn ('sys_id', gnv_vari.is_sys_id)
dw_notice.uf_setcolumn ('user_id', gaa.login)
dw_notice.uf_setcolumn ('ymd', istr_home.ymd)
dw_notice.uf_setcolumn ('importance', '2')
dw_notice.uf_setcolumn ('reg_id', gnv_vari.is_user_id)
dw_notice.uf_setcolumn ('upd_id', gnv_vari.is_user_id)

ll_rtn = dw_notice.Retrieve (gnv_vari.is_sys_id, gnv_vari.is_user_id, ls_ymd)
If ll_rtn = 0 Then
	dw_notice.Insertrow(0)
	dw_notice.object.ymd [1] = ls_ymd
	dw_notice.object.reg_dt [1] = fw_f_getymdhh24miss4s ()
End If
end event

event closequery;//
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_plan4u_popup
end type

type ln_tempstart from w_response1st`ln_tempstart within w_plan4u_popup
end type

type ln_templeft from w_response1st`ln_templeft within w_plan4u_popup
end type

type ln_cond_start from w_response1st`ln_cond_start within w_plan4u_popup
end type

type ln_tempright from w_response1st`ln_tempright within w_plan4u_popup
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_plan4u_popup
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_plan4u_popup
end type

type dw_notice from u_dw within w_plan4u_popup
integer width = 1874
integer height = 676
integer taborder = 10
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_plan4u_pop_1"
end type

event clicked;call super::clicked;This.AcceptText()
Choose Case dwo.name
	Case 'p_update'
		update ()
		commitJ ()
		Post Close(parent)
	Case 'p_close'
		// 포커스 잃는 경우 종료
		Post Close(parent)
End Choose
end event

event itemfocuschanged;call super::itemfocuschanged;Choose Case dwo.name
	Case 'description'
		pf_f_togglekoreng('k')
	Case Else
		pf_f_togglekoreng('e')
End Choose
end event

event losefocus;call super::losefocus;// 포커스 잃는 경우 종료
//Post Close(parent)

end event

event oue_setupdatecheck;call super::oue_setupdatecheck;String	ls_temp
long		NbrRows, ll_row = 0

DWItemStatus	ldwstate

NbrRows = this.RowCount()

If NbrRows = 0 Then
	messagebox( "ERROR", "No data available.")
	Return 1
End If

DO WHILE ll_row <= NbrRows
	ll_row = this.GetNextModIfied(ll_row, Primary!)
	If ll_row > 0 Then
		ls_temp = fw_f_nvls(this.getItemString(ll_Row, 'description'), '')
		If Len(ls_temp) = 0 Then
			Messagebox("ERROR", "Please Register Description!")
			Return -1
		End If
	Else
		ll_row = NbrRows + 1
	End If
Loop

Return 1
end event

event itemchanged;call super::itemchanged;Object.upd_dt [1] = fw_f_getymdhh24miss4s ()
end event

