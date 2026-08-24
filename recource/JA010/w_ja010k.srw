forward
global type w_ja010k from wt_vertdetail
end type
end forward

global type w_ja010k from wt_vertdetail
boolean eb_rowchangewait = true
string is_find = "fund_cd=~'~'"
end type
global w_ja010k w_ja010k

on w_ja010k.create
int iCurrent
call super::create
end on

on w_ja010k.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;DateTime ldt

ldt = f_gijunga_ymd ('-')

dw_c.object.tymd [1] = ldt

SELECT  ADD_MONTHS (:ldt, -3) + 1
  INTO  :ldt
FROM    dual;

ldt = SQLCA.getitemdatetime (1)

dw_c.object.fymd [1] = ldt
end event

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.tymd [1])
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja010k
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja010k
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja010k
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja010k
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja010k
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja010k
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja010k
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja010k
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja010k
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja010k
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja010k
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja010k
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja010k
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja010k
end type

type p_close from wt_vertdetail`p_close within w_ja010k
end type

type p_excel from wt_vertdetail`p_excel within w_ja010k
end type

type p_print from wt_vertdetail`p_print within w_ja010k
end type

type p_delete from wt_vertdetail`p_delete within w_ja010k
end type

type p_update from wt_vertdetail`p_update within w_ja010k
end type

type p_input from wt_vertdetail`p_input within w_ja010k
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja010k
end type

type p_clear from wt_vertdetail`p_clear within w_ja010k
end type

type p_copy from wt_vertdetail`p_copy within w_ja010k
end type

type dw_c from wt_vertdetail`dw_c within w_ja010k
string title = "조회일자구간"
string dataobject = "dc_ftymd"
end type

type btn_update from wt_vertdetail`btn_update within w_ja010k
end type

type st_count from wt_vertdetail`st_count within w_ja010k
end type

type dw_list from wt_vertdetail`dw_list within w_ja010k
string dataobject = "d_ja010k1"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

type dw_detail from wt_vertdetail`dw_detail within w_ja010k
string dataobject = "d_ja010k2"
boolean eb_new_false = true
boolean eb_copy_false = true
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr,  dw_c.object.fymd[1], dw_c.object.tymd[1], dw_List.object.fund_cd[iRow])

end event

event dw_detail::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

Object.vc_old_dt [row] = f_sysdate ('')
end event

type st_move from wt_vertdetail`st_move within w_ja010k
end type

