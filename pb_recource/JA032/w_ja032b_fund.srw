forward
global type w_ja032b_fund from wt_listdetail
end type
end forward

global type w_ja032b_fund from wt_listdetail
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "fund_cd=~'~'"
boolean ib_managedata = false
end type
global w_ja032b_fund w_ja032b_fund

on w_ja032b_fund.create
int iCurrent
call super::create
end on

on w_ja032b_fund.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja032b_fund
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja032b_fund
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja032b_fund
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja032b_fund
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja032b_fund
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja032b_fund
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja032b_fund
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja032b_fund
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja032b_fund
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja032b_fund
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja032b_fund
end type

type uo_navi from wt_listdetail`uo_navi within w_ja032b_fund
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja032b_fund
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja032b_fund
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja032b_fund
end type

type p_close from wt_listdetail`p_close within w_ja032b_fund
end type

type p_excel from wt_listdetail`p_excel within w_ja032b_fund
end type

type p_print from wt_listdetail`p_print within w_ja032b_fund
end type

type p_delete from wt_listdetail`p_delete within w_ja032b_fund
end type

type p_update from wt_listdetail`p_update within w_ja032b_fund
end type

type p_input from wt_listdetail`p_input within w_ja032b_fund
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja032b_fund
end type

type p_clear from wt_listdetail`p_clear within w_ja032b_fund
end type

type p_copy from wt_listdetail`p_copy within w_ja032b_fund
end type

type dw_c from wt_listdetail`dw_c within w_ja032b_fund
string title = "조회기준일"
string dataobject = "dc_ymd"
end type

type btn_update from wt_listdetail`btn_update within w_ja032b_fund
end type

type st_count from wt_listdetail`st_count within w_ja032b_fund
end type

type dw_list from wt_listdetail`dw_list within w_ja032b_fund
string dataobject = "d_ja032a1"
end type

type dw_detail from wt_listdetail`dw_detail within w_ja032b_fund
string dataobject = "d_ja032b_fund2"
string islist4subbtnauth = "0010001001"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_list.object.fund_cd [iRow])
end event

type st_move from wt_listdetail`st_move within w_ja032b_fund
end type

