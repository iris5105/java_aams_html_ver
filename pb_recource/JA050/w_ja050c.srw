forward
global type w_ja050c from wt_vertole
end type
end forward

global type w_ja050c from wt_vertole
string is_find = "fund_cd=~'~'"
end type
global w_ja050c w_ja050c

on w_ja050c.create
int iCurrent
call super::create
end on

on w_ja050c.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = '1'
end event

event wue_retrieve;call super::wue_retrieve;STRING	ls_select

is_find = "fund_cd='" + gaa.fund_cd + "'"
IF dw_c.object.dddw [1]='9'   Then
	ls_select = dw_list.uf_sql_default () + " WHERE corp_gr='" + gaa.corp_gr + "' And fund_cd in (select ta.fund_cd from skt0bu ta where ta.corp_gr='" + gaa.corp_gr + "' and ta.tr_ymd='" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' and ta.proc_step='9') "
Else
	ls_select = dw_list.uf_sql_default () + " WHERE corp_gr='" + gaa.corp_gr + "' And fund_cd in (select ta.fund_cd from skt0bu ta where ta.corp_gr='" + gaa.corp_gr + "' and ta.tr_ymd='" + string(dw_c.object.ymd [1],'yyyy.mm.dd') + "') "
End IF
dw_list.Modify ("DataWindow.Table.Select = ~" " + ls_select + "~" ")
dw_list.retrieve ()
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja050c
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja050c
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja050c
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja050c
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja050c
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja050c
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja050c
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja050c
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja050c
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja050c
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja050c
end type

type uo_navi from wt_vertole`uo_navi within w_ja050c
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja050c
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja050c
end type

type st_top_rect from wt_vertole`st_top_rect within w_ja050c
end type

type p_close from wt_vertole`p_close within w_ja050c
end type

type p_excel from wt_vertole`p_excel within w_ja050c
end type

type p_print from wt_vertole`p_print within w_ja050c
end type

type p_delete from wt_vertole`p_delete within w_ja050c
end type

type p_update from wt_vertole`p_update within w_ja050c
end type

type p_input from wt_vertole`p_input within w_ja050c
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja050c
end type

type p_clear from wt_vertole`p_clear within w_ja050c
end type

type p_copy from wt_vertole`p_copy within w_ja050c
end type

type dw_c from wt_vertole`dw_c within w_ja050c
string title = "기준일자@구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', '', '1,일반,,9,수기,', 1, '')
end event

type btn_update from wt_vertole`btn_update within w_ja050c
end type

type st_count from wt_vertole`st_count within w_ja050c
end type

type dw_list from wt_vertole`dw_list within w_ja050c
boolean visible = true
boolean enabled = true
string dataobject = "d_fund_select"
end type

type st_move from wt_vertole`st_move within w_ja050c
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_ja050c
end type

event ole_rd::ue_retrieve;call super::ue_retrieve; uf_fileopen ('rd_ja050c.mrd', 'ymd[' + string (dw_c.object.ymd [1],'yyyy.mm.dd') + '] ' + &
                           'proc_step[' + dw_c.object.dddw [1] + '] ' + &
                           'fund_cd[' + dw_list.object.fund_cd [row] + ']')
end event

type rb_onepage from wt_vertole`rb_onepage within w_ja050c
end type

