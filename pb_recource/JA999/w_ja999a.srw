forward
global type w_ja999a from wt_listole
end type
end forward

global type w_ja999a from wt_listole
boolean eb_direct_retrieve = true
integer ii_dddw_position = 1
integer ii_dddw_width = 800
string is_init_value = "%"
end type
global w_ja999a w_ja999a

on w_ja999a.create
int iCurrent
call super::create
end on

on w_ja999a.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;f_setprotect (dw_c, NOT gaa.admin, { 'dddw' })
f_dddwctl (dw_c, 'dddw | corp_gr', gaa.corp_gr, '', 1, '')

dw_c.object.ymd [1] = f_gijunga_ymd ('')
dw_c.object.dddw [1] = gaa.corp_gr
dw_c.object.dddw2 [1] = ia_value [1]
end event

type lb_dirlist from wt_listole`lb_dirlist within w_ja999a
end type

type ln_templeft from wt_listole`ln_templeft within w_ja999a
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_ja999a
end type

type ln_temptop from wt_listole`ln_temptop within w_ja999a
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_ja999a
end type

type ln_tempstart from wt_listole`ln_tempstart within w_ja999a
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_ja999a
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_ja999a
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_ja999a
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_ja999a
end type

type ln_tempright from wt_listole`ln_tempright within w_ja999a
end type

type uo_navi from wt_listole`uo_navi within w_ja999a
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_ja999a
end type

type st_windelaytime from wt_listole`st_windelaytime within w_ja999a
end type

type st_top_rect from wt_listole`st_top_rect within w_ja999a
end type

type p_close from wt_listole`p_close within w_ja999a
end type

type p_excel from wt_listole`p_excel within w_ja999a
end type

type p_print from wt_listole`p_print within w_ja999a
end type

type p_delete from wt_listole`p_delete within w_ja999a
end type

type p_update from wt_listole`p_update within w_ja999a
end type

type p_input from wt_listole`p_input within w_ja999a
end type

type p_retrieve from wt_listole`p_retrieve within w_ja999a
end type

type p_clear from wt_listole`p_clear within w_ja999a
end type

type p_copy from wt_listole`p_copy within w_ja999a
end type

type dw_c from wt_listole`dw_c within w_ja999a
string title = "운용사@기준일자@증권사"
string dataobject = "dc_ymd_dddw2"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw2 | sell_co', gaa.corp_gr, "%,전체,", 1, '')
end event

type btn_update from wt_listole`btn_update within w_ja999a
end type

type st_count from wt_listole`st_count within w_ja999a
end type

type dw_list from wt_listole`dw_list within w_ja999a
end type

type st_move from wt_listole`st_move within w_ja999a
boolean visible = false
boolean enabled = false
end type

type ole_rd from wt_listole`ole_rd within w_ja999a
integer y = 348
integer height = 2416
boolean eb_onepage = true
boolean eb_openpagerd = true
integer ii_pagetype = 2
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;ia_value [1] = dw_c.object.dddw2 [1]
uf_fileopen ('rd_ja999a.mrd', 'corp_gr [' + dw_c.object.dddw [1] + '] ymd[' + string (dw_c.object.ymd [1],'yyyymmdd') + '] mg_cd[' + ia_value [1] + ']')

end event

type rb_onepage from wt_listole`rb_onepage within w_ja999a
end type

