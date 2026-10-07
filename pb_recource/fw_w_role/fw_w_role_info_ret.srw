forward
global type fw_w_role_info_ret from w_window1st5ncn
end type
type tab_1 from tab within fw_w_role_info_ret
end type
type tabpage_1 from userobject within tab_1
end type
type cb_2 from pf_u_commandbutton within tabpage_1
end type
type cb_1 from pf_u_commandbutton within tabpage_1
end type
type dw_role_list from fw_u_dwo within tabpage_1
end type
type tv_menu from pf_u_treeview within tabpage_1
end type
type dw_user_list from fw_u_dwo within tabpage_1
end type
type p_search from pf_u_imagebutton within tabpage_1
end type
type dw_user_list_cond from fw_u_dwo within tabpage_1
end type
type uo_title1 from fw_u_dw2title within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_2 cb_2
cb_1 cb_1
dw_role_list dw_role_list
tv_menu tv_menu
dw_user_list dw_user_list
p_search p_search
dw_user_list_cond dw_user_list_cond
uo_title1 uo_title1
end type
type tabpage_2 from userobject within tab_1
end type
type uo_title2 from fw_u_dw2title within tabpage_2
end type
type dw_pgm_user from fw_u_dwo within tabpage_2
end type
type dw_pgm_role from fw_u_dwo within tabpage_2
end type
type tv_fullmenu from pf_u_treeview within tabpage_2
end type
type tabpage_2 from userobject within tab_1
uo_title2 uo_title2
dw_pgm_user dw_pgm_user
dw_pgm_role dw_pgm_role
tv_fullmenu tv_fullmenu
end type
type tab_1 from tab within fw_w_role_info_ret
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type uo_1 from pf_u_tab within fw_w_role_info_ret
end type
end forward

global type fw_w_role_info_ret from w_window1st5ncn
string title = "Role 조회"
tab_1 tab_1
uo_1 uo_1
end type
global fw_w_role_info_ret fw_w_role_info_ret

type variables
fw_u_dwo	idw_user_list_cond
fw_u_dwo idw_user_list
fw_u_dwo idw_role_list
treeview itv_menu

treeview itv_fullmenu
fw_u_dwo idw_pgm_role
fw_u_dwo idw_pgm_user

n_authority		inv_authority
ads_jTier		ids_menu
ads_jTier		ids_fullmenu
ads_jTier		ids_role_cat

end variables

forward prototypes
public function integer of_set_user_menu ()
public function integer of_set_pgm_fullmenu ()
public subroutine of_clearusermenu ()
public function integer of_set_title_role_memb ()
end prototypes

public function integer of_set_user_menu ();ads_jTier lds_menu
long ll_rowcnt, ll_handle, ll_roothndl
integer i
treeviewitem ltvi_item
long ll_level, ll_parent[]

itv_menu.setredraw(false)
itv_menu.post setredraw(true)

ll_handle = itv_menu.finditem(roottreeitem!, 0)
do while ll_handle > 0
	itv_menu.deleteitem(ll_handle)
	ll_handle = itv_menu.finditem(roottreeitem!, ll_handle)
loop

String	ls_memb_code1, ls_memb_code2, ls_memb_code3, ls_memb_code4, ls_memb_code5, ls_memb_code6, ls_memb_code7, ls_memb_code8
ls_memb_code1 = fw_f_nvls(inv_authority.is_inq_memb_code[1], '')
ls_memb_code2 = fw_f_nvls(inv_authority.is_inq_memb_code[2], '')
ls_memb_code3 = fw_f_nvls(inv_authority.is_inq_memb_code[3], '')
ls_memb_code4 = fw_f_nvls(inv_authority.is_inq_memb_code[4], '')
ls_memb_code5 = fw_f_nvls(inv_authority.is_inq_memb_code[5], '')
ls_memb_code6 = fw_f_nvls(inv_authority.is_inq_memb_code[6], '')
ls_memb_code7 = fw_f_nvls(inv_authority.is_inq_memb_code[7], '')
ls_memb_code8 = fw_f_nvls(inv_authority.is_inq_memb_code[8], '')

