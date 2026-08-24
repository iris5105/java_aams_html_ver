forward
global type fw_w_role_assign_pop from w_response1st
end type
type dw_data from fw_u_dwo within fw_w_role_assign_pop
end type
type p_search from pf_u_imagebutton within fw_w_role_assign_pop
end type
type p_close from pf_u_imagebutton within fw_w_role_assign_pop
end type
type p_select from pf_u_imagebutton within fw_w_role_assign_pop
end type
type dw_cond from fw_u_dwo within fw_w_role_assign_pop
end type
end forward

global type fw_w_role_assign_pop from w_response1st
integer width = 2459
integer height = 2584
string title = "Role 멤버 선택"
dw_data dw_data
p_search p_search
p_close p_close
p_select p_select
dw_cond dw_cond
end type
global fw_w_role_assign_pop fw_w_role_assign_pop

type variables
string is_parm

end variables

on fw_w_role_assign_pop.create
int iCurrent
call super::create
this.dw_data=create dw_data
this.p_search=create p_search
this.p_close=create p_close
this.p_select=create p_select
this.dw_cond=create dw_cond
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_data
this.Control[iCurrent+2]=this.p_search
this.Control[iCurrent+3]=this.p_close
this.Control[iCurrent+4]=this.p_select
this.Control[iCurrent+5]=this.dw_cond
end on

on fw_w_role_assign_pop.destroy
call super::destroy
destroy(this.dw_data)
destroy(this.p_search)
destroy(this.p_close)
destroy(this.p_select)
destroy(this.dw_cond)
end on

event open;call super::open;string	ls_dataobject, ls_sql

is_parm = message.stringparm
if isnull(is_parm) or len(is_parm) = 0 then
	messagebox('Notice', 'There is no parameter variable value.')
	return
end if

// 문자열 앞.뒤 DoubleQuotation 제거
if left(is_parm, 1) = '"' then
	is_parm = mid(is_parm, 2, len(is_parm) - 2)
end if

// 소스타입에 따른 코드 데이터 조회
choose case left(is_parm, 4)
	case 'dwo:'
		ls_dataobject = mid(is_parm, 5)
		dw_data.dataobject = ls_dataobject
		dw_data.settransobject(sqlca)
		dw_data.event oue_dataobjectchanged()

	case 'sql:'
		ls_sql = mid(is_parm, 5)

		fw_n_dso	lds_temp
		blob	lblb_state

		lds_temp = create fw_n_dso
		lds_temp.settransobject(sqlca)
		if lds_temp.of_createfromsql(ls_sql) > 0 then
			if lds_temp.getfullstate(lblb_state) >= 0 then
				dw_data.setfullstate(lblb_state)
				dw_data.settransobject(sqlca)
				dw_data.event oue_dataobjectchanged()
			end if
		end if
end choose
end event

event wue_postopen;call super::wue_postopen;dw_cond.insertrow(0)
dw_cond.setfocus()
p_search.event clicked ()
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_role_assign_pop
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_role_assign_pop
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_role_assign_pop
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_role_assign_pop
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_role_assign_pop
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_role_assign_pop
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_role_assign_pop
end type

type dw_data from fw_u_dwo within fw_w_role_assign_pop
integer x = 50
integer y = 348
integer width = 2359
integer height = 2120
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
end type

event doubleclicked;call super::doubleclicked;if row = 0 then return

// DoubleClicked
p_select.post event clicked()
end event

event oue_keydown;call super::oue_keydown;If This.GetRow() = 0 Then Return

If key = KeyEnter! Then
	p_select.Event Clicked()
End If
end event

type p_search from pf_u_imagebutton within fw_w_role_assign_pop
integer x = 1705
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_find.jpg"
end type

event clicked;call super::clicked;If dw_cond.accepttext() = -1 then return
dw_data.Reset()

string	ls_code, ls_name

ls_code = dw_cond.getitemstring(1, 'code')
ls_name = dw_cond.getitemstring(1, 'name')

If isnull(ls_code) or len(trim(ls_code)) = 0 then
	ls_code = '%'
Else
	ls_code = '%' + ls_code + '%'
