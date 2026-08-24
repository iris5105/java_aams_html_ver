forward
global type pf_w_pgm_mst_role_pgm from w_response1st
end type
type dw_role_memb from fw_u_dwo within pf_w_pgm_mst_role_pgm
end type
type p_close from pf_u_imagebutton within pf_w_pgm_mst_role_pgm
end type
type p_update from pf_u_imagebutton within pf_w_pgm_mst_role_pgm
end type
type dw_role_mst from fw_u_dwo within pf_w_pgm_mst_role_pgm
end type
end forward

global type pf_w_pgm_mst_role_pgm from w_response1st
integer width = 4983
integer height = 2436
string title = "프로그램별 권한선택"
dw_role_memb dw_role_memb
p_close p_close
p_update p_update
dw_role_mst dw_role_mst
end type
global pf_w_pgm_mst_role_pgm pf_w_pgm_mst_role_pgm

type variables
pf_n_hashtable inv_parm

ads_jTier ids_role_cat
ads_jTier ids_role_pgm
string is_pgm_no

end variables

forward prototypes
public function integer of_set_title_dw_role_memb ()
public function integer of_add_parent_pgm_node (string as_role_no, string as_pgm_no)
end prototypes

public function integer of_set_title_dw_role_memb ();integer i, il_role_cat_no
boolean lb_role_cat_yn[8]
string ls_modify, ls_search_type
string ls_role_cat_no, ls_role_cat_nm
string ls_code_list_dwo

// modify header title
for i = 1 to ids_role_cat.rowcount()
	ls_role_cat_no = ids_role_cat.getitemstring(i, 'role_cat_no')
	il_role_cat_no = integer(ls_role_cat_no)
	lb_role_cat_yn[il_role_cat_no] = true
	ls_role_cat_nm = ids_role_cat.getitemstring(i, 'role_cat_nm')
	ls_search_type = ids_role_cat.getitemstring(i, 'search_type')
	ls_code_list_dwo = ids_role_cat.getitemstring(i, 'code_list_dwo')
	
	ls_modify += "memb_name" + string(il_role_cat_no) + "_t.text='" + ls_role_cat_nm + "'~r~n"
	ls_modify += "memb_name" + string(il_role_cat_no) + "_t.tag='" + ls_code_list_dwo + "'~r~n"
next

// hide unused columns
for i = 1 to upperbound(lb_role_cat_yn)
	if lb_role_cat_yn[i] = false then
		ls_modify += 'memb_name' + string(i) + '_t.visible="0"~r~n'
		ls_modify += 'memb_name' + string(i) + '.visible="0"~r~n'
	end if
next

// do moidfy
string ls_error

ls_error = dw_role_memb.Modify(ls_modify)
if len(ls_error) > 0 then
	::clipboard(dw_role_memb.classname() + "~r~n" + ls_modify)
	messagebox("Error", dw_role_memb.classname() + " Syntax Modification Failure!! : " + ls_error)
	return -1
end if

dw_role_memb.event oue_dwowidthchanged()

return 1
end function

public function integer of_add_parent_pgm_node (string as_role_no, string as_pgm_no);string ls_pgm_no
long ll_rolepgm_cnt
long ll_new

select		s01.parent_pgm,
			(case when s02.role_no is null then 0 else 1 end) rolepgm_cnt
into		:ls_pgm_no,
			:ll_rolepgm_cnt
from		fw_pgm_mst s01 left
outer join fw_role_pgm s02 on s02.sys_id = s01.sys_id and s02.role_no = :as_role_no and s02.pgm_no = s01.parent_pgm
where	s01.sys_id = :gnv_vari.is_sys_id
and		s01.pgm_no = :as_pgm_no;

ls_pgm_no      = SQLCA.getitemstring (1)
ll_rolepgm_cnt = SQLCA.getitemnumber (2)

do while sqlca.sqlcode() = 0 and ls_pgm_no <> 'ROOT'
	if ll_rolepgm_cnt = 0 then
		ll_new = ids_role_pgm.insertrow(0)
		ids_role_pgm.setitem(ll_new, 'sys_id', gnv_vari.is_sys_id)
		ids_role_pgm.setitem(ll_new, 'pgm_no', ls_pgm_no)
		ids_role_pgm.setitem(ll_new, 'role_no', as_role_no)
	end if
	
	select		s01.parent_pgm,
				(case when s02.role_no is null then 0 else 1 end) rolepgm_cnt
	into		:ls_pgm_no,
				:ll_rolepgm_cnt
	from		fw_pgm_mst s01 left
	outer join fw_role_pgm s02 on s02.sys_id = s01.sys_id and s02.role_no = :as_role_no and s02.pgm_no = s01.parent_pgm
	where	s01.sys_id = :gnv_vari.is_sys_id
	and		s01.pgm_no = :ls_pgm_no;
	
	ls_pgm_no      = SQLCA.getitemstring (1)
	ll_rolepgm_cnt = SQLCA.getitemnumber (2)

loop

return 0

end function

on pf_w_pgm_mst_role_pgm.create
int iCurrent
call super::create
this.dw_role_memb=create dw_role_memb
this.p_close=create p_close
this.p_update=create p_update
this.dw_role_mst=create dw_role_mst
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_role_memb
this.Control[iCurrent+2]=this.p_close
this.Control[iCurrent+3]=this.p_update
this.Control[iCurrent+4]=this.dw_role_mst
end on

