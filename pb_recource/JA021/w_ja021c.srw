forward
global type w_ja021c from wt_tab
end type
type tabpage_1 from u_ja021c_t1 within tab_subpage
end type
type tabpage_1 from u_ja021c_t1 within tab_subpage
end type
type tabpage_3 from u_ja021c_t3 within tab_subpage
end type
type tabpage_3 from u_ja021c_t3 within tab_subpage
end type
type tabpage_4 from u_ja021c_t4 within tab_subpage
end type
type tabpage_4 from u_ja021c_t4 within tab_subpage
end type
end forward

global type w_ja021c from wt_tab
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
end type
global w_ja021c w_ja021c

on w_ja021c.create
int iCurrent
call super::create
end on

on w_ja021c.destroy
call super::destroy
end on

event wue_postopen;call super::wue_postopen;tab_string [1] = ''
end event

event activate;call super::activate;tab_string [1] = ''
end event

event open;call super::open;tab_string [1] = ''
end event

type lb_dirlist from wt_tab`lb_dirlist within w_ja021c
end type

type ln_templeft from wt_tab`ln_templeft within w_ja021c
end type

type ln_tempbuttom from wt_tab`ln_tempbuttom within w_ja021c
end type

type ln_temptop from wt_tab`ln_temptop within w_ja021c
end type

type ln_tempbutton from wt_tab`ln_tempbutton within w_ja021c
end type

type ln_tempstart from wt_tab`ln_tempstart within w_ja021c
end type

type ln_cond1_yline from wt_tab`ln_cond1_yline within w_ja021c
end type

type ln_dw1_yline from wt_tab`ln_dw1_yline within w_ja021c
end type

type ln_cond2_yline from wt_tab`ln_cond2_yline within w_ja021c
end type

type ln_dw2_yline from wt_tab`ln_dw2_yline within w_ja021c
end type

type ln_tempright from wt_tab`ln_tempright within w_ja021c
end type

type uo_navi from wt_tab`uo_navi within w_ja021c
end type

type ln_temptop_shadow from wt_tab`ln_temptop_shadow within w_ja021c
end type

type st_windelaytime from wt_tab`st_windelaytime within w_ja021c
end type

type st_top_rect from wt_tab`st_top_rect within w_ja021c
end type

type p_close from wt_tab`p_close within w_ja021c
end type

type p_excel from wt_tab`p_excel within w_ja021c
end type

type p_print from wt_tab`p_print within w_ja021c
end type

type p_delete from wt_tab`p_delete within w_ja021c
end type

type p_update from wt_tab`p_update within w_ja021c
end type

type p_input from wt_tab`p_input within w_ja021c
end type

type p_retrieve from wt_tab`p_retrieve within w_ja021c
end type

type p_clear from wt_tab`p_clear within w_ja021c
end type

type p_copy from wt_tab`p_copy within w_ja021c
end type

type dw_c from wt_tab`dw_c within w_ja021c
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_tab`btn_update within w_ja021c
end type

type st_count from wt_tab`st_count within w_ja021c
end type

type tab_subpage from wt_tab`tab_subpage within w_ja021c
integer y = 156
integer height = 2608
tabpage_1 tabpage_1
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_subpage.create
this.tabpage_1=create tabpage_1
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_subpage.destroy
call super::destroy
destroy(this.tabpage_1)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event tab_subpage::selectionchanged;IF newindex>0 And oldindex<>newindex And enabled   Then
   //Control [newindex].picturename = Parent.picturename
   Control [newindex].TriggerEvent ('ue_subpage_Selected')
   IF gaa.debug THEN f_microhelp (string (Now ()) + 'tab_subpage selectionchanged')
End IF
end event

event tab_subpage::selectionchanging;IF oldindex>0 And oldindex<>newindex And enabled  Then
   IF Control [oldindex].DYNAMIC EVENT ue_wpage_modified () Then
      CHOOSE CASE f_messageBox ('W005', Control [oldindex].TEXT + '(selectionchanging)')
         CASE 1   // Update_OK
            IF Control [oldindex].DYNAMIC EVENT wue_update ()=-1 THEN RETURN 1
            f_microHelp (string (Now ()) + ' -> [' + TITLE + '] commit')
            Control [oldindex].DYNAMIC EVENT wue_clear_nocommit ()
         CASE 2   // Update_PASS
            //
         CASE 3   // Cancel
            RETURN 1
      END CHOOSE
   End IF
   Control [oldindex].picturename='Custom009!'
End IF
end event

type uo_tab from wt_tab`uo_tab within w_ja021c
end type

type tabpage_1 from u_ja021c_t1 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2480
string text = "중간배당(G15,회사별)"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   ts_find = "balh_co='" + tab_string [1] + "'"
	dw_pagelist.retrieve (gaa.corp_gr, idt_workdate)
Else
   dw_pagelist.uf_find ("balh_co='" + tab_string [1] + "'")
End IF
RETURN 1
end event

type tabpage_3 from u_ja021c_t3 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2480
string text = "현금중간배당확정(G23)"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   ts_find = "balh_co='" + tab_string [1] + "'"
   dw_pagelist.retrieve (gaa.corp_gr, idt_workdate)
Else
   dw_pagelist.uf_find ("balh_co='" + tab_string [1] + "'")
End IF
RETURN 1
end event

type tabpage_4 from u_ja021c_t4 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2480
string text = "주식중간배당확정(G23)"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   ts_find = "balh_co='" + tab_string [1] + "'"
   dw_pagelist.retrieve (gaa.corp_gr, idt_workdate)
Else
   dw_pagelist.uf_find ("balh_co='" + tab_string [1] + "'")
End IF
RETURN 1
end event

