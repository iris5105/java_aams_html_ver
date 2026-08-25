forward
global type w_ja031k from wt_list
end type
end forward

global type w_ja031k from wt_list
string is_init_value = "E25"
end type
global w_ja031k w_ja031k

type variables

end variables

on w_ja031k.create
int iCurrent
call super::create
end on

on w_ja031k.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja031k
end type

type ln_templeft from wt_list`ln_templeft within w_ja031k
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja031k
end type

type ln_temptop from wt_list`ln_temptop within w_ja031k
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja031k
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja031k
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja031k
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja031k
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja031k
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja031k
end type

type ln_tempright from wt_list`ln_tempright within w_ja031k
end type

type uo_navi from wt_list`uo_navi within w_ja031k
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja031k
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja031k
end type

type st_top_rect from wt_list`st_top_rect within w_ja031k
end type

type p_close from wt_list`p_close within w_ja031k
end type

type p_excel from wt_list`p_excel within w_ja031k
end type

type p_print from wt_list`p_print within w_ja031k
end type

type p_delete from wt_list`p_delete within w_ja031k
end type

type p_update from wt_list`p_update within w_ja031k
end type

type p_input from wt_list`p_input within w_ja031k
end type

type p_retrieve from wt_list`p_retrieve within w_ja031k
end type

type p_clear from wt_list`p_clear within w_ja031k
end type

type p_copy from wt_list`p_copy within w_ja031k
end type

type dw_c from wt_list`dw_c within w_ja031k
string title = "영업일자@입금거래구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1]>=uf_initdate ('inputdate'))
ia_value [1] = dw_c.object.dddw [1]
RETURN TRUE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA031K'")
end event

type btn_update from wt_list`btn_update within w_ja031k
end type

type st_count from wt_list`st_count within w_ja031k
end type

type dw_list from wt_list`dw_list within w_ja031k
integer y = 332
string dataobject = "d_ja031k"
boolean eb_always_1_insert = true
string is_resize_column = "bigo"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_SetColumn ("tr_ymd",  string (dw_c.object.ymd [1]))
uf_SetColumn ("tr_cd",   dw_c.object.dddw [1])

POST SetColumn ("fund_cd")

RETURN 0
end event

