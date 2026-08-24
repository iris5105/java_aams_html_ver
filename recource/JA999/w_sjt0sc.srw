forward
global type w_sjt0sc from wt_list
end type
end forward

global type w_sjt0sc from wt_list
boolean eb_direct_retrieve = true
end type
global w_sjt0sc w_sjt0sc

type variables

end variables

on w_sjt0sc.create
int iCurrent
call super::create
end on

on w_sjt0sc.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;CHOOSE CASE gaa.corp_gr
	CASE '2402'
		dw_list.uf_dataobject ('d_sjt0sc_2402', FALSE)
	CASE ELSE
		dw_list.uf_dataobject ('d_sjt0sc', FALSE)
END CHOOSE

dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type lb_dirlist from wt_list`lb_dirlist within w_sjt0sc
end type

type ln_templeft from wt_list`ln_templeft within w_sjt0sc
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_sjt0sc
end type

type ln_temptop from wt_list`ln_temptop within w_sjt0sc
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_sjt0sc
end type

type ln_tempstart from wt_list`ln_tempstart within w_sjt0sc
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_sjt0sc
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_sjt0sc
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_sjt0sc
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_sjt0sc
end type

type ln_tempright from wt_list`ln_tempright within w_sjt0sc
end type

type uo_navi from wt_list`uo_navi within w_sjt0sc
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_sjt0sc
end type

type st_windelaytime from wt_list`st_windelaytime within w_sjt0sc
end type

type st_top_rect from wt_list`st_top_rect within w_sjt0sc
end type

type p_close from wt_list`p_close within w_sjt0sc
end type

type p_excel from wt_list`p_excel within w_sjt0sc
end type

type p_print from wt_list`p_print within w_sjt0sc
end type

type p_delete from wt_list`p_delete within w_sjt0sc
end type

type p_update from wt_list`p_update within w_sjt0sc
end type

type p_input from wt_list`p_input within w_sjt0sc
end type

type p_retrieve from wt_list`p_retrieve within w_sjt0sc
end type

type p_clear from wt_list`p_clear within w_sjt0sc
end type

type p_copy from wt_list`p_copy within w_sjt0sc
end type

type dw_c from wt_list`dw_c within w_sjt0sc
string title = "영업일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_list`btn_update within w_sjt0sc
end type

type st_count from wt_list`st_count within w_sjt0sc
end type

type dw_list from wt_list`dw_list within w_sjt0sc
string dataobject = "d_sjt0sc_2402"
boolean eb_null_line = false
string is_resize_column = "bigo"
end type

event dw_list::itemchanged_next;call super::itemchanged_next;CHOOSE CASE name
	CASE 'dang_gijun_ga'
		Object.dang_ggijun_ga [row] = Object.dang_gijun_ga [row]
		Object.load_siga_aek [row] = null_dc
	CASE 'gyul_gijun_ga'
		Object.gyul_ggijun_ga [row] = Object.gyul_gijun_ga [row]
		Object.load_siga_aek [row] = null_dc
	CASE 'load_siga_aek'
		Object.dang_gijun_ga [row] = null_dc
		Object.dang_ggijun_ga [row] = null_dc
END CHOOSE
Object.bigo [row] = 'W_SJT0SC'
end event

