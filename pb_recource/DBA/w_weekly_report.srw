forward
global type w_weekly_report from wt_listole
end type
end forward

global type w_weekly_report from wt_listole
end type
global w_weekly_report w_weekly_report

on w_weekly_report.create
int iCurrent
call super::create
end on

on w_weekly_report.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.sb_cd [1] = gnv_vari.is_user_id
end event

type ln_templeft from wt_listole`ln_templeft within w_weekly_report
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_weekly_report
end type

type ln_temptop from wt_listole`ln_temptop within w_weekly_report
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_weekly_report
end type

type ln_tempstart from wt_listole`ln_tempstart within w_weekly_report
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_weekly_report
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_weekly_report
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_weekly_report
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_weekly_report
end type

type ln_tempright from wt_listole`ln_tempright within w_weekly_report
end type

type uo_navi from wt_listole`uo_navi within w_weekly_report
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_weekly_report
end type

type st_windelaytime from wt_listole`st_windelaytime within w_weekly_report
end type

type p_close from wt_listole`p_close within w_weekly_report
end type

type p_excel from wt_listole`p_excel within w_weekly_report
end type

type p_print from wt_listole`p_print within w_weekly_report
end type

type p_delete from wt_listole`p_delete within w_weekly_report
end type

type p_update from wt_listole`p_update within w_weekly_report
end type

type p_input from wt_listole`p_input within w_weekly_report
end type

type p_retrieve from wt_listole`p_retrieve within w_weekly_report
end type

type p_clear from wt_listole`p_clear within w_weekly_report
end type

type p_copy from wt_listole`p_copy within w_weekly_report
end type

type dw_c from wt_listole`dw_c within w_weekly_report
string dataobject = "d_weekly_report"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;DateTime	ldt

String	ls

//SELECT	to_char(max(ymd), 'yyyy.mm.dd')
//	INTO	:ls
//FROM	szx9dt t1
//WHERE	ymd	> sysdate - 8
// AND	to_char(ymd,'d') = 2;

f_dddwctl (THIS, 'week', gaa.corp_gr, '', 1, "ymd >= '2017.9.1'")

Object.week [1] = ls

f_dddwctl (dw_c, 'sb_cd', gaa.corp_gr, '%,전체,', 1, "")
end event

type btn_update from wt_listole`btn_update within w_weekly_report
end type

type dw_list from wt_listole`dw_list within w_weekly_report
boolean applydesign = false
boolean useborder = false
end type

type st_move from wt_listole`st_move within w_weekly_report
end type

type ole_rd from wt_listole`ole_rd within w_weekly_report
integer y = 348
integer height = 2464
boolean eb_onepage = true
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;IF	dw_c.object.report [1] = '1'	Then
	eb_OnePage = FALSE ; rb_onepage.Enabled = FALSE
	uf_fileopen ('rd_weekly_rep.mrd', 'week[' + dw_c.describe("Evaluate('LookupDisplay(week)',1)") + '] ymd[' + dw_c.object.week [1] + '] sb[' + dw_c.object.sb_cd [1] + ']')
Else
	IF	eb_OnePage THEN rb_onepage.Enabled = TRUE
	uf_fileopen ('rd_weekly.mrd', 'week[' + dw_c.describe("Evaluate('LookupDisplay(week)',1)") + '] ymd[' + dw_c.object.week [1] + '] sb[' + dw_c.object.sb_cd [1] + ']')
End IF
end event

type rb_onepage from wt_listole`rb_onepage within w_weekly_report
integer x = 4686
integer y = 256
boolean enabled = false
end type