ll_rowcnt = ids_menu.retrieve(gnv_vari.is_sys_id, 'ROOT', gnv_vari.is_lang_type, gnv_vari.is_login_dt, ls_memb_code1, ls_memb_code2, ls_memb_code3, ls_memb_code4, ls_memb_code5, ls_memb_code6, ls_memb_code7, ls_memb_code8)

// 할당된 프로그램이 없으면 리턴
if ll_rowcnt < 1 then return 0

ll_parent[1] = 0

for i = 1 to ll_rowcnt
	ltvi_item.data = ids_menu.getitemstring(i, 'pgm_no')
	ltvi_item.label = ids_menu.getitemstring(i, 'pgm_nm')
	
	choose case ids_menu.getitemstring(i, 'pgm_kind_code')
		case 'M'
			ltvi_item.PictureIndex = 3
			ltvi_item.SelectedPictureIndex = 4
			ltvi_item.Children = true
		case 'P'
			ltvi_item.PictureIndex = 1
			ltvi_item.SelectedPictureIndex = 2
			ltvi_item.Children = false
	end choose
	
//	if ids_menu.getitemnumber(i, 'child_cnt') > 0 then
//		ltvi_item.Children = true
//	else
//		ltvi_item.Children = false
//	end if
	
	ltvi_item.HasFocus = false
	ltvi_item.selected = false
	
//	if ids_menu.getitemstring(i, 'pgm_chk') = 'Y' then
//		ltvi_item.statepictureindex = 2
//	else
//		ltvi_item.statepictureindex = 1
//	end if
	
	ll_level = ids_menu.getitemnumber(i, 'level_no')
	ll_handle = itv_menu.InsertItemLast(ll_parent[ll_level], ltvi_item)
	if ids_menu.getitemstring(i, 'pgm_kind_code') = 'M' then
		ll_parent[ll_level + 1] = ll_handle
	end if
next

// expand treeview items
ll_handle = itv_menu.finditem(roottreeitem!, 0)
if ll_handle > 0 then
	// expand the root treeviewitem
	itv_menu.expandall(ll_handle)

	// scroll back to top
	itv_menu.SetFirstVisible(ll_handle)

	// select first treeviewitem
	itv_menu.post selectitem(ll_handle)
end if
//itv_menu.post selectitem(ll_parent[2])
return ll_rowcnt

end function

public function integer of_set_pgm_fullmenu ();ads_jTier lds_menu
long ll_rowcnt, ll_handle, ll_roothndl
integer i
treeviewitem ltvi_item
long ll_level, ll_parent[]

itv_fullmenu.setredraw(false)
itv_fullmenu.post setredraw(true)

ll_handle = itv_fullmenu.finditem(roottreeitem!, 0)
do while ll_handle > 0
	itv_fullmenu.deleteitem(ll_handle)
	ll_handle = itv_fullmenu.finditem(roottreeitem!, ll_handle)
loop

ll_rowcnt = ids_fullmenu.retrieve(gnv_vari.is_sys_id, 'ROOT', gnv_vari.is_lang_type)

// 할당된 프로그램 없으면 리턴
if ll_rowcnt = 0 then
	return 0
end if

ll_parent[1] = 0
for i = 1 to ll_rowcnt
	ltvi_item.data = ids_fullmenu.getitemstring(i, 'pgm_no')
	ltvi_item.label = ids_fullmenu.getitemstring(i, 'pgm_nm')
	
	choose case ids_fullmenu.getitemstring(i, 'pgm_kind_code')
		case 'M'
			ltvi_item.PictureIndex = 3
			ltvi_item.SelectedPictureIndex = 4
		case 'P'
			ltvi_item.PictureIndex = 1
			ltvi_item.SelectedPictureIndex = 2
	end choose
	
	if ids_fullmenu.getitemnumber(i, 'child_cnt') > 0 then
		ltvi_item.children = true
	else
		ltvi_item.children = false
	end if
	
	ltvi_item.hasfocus = false
	ltvi_item.selected = false
	
	ll_level = ids_fullmenu.getitemnumber(i, 'level_no')
	ll_handle = itv_fullmenu.InsertItemLast(ll_parent[ll_level], ltvi_item)
	if ids_fullmenu.getitemstring(i, 'pgm_kind_code') = 'M' then
		ll_parent[ll_level + 1] = ll_handle
	end if
