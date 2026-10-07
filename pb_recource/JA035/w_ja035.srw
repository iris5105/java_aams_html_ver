forward
global type w_ja035 from wt_tab
end type
type tabpage_3 from u_ja035t1 within tab_subpage
end type
type tabpage_3 from u_ja035t1 within tab_subpage
end type
type tabpage_4 from u_ja035t2 within tab_subpage
end type
type tabpage_4 from u_ja035t2 within tab_subpage
end type
end forward

global type w_ja035 from wt_tab
boolean eb_direct_retrieve = true
string is_date_nation = "US"
end type
global w_ja035 w_ja035

on w_ja035.create
int iCurrent
call super::create
end on

on w_ja035.destroy
call super::destroy
end on

type lb_dirlist from wt_tab`lb_dirlist within w_ja035
end type

type ln_templeft from wt_tab`ln_templeft within w_ja035
end type

type ln_tempbuttom from wt_tab`ln_tempbuttom within w_ja035
end type

type ln_temptop from wt_tab`ln_temptop within w_ja035
end type

type ln_tempbutton from wt_tab`ln_tempbutton within w_ja035
end type

type ln_tempstart from wt_tab`ln_tempstart within w_ja035
end type

type ln_cond1_yline from wt_tab`ln_cond1_yline within w_ja035
end type

type ln_dw1_yline from wt_tab`ln_dw1_yline within w_ja035
end type

type ln_cond2_yline from wt_tab`ln_cond2_yline within w_ja035
end type

type ln_dw2_yline from wt_tab`ln_dw2_yline within w_ja035
end type

type ln_tempright from wt_tab`ln_tempright within w_ja035
end type

type uo_navi from wt_tab`uo_navi within w_ja035
end type

type ln_temptop_shadow from wt_tab`ln_temptop_shadow within w_ja035
end type

type st_windelaytime from wt_tab`st_windelaytime within w_ja035
end type

type st_top_rect from wt_tab`st_top_rect within w_ja035
end type

type p_close from wt_tab`p_close within w_ja035
end type

type p_excel from wt_tab`p_excel within w_ja035
end type

type p_print from wt_tab`p_print within w_ja035
end type

type p_delete from wt_tab`p_delete within w_ja035
end type

type p_update from wt_tab`p_update within w_ja035
end type

type p_input from wt_tab`p_input within w_ja035
end type

type p_retrieve from wt_tab`p_retrieve within w_ja035
end type

type p_clear from wt_tab`p_clear within w_ja035
end type

type p_copy from wt_tab`p_copy within w_ja035
end type

type dw_c from wt_tab`dw_c within w_ja035
boolean visible = false
end type

type btn_update from wt_tab`btn_update within w_ja035
end type

type st_count from wt_tab`st_count within w_ja035
end type

type tab_subpage from wt_tab`tab_subpage within w_ja035
integer y = 160
integer height = 2600
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_subpage.create
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
call super::create
this.Control[]={this.tabpage_3,&
this.tabpage_4}
end on

on tab_subpage.destroy
call super::destroy
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type uo_tab from wt_tab`uo_tab within w_ja035
end type

type tabpage_3 from u_ja035t1 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2472
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1 THEN dw_pageList.retrieve (gaa.corp_gr)
RETURN 0
end event

type tabpage_4 from u_ja035t2 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2472
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1 THEN dw_pageList.retrieve (gaa.corp_gr)
RETURN 0
end event

