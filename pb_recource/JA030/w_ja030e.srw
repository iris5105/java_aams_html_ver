forward
global type w_ja030e from wt_vertdetail
end type
end forward

global type w_ja030e from wt_vertdetail
boolean eb_direct_retrieve = true
boolean ib_managedata = false
end type
global w_ja030e w_ja030e

on w_ja030e.create
int iCurrent
call super::create
end on

on w_ja030e.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_print;dw_detail.EVENT ue_print ()
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja030e
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja030e
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja030e
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja030e
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja030e
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja030e
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja030e
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja030e
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja030e
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja030e
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja030e
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja030e
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja030e
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja030e
end type

type p_close from wt_vertdetail`p_close within w_ja030e
end type

type p_excel from wt_vertdetail`p_excel within w_ja030e
end type

type p_print from wt_vertdetail`p_print within w_ja030e
end type

type p_delete from wt_vertdetail`p_delete within w_ja030e
end type

type p_update from wt_vertdetail`p_update within w_ja030e
end type

type p_input from wt_vertdetail`p_input within w_ja030e
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja030e
end type

type p_clear from wt_vertdetail`p_clear within w_ja030e
end type

type p_copy from wt_vertdetail`p_copy within w_ja030e
end type

type dw_c from wt_vertdetail`dw_c within w_ja030e
string title = "영업일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertdetail`btn_update within w_ja030e
end type

type st_count from wt_vertdetail`st_count within w_ja030e
end type

type dw_list from wt_vertdetail`dw_list within w_ja030e
string dataobject = "d_ja030e1"
boolean eb_null_line = false
end type

type dw_detail from wt_vertdetail`dw_detail within w_ja030e
string dataobject = "d_ja030e2"
boolean ibsetlist4singleselect = false
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;Modify ("dt2.Text = '( " + string (dw_c.object.ymd [1],"yyyy.mm.dd") + " )'")
Modify ("company_name.Text = '" + gaa.corp_nm + "'")
Modify ("company_last.Text = '" + gaa.corp_nm + "'")

retrieve (gaa.corp_gr, dw_List.object.jm_cd [iRow], dw_List.object.jm_cd [iRow], string (dw_c.object.ymd [1],'yyyymmdd'))
end event

event dw_detail::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'bond_attr', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'ija_jigub_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'budo_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'danbok_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'halin_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'sangj_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'sunhu_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'chg_stock_gb', gaa.corp_gr, '', 1, '')
end event

type st_move from wt_vertdetail`st_move within w_ja030e
end type

