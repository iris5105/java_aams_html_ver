forward
global type w_ja036f from wt_listshare
end type
end forward

global type w_ja036f from wt_listshare
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_init_value = "1"
boolean ib_managedata = false
end type
global w_ja036f w_ja036f

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

on w_ja036f.create
int iCurrent
call super::create
end on

on w_ja036f.destroy
call super::destroy
end on

type lb_dirlist from wt_listshare`lb_dirlist within w_ja036f
end type

type ln_templeft from wt_listshare`ln_templeft within w_ja036f
end type

type ln_tempbuttom from wt_listshare`ln_tempbuttom within w_ja036f
end type

type ln_temptop from wt_listshare`ln_temptop within w_ja036f
end type

type ln_tempbutton from wt_listshare`ln_tempbutton within w_ja036f
end type

type ln_tempstart from wt_listshare`ln_tempstart within w_ja036f
end type

type ln_cond1_yline from wt_listshare`ln_cond1_yline within w_ja036f
end type

type ln_dw1_yline from wt_listshare`ln_dw1_yline within w_ja036f
end type

type ln_cond2_yline from wt_listshare`ln_cond2_yline within w_ja036f
end type

type ln_dw2_yline from wt_listshare`ln_dw2_yline within w_ja036f
end type

type ln_tempright from wt_listshare`ln_tempright within w_ja036f
end type

type uo_navi from wt_listshare`uo_navi within w_ja036f
end type

type ln_temptop_shadow from wt_listshare`ln_temptop_shadow within w_ja036f
end type

type st_windelaytime from wt_listshare`st_windelaytime within w_ja036f
end type

type st_top_rect from wt_listshare`st_top_rect within w_ja036f
end type

type p_close from wt_listshare`p_close within w_ja036f
end type

type p_excel from wt_listshare`p_excel within w_ja036f
end type

type p_print from wt_listshare`p_print within w_ja036f
end type

type p_delete from wt_listshare`p_delete within w_ja036f
end type

type p_update from wt_listshare`p_update within w_ja036f
end type

type p_input from wt_listshare`p_input within w_ja036f
end type

type p_retrieve from wt_listshare`p_retrieve within w_ja036f
end type

type p_clear from wt_listshare`p_clear within w_ja036f
end type

type p_copy from wt_listshare`p_copy within w_ja036f
end type

type dw_c from wt_listshare`dw_c within w_ja036f
string title = "기준일자@조회구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_valid;call super::ue_valid;IF Object.dddw [1]='2'  Then
   dw_list.uf_dataobject ('d_ja036f1', FALSE, dw_master, 'd_ja036f2')
Else
   dw_list.uf_dataobject ('d_ja036f1_krw', FALSE, dw_master, 'd_ja036f2_krw')
End IF
RETURN TRUE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', gaa.corp_gr, '1,원화계좌,,2,외화계좌,', 1, '')
end event

type btn_update from wt_listshare`btn_update within w_ja036f
end type

type st_count from wt_listshare`st_count within w_ja036f
end type

type dw_list from wt_listshare`dw_list within w_ja036f
string dataobject = "d_ja036f1"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'jasan_gb', gaa.corp_gr, '', 51, "")
F_DDDWCTL (dw_master, 'trustee', gaa.corp_gr, '', 1, "") 
end event

type dw_master from wt_listshare`dw_master within w_ja036f
integer x = 1792
integer y = 1224
integer width = 3561
integer height = 1436
string dataobject = "d_ja036f2"
end type

