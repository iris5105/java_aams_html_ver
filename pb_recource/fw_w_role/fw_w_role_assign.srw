forward
global type fw_w_role_assign from w_window1st5ncn
end type
type dw_role_mst from fw_u_dwo within fw_w_role_assign
end type
type cbx_hierachy from pf_u_checkbox within fw_w_role_assign
end type
type cbx_expand from pf_u_checkbox within fw_w_role_assign
end type
type dw_role_memb from fw_u_dwo within fw_w_role_assign
end type
type uo_title1 from fw_u_dw2title within fw_w_role_assign
end type
type st_4 from pf_u_splitbar_vertical within fw_w_role_assign
end type
type st_1 from pf_u_splitbar_horizontal within fw_w_role_assign
end type
type tv_pgm from pf_u_treeview within fw_w_role_assign
end type
end forward

global type fw_w_role_assign from w_window1st5ncn
dw_role_mst dw_role_mst
cbx_hierachy cbx_hierachy
cbx_expand cbx_expand
dw_role_memb dw_role_memb
uo_title1 uo_title1
st_4 st_4
st_1 st_1
tv_pgm tv_pgm
end type
global fw_w_role_assign fw_w_role_assign

type variables
ads_jTier	ids_menu, ids_menu_ds4root
ads_jTier	ids_role_pgm
ads_jTier	ids_role_cat

boolean	ib_chk4update = false
String	is_role_no, is_role_nm, is_pgm_lv2
Long		il_handle

fw_m_pgm_mst im_treemenu
end variables

forward prototypes
public function integer of_set_title_role_memb ()
public function integer of_set_popup_dddw_data ()
public function long of_retrieve_treeview (string as_role_no)
public function integer of_add_role_pgm (string as_role_no, string as_pgm_no)
public function long of_delete_role_pgm (string as_role_no, string as_pgm_no)
public function integer of_set_role_memb_name (string as_column, long al_row)
end prototypes

public function integer of_set_title_role_memb ();integer	i, j, il_role_cat_no
boolean	lb_role_cat_yn[8]
string	ls_modify, ls_search_type
string	ls_role_cat_no, ls_role_cat_nm
string	ls_code_list_dwo, ls_code_list_sql
string	ls_datacolumn, ls_displaycolumn

ads_jTier	lds_temp

datawindowchild	ldwc_1

long	ll_rowcnt

lds_temp = create ads_jTier
lds_temp.settransobject(sqlca)

// modify header title
for i = 1 to ids_role_cat.rowcount()
	ls_role_cat_no = ids_role_cat.getitemstring(i, 'role_cat_no')
	il_role_cat_no = integer(ls_role_cat_no)
	lb_role_cat_yn[il_role_cat_no] = true
	ls_role_cat_nm = ids_role_cat.getitemstring(i, 'role_cat_nm')
	ls_search_type = ids_role_cat.getitemstring(i, 'search_type')
	ls_code_list_dwo = ids_role_cat.getitemstring(i, 'code_list_dwo')
	ls_code_list_sql = ids_role_cat.getitemstring(i, 'code_list_sql')

	ls_modify += "memb_code" + string(il_role_cat_no) + "_t.text='" + ls_role_cat_nm + "'~r~n"
	if not pf_f_isemptystring(ls_code_list_dwo) then
		ls_modify += "memb_code" + string(il_role_cat_no) + ".tag='dwo:" + ls_code_list_dwo + "'~r~n"
	elseif not pf_f_isemptystring(ls_code_list_sql) then
		ls_modify += "memb_code" + string(il_role_cat_no) + ".tag='sql:" + fw_f_replaceall(ls_code_list_sql, "'", "~~'") + "'~r~n"
	else
		messagebox('Notice', '권한 유형정보가 올바르게 설정되지 않았습니다')
		return -1
	end if

	choose case ls_search_type
		case 'popup'
			ls_modify += "memb_code" + string(il_role_cat_no) + ".tabsequence='0'~r~n"
		case 'dddw'
			if not pf_f_isemptystring(ls_code_list_dwo) then
				lds_temp.dataobject = ls_code_list_dwo
				ls_datacolumn = lds_temp.describe("#1.Name")
				ls_displaycolumn = lds_temp.describe("#2.Name")

				ls_modify += "memb_code" + string(il_role_cat_no) + ".dddw.Name='" + ls_code_list_dwo + "'~r~n"
				ls_modify += "memb_code" + string(il_role_cat_no) + ".dddw.DataColumn='" + ls_datacolumn + "'~r~n"
				ls_modify += "memb_code" + string(il_role_cat_no) + ".dddw.DisplayColumn='" + ls_displaycolumn + "'~r~n"
			elseif not pf_f_isemptystring(ls_code_list_sql) then
				if dw_role_memb.getchild("memb_code" + string(il_role_cat_no), ldwc_1) = 1 then
					ll_rowcnt = SQLCA.sql2ds( this.classname(), ls_code_list_sql, lds_temp, 'xml')
					//ll_rowcnt = lds_temp.of_retrievefromsql(ls_code_list_sql)
					for j = 1 to ll_rowcnt
						ldwc_1.insertrow(j)
						ldwc_1.setitem(j, 1, lds_temp.getitemstring(j, 1))
						ldwc_1.setitem(j, 2, lds_temp.getitemstring(j, 2))
					next
				end if
			end if
	end choose