next
//itv_menu.ExpandAll(ll_parent[2])

// expand treeview items
ll_handle = itv_fullmenu.finditem(roottreeitem!, 0)
if ll_handle > 0 then
	// expand the root treeviewitem
	itv_fullmenu.expandall(ll_handle)

	// scroll back to top
	itv_fullmenu.SetFirstVisible(ll_handle)

	// select first treeviewitem
	itv_fullmenu.post selectitem(ll_handle)

	//ll_roothndl = ll_handle
	//do while ll_handle > 0
	//	if tab_1.tabpage_2.cbx_expand2.checked = true then
	//		itv_fullmenu.expandall(ll_handle)
	//	else
	//		itv_fullmenu.expanditem(ll_handle)
	//	end if
	//	ll_handle = itv_fullmenu.finditem(NextTreeItem!, ll_handle)
	//loop
end if

return ll_rowcnt

end function

public subroutine of_clearusermenu ();long ll_handle

ll_handle = itv_menu.finditem(roottreeitem!, 0)
do while ll_handle > 0
	itv_menu.deleteitem(ll_handle)
	ll_handle = itv_menu.finditem(roottreeitem!, ll_handle)
loop
end subroutine

public function integer of_set_title_role_memb ();integer i, li_role_cat_no
boolean lb_role_cat_yn[8]
string ls_modify, ls_search_type
string ls_role_cat_no, ls_role_cat_nm
string ls_code_list_dwo

string ls_datacolumn, ls_displaycolumn
ads_jTier lds_temp
pf_n_syntaxbuffer lnv_syntax

lnv_syntax = create pf_n_syntaxbuffer
lds_temp = create ads_jTier

// modify header title
for i = 1 to ids_role_cat.rowcount()
	ls_role_cat_no = ids_role_cat.getitemstring(i, 'role_cat_no')
	li_role_cat_no = integer(ls_role_cat_no)
	lb_role_cat_yn[li_role_cat_no] = true
	ls_role_cat_nm = ids_role_cat.getitemstring(i, 'role_cat_nm')
	ls_search_type = ids_role_cat.getitemstring(i, 'search_type')
	ls_code_list_dwo = ids_role_cat.getitemstring(i, 'code_list_dwo')
	
	lnv_syntax.of_append("memb_code" + string(li_role_cat_no) + ".visible=0")
	lnv_syntax.of_append("memb_name" + string(li_role_cat_no) + "_t.text='" + ls_role_cat_nm + "'")
	lnv_syntax.of_append("memb_name" + string(li_role_cat_no) + ".tag='" + ls_code_list_dwo + "'")
next

// hide unused columns
for i = 1 to upperbound(lb_role_cat_yn)
	if lb_role_cat_yn[i] = false then
		lnv_syntax.of_append("memb_code" + string(i) + "_t.visible=0")
		lnv_syntax.of_append("memb_code" + string(i) + ".visible=0")
		lnv_syntax.of_append("memb_name" + string(i) + "_t.visible=0")
		lnv_syntax.of_append("memb_name" + string(i) + ".visible=0")
	end if
next

// do moidfy
string ls_error

ls_error = idw_pgm_user.Modify(lnv_syntax.of_toString())
if len(ls_error) > 0 then
	::clipboard(lnv_syntax.of_toString())
	messagebox("Error", idw_pgm_user.classname() + " Syntax Modification Failure!! : " + ls_error)
	return -1
end if

//idw_pgm_user.event ue_dwowidthchanged()
return 1

end function

on fw_w_role_info_ret.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.uo_1
end on

on fw_w_role_info_ret.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.uo_1)
end on

event open;call super::open;inv_authority = Create n_authority

idw_user_list_cond	= tab_1.tabpage_1.dw_user_list_cond
idw_user_list		= tab_1.tabpage_1.dw_user_list
idw_role_list		= tab_1.tabpage_1.dw_role_list
idw_pgm_role		= tab_1.tabpage_2.dw_pgm_role
idw_pgm_user		= tab_1.tabpage_2.dw_pgm_user

itv_menu		= tab_1.tabpage_1.tv_menu
itv_fullmenu		= tab_1.tabpage_2.tv_fullmenu

