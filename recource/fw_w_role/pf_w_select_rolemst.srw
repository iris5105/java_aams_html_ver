forward
global type pf_w_select_rolemst from w_response1st
end type
type dw_role_mst from fw_u_dwo within pf_w_select_rolemst
end type
type p_close from pf_u_imagebutton within pf_w_select_rolemst
end type
type p_select from pf_u_imagebutton within pf_w_select_rolemst
end type
end forward

global type pf_w_select_rolemst from w_response1st
integer width = 2331
integer height = 2444
string title = "프로그램별 권한선택"
dw_role_mst dw_role_mst
p_close p_close
p_select p_select
end type
global pf_w_select_rolemst pf_w_select_rolemst

type variables
pf_n_hashtable inv_parm

ads_jTier ids_role_cat
ads_jTier ids_role_pgm

string is_job_type
string is_pgm_no
string is_user_id

end variables

forward prototypes
public function integer of_add_parent_pgm_node (string as_role_no, string as_pgm_no)
end prototypes

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

ls_pgm_no 	   = SQLCA.getitemstring (1)
ll_rolepgm_cnt = SQLCA.getitemnumber (2)

do while sqlca.sqlcode () = 0 and ls_pgm_no <> 'ROOT'
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

	ls_pgm_no 		= SQLCA.getitemstring (1)
	ll_rolepgm_cnt = SQLCA.getitemnumber (2)
loop

return 0

end function

on pf_w_select_rolemst.create
int iCurrent
call super::create
this.dw_role_mst=create dw_role_mst
this.p_close=create p_close
this.p_select=create p_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_role_mst
this.Control[iCurrent+2]=this.p_close
this.Control[iCurrent+3]=this.p_select
end on

on pf_w_select_rolemst.destroy
call super::destroy
destroy(this.dw_role_mst)
destroy(this.p_close)
destroy(this.p_select)
end on

event open;call super::open;dw_role_mst.settransobject(sqlca)

end event

event wue_postopen;call super::wue_postopen;dw_role_mst.retrieve(gnv_vari.is_sys_id)

end event

type ln_tempbutton from w_response1st`ln_tempbutton within pf_w_select_rolemst
end type

type ln_tempstart from w_response1st`ln_tempstart within pf_w_select_rolemst
end type

type ln_templeft from w_response1st`ln_templeft within pf_w_select_rolemst
end type

type ln_cond_start from w_response1st`ln_cond_start within pf_w_select_rolemst
end type

type ln_tempright from w_response1st`ln_tempright within pf_w_select_rolemst
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within pf_w_select_rolemst
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within pf_w_select_rolemst
end type

type dw_role_mst from fw_u_dwo within pf_w_select_rolemst
integer x = 50
integer y = 144
integer width = 2231
integer height = 2180
integer taborder = 10
string title = "권한목록"
string dataobject = "pf_d_select_rolemst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean ibsetlist4singleselect = true
end type

event doubleclicked;call super::doubleclicked;if row > 0 then
	p_select.post event clicked()
end if

end event

type p_close from pf_u_imagebutton within pf_w_select_rolemst
integer x = 2053
integer y = 28
integer width = 229
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;CloseWithReturn(Parent, '')
end event

type p_select from pf_u_imagebutton within pf_w_select_rolemst
integer x = 1815
integer y = 28
integer width = 229
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_select.jpg"
end type

event clicked;call super::clicked;long ll_row
string ls_role_no, ls_role_nm

ll_row = dw_role_mst.getrow()
if ll_row = 0 then
	messagebox('Notice', '선택된 권한이 없습니다')
	return
end if

ls_role_no = dw_role_mst.getitemstring(ll_row, 'role_no')
ls_role_nm = dw_role_mst.getitemstring(ll_row, 'role_nm')

closewithreturn(parent, ls_role_no + '~t' + ls_role_nm)

end event