next

// hide unused columns
for i = 1 to upperbound(lb_role_cat_yn)
	if lb_role_cat_yn[i] = false then
		ls_modify += 'memb_code' + string(i) + '_t.visible="0"~r~n'
		ls_modify += 'memb_code' + string(i) + '.visible="0"~r~n'
	end if
next

// do moidfy
string	ls_error

ls_error = dw_role_memb.Modify (ls_modify)
if len(ls_error) > 0 then
	::clipboard(dw_role_memb.classname() + "~r~n" + ls_modify)
	messagebox("Error", dw_role_memb.classname() + " Syntax Modification Failure!! : " + ls_error)
	return -1
end if

dw_role_memb.event oue_dwowidthchanged()

// remove header of dddw columns
for i = 1 to ids_role_cat.rowcount()
	ls_role_cat_no = ids_role_cat.getitemstring(i, 'role_cat_no')
	il_role_cat_no = integer(ls_role_cat_no)
	ls_search_type = ids_role_cat.getitemstring(i, 'search_type')
	if ls_search_type = 'dddw' then
		fw_f_setdddw(dw_role_memb, "memb_code" + string(il_role_cat_no), {gnv_vari.is_sys_id})
		if dw_role_memb.getchild("memb_code" + string(il_role_cat_no), ldwc_1) = 1 then
			ldwc_1.insertrow(1)
			ldwc_1.setitem(1, 1, '')
			ldwc_1.setitem(1, 2, "All")
			ldwc_1.modify("Datawindow.Header.Height=0")
		end if
	end if
next

return 1
end function

public function integer of_set_popup_dddw_data ();string	ls_search_type, ls_role_cat_no
string	ls_code, ls_name

long		ll_new
integer	i, j, il_role_cat_no

datawindowchild	ldwc_1

dw_role_memb.setredraw(false)

for i = 1 to ids_role_cat.rowcount()
	ls_role_cat_no = ids_role_cat.getitemstring(i, 'role_cat_no')
	il_role_cat_no = integer(ls_role_cat_no)
	ls_search_type = ids_role_cat.getitemstring(i, 'search_type')
	if ls_search_type = 'popup' then
		if dw_role_memb.getchild("memb_code" + string(il_role_cat_no), ldwc_1) = 1 then
			ldwc_1.reset()
			ldwc_1.insertrow(1)
			ldwc_1.setitem(1, 1, '')
			ldwc_1.setitem(1, 2, 'All')
			for j = 1 to dw_role_memb.rowcount()
				ls_code = dw_role_memb.getitemstring(j, 'memb_code' + string(il_role_cat_no))
				ls_name = dw_role_memb.getitemstring(j, 'memb_name' + string(il_role_cat_no))
				if not isnull(ls_code) and ls_code <> '' then
					ll_new = ldwc_1.insertrow(0)
					ldwc_1.setitem(ll_new, 1, ls_code)
					ldwc_1.setitem(ll_new, 2, ls_name)
				end if
			next
		end if
	end if
next

dw_role_memb.setredraw(true)

return 1
end function

public function long of_retrieve_treeview (string as_role_no);long	ll_rowcnt, ll_handle, i, ll_roothndl, ll_pgm = 0, ll_yes = 0, ll_handle4
long	ll_level, ll_parent[]

boolean	lb_pass

treeviewitem	ltvi_item, ltvi_item4

ads_jTier	lds_menu

f_loadingpage (true)

tv_pgm.setredraw(false)

ll_handle = tv_pgm.finditem(roottreeitem!, 0)
do while ll_handle > 0
	tv_pgm.deleteitem(ll_handle)
	ll_handle = tv_pgm.finditem(roottreeitem!, ll_handle)