idw_user_list.settransobject(sqlca)
idw_role_list.settransobject(sqlca)

idw_pgm_role.settransobject(sqlca)
idw_pgm_user.settransobject(sqlca)

//choose case upper(left(sqlca.dbms, 3))
//	// Oracle
//	case 'O80', 'O90', 'O10', 'ORA'
//	// Else
//	case else
//		ids_menu.dataobject = 'fw_d_role_s_07_asa'
//end choose
ids_menu = create ads_jTier
ids_menu.dataobject = 'fw_d_role_s_07_ds1_ora'
ids_menu.settransobject(sqlca)

ids_fullmenu = create ads_jTier
ids_fullmenu.dataobject = 'fw_d_btn_role_assign_ds1_ora'
ids_fullmenu.settransobject(sqlca)

ids_role_cat = create ads_jTier
ids_role_cat.dataobject = 'fw_d_role_assign_ds2'
ids_role_cat.settransobject(sqlca)

end event

event wue_postopen;call super::wue_postopen;ids_role_cat.retrieve(gnv_vari.is_sys_id)
this.of_set_title_role_memb()

idw_user_list_cond.insertrow(0)
of_set_pgm_fullmenu()
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within fw_w_role_info_ret
end type

type ln_templeft from w_window1st5ncn`ln_templeft within fw_w_role_info_ret
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within fw_w_role_info_ret
end type

type ln_temptop from w_window1st5ncn`ln_temptop within fw_w_role_info_ret
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within fw_w_role_info_ret
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within fw_w_role_info_ret
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within fw_w_role_info_ret
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within fw_w_role_info_ret
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within fw_w_role_info_ret
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within fw_w_role_info_ret
end type

type ln_tempright from w_window1st5ncn`ln_tempright within fw_w_role_info_ret
end type

type uo_navi from w_window1st5ncn`uo_navi within fw_w_role_info_ret
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within fw_w_role_info_ret
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within fw_w_role_info_ret
end type

type p_close from w_window1st5ncn`p_close within fw_w_role_info_ret
end type

type p_excel from w_window1st5ncn`p_excel within fw_w_role_info_ret
end type

type p_print from w_window1st5ncn`p_print within fw_w_role_info_ret
end type

type p_delete from w_window1st5ncn`p_delete within fw_w_role_info_ret
end type

type p_update from w_window1st5ncn`p_update within fw_w_role_info_ret
end type

type p_input from w_window1st5ncn`p_input within fw_w_role_info_ret
end type

type p_retrieve from w_window1st5ncn`p_retrieve within fw_w_role_info_ret
end type

type p_clear from w_window1st5ncn`p_clear within fw_w_role_info_ret
end type

type tab_1 from tab within fw_w_role_info_ret
integer x = 50
integer y = 140
integer width = 5381
integer height = 2624
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 5344
integer height = 2492
long backcolor = 33225466
string text = "사용자별 권한조회"
long tabtextcolor = 25123896
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
cb_2 cb_2
cb_1 cb_1
dw_role_list dw_role_list
tv_menu tv_menu
dw_user_list dw_user_list
p_search p_search
dw_user_list_cond dw_user_list_cond
uo_title1 uo_title1
end type

on tabpage_1.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_role_list=create dw_role_list
this.tv_menu=create tv_menu
this.dw_user_list=create dw_user_list
this.p_search=create p_search
this.dw_user_list_cond=create dw_user_list_cond
this.uo_title1=create uo_title1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_role_list,&
this.tv_menu,&
this.dw_user_list,&
this.p_search,&
this.dw_user_list_cond,&
this.uo_title1}
end on

on tabpage_1.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_role_list)
destroy(this.tv_menu)
destroy(this.dw_user_list)
destroy(this.p_search)
destroy(this.dw_user_list_cond)
destroy(this.uo_title1)
end on

type cb_2 from pf_u_commandbutton within tabpage_1
integer x = 4800
integer y = 60
integer width = 512
integer height = 100
integer taborder = 30
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "Indi/Author/Del"
boolean fixedtoright = true
end type

event clicked;call super::clicked;// 사용자에게 할당된 권한 제거
// 개인별로 할당된 권한만 제거 가능합니다.

