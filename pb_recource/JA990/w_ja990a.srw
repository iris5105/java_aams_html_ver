forward
global type w_ja990a from wt_tab
end type
type tabpage_1 from u_ja990a_t1 within tab_subpage
end type
type tabpage_1 from u_ja990a_t1 within tab_subpage
end type
type tabpage_2 from u_ja990a_t2 within tab_subpage
end type
type tabpage_2 from u_ja990a_t2 within tab_subpage
end type
type tabpage_3 from u_ja990a_t3 within tab_subpage
end type
type tabpage_3 from u_ja990a_t3 within tab_subpage
end type
end forward

global type w_ja990a from wt_tab
boolean eb_direct_retrieve = true
end type
global w_ja990a w_ja990a

on w_ja990a.create
int iCurrent
call super::create
end on

on w_ja990a.destroy
call super::destroy
end on

type lb_dirlist from wt_tab`lb_dirlist within w_ja990a
end type

type ln_templeft from wt_tab`ln_templeft within w_ja990a
end type

type ln_tempbuttom from wt_tab`ln_tempbuttom within w_ja990a
end type

type ln_temptop from wt_tab`ln_temptop within w_ja990a
end type

type ln_tempbutton from wt_tab`ln_tempbutton within w_ja990a
end type

type ln_tempstart from wt_tab`ln_tempstart within w_ja990a
end type

type ln_cond1_yline from wt_tab`ln_cond1_yline within w_ja990a
end type

type ln_dw1_yline from wt_tab`ln_dw1_yline within w_ja990a
end type

type ln_cond2_yline from wt_tab`ln_cond2_yline within w_ja990a
end type

type ln_dw2_yline from wt_tab`ln_dw2_yline within w_ja990a
end type

type ln_tempright from wt_tab`ln_tempright within w_ja990a
end type

type uo_navi from wt_tab`uo_navi within w_ja990a
end type

type ln_temptop_shadow from wt_tab`ln_temptop_shadow within w_ja990a
end type

type st_windelaytime from wt_tab`st_windelaytime within w_ja990a
end type

type p_close from wt_tab`p_close within w_ja990a
end type

type p_excel from wt_tab`p_excel within w_ja990a
end type

type p_print from wt_tab`p_print within w_ja990a
end type

type p_delete from wt_tab`p_delete within w_ja990a
end type

type p_update from wt_tab`p_update within w_ja990a
end type

type p_input from wt_tab`p_input within w_ja990a
end type

type p_retrieve from wt_tab`p_retrieve within w_ja990a
end type

type p_clear from wt_tab`p_clear within w_ja990a
end type

type p_copy from wt_tab`p_copy within w_ja990a
end type

type dw_c from wt_tab`dw_c within w_ja990a
boolean visible = false
end type

type btn_update from wt_tab`btn_update within w_ja990a
end type

type st_count from wt_tab`st_count within w_ja990a
end type

type tab_subpage from wt_tab`tab_subpage within w_ja990a
integer y = 160
integer height = 2604
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_subpage.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_subpage.destroy
call super::destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type uo_tab from wt_tab`uo_tab within w_ja990a
end type

type tabpage_1 from u_ja990a_t1 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2476
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1 THEN dw_pageList.retrieve ()
RETURN   AncestorReturnVALUE
end event

type tabpage_2 from u_ja990a_t2 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2476
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1 THEN dw_pageList.retrieve ()
RETURN   AncestorReturnVALUE
end event

type tabpage_3 from u_ja990a_t3 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2476
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1 THEN dw_pageList.retrieve ()
RETURN   AncestorReturnVALUE
end event

