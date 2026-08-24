forward
global type w_mon2task from wt_1monliist
end type
end forward

global type w_mon2task from wt_1monliist
boolean ib_managedata = false
end type
global w_mon2task w_mon2task

on w_mon2task.create
int iCurrent
call super::create
end on

on w_mon2task.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_plan.retrieve (gnv_vari.is_sys_id, gaa.corp_gr, dw_c.object.ym [1], 'all')
dw_list.retrieve (gaa.corp_gr, dw_c.object.ym [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ym [1] = string (idt_workdate,'yyyymm')
end event

type ln_templeft from wt_1monliist`ln_templeft within w_mon2task
end type

type ln_tempbuttom from wt_1monliist`ln_tempbuttom within w_mon2task
end type

type ln_temptop from wt_1monliist`ln_temptop within w_mon2task
end type

type ln_tempbutton from wt_1monliist`ln_tempbutton within w_mon2task
end type

type ln_tempstart from wt_1monliist`ln_tempstart within w_mon2task
end type

type ln_cond1_yline from wt_1monliist`ln_cond1_yline within w_mon2task
end type

type ln_dw1_yline from wt_1monliist`ln_dw1_yline within w_mon2task
end type

type ln_cond2_yline from wt_1monliist`ln_cond2_yline within w_mon2task
end type

type ln_dw2_yline from wt_1monliist`ln_dw2_yline within w_mon2task
end type

type ln_tempright from wt_1monliist`ln_tempright within w_mon2task
end type

type uo_navi from wt_1monliist`uo_navi within w_mon2task
end type

type ln_temptop_shadow from wt_1monliist`ln_temptop_shadow within w_mon2task
end type

type st_windelaytime from wt_1monliist`st_windelaytime within w_mon2task
end type

type p_close from wt_1monliist`p_close within w_mon2task
end type

type p_excel from wt_1monliist`p_excel within w_mon2task
end type

type p_print from wt_1monliist`p_print within w_mon2task
end type

type p_delete from wt_1monliist`p_delete within w_mon2task
end type

type p_update from wt_1monliist`p_update within w_mon2task
end type

type p_input from wt_1monliist`p_input within w_mon2task
end type

type p_retrieve from wt_1monliist`p_retrieve within w_mon2task
end type

type p_clear from wt_1monliist`p_clear within w_mon2task
end type

type p_copy from wt_1monliist`p_copy within w_mon2task
end type

type dw_c from wt_1monliist`dw_c within w_mon2task
string title = "영업년월"
string dataobject = "dc_dddw_ym"
end type

type btn_update from wt_1monliist`btn_update within w_mon2task
end type

type dw_plan from wt_1monliist`dw_plan within w_mon2task
boolean ibtitle4datawindow = false
end type

type dw_list from wt_1monliist`dw_list within w_mon2task
string dataobject = "d_mon2task"
end type

