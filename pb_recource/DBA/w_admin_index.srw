forward
global type w_admin_index from wt_list
end type
end forward

global type w_admin_index from wt_list
boolean ib_managedata = false
end type
global w_admin_index w_admin_index

type variables

end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.owner [1] = 'ICAM'
dw_c.object.Table_name [1] = '%'
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve ('%' + dw_c.object.Table_name [1] + '%')
end event

on w_admin_index.create
int iCurrent
call super::create
end on

on w_admin_index.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_admin_index
end type

type ln_templeft from wt_list`ln_templeft within w_admin_index
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_admin_index
end type

type ln_temptop from wt_list`ln_temptop within w_admin_index
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_admin_index
end type

type ln_tempstart from wt_list`ln_tempstart within w_admin_index
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_admin_index
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_admin_index
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_admin_index
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_admin_index
end type

type ln_tempright from wt_list`ln_tempright within w_admin_index
end type

type uo_navi from wt_list`uo_navi within w_admin_index
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_admin_index
end type

type st_windelaytime from wt_list`st_windelaytime within w_admin_index
end type

type p_close from wt_list`p_close within w_admin_index
end type

type p_excel from wt_list`p_excel within w_admin_index
end type

type p_print from wt_list`p_print within w_admin_index
end type

type p_delete from wt_list`p_delete within w_admin_index
end type

type p_update from wt_list`p_update within w_admin_index
end type

type p_input from wt_list`p_input within w_admin_index
end type

type p_retrieve from wt_list`p_retrieve within w_admin_index
end type

type p_clear from wt_list`p_clear within w_admin_index
end type

type p_copy from wt_list`p_copy within w_admin_index
end type

type dw_c from wt_list`dw_c within w_admin_index
string dataobject = "d_admin_index_c"
end type

type btn_update from wt_list`btn_update within w_admin_index
end type

type dw_list from wt_list`dw_list within w_admin_index
string dataobject = "d_admin_indexs_l"
boolean eb_null_line = false
end type