loop

 If is_pgm_lv2<>'00000'	Then
	ids_menu.dataobject = 'fw_d_role_assign_ds4_ora'
	ids_menu.settransobject(sqlca)
	ll_rowcnt = ids_menu.retrieve(gnv_vari.is_sys_id, is_pgm_lv2, as_role_no, gnv_vari.is_lang_type)
 Else
	ids_menu.dataobject = 'fw_d_role_assign_ds3_ora'
	ids_menu.settransobject(sqlca)
	ll_rowcnt = ids_menu.retrieve(gnv_vari.is_sys_id, 'ROOT', as_role_no, gnv_vari.is_lang_type)
 End If

ll_parent[1] = 0

for i = 1 to ll_rowcnt
	if ids_menu.object.level_no [i]<=2 then lb_pass = false
	if cbx_expand.checked And ids_menu.object.pgm_chk [i]<>'Y' And ids_menu.object.level_no [i]=2 then lb_pass = true
	if lb_pass then continue

	ltvi_item.data = ids_menu.object.pgm_no [i]
	If f_null (ids_menu.object.pgm_id [i]) Then
		ltvi_item.label = ids_menu.object.pgm_nm [i]
	Else
		ltvi_item.label = ids_menu.object.pgm_nm [i] + ' (' + ids_menu.object.pgm_id [i] + ')'
	End If
	Choose Case ids_menu.object.pgm_kind_code [i]
		Case 'M'
			ltvi_item.bold = false
			If ltvi_item.data = '00000' Then
				ltvi_item.PictureIndex = 1
				ltvi_item.SelectedPictureIndex = 2
			Else
				ltvi_item.PictureIndex = 3
				ltvi_item.SelectedPictureIndex = 4
			End If
		Case 'P'
			ll_pgm ++
			IF	ids_menu.object.pgm_chk [i]='Y'	Then
				ll_yes ++
				ltvi_item.bold = false
			Else
				ltvi_item.bold = true
			End IF
			ltvi_item.PictureIndex = 5
			ltvi_item.SelectedPictureIndex = 6
			ltvi_item.label = f_nvl (ids_menu.object.pgm_go [i],'....') + ' ' + ltvi_item.label
	End Choose

	If ids_menu.object.child_cnt [i]>0 then
		ltvi_item.Children = true
	Else
		ltvi_item.Children = false
	End if

	ltvi_item.HasFocus = false
	ltvi_item.selected = false	
	If ids_menu.object.pgm_chk [i]='Y' then
		ltvi_item.statepictureindex = 2
	Else
		ltvi_item.statepictureindex = 1
	End If
	ll_level = ids_menu.object.level_no [i]
	ll_handle = tv_pgm.InsertItemLast(ll_parent[ll_level], ltvi_item)
	IF	ll_level=4	Then
		IF	ll_pgm<>ll_yes And ll_yes>0	Then
			ltvi_item4.PictureIndex = 1
			ltvi_item4.SelectedPictureIndex = 2
			tv_pgm.setitem (ll_handle4, ltvi_item4)
		End IF
		ll_pgm = 0
		ll_yes = 0
		ltvi_item4 = ltvi_item
		ll_handle4 = ll_handle
	End IF
	IF	ids_menu.object.pgm_kind_code [i]='M' THEN ll_parent[ll_level + 1] = ll_handle
Next
IF	ll_pgm<>ll_yes THEN tv_pgm.setitem (ll_parent[4], ltvi_item4)

ll_handle = tv_pgm.finditem(roottreeitem!, 0)
ll_roothndl = ll_handle
do while ll_handle > 0
	if cbx_expand.checked = true then
		tv_pgm.expandall(ll_handle)
	else
		tv_pgm.expanditem(ll_handle)
	End if
	ll_handle = tv_pgm.finditem(NextTreeItem!, ll_handle)
loop

f_loadingpage (false)

// scroll back to top
tv_pgm.SetFirstVisible(ll_roothndl)

tv_pgm.setredraw(true)

return	ll_rowcnt
end function

public function integer of_add_role_pgm (string as_role_no, string as_pgm_no);long	ll_find

ll_find = ids_role_pgm.find('pgm_no_mst="' + as_pgm_no + '"', 1, ids_role_pgm.rowcount())
if ll_find > 0 then
	ids_role_pgm.setitem(ll_find, 'sys_id', gnv_vari.is_sys_id)
	ids_role_pgm.setitem(ll_find, 'role_no', is_role_no)
	ids_role_pgm.setitem(ll_find, 'pgm_no', as_pgm_no)