End If

If isnull(ls_name) or len(trim(ls_name)) = 0 then
	ls_name = '%'
Else
	ls_name = '%' + ls_name + '%'
End If

string	ls_orig_sql, ls_modi_sql
string	ls_sysiddbalias, ls_codedbalias, ls_namedbalias
integer	li_rtn, li_rc
long		ll_pos, ll_objcnt
String	ls_objarr[]

/* to-be */
ls_orig_sql = dw_data.Describe("Datawindow.Table.Select")

// sys_id
ls_sysiddbalias = dw_data.describe("#1.dbAlias")
If ls_sysiddbalias = '?' or ls_sysiddbalias = '!' or  len(trim(ls_sysiddbalias)) = 0 then
	ls_sysiddbalias = dw_data.describe("#1.dbName")
	ll_objcnt = fw_f_obj2array(ls_sysiddbalias, '.', ls_objarr[])
	ls_sysiddbalias = ls_objarr[ll_objcnt]
End If

// code
ls_codedbalias = dw_data.describe("#2.dbAlias")
If ls_codedbalias = '?' or ls_codedbalias = '!' or  len(trim(ls_codedbalias)) = 0 then
	ls_codedbalias = dw_data.describe("#2.dbName")
End If

ll_pos = pos(ls_codedbalias, '.')
If ll_pos > 0 then
	ls_codedbalias = mid(ls_codedbalias, ll_pos + 1)
End If

// name
ls_namedbalias = dw_data.describe("#3.dbAlias")
If ls_namedbalias = '?' or ls_namedbalias = '!' or  len(trim(ls_namedbalias)) = 0 then
	ls_namedbalias = dw_data.describe("#3.dbName") //dbName
End If

ll_pos = pos(ls_namedbalias, '.')
If ll_pos > 0 then
	ls_namedbalias = mid(ls_namedbalias, ll_pos + 1)
End If

ls_modi_sql = "select * from ( " + ls_orig_sql + " ) sub01 where (" + ls_sysiddbalias + " = '" + gnv_vari.is_sys_id + "' or sys_id = 'aaa') and " + ls_codedbalias + " like '" + ls_code + "' and " + ls_namedbalias + " like '" + ls_name + "' order by 1, 2, 3"

dw_data.Object.Datawindow.Table.Select = ls_modi_sql
dw_data.setTransObject( sqlca )
dw_data.Retrieve()

dw_data.Object.Datawindow.Table.Select = ls_orig_sql

dw_data.insertrow(1)
dw_data.setitem(1, 1, gnv_vari.is_sys_id)
dw_data.setitem(1, 2, '')
dw_data.setitem(1, 3, 'All')
dw_data.setrow(1)
dw_data.setfocus()
end event

type p_close from pf_u_imagebutton within fw_w_role_assign_pop
integer x = 2181
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;closewithreturn(parent, 'Cancel')
end event

type p_select from pf_u_imagebutton within fw_w_role_assign_pop
integer x = 1943
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_linput.jpg"
end type

event clicked;call super::clicked;long		ll_row
string	ls_sys_id, ls_code, ls_name

ll_row = dw_data.getrow()
if ll_row < 1 then
	messagebox('Notice', '선택할 멤버가 존재하지 않습니다')
	return
end if

ls_code = dw_data.getitemstring(ll_row, 2)
if len(ls_code) > 0 then
	ls_sys_id	= dw_data.getitemstring(ll_row, 1)
	ls_name	= dw_data.getitemstring(ll_row, 3)
end if

closewithreturn(parent, 'OK' + '~t' + ls_sys_id + '~t' + ls_code + '~t' + ls_name)
end event

type dw_cond from fw_u_dwo within fw_w_role_assign_pop
integer x = 50
integer y = 156
integer width = 2359
integer height = 164
integer taborder = 10
boolean bringtotop = true
string dataobject = "pf_d_role_mst_memb_select_01"
boolean livescroll = false
boolean scaletoright = true
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
end type

event itemchanged;call super::itemchanged;choose case dwo.name
	case 'code', 'name'
		p_search.post event clicked()
end choose
end event

