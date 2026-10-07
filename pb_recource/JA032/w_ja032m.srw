forward
global type w_ja032m from wt_vertdetail
end type
end forward

global type w_ja032m from wt_vertdetail
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "fund_cd=~'~'"
end type
global w_ja032m w_ja032m

on w_ja032m.create
int iCurrent
call super::create
end on

on w_ja032m.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja032m
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja032m
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja032m
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja032m
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja032m
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja032m
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja032m
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja032m
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja032m
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja032m
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja032m
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja032m
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja032m
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja032m
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja032m
end type

type p_close from wt_vertdetail`p_close within w_ja032m
end type

type p_excel from wt_vertdetail`p_excel within w_ja032m
end type

type p_print from wt_vertdetail`p_print within w_ja032m
end type

type p_delete from wt_vertdetail`p_delete within w_ja032m
end type

type p_update from wt_vertdetail`p_update within w_ja032m
end type

type p_input from wt_vertdetail`p_input within w_ja032m
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja032m
end type

type p_clear from wt_vertdetail`p_clear within w_ja032m
end type

type p_copy from wt_vertdetail`p_copy within w_ja032m
end type

type dw_c from wt_vertdetail`dw_c within w_ja032m
string title = "조회일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertdetail`btn_update within w_ja032m
end type

type st_count from wt_vertdetail`st_count within w_ja032m
end type

type dw_list from wt_vertdetail`dw_list within w_ja032m
string dataobject = "d_ja032m1"
end type

type dw_detail from wt_vertdetail`dw_detail within w_ja032m
string dataobject = "d_ja032m2"
string islist4subbtnauth = "0010001001"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_list.object.fund_cd [iRow])
end event

type st_move from wt_vertdetail`st_move within w_ja032m
boolean leftmaxsizefixed = true
end type

