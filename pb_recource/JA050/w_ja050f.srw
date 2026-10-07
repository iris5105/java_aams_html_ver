forward
global type w_ja050f from wt_vertdetail
end type
end forward

global type w_ja050f from wt_vertdetail
boolean eb_direct_retrieve = true
end type
global w_ja050f w_ja050f

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ()
end event

on w_ja050f.create
int iCurrent
call super::create
end on

on w_ja050f.destroy
call super::destroy
end on

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja050f
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja050f
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja050f
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja050f
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja050f
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja050f
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja050f
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja050f
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja050f
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja050f
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja050f
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja050f
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja050f
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja050f
end type

type p_close from wt_vertdetail`p_close within w_ja050f
end type

type p_excel from wt_vertdetail`p_excel within w_ja050f
end type

type p_print from wt_vertdetail`p_print within w_ja050f
end type

type p_delete from wt_vertdetail`p_delete within w_ja050f
end type

type p_update from wt_vertdetail`p_update within w_ja050f
end type

type p_input from wt_vertdetail`p_input within w_ja050f
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja050f
end type

type p_clear from wt_vertdetail`p_clear within w_ja050f
end type

type p_copy from wt_vertdetail`p_copy within w_ja050f
end type

type dw_c from wt_vertdetail`dw_c within w_ja050f
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_vertdetail`btn_update within w_ja050f
end type

type st_count from wt_vertdetail`st_count within w_ja050f
end type

type dw_list from wt_vertdetail`dw_list within w_ja050f
integer y = 156
integer height = 2608
string dataobject = "d_ja050f1"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('gr_cd', '90')

POST SetColumn ("sebu_cd")

RETURN 0
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja050f
integer y = 156
integer height = 2608
string dataobject = "d_ja050f2"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.sebu_cd [iRow])
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setColumn ('chk_no', dw_list.object.sebu_cd [iRow])

POST SetColumn ("chk_gb")

RETURN 0
end event

event dw_detail::ue_setcodesearch;call super::ue_setcodesearch;RETURN 9
end event

type st_move from wt_vertdetail`st_move within w_ja050f
integer y = 160
boolean leftmaxsizefixed = true
end type

