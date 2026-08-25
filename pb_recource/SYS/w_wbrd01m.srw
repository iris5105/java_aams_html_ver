forward
global type w_wbrd01m from wt_list
end type
end forward

global type w_wbrd01m from wt_list
boolean ib_managedata = false
end type
global w_wbrd01m w_wbrd01m

on w_wbrd01m.create
int iCurrent
call super::create
end on

on w_wbrd01m.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;//dw_list.retrieve (gaa.corp_gr)
//dw_List.retrieve (dw_c.object.dddw [1])
dw_List.retrieve (dw_c.object.dddw [1], dw_c.object.fymd[1],dw_c.object.tymd[1])
end event

event wue_lastopen;call super::wue_lastopen;f_setprotect (dw_c, NOT (gaa.admin OR gaa.aams), { 'dddw' })
dw_c.object.dddw [1] = '%'
dw_c.object.tymd [1] = idt_workdate
dw_c.object.fymd [1] = idt_workdate
end event

type lb_dirlist from wt_list`lb_dirlist within w_wbrd01m
end type

type ln_templeft from wt_list`ln_templeft within w_wbrd01m
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_wbrd01m
end type

type ln_temptop from wt_list`ln_temptop within w_wbrd01m
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_wbrd01m
end type

type ln_tempstart from wt_list`ln_tempstart within w_wbrd01m
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_wbrd01m
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_wbrd01m
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_wbrd01m
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_wbrd01m
end type

type ln_tempright from wt_list`ln_tempright within w_wbrd01m
end type

type uo_navi from wt_list`uo_navi within w_wbrd01m
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_wbrd01m
end type

type st_windelaytime from wt_list`st_windelaytime within w_wbrd01m
end type

type p_close from wt_list`p_close within w_wbrd01m
end type

type p_excel from wt_list`p_excel within w_wbrd01m
end type

type p_print from wt_list`p_print within w_wbrd01m
end type

type p_delete from wt_list`p_delete within w_wbrd01m
end type

type p_update from wt_list`p_update within w_wbrd01m
end type

type p_input from wt_list`p_input within w_wbrd01m
end type

type p_retrieve from wt_list`p_retrieve within w_wbrd01m
end type

type p_clear from wt_list`p_clear within w_wbrd01m
end type

type p_copy from wt_list`p_copy within w_wbrd01m
end type

type dw_c from wt_list`dw_c within w_wbrd01m
string title = "일자구간@운용사"
string dataobject = "dc_ftymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | corp_gr', gaa.corp_gr, '%,전체,', 1, "substrb (company_name,1,1) != '*'")
end event

type btn_update from wt_list`btn_update within w_wbrd01m
end type

type st_count from wt_list`st_count within w_wbrd01m
end type

type dw_list from wt_list`dw_list within w_wbrd01m
string dataobject = "d_wbrd01m_list"
string is_resize_column = "board_text"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'corp_gr', gaa.corp_gr, '%,전체,', 1, '')
end event

