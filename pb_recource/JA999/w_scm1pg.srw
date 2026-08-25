forward
global type w_scm1pg from wt_vertdetail
end type
end forward

global type w_scm1pg from wt_vertdetail
boolean eb_direct_retrieve = true
end type
global w_scm1pg w_scm1pg

on w_scm1pg.create
int iCurrent
call super::create
end on

on w_scm1pg.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_scm1pg
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_scm1pg
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_scm1pg
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_scm1pg
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_scm1pg
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_scm1pg
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_scm1pg
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_scm1pg
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_scm1pg
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_scm1pg
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_scm1pg
end type

type uo_navi from wt_vertdetail`uo_navi within w_scm1pg
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_scm1pg
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_scm1pg
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_scm1pg
end type

type p_close from wt_vertdetail`p_close within w_scm1pg
end type

type p_excel from wt_vertdetail`p_excel within w_scm1pg
end type

type p_print from wt_vertdetail`p_print within w_scm1pg
end type

type p_delete from wt_vertdetail`p_delete within w_scm1pg
end type

type p_update from wt_vertdetail`p_update within w_scm1pg
end type

type p_input from wt_vertdetail`p_input within w_scm1pg
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_scm1pg
end type

type p_clear from wt_vertdetail`p_clear within w_scm1pg
end type

type p_copy from wt_vertdetail`p_copy within w_scm1pg
end type

type dw_c from wt_vertdetail`dw_c within w_scm1pg
string title = "적용기준일"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertdetail`btn_update within w_scm1pg
end type

type st_count from wt_vertdetail`st_count within w_scm1pg
end type

type dw_list from wt_vertdetail`dw_list within w_scm1pg
string dataobject = "d_scm1pg_1"
end type

type dw_detail from wt_vertdetail`dw_detail within w_scm1pg
string dataobject = "d_scm1pg_2"
string is_resize_column = "fund_list"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_list.object.jm_cd [iRow])
end event

event dw_detail::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'pg_cd', '', '', 1, '')
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setColumn ('ymd', string(dw_c.object.ymd [1]))
uf_setColumn ('jm_cd', string(dw_list.object.jm_cd [iRow]))

POST SetColumn ('ymd')

RETURN 0
end event

event dw_detail::itemchanged;call super::itemchanged;STRING	ls_jm_cd
DATETIME ldt

ls_jm_cd = dw_list.object.jm_cd [iRow]
ldt = Object.ymd [row]

UPDATE SCM1J ta
   SET pg_cd = :data
 WHERE ta.corp_gr  = :gaa.corp_gr
   AND ta.jm_cd    = :ls_jm_cd
   AND ta.buy_date = TO_CHAR(:ldt,'yyyymmdd');

commitJ ()
end event

event dw_detail::doubleclicked;call super::doubleclicked;IF	dwo.name<>'pg_cd' THEN RETURN

STRING	ls_jm_cd, ls_pg_cd
DATETIME ldt

ls_jm_cd = dw_list.object.jm_cd [iRow]
ldt = Object.ymd [row]
ls_pg_cd = Object.pg_cd [row]

UPDATE SCM1J ta
   SET pg_cd = :ls_pg_cd
 WHERE ta.corp_gr  = :gaa.corp_gr
   AND ta.jm_cd    = :ls_jm_cd
   AND ta.buy_date = TO_CHAR(:ldt,'yyyymmdd');

commitJ ()
end event

type st_move from wt_vertdetail`st_move within w_scm1pg
boolean leftmaxsizefixed = true
end type

