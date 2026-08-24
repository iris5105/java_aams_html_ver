forward
global type w_ja020a from wt_tab
end type
type tabpage_1 from u_ja020a_t1 within tab_subpage
end type
type tabpage_1 from u_ja020a_t1 within tab_subpage
end type
type tabpage_4 from u_ja020a_t4 within tab_subpage
end type
type tabpage_4 from u_ja020a_t4 within tab_subpage
end type
type tabpage_5 from u_ja020a_t5 within tab_subpage
end type
type tabpage_5 from u_ja020a_t5 within tab_subpage
end type
end forward

global type w_ja020a from wt_tab
boolean eb_direct_retrieve = true
end type
global w_ja020a w_ja020a

type variables

end variables

on w_ja020a.create
int iCurrent
call super::create
end on

on w_ja020a.destroy
call super::destroy
end on

event open;tab_string [1] = ''
call super::open
end event

type lb_dirlist from wt_tab`lb_dirlist within w_ja020a
end type

type ln_templeft from wt_tab`ln_templeft within w_ja020a
end type

type ln_tempbuttom from wt_tab`ln_tempbuttom within w_ja020a
end type

type ln_temptop from wt_tab`ln_temptop within w_ja020a
end type

type ln_tempbutton from wt_tab`ln_tempbutton within w_ja020a
end type

type ln_tempstart from wt_tab`ln_tempstart within w_ja020a
end type

type ln_cond1_yline from wt_tab`ln_cond1_yline within w_ja020a
end type

type ln_dw1_yline from wt_tab`ln_dw1_yline within w_ja020a
end type

type ln_cond2_yline from wt_tab`ln_cond2_yline within w_ja020a
end type

type ln_dw2_yline from wt_tab`ln_dw2_yline within w_ja020a
end type

type ln_tempright from wt_tab`ln_tempright within w_ja020a
end type

type uo_navi from wt_tab`uo_navi within w_ja020a
end type

type ln_temptop_shadow from wt_tab`ln_temptop_shadow within w_ja020a
end type

type st_windelaytime from wt_tab`st_windelaytime within w_ja020a
end type

type st_top_rect from wt_tab`st_top_rect within w_ja020a
end type

type p_close from wt_tab`p_close within w_ja020a
end type

type p_excel from wt_tab`p_excel within w_ja020a
end type

type p_print from wt_tab`p_print within w_ja020a
end type

type p_delete from wt_tab`p_delete within w_ja020a
end type

type p_update from wt_tab`p_update within w_ja020a
end type

type p_input from wt_tab`p_input within w_ja020a
end type

type p_retrieve from wt_tab`p_retrieve within w_ja020a
end type

type p_clear from wt_tab`p_clear within w_ja020a
end type

type p_copy from wt_tab`p_copy within w_ja020a
end type

type dw_c from wt_tab`dw_c within w_ja020a
boolean visible = false
boolean enabled = false
string title = ""
end type

type btn_update from wt_tab`btn_update within w_ja020a
end type

type st_count from wt_tab`st_count within w_ja020a
end type

type tab_subpage from wt_tab`tab_subpage within w_ja020a
integer y = 156
integer height = 2608
tabpage_1 tabpage_1
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_subpage.create
this.tabpage_1=create tabpage_1
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_subpage.destroy
call super::destroy
destroy(this.tabpage_1)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type uo_tab from wt_tab`uo_tab within w_ja020a
end type

type tabpage_1 from u_ja020a_t1 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2480
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   ts_find = "jc_join='" + tab_string [1] + "'"
   dw_pagelist.retrieve (gaa.corp_gr)
Else
   dw_pagelist.uf_find ("jc_join='" + tab_string [1] + "'")
End IF
RETURN 1
end event

event constructor;call super::constructor;gs_corp_gr = gaa.corp_gr
end event

type tabpage_4 from u_ja020a_t4 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2480
string text = "배정등록(청약주수)"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   ts_find = "jc_join='" + tab_string [1] + "'"
   dw_pagelist.retrieve (gaa.corp_gr)
Else
   dw_pagelist.uf_find ("jc_join='" + tab_string [1] + "'")
End IF
RETURN 1
end event

event constructor;call super::constructor;gs_corp_gr = gaa.corp_gr
gs_cy_type = '2'
end event

type tabpage_5 from u_ja020a_t5 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2480
string text = "수요예측참여총괄표"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   ts_find = "jc_join='" + tab_string [1] + "'"
   dw_pagelist.retrieve (gaa.corp_gr, idt_workdate)
Else
   dw_pagelist.uf_find ("jc_join='" + tab_string [1] + "'")
End IF
RETURN 1
end event

