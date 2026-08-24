forward
global type fw_w_role_setting_config from w_response1st
end type
type cb_1 from commandbutton within fw_w_role_setting_config
end type
type p_close from pf_u_imagebutton within fw_w_role_setting_config
end type
type p_update from pf_u_imagebutton within fw_w_role_setting_config
end type
type dw_preview from fw_u_dwo within fw_w_role_setting_config
end type
type dw_cat from fw_u_dwo within fw_w_role_setting_config
end type
end forward

global type fw_w_role_setting_config from w_response1st
integer width = 2437
integer height = 2052
string title = "Role 카테고리 관리"
cb_1 cb_1
p_close p_close
p_update p_update
dw_preview dw_preview
dw_cat dw_cat
end type
global fw_w_role_setting_config fw_w_role_setting_config

on fw_w_role_setting_config.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.p_close=create p_close
this.p_update=create p_update
this.dw_preview=create dw_preview
this.dw_cat=create dw_cat
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.p_close
this.Control[iCurrent+3]=this.p_update
this.Control[iCurrent+4]=this.dw_preview
this.Control[iCurrent+5]=this.dw_cat
end on

on fw_w_role_setting_config.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.p_close)
destroy(this.p_update)
destroy(this.dw_preview)
destroy(this.dw_cat)
end on

event open;call super::open;string	ls_parm, ls_parm_arr[]
string ls_dddwobj

ls_parm = message.stringparm
if isnull(ls_parm) or len(ls_parm) = 0 then
	messagebox('Notice', 'There is no parameter variable value.')
	return
end if

dw_cat.settransobject(sqlca)

//choose case upper(left(sqlca.dbms, 3))
//	case 'ASE', 'SYC', 'ODB'
//		dw_cat.modify('user_tbl_col.dddw.name=fw_dddw_dbcol_asa')
//	case 'IN8', 'IN9', 'I10'
//		dw_cat.modify('user_tbl_col.dddw.name=fw_dddw_dbcol_inf')
//	case 'O80', 'O90', 'O10', 'ORA'
//		dw_cat.modify('user_tbl_col.dddw.name=fw_dddw_dbcol_ora')
//	case 'ADO', 'OLE', 'SNC'
//		dw_cat.modify('user_tbl_col.dddw.name=fw_dddw_dbcol_mssql')
//	case else
//		messagebox('Notice', '알수 없는 DBMS 타입입니다~r~nDBMS=' + sqlca.dbms)
//		return
//end choose
//
//dw_cat.modify("user_tbl_col.dddw.name='" + ls_dddwobj + "'")
//
//datawindowchild	ldwc
//dw_cat.getchild('user_tbl_col', ldwc)
//ldwc.settransobject(sqlca)
//ldwc.retrieve('FW_USER_MST')
//ldwc.insertrow(1)

fw_f_obj2array(ls_parm, '~t', ls_parm_arr)
choose case ls_parm_arr[1]
	case '추가'
		dw_cat.insertrow(0)
	case '수정'
		dw_cat.retrieve(gnv_vari.is_sys_id, ls_parm_arr[2])
end choose

this.title = this.title + '[' + ls_parm_arr[1] + ']'
dw_cat.setfocus()

end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_role_setting_config
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_role_setting_config
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_role_setting_config
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_role_setting_config
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_role_setting_config
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_role_setting_config
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_role_setting_config
end type

type cb_1 from commandbutton within fw_w_role_setting_config
integer x = 1280
integer y = 28
integer width = 398
integer height = 104
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "SQL테스트"
end type

event clicked;// 입력된 쿼리를 확인합니다

string ls_sql
long ll_rv
blob lblb_status

ls_sql = dw_cat.getitemstring(1, 'code_list_sql')
if pf_f_isemptystring(ls_sql) then
	messagebox('Notice', '코드 리스트 조회용 쿼리가 입력되지 않았습니다')
	return
end if

ads_jTier lds_preview

ll_rv = SQLCA.sql2ds (parent.classname(), ls_sql, lds_preview, 'xml')
choose case ll_rv
	case is > 0
		if lds_preview.getfullstate(lblb_status) > 0 then
			dw_preview.setfullstate(lblb_status)
			dw_preview.visible = true
		end if
	case 0
		messagebox('Notice', '해당 쿼리는 데이터가 존재하지 않습니다')
	case else
		messagebox('Notice', '잘못된 쿼리문입니다.')
end choose

end event