string ls_user_id, ls_user_nm
string ls_role_no, ls_role_nm
long ll_userrow, ll_rolerow, ll_membcnt

// 권한 삭제할 사용자 확인
ll_userrow = idw_user_list.getrow()
if ll_userrow = 0 then
	messagebox('Notice', '먼저 권한을 삭제할 사용자를 조회/선택하세요')
	return
end if

ls_user_id = idw_user_list.getitemstring(ll_userrow, 'user_id')
ls_user_nm = idw_user_list.getitemstring(ll_userrow, 'user_nm')

// 삭제할 권한 확인
ll_rolerow = idw_role_list.getrow()
if ll_rolerow = 0 then
	messagebox('Notice', '삭제할 권한을 선택하세요')
	return
end if

ls_role_no = idw_role_list.getitemstring(ll_rolerow, 'role_no')
ls_role_nm = idw_role_list.getitemstring(ll_rolerow, 'role_nm')

// 개인별로 할당된 권한인지 확인
select	count(1)
  into :ll_membcnt
from		fw_role_memb
where	sys_id = :gnv_vari.is_sys_id
and		role_no = :ls_role_no
and		memb_code1 = :ls_user_id;
ll_membcnt = SQLCA.getitemnumber (1)
if ll_membcnt = 0 then
	messagebox('Notice', '개인별로 할당된 권한에 대해서만 삭제 가능 합니다.~r~n그룹별(예:부서별, 직급별)로 할당된 권한은 특정 개인만 삭제할 수 없습니다.')
	return
end if

// 삭제 여부를 확인
if messagebox('Notice', ls_user_nm + ' 사용자에게 할당된 ~'' + ls_role_nm + '[' + ls_role_no + ']~' 권한을 삭제 하시겠습니까?', Question!, YesNo!, 2) = 2 then return

// 할당된 권한 삭제
string ls_errtext

delete		fw_role_memb
where	sys_id = :gnv_vari.is_sys_id
and		role_no = :ls_role_no
and		memb_code1 = :ls_user_id;

if sqlca.sqlcode() = -1 then
	ls_errtext = sqlca.sqlerrtext()
	rollbackj()
	messagebox('Notice', '사용자에게 할당된 권한을 삭제하는 중 아래와 같은 오류가 발생되었습니다.~r~n' + ls_errtext)
	return
end if

commitJ ()
messagebox('Notice', '사용자에게 할당된 권할을 삭제했습니다.~r~n트리 메뉴 데이터를 재조회 합니다.')

// 트리 메뉴 및 권한 데이터 재 조회 
idw_user_list.post event rowfocuschanged(ll_userrow)

end event

type cb_1 from pf_u_commandbutton within tabpage_1
integer x = 4256
integer y = 60
integer width = 530
integer height = 100
integer taborder = 20
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "Indi/Author/Add"
boolean fixedtoright = true
end type

event clicked;call super::clicked;string ls_user_id, ls_user_nm
long ll_userrow

ll_userrow = idw_user_list.getrow()
if ll_userrow = 0 then
	messagebox('Notice', '먼저 권한을 할당할 사용자를 조회/선택하세요')
	return
end if

ls_user_id = idw_user_list.getitemstring(ll_userrow, 'user_id')
ls_user_nm = idw_user_list.getitemstring(ll_userrow, 'user_nm')

open(pf_w_select_rolemst)
if len(message.stringparm) = 0 then return

string ls_retval[]
string ls_role_no, ls_role_nm
long ll_membcnt

fw_f_obj2array(message.stringparm, '~t', ls_retval[])

ls_role_no = ls_retval[1]
ls_role_nm = ls_retval[2]

// 이미 등록된 권한인지 확인
select	count(1)
into		:ll_membcnt
from	fw_role_memb
where	sys_id = :gnv_vari.is_sys_id
and		role_no = :ls_role_no
and		memb_code1 = :ls_user_id;
ll_membcnt = SQLCA.getitemnumber (1)
if ll_membcnt > 0 then
	messagebox('Notice', '(중복 등록)이미 사용자에게 할당된 권한입니다.')
	return
end if