on pf_w_pgm_mst_role_pgm.destroy
call super::destroy
destroy(this.dw_role_memb)
destroy(this.p_close)
destroy(this.p_update)
destroy(this.dw_role_mst)
end on

event open;call super::open;IF f_null (message.stringparm)   Then
   messagebox ('Notice', 'There is no parameter variable value.')
   CLOSE(THIS)
Else
   is_pgm_no = message.stringparm

	TITLE = is_pgm_no + ' ' + gnv_rolemenu.of_getpgmnm (is_pgm_no) + ' 권한선택'

   ids_role_pgm = CREATE ads_jTier
   ids_role_pgm.dataobject = 'pf_d_pgm_mst_role_pgm_03'
   ids_role_pgm.settransobject(SQLCA)
   ids_role_pgm.retrieve (gnv_vari.is_sys_id, is_pgm_no)

   dw_role_mst.settransobject(SQLCA)
   dw_role_memb.settransobject(SQLCA)

   ids_role_cat = CREATE ads_jTier
   ids_role_cat.dataobject = 'fw_d_role_assign_ds2'
   ids_role_cat.settransobject(SQLCA)
   ids_role_cat.retrieve (gnv_vari.is_sys_id)

   of_set_title_dw_role_memb ()
End IF
end event

event wue_postopen;call super::wue_postopen;dw_role_mst.retrieve (gnv_vari.is_sys_id)

LONG	ll, ll_find, ll_rowcnt, ll_role

ll_rowcnt = ids_role_pgm.rowcount ()
ll_role = dw_role_mst.rowcount ()
FOR  ll = 1  TO  ll_rowcnt
   ll_find = dw_role_mst.find ("role_no='" + ids_role_pgm.getitemstring (ll, 'role_no') + "'", 1, ll_role)
   IF ll_find>0 THEN dw_role_mst.setitem (ll_find, 'chk', 'Y')
NEXT
IF	ll_find>0	Then
	dw_role_mst.post uf_setrow (ll_find, true)
Else
	dw_role_mst.post uf_setrow (1, true)
End IF
end event

type ln_tempbutton from w_response1st`ln_tempbutton within pf_w_pgm_mst_role_pgm
end type

type ln_tempstart from w_response1st`ln_tempstart within pf_w_pgm_mst_role_pgm
end type

type ln_templeft from w_response1st`ln_templeft within pf_w_pgm_mst_role_pgm
end type

type ln_cond_start from w_response1st`ln_cond_start within pf_w_pgm_mst_role_pgm
end type

type ln_tempright from w_response1st`ln_tempright within pf_w_pgm_mst_role_pgm
integer beginy = -28
integer endy = 3144
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within pf_w_pgm_mst_role_pgm
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within pf_w_pgm_mst_role_pgm
end type

type dw_role_memb from fw_u_dwo within pf_w_pgm_mst_role_pgm
integer x = 2350
integer y = 128
integer width = 2560
integer height = 2184
integer taborder = 10
string title = "권한멤버"
string dataobject = "pf_d_pgm_mst_role_pgm_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

type p_close from pf_u_imagebutton within pf_w_pgm_mst_role_pgm
integer x = 4677
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;closewithreturn(parent, 'Cancel')
end event

type p_update from pf_u_imagebutton within pf_w_pgm_mst_role_pgm
integer x = 4439
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_save.jpg"
end type

event clicked;call super::clicked;string ls_errtext

// Accept Text
if dw_role_mst.accepttext() = -1 then return

if ids_role_pgm.update () = 1 then
	commitJ ()
	closewithreturn(parent, 'OK')
else
	ls_errtext = sqlca.sqlerrtext()
	rollbackJ ()
	messagebox('Notice', '프로그램 권한 정보 저장 실패!!~r~n' + 'Error Text: ' + ls_errtext)
end if
end event

type dw_role_mst from fw_u_dwo within pf_w_pgm_mst_role_pgm
integer x = 50
integer y = 128
integer width = 2290
integer height = 2184
integer taborder = 10
string title = "권한목록"
string dataobject = "pf_d_pgm_mst_role_pgm_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow=0 then return

string ls_role_no

ls_role_no = this.getitemstring (currentrow, 'role_no')
dw_role_memb.retrieve (gnv_vari.is_sys_id, ls_role_no)
end event

event itemchanged;call super::itemchanged;long ll_new, ll_find
string ls_role_no

choose case dwo.name
	case 'chk'
		if data='Y'	then
			ll_new = ids_role_pgm.insertrow(0)
			ls_role_no = this.getitemstring(row, 'role_no')
			ids_role_pgm.setitem(ll_new, 'sys_id', gnv_vari.is_sys_id)
			ids_role_pgm.setitem(ll_new, 'pgm_no', is_pgm_no)
			ids_role_pgm.setitem(ll_new, 'role_no', ls_role_no)
			
			of_add_parent_pgm_node(ls_role_no, is_pgm_no)
		else
			ls_role_no = this.getitemstring(row, 'role_no')
			ll_find = ids_role_pgm.find("role_no='" + ls_role_no + "' and pgm_no='" + is_pgm_no + "'", 1, ids_role_pgm.rowcount())
			if ll_find>0 then ids_role_pgm.deleterow (ll_find)
		end if
end choose
end event