type p_close from pf_u_imagebutton within fw_w_role_setting_config
integer x = 2153
integer y = 36
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;closewithreturn(parent, 'Cancel')

end event

type p_update from pf_u_imagebutton within fw_w_role_setting_config
integer x = 1915
integer y = 36
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_save.jpg"
end type

event clicked;call super::clicked;// Accept Text
if dw_cat.accepttext() = -1 then return

// Check Mendatory Field
string	ls_role_cat_no, ls_role_cat_nm
string	ls_emp_tbl_col, ls_code_list_dwo
string ls_code_list_sql

ls_role_cat_nm = dw_cat.getitemstring(1, 'role_cat_nm')
if isnull(ls_role_cat_nm) or len(trim(ls_role_cat_nm)) = 0 then
	messagebox('Notice', 'Role 명칭을 입력하세요')
	return
end if

//ls_emp_tbl_col = dw_cat.getitemstring(1, 'emp_tbl_col')
//if isnull(ls_emp_tbl_col) or len(trim(ls_emp_tbl_col)) = 0 then
//	messagebox('Notice', '연계될 pf_Employee 테이블 컬럼명을 입력하세요')
//	return
//end if

ls_code_list_dwo = dw_cat.getitemstring(1, 'code_list_dwo')
ls_code_list_sql = dw_cat.getitemstring(1, 'code_list_sql')

if (isnull(ls_code_list_dwo) or len(trim(ls_code_list_dwo)) = 0) and & 
	(isnull(ls_code_list_sql) or len(trim(ls_code_list_sql)) = 0) then
	messagebox('Notice', '코드리스트 조회용 DWObject 또는 SQL을 입력하세요')
	return
end if

// Set Primary Key
if dw_cat.getitemstatus(1, 0, primary!) = newmodified! then
	select	max(role_cat_no)
	into		:ls_role_cat_no
	from		fw_role_cat_mst
	where	sys_id = :gnv_vari.is_sys_id
	;
	ls_role_cat_no = SQLCA.getitemstring (1)
	
	if isnull(ls_role_cat_no) then
		ls_role_cat_no = '00001'
	else
		ls_role_cat_no = string(long(ls_role_cat_no) + 1, '00000')
	end if
	
	dw_cat.setitem(1, 'sys_id', gnv_vari.is_sys_id)
	dw_cat.setitem(1, 'role_cat_no', ls_role_cat_no)
end if

// Do Update
string	ls_errtext

if dw_cat.update () = 1 then
	commitJ ()
else
	ls_errtext = sqlca.sqlerrtext()
	rollbackJ ()
	messagebox('Notice', 'Role 정보 저장 실패!!~r~n' + 'Error Text: ' + ls_errtext)
	return
end if

closewithreturn(parent, 'OK')
end event

type dw_preview from fw_u_dwo within fw_w_role_setting_config
boolean visible = false
integer x = 1925
integer y = 256
integer width = 2331
integer height = 1788
integer taborder = 20
boolean titlebar = true
string title = "Please, doubleclick the row in order to close this sql preview"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event doubleclicked;call super::doubleclicked;this.visible = false

end event

event oue_postopen;call super::oue_postopen;this.title = 'Please, doubleclick to close this sql preview'
end event

type dw_cat from fw_u_dwo within fw_w_role_setting_config
integer x = 50
integer y = 144
integer width = 2331
integer height = 1708
integer taborder = 10
string dataobject = "fw_d_role_setting_config_1"
boolean applydesign = true
boolean useborder = true
end type

event buttonclicked;if dwo.name = 'b_dwo' then
	OpenwithParm(pf_w_datawindow_search, '', parent)
	if isvalid(message.powerobjectparm) then
		pf_n_hashtable lnv_retval
		lnv_retval = message.powerobjectparm
		if isvalid(lnv_retval) then
			this.setitem(row, 'code_list_dwo', lnv_retval.of_get('classname'))
		end if
	end if
end if

end event

event itemchanged;call super::itemchanged;// code list 용 sql 이 변경된 경우 유요한 sql 인지 확인합니다.

choose case dwo.name
	case 'code_list_sql'
		if pf_f_isemptystring(data) then return 0

		ads_jTier lds_verify
		lds_verify = create ads_jTier
		
		if SQLCA.sql2ds( parent.classname(), data, lds_verify, 'xml') < 0 then
		
//		lds_verify.settransobject(sqlca)
//		if lds_verify.of_retrievefromsql(data) < 0 then
			return 2
		end if
end choose

return 0

end event