end if

return ll_find
end function

public function long of_delete_role_pgm (string as_role_no, string as_pgm_no);long	ll_find

ll_find = ids_role_pgm.find("role_no = '" + as_role_no + "' and pgm_no = '"  + as_pgm_no + "'", 1, ids_role_pgm.rowcount())
if ll_find > 0 then
	ids_role_pgm.setitem(ll_find, 'sys_id', '')
	ids_role_pgm.setitem(ll_find, 'role_no', '')
	ids_role_pgm.setitem(ll_find, 'pgm_no', '')
end if

return ll_find
end function

public function integer of_set_role_memb_name (string as_column, long al_row);string	ls_name
ls_name = dw_role_memb.Describe("Evaluate('LookUpDisplay(" + as_column + ")'," + string(al_row) + ")")
dw_role_memb.setitem(al_row, 'memb_name' + mid(as_column, 10), ls_name)
return 1
end function

on fw_w_role_assign.create
int iCurrent
call super::create
this.dw_role_mst=create dw_role_mst
this.cbx_hierachy=create cbx_hierachy
this.cbx_expand=create cbx_expand
this.dw_role_memb=create dw_role_memb
this.uo_title1=create uo_title1
this.st_4=create st_4
this.st_1=create st_1
this.tv_pgm=create tv_pgm
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_role_mst
this.Control[iCurrent+2]=this.cbx_hierachy
this.Control[iCurrent+3]=this.cbx_expand
this.Control[iCurrent+4]=this.dw_role_memb
this.Control[iCurrent+5]=this.uo_title1
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.tv_pgm
end on

on fw_w_role_assign.destroy
call super::destroy
destroy(this.dw_role_mst)
destroy(this.cbx_hierachy)
destroy(this.cbx_expand)
destroy(this.dw_role_memb)
destroy(this.uo_title1)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.tv_pgm)
end on

event wue_delete;LONG	ll_row

STRING	ls_role_no, ls_role_nm, ls_errtext

ll_row = dw_role_mst.getrow()
IF ll_row>0 Then
   ls_role_no = dw_role_mst.getitemstring(ll_row, 'role_no')
   ls_role_nm = f_nvl (dw_role_mst.getitemstring(ll_row, 'role_nm'),'')
   IF ls_role_no='00001'   Then
      messagebox('Notice', '관리자용 권한은 삭제할 수 없습니다')
      RETURN -1
   End IF
   IF dw_role_memb.rowcount ()>0 Then
      messagebox('Notice', '먼저 권한 멤버를 삭제하세요')
      RETURN -1
   End IF
   IF messagebox('Notice', '선택하신 ' + ls_role_nm + '[' + ls_role_no + '] 권한을 삭제하시겠습니까?', Exclamation!, YesNo!, 2)=1   Then
      dw_role_mst.deleterow (ll_row)
      IF dw_role_mst.update () = 1 then
         // 기존 권한프로그램 삭제
         DELETE  fw_role_pgm
         WHERE   sys_id  = :gnv_vari.is_sys_id
           AND   role_no = :ls_role_no;

         commitJ ()
         fw_f_message('U01', '', '')
      Else
         ls_errtext=SQLCA.sqlerrtext()
         rollbackJ ()
         messagebox('Notice', 'Role 정보 삭제 실패!!~r~n' + 'Error Text: ' + ls_errtext)
         RETURN -1
      End IF
   End IF
End IF
RETURN 1
end event

event wue_update;string	ls_errtext
string	ls_org_role_no, ls_role_no, ls_crud_type
long		ll_modified, ll_deleted, i, ll_memb_seq, ll_row, ll_rtn

dw_role_mst.AcceptText()
dw_role_memb.AcceptText()
ids_role_pgm.AcceptText()