// 등록 여부를 확인
if messagebox('Notice', '~'' + ls_role_nm + '[' + ls_role_no + ']~' 권한을 ' + ls_user_nm + ' 사용자에게 할당 하시겠습니까?', Question!, YesNo!, 2) = 2 then return

// 권한 등록
string	ls_now, ls_errtext
long	ll_membseq

Select	max(memb_seq) into :ll_membseq
 from	fw_role_memb
where	sys_id		= :gnv_vari.is_sys_id
   and	role_no	= :ls_role_no;

ll_membseq = SQLCA.getitemnumber (1)

if isnull(ll_membseq) then ll_membseq = 0
ll_membseq ++
ls_now = fw_f_getymdhh24miss4s()

insert into fw_role_memb
( sys_id, role_no, memb_seq, memb_code1, memb_name1, valid_dt_yn, reg_dt, reg_id )
values ( :gnv_vari.is_sys_id, :ls_role_no, :ll_membseq, :ls_user_id, :ls_user_nm, 'N', :ls_now, :gnv_vari.is_user_id);

if sqlca.sqlcode() = -1 then
	ls_errtext = sqlca.sqlerrtext()
	rollbackj()
	messagebox('Notice', '사용자에게 권한을 할당하는 중 아래와 같은 오류가 발생되었습니다.~r~n' + ls_errtext)
	return
end if

commitJ ()
messagebox('Notice', '사용자에게 권한을 추가했습니다.~r~n트리 메뉴 데이터를 재조회 합니다.')

// 트리 메뉴 및 권한 데이터 재 조회 
idw_user_list.post event rowfocuschanged(ll_userrow)

end event

type dw_role_list from fw_u_dwo within tabpage_1
integer x = 3314
integer y = 88
integer width = 1998
integer height = 2388
integer taborder = 20
string title = "사용 권한"
string dataobject = "fw_d_role_search_03"
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

type tv_menu from pf_u_treeview within tabpage_1
integer x = 1486
integer y = 176
integer width = 1801
integer height = 2304
integer taborder = 30
fontcharset fontcharset = hangeul!
long textcolor = 20132659
string picturename[] = {"Application5!","ApplicationIcon!","Custom039!","Open!"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

type dw_user_list from fw_u_dwo within tabpage_1
integer x = 14
integer y = 352
integer width = 1445
integer height = 2128
integer taborder = 20
string dataobject = "fw_d_role_search_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

string ls_user_id

ls_user_id = this.getitemstring(currentrow, 'user_id')

if inv_authority.of_SetUserInfo(ls_user_id) < 1 then return
if inv_authority.of_SetAllUserRole(ls_user_id) < 1 then
	of_clearusermenu()
	dw_role_list.reset()
	messagebox('Notice', '해당 시스템을 사용할 수 있는 권한이 없습니다')
	return
end if

dw_role_list.reset()
dw_role_list.retrieve(gnv_vari.is_sys_id, gnv_vari.is_login_dt, &
			inv_authority.is_inq_memb_code[1], inv_authority.is_inq_memb_code[2], inv_authority.is_inq_memb_code[3], inv_authority.is_inq_memb_code[4], &
			inv_authority.is_inq_memb_code[5], inv_authority.is_inq_memb_code[6], inv_authority.is_inq_memb_code[7], inv_authority.is_inq_memb_code[8])

Post of_set_user_menu()
Yield ( )
end event

type p_search from pf_u_imagebutton within tabpage_1
integer x = 1230
integer y = 72
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_find.jpg"
end type

event clicked;call super::clicked;if dw_user_list_cond.accepttext() = -1 then return

string ls_code, ls_name

ls_code = dw_user_list_cond.getitemstring(1, 'code')
ls_name = dw_user_list_cond.getitemstring(1, 'name')

if isnull(ls_code) or len(trim(ls_code)) = 0 then
	ls_code = '%'
else
	ls_code = '%' + ls_code + '%'
end if

if isnull(ls_name) or len(trim(ls_name)) = 0 then
	ls_name = '%'
else
	ls_name = '%' + ls_name + '%'
end if

//if ls_code = '%' and ls_name = '%' then
//	messagebox('Notice', '사용자ID 또는 사용자명을 입력하세요')
//	return
//end if
Long		ll_ret
ll_ret = dw_user_list.retrieve(gnv_vari.is_sys_id, ls_code, ls_name)

If ll_ret > 0 Then dw_user_list.Event RowFocusChanged(1)
return

end event

type dw_user_list_cond from fw_u_dwo within tabpage_1
integer x = 14
integer y = 176
integer width = 1445
integer height = 164
integer taborder = 20
string dataobject = "fw_d_role_search_01"
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
end type

event itemchanged;call super::itemchanged;choose case dwo.name
	case 'code', 'name'
		p_search.post event clicked()
end choose

return 0

end event

event itemfocuschanged;call super::itemfocuschanged;Choose Case dwo.name
	Case 'name'
		pf_f_togglekoreng('k')
	Case Else 
		pf_f_togglekoreng('e')
End Choose
end event

type uo_title1 from fw_u_dw2title within tabpage_1
integer x = 1481
integer y = 88
integer taborder = 20
boolean bringtotop = true
string istitletext = "사용 프로그램"
end type

on uo_title1.destroy
call fw_u_dw2title::destroy
end on

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 5344
integer height = 2492
long backcolor = 33225466
string text = "프로그램별 권한조회"
long tabtextcolor = 25123896
long tabbackcolor = 1073741824
long picturemaskcolor = 536870912
uo_title2 uo_title2
dw_pgm_user dw_pgm_user
dw_pgm_role dw_pgm_role
tv_fullmenu tv_fullmenu
end type

on tabpage_2.create
this.uo_title2=create uo_title2
this.dw_pgm_user=create dw_pgm_user
this.dw_pgm_role=create dw_pgm_role
this.tv_fullmenu=create tv_fullmenu
this.Control[]={this.uo_title2,&
this.dw_pgm_user,&
this.dw_pgm_role,&
this.tv_fullmenu}
end on

on tabpage_2.destroy
destroy(this.uo_title2)
destroy(this.dw_pgm_user)
destroy(this.dw_pgm_role)
destroy(this.tv_fullmenu)
end on

type uo_title2 from fw_u_dw2title within tabpage_2
integer x = 14
integer y = 24
integer taborder = 30
boolean bringtotop = true
string istitletext = "전체 프로그램 메뉴"
end type

on uo_title2.destroy
call fw_u_dw2title::destroy
end on

type dw_pgm_user from fw_u_dwo within tabpage_2
integer x = 2670
integer y = 24
integer width = 2647
integer height = 2448
integer taborder = 10
string title = "사용 권한 멤버"
string dataobject = "fw_d_role_search_06"
boolean hscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

type dw_pgm_role from fw_u_dwo within tabpage_2
integer x = 1413
integer y = 24
integer width = 1234
integer height = 2448
integer taborder = 30
string title = "사용 권한"
string dataobject = "fw_d_role_search_05"
boolean hscrollbar = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

event rowfocuschanged;this.selectrow(0, false)
this.selectrow(currentrow, true)

if currentrow = 0 then return

string ls_role_no

ls_role_no = this.getitemstring(currentrow, 'role_no')

dw_pgm_user.reset()
dw_pgm_user.retrieve(gnv_vari.is_sys_id, ls_role_no)

end event

type tv_fullmenu from pf_u_treeview within tabpage_2
integer x = 18
integer y = 112
integer width = 1371
integer height = 2364
integer taborder = 30
fontcharset fontcharset = hangeul!
long textcolor = 20132659
string picturename[] = {"..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif","Custom039!","Open!"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event selectionchanged;treeviewitem ltvi_item
string ls_pgm_no

if this.getitem(newhandle, ltvi_item) > 0 then
	ls_pgm_no = ltvi_item.data

	dw_pgm_role.reset()
	dw_pgm_role.retrieve(gnv_vari.is_sys_id, ls_pgm_no)
end if

end event

type uo_1 from pf_u_tab within fw_w_role_info_ret
integer x = 1248
integer y = 128
integer width = 978
integer taborder = 20
boolean bringtotop = true
boolean scaletoright = true
boolean scaletobottom = true
string referencedtab = "tab_1"
end type

on uo_1.destroy
call pf_u_tab::destroy
end on