ll_row = ids_role_pgm.getnextmodified(0, primary!)
do while ll_row > 0
	If ids_role_pgm.getitemstatus(ll_row, 'role_no', primary!) = Datamodified! then
		ls_org_role_no	= ids_role_pgm.getitemstring(ll_row, 'role_no', primary!, true)
		ls_role_no		= ids_role_pgm.getitemstring(ll_row, 'role_no')

		// insert
		If pf_f_isemptystring(ls_org_role_no) = true and pf_f_isemptystring(ls_role_no) = false then
			ids_role_pgm.setitemstatus(ll_row, 0, primary!, newmodified!)
			// button 초기값.
			ids_role_pgm.setitem(ll_row, 'retrieve_auth_yn', 'Y')
			ids_role_pgm.setitem(ll_row, 'input_auth_yn', 'Y')
			ids_role_pgm.setitem(ll_row, 'delete_auth_yn', 'Y')
			ids_role_pgm.setitem(ll_row, 'update_auth_yn', 'Y')
			ids_role_pgm.setitem(ll_row, 'print_auth_yn', 'Y')
			ids_role_pgm.setitem(ll_row, 'execute_auth_yn', 'Y')
			ids_role_pgm.setitem(ll_row, 'cancel_auth_yn', 'Y')
			ids_role_pgm.setitem(ll_row, 'excel_auth_yn', 'Y')
			ids_role_pgm.setitem(ll_row, 'comm_btn_auth_yn', 'Y')
			ids_role_pgm.setitem(ll_row, 'ext1_auth_yn', 'Y')

		// delete
		elseIf pf_f_isemptystring(ls_org_role_no) = false and pf_f_isemptystring(ls_role_no) = true then
			ids_role_pgm.deleterow(ll_row)
			ll_row = ll_row - 1

		// case else
		else
			ids_role_pgm.setitemstatus(ll_row, 0, primary!, notmodified!)
		End If
	End If
	ll_row = ids_role_pgm.getnextmodified(ll_row, primary!)
loop

If dw_role_mst.update () = -1 then
	ls_errtext = sqlca.sqlerrtext()
	rollbackJ ()
	messagebox('Notice', '권한(dw_role_mst) 저장 실패!!~r~n' + 'Error Text: ' + ls_errtext)
	Return -1
End IF
If dw_role_memb.update () = -1 then
	ls_errtext = sqlca.sqlerrtext()
	rollbackJ ()
	messagebox('Notice', '권한(dw_role_memb) 저장 실패!!~r~n' + 'Error Text: ' + ls_errtext)
	Return -1
End IF
If ids_role_pgm.update () = -1	then
	ls_errtext = sqlca.sqlerrtext()
	rollbackJ ()
	messagebox('Notice', '권한(ids_role_pgm) 저장 실패!!~r~n' + 'Error Text: ' + ls_errtext)
	Return -1
Else
	commitJ ()
	IF sqlca.sqlcode() = 0 THEN
		fw_f_message('U01', '', '')
		ib_chk4update = false
		// 삭제된 ROW 재조회
		ids_role_pgm.retrieve (gnv_vari.is_sys_id, is_role_no)
	ELSE
		ls_errtext = sqlca.sqlerrtext()
		rollbackJ ()
		messagebox('Notice', 'commit 실패!!~r~n' + 'Error Text: ' + ls_errtext)
		Return -1
	END IF
End If
Return 0
end event

event wue_input;IF EVENT wue_update()=-1 THEN RETURN -1

LONG	lRow

STRING	ls_role_no

lRow = dw_role_mst.insertrow (0)

SELECT  NVL(max(role_no),'00000')
  INTO  :ls_role_no
FROM    fw_role_mst t1
WHERE   sys_id = :gnv_vari.is_sys_id;

ls_role_no = SQLCA.getitemstring (1)
ls_role_no = string(long(ls_role_no) + 1, '00000')

dw_role_mst.object.sys_id [lRow] = gnv_vari.is_sys_id
dw_role_mst.object.role_no [lRow] = ls_role_no
dw_role_mst.object.pgm_lv2 [lRow] = '00000'
dw_role_mst.setrow (lRow)
dw_role_mst.scrolltorow (lRow)

RETURN 1
end event

event wue_setdddw;call super::wue_setdddw;fw_f_setdddw(dw_role_mst, 'pgm_lv2', {gnv_vari.is_sys_id})
end event

event wue_lastinst;call super::wue_lastinst;ids_role_cat.retrieve (gnv_vari.is_sys_id)

this.of_set_title_role_memb ()

string	ls_top2pgm
long		ll_ret

If inv_menu.is_parameter1='01'	Then
	dw_role_mst.retrieve (gnv_vari.is_sys_id, '%')
Else
	ls_top2pgm = gnv_rolemenu.of_getlevel4findmenu (inv_menu.is_pgm_no, 2)
	ll_ret = dw_role_mst.retrieve (gnv_vari.is_sys_id, ls_top2pgm)
End If
dw_role_mst.uf_setrow (1, true)
end event

event wue_postopen;call super::wue_postopen;dw_role_mst.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage','p_input','p_delete'}, true)
dw_role_memb.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage','p_input','p_delete'}, true)

ids_menu = create ads_jTier
ids_menu_ds4root = create ads_jTier

ids_role_pgm = create ads_jTier
ids_role_pgm.dataobject = 'fw_d_role_assign_ds1'
ids_role_pgm.settransobject(sqlca)

ids_role_cat = create ads_jTier
ids_role_cat.dataobject = 'fw_d_role_assign_ds2'
ids_role_cat.settransobject(sqlca)

// create popup menu
im_treemenu = create fw_m_pgm_mst
im_treemenu.m_add.visible = false
im_treemenu.m_delete.visible = false
im_treemenu.m_0.visible = false
im_treemenu.m_upper.visible = false
im_treemenu.m_lower.visible = false
im_treemenu.m_1.visible = false
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within fw_w_role_assign
end type

type ln_templeft from w_window1st5ncn`ln_templeft within fw_w_role_assign
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within fw_w_role_assign
end type

type ln_temptop from w_window1st5ncn`ln_temptop within fw_w_role_assign
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within fw_w_role_assign
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within fw_w_role_assign
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within fw_w_role_assign
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within fw_w_role_assign
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within fw_w_role_assign
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within fw_w_role_assign
end type

type ln_tempright from w_window1st5ncn`ln_tempright within fw_w_role_assign
end type

type uo_navi from w_window1st5ncn`uo_navi within fw_w_role_assign
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within fw_w_role_assign
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within fw_w_role_assign
end type

type p_close from w_window1st5ncn`p_close within fw_w_role_assign
end type

type p_excel from w_window1st5ncn`p_excel within fw_w_role_assign
end type

type p_print from w_window1st5ncn`p_print within fw_w_role_assign
end type

type p_delete from w_window1st5ncn`p_delete within fw_w_role_assign
end type

type p_update from w_window1st5ncn`p_update within fw_w_role_assign
end type

type p_input from w_window1st5ncn`p_input within fw_w_role_assign
end type

type p_retrieve from w_window1st5ncn`p_retrieve within fw_w_role_assign
end type

type p_clear from w_window1st5ncn`p_clear within fw_w_role_assign
end type

type dw_role_mst from fw_u_dwo within fw_w_role_assign
integer x = 50
integer y = 156
integer width = 2944
integer height = 1724
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
string title = "권한 리스트"
string dataobject = "fw_d_role_assign_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean setedittoken = true
string is_resize_column = "role_desc"
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then
	is_role_no = ''
	is_role_nm = ''
	return
end if

if NOT enabled           then return
If Event wue_update()=-1 THEN RETURN 1

is_role_no	= this.getitemstring(currentrow, 'role_no')
is_role_nm	= this.getitemstring(currentrow, 'role_nm')
is_pgm_lv2	= this.getitemstring(currentrow, 'pgm_lv2')

dw_role_memb.retrieve(gnv_vari.is_sys_id, is_role_no)
Parent.of_set_popup_dddw_data()

ids_role_pgm.retrieve(gnv_vari.is_sys_id, is_role_no)
Parent.of_retrieve_treeview(is_role_no)
end event

event retrieveend;call super::retrieveend;enabled = true
end event

type cbx_hierachy from pf_u_checkbox within fw_w_role_assign
integer x = 4832
integer y = 168
integer width = 594
integer height = 72
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 8421504
string text = "하위항목 일괄선택"
boolean checked = true
boolean setbringtotop = true
boolean setsheetcolor = true
boolean fixedtoright = true
end type

type cbx_expand from pf_u_checkbox within fw_w_role_assign
integer x = 4411
integer y = 168
integer width = 384
integer height = 72
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 8421504
string text = "열린 메뉴"
boolean setbringtotop = true
boolean setsheetcolor = true
boolean fixedtoright = true
end type

event clicked;call super::clicked;Parent.Post of_retrieve_treeview(is_role_no)
end event

type dw_role_memb from fw_u_dwo within fw_w_role_assign
integer x = 50
integer y = 1904
integer width = 2944
integer height = 860
integer taborder = 20
boolean bringtotop = true
string title = "권한 멤버"
string dataobject = "fw_d_role_assign_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean fixedtobottom = true
boolean scaletoright = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0011011001"
end type

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0, false)
this.selectrow(currentrow, true)
end event

event clicked;call super::clicked;if row = 0                      then return
if string(dwo.type) <> 'column' then return

long		ll_row, ll_new
string	ls_column, ls_column_tag, ls_role_no
string	ls_rtn, ls_rtn_arr[]

datawindowchild	ldwc_1

ls_column = string(dwo.name)
if left(ls_column,9) = 'memb_code' and long(dwo.tabsequence) = 0 then
	if is_role_no = '' then return
	ls_column_tag = string(dwo.tag)
	openwithparm(fw_w_role_assign_pop, ls_column_tag)
	ls_rtn = message.stringparm
	if isnull(ls_rtn) or len(trim(ls_rtn)) = 0 then return
	fw_f_obj2array(ls_rtn, '~t', ls_rtn_arr)
	if ls_rtn_arr[1] = 'OK' then
		this.getchild(ls_column, ldwc_1)
		ll_new = ldwc_1.insertrow(0)
		ldwc_1.setitem(ll_new, 'code', ls_rtn_arr[3])
		ldwc_1.setitem(ll_new, 'name', ls_rtn_arr[4])
		this.setitem(row, ls_column, ls_rtn_arr[3])
		this.setitem(row, 'memb_name' + mid(ls_column, 10), ls_rtn_arr[4])		
	end if
end if

return 0
end event

event itemchanged;call super::itemchanged;if row = 0                      then return 0
if string(dwo.type) <> 'column' then return 0

long		ll_row, ll_new
string	ls_column, ls_name

ls_column = string(dwo.name)
if left(ls_column,9) = 'memb_code' and long(dwo.tabsequence) > 0 then
	if is_role_no = '' then return 0
	if isnull(data) or data = '' then
		this.setitem(row, 'memb_name' + mid(ls_column, 10), '')
	else
		post of_set_role_memb_name(ls_column, row)
	end if
end if

return 0
end event

event oue_subbtn_input;call super::oue_subbtn_input;long		ll_row, ll_new
string	ls_code_list_dwo, ls_role_no
string	ls_rtn, ls_rtn_arr[]
string	ls_memb_seq

ll_row = dw_role_mst.getrow()
if ll_row < 1 then return

ls_role_no = dw_role_mst.getitemstring(ll_row, 'role_no')
ls_memb_seq = dw_role_memb.describe("evaluate('max (memb_seq for all)',0)")
if ls_memb_seq = '!' then return

ll_new = dw_role_memb.insertrow(0)
dw_role_memb.ScrolltoRow(ll_new)
dw_role_memb.setitem(ll_new, 'sys_id', gnv_vari.is_sys_id)
dw_role_memb.setitem(ll_new, 'role_no', ls_role_no)
dw_role_memb.setitem(ll_new, 'memb_seq', long(ls_memb_seq) + 1)
dw_role_memb.setitem(ll_new, 'valid_dt_yn', 'N')
end event

event oue_subbtn_delete;call super::oue_subbtn_delete;long		ll_row, ll_find
string	ls_memb_code, ls_memb_name, ls_errtext

ll_row = dw_role_memb.object.memb_seq[dw_role_memb.getrow()]
if ll_row > 0 then
	if messagebox('Notice', '선택하신 ' + string(ll_row) + ' 멤버를 삭제하시겠습니까?', Exclamation!, YesNo!, 2) = 1 then
		ll_find = dw_role_memb.Find("memb_seq=" + string(ll_row) + "", 1, dw_role_memb.rowcount())
		dw_role_memb.deleterow(ll_find)
	end if
end if
end event

type uo_title1 from fw_u_dw2title within fw_w_role_assign
integer x = 3026
integer y = 160
integer taborder = 100
boolean bringtotop = true
boolean fixedtoright = true
string istitletext = "프로그램 권한"
end type

on uo_title1.destroy
call fw_u_dw2title::destroy
end on

type st_4 from pf_u_splitbar_vertical within fw_w_role_assign
integer x = 2999
integer y = 256
integer width = 23
integer height = 2504
boolean bringtotop = true
boolean setcondcolor = true
string leftdragobject = "dw_role_mst;dw_role_memb"
string rightdragobject = "tv_pgm;uo_title1"
end type

type st_1 from pf_u_splitbar_horizontal within fw_w_role_assign
integer x = 50
integer y = 1884
integer width = 2949
boolean bringtotop = true
boolean setcondcolor = true
boolean fixedtobottom = true
string topdragobject = "dw_role_mst"
string bottomdragobject = "dw_role_memb;"
end type

type tv_pgm from pf_u_treeview within fw_w_role_assign
event ue_checkoutcbx ( long al_clicked,  long al_state )
event ue_checked ( long al_handle )
event ue_unchecked ( long al_handle )
integer x = 3026
integer y = 256
integer width = 2405
integer height = 2508
integer taborder = 20
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 20132659
boolean hideselection = false
boolean checkboxes = true
string picturename[] = {"..\img\mainframe\u_treemenu\lvl1close.gif","..\img\mainframe\u_treemenu\lvl1open.gif","..\img\mainframe\u_treemenu\lvl3close.gif","..\img\mainframe\u_treemenu\lvl3open.gif","..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif"}
long picturemaskcolor = 12632256
boolean scaletoright = true
boolean scaletobottom = true
end type

event ue_checkoutcbx(long al_clicked, long al_state);treeviewitem	ltvi_item

this.getitem(al_clicked, ltvi_item)
if al_state = 1 and ltvi_item.statepictureindex = 2 then
	this.event ue_checked(al_clicked)
elseif al_state = 2 and ltvi_item.statepictureindex = 1 then
	this.event ue_unchecked(al_clicked)
end if
ib_chk4update = true
end event

event ue_checked(long al_handle);treeviewitem	ltvi_parent, ltvi_child

long	ll_nextitem, ll_previtem, i

if this.getitem(al_handle, ltvi_parent) < 0 then return

// 하위 노드 선택
if cbx_hierachy.checked = true then
	ll_nextitem = this.finditem(nextvisibletreeitem!, al_handle)
	do while ll_nextitem > 0
		this.getitem(ll_nextitem, ltvi_child)
		if ltvi_child.level <= ltvi_parent.level then exit
		if ltvi_child.statepictureindex = 1 then
			ltvi_child.statepictureindex = 2
			this.setitem(ll_nextitem, ltvi_child)
			this.selectitem(ll_nextitem)
			of_add_role_pgm(is_role_no, string(ltvi_child.data))
		end if
		ll_nextitem = this.finditem(nextvisibletreeitem!, ll_nextitem)
	loop
end if

// 상위 노드 선택
ll_previtem = this.finditem(ParentTreeItem!, al_handle)
do while ll_previtem > 0
	this.getitem(ll_previtem, ltvi_child)
	if ltvi_child.level < 1 then exit
	if ltvi_child.statepictureindex = 1 then
		ltvi_child.statepictureindex = 2
		this.setitem(ll_previtem, ltvi_child)
		this.selectitem(ll_previtem)
		of_add_role_pgm(is_role_no, string(ltvi_child.data))
	end if
	ll_previtem = this.finditem(ParentTreeItem!, ll_previtem)
loop

this.selectitem(al_handle)
of_add_role_pgm(is_role_no, string(ltvi_parent.data))

ib_chk4update = true
end event

event ue_unchecked(long al_handle);treeviewitem	ltvi_parent, ltvi_child

long	ll_nextitem, i

if this.getitem(al_handle, ltvi_parent) < 0 then return

if cbx_hierachy.checked = true then
	ll_nextitem = this.finditem(nextvisibletreeitem!, al_handle)
	do while ll_nextitem > 0
		this.getitem(ll_nextitem, ltvi_child)
		if ltvi_child.level <= ltvi_parent.level then exit
		if ltvi_child.statepictureindex = 2 then
			ltvi_child.statepictureindex = 1
			this.setitem(ll_nextitem, ltvi_child)
			this.selectitem(ll_nextitem)
			of_delete_role_pgm(is_role_no, string(ltvi_child.data))
		end if
		ll_nextitem = this.finditem(nextvisibletreeitem!, ll_nextitem)
	loop
end if

this.selectitem(al_handle)

of_delete_role_pgm(is_role_no, string(ltvi_parent.data))
end event

event clicked;call super::clicked;treeviewitem	ltvi_item
this.getitem(handle, ltvi_item)
this.post event ue_checkoutcbx(handle, ltvi_item.statepictureindex)
end event

event key;call super::key;treeviewitem	ltvi_item

choose case key
	case keyspacebar!
		if this.getitem(il_handle, ltvi_item) > 0 then this.post event ue_checkoutcbx(il_handle, ltvi_item.statepictureindex)
end choose
return 0
end event

event selectionchanged;call super::selectionchanged;il_handle = newhandle
end event

event rightclicked;call super::rightclicked;treeviewitem	ltvi_item

if this.selectitem(handle) = -1         then return
if this.getitem(handle, ltvi_item) = -1 then return
choose case ltvi_item.PictureIndex
	case 3, 4
		im_treemenu.popmenu(iw_parent.pointerx(), iw_parent.pointery())
end choose
end event

