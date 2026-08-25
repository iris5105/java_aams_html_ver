forward
global type w_ja021b from wt_tabvert
end type
type tabpage_1 from u_ja021b_t1 within tab_subpage
end type
type tabpage_1 from u_ja021b_t1 within tab_subpage
end type
type tabpage_2 from u_ja021b_t2 within tab_subpage
end type
type tabpage_2 from u_ja021b_t2 within tab_subpage
end type
type tabpage_3 from u_ja021b_t3 within tab_subpage
end type
type tabpage_3 from u_ja021b_t3 within tab_subpage
end type
type tabpage_4 from u_ja021b_t4 within tab_subpage
end type
type tabpage_4 from u_ja021b_t4 within tab_subpage
end type
type tabpage_5 from u_ja021b_t5 within tab_subpage
end type
type tabpage_5 from u_ja021b_t5 within tab_subpage
end type
end forward

global type w_ja021b from wt_tabvert
string is_find = "corp_gr=~'~'"
string is_init_value = "자산운용"
end type
global w_ja021b w_ja021b

on w_ja021b.create
int iCurrent
call super::create
end on

on w_ja021b.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;STRING	ls_ym, ls_corp_pos

ls_ym = dw_c.object.ym [1]

SELECT  listagg(distinct corp_gr,',')
  INTO  :ls_corp_pos
FROM    sjt0bm t1
WHERE   corp_gr LIKE '%'
  AND   ymd     Between  to_date (:ls_ym,'yyyymm') And last_day(to_date (:ls_ym,'yyyymm'));

ls_corp_pos = SQLCA.getitemstring (1)

dw_list.setfilter ("POS ('" + f_nvl (ls_corp_pos,'') + "',corp_gr)>0")
is_find = "corp_gr='" + gaa.corp_gr + "'"
ia_value [1] = dw_c.object.dddw [1]
IF gaa.aams	Then
	dw_list.retrieve ('%', ia_value [1])
Else
	dw_list.retrieve (gaa.corp_gr, ia_value [1])
End IF

tab_subpage.enabled = TRUE
tab_string [1] = ''
tab_subpage.TabTriggerEvent ('ue_subpage_reset')
tab_subpage.TabTriggerEvent ('ue_subpage_reset_flag')
tab_subpage.Control [1].PostEvent ('ue_subpage_Selected')
end event

event wue_lastopen;call super::wue_lastopen;STRING	ls_ym

IF	string (idt_workdate,'dd')<'10'	Then
	SELECT  TO_CHAR(add_months (:idt_workdate, -1),'yyyymm')
	  INTO  :ls_ym
	FROM    dual;
Else
	SELECT  TO_CHAR(:idt_workdate,'yyyymm')
	  INTO  :ls_ym
	FROM    dual;
End IF

ls_ym = SQLCA.getitemstring (1)

f_setprotect (dw_c, NOT (gaa.admin OR gaa.aams), { 'dddw' })
dw_c.object.ym [1] = ls_ym
dw_c.object.dddw [1] = gaa.customer_gr
end event

event activate;call super::activate;tab_string [1] = ''
end event

event open;call super::open;tab_string [1] = ''
end event

type lb_dirlist from wt_tabvert`lb_dirlist within w_ja021b
end type

type ln_templeft from wt_tabvert`ln_templeft within w_ja021b
end type

type ln_tempbuttom from wt_tabvert`ln_tempbuttom within w_ja021b
end type

type ln_temptop from wt_tabvert`ln_temptop within w_ja021b
end type

type ln_tempbutton from wt_tabvert`ln_tempbutton within w_ja021b
end type

type ln_tempstart from wt_tabvert`ln_tempstart within w_ja021b
end type

type ln_cond1_yline from wt_tabvert`ln_cond1_yline within w_ja021b
end type

type ln_dw1_yline from wt_tabvert`ln_dw1_yline within w_ja021b
end type

type ln_cond2_yline from wt_tabvert`ln_cond2_yline within w_ja021b
end type

type ln_dw2_yline from wt_tabvert`ln_dw2_yline within w_ja021b
end type

type ln_tempright from wt_tabvert`ln_tempright within w_ja021b
end type

type uo_navi from wt_tabvert`uo_navi within w_ja021b
end type

type ln_temptop_shadow from wt_tabvert`ln_temptop_shadow within w_ja021b
end type

type st_windelaytime from wt_tabvert`st_windelaytime within w_ja021b
end type

type p_close from wt_tabvert`p_close within w_ja021b
end type

type p_excel from wt_tabvert`p_excel within w_ja021b
end type

type p_print from wt_tabvert`p_print within w_ja021b
end type

type p_delete from wt_tabvert`p_delete within w_ja021b
end type

type p_update from wt_tabvert`p_update within w_ja021b
end type

type p_input from wt_tabvert`p_input within w_ja021b
end type

type p_retrieve from wt_tabvert`p_retrieve within w_ja021b
end type

type p_clear from wt_tabvert`p_clear within w_ja021b
end type

type p_copy from wt_tabvert`p_copy within w_ja021b
end type

type dw_c from wt_tabvert`dw_c within w_ja021b
string tag = "확정배당 종목별등록은 확정일자 더블클릭"
string title = "배당공시월@회사그룹"
string dataobject = "dc_dddw_ym"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', gaa.corp_gr, '자산운용,자산운용,,자문회사,자문회사,', 1, '')
end event

type btn_update from wt_tabvert`btn_update within w_ja021b
end type

type st_count from wt_tabvert`st_count within w_ja021b
end type

type tab_subpage from wt_tabvert`tab_subpage within w_ja021b
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_subpage.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_subpage.destroy
call super::destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

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
End IF
end event

type dw_list from wt_tabvert`dw_list within w_ja021b
string dataobject = "dl_corp_gr"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

type uo_tab from wt_tabvert`uo_tab within w_ja021b
end type

type st_tab_move from wt_tabvert`st_tab_move within w_ja021b
end type

type tabpage_1 from u_ja021b_t1 within tab_subpage
integer x = 18
integer y = 112
integer width = 3049
integer height = 2288
string text = "예상배당공시"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
	ts_find = "balh_co='" + tab_string [1] + "'"
	IF	gaa.aams	Then
		dw_pagelist.retrieve ('%', dw_c.object.ym [1], dw_c.object.dddw [1])
	Else
		dw_pagelist.retrieve (gaa.corp_gr, dw_c.object.ym [1], dw_c.object.dddw [1])
	End IF
Else
	dw_pagelist.uf_find ("balh_co='" + tab_string [1] + "'")
End IF
RETURN 1
end event

type tabpage_2 from u_ja021b_t2 within tab_subpage
integer x = 18
integer y = 112
integer width = 3049
integer height = 2288
string text = "운용사별예상배당"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   IF iRow>0   Then
      gs_corp_gr = dw_list.object.corp_gr [iRow]
   Else
      gs_corp_gr = gaa.corp_gr
   End IF
   ts_find = "balh_co='" + tab_string [1] + "'"
   dw_pagelist.retrieve (gs_corp_gr, dw_c.object.ym [1], idt_workdate)
Else
   dw_pagelist.uf_find ("balh_co='" + tab_string [1] + "'")
End IF
RETURN 1
end event

type tabpage_3 from u_ja021b_t3 within tab_subpage
integer x = 18
integer y = 112
integer width = 3049
integer height = 2288
string text = "현금확정배당(G20)"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   gs_customer_gr = dw_c.object.dddw [1]
   ts_find = "balh_co='" + tab_string [1] + "'"
   dw_pagelist.retrieve (gs_customer_gr, dw_c.object.ym [1], idt_workdate)
Else
   dw_pagelist.uf_find ("balh_co='" + tab_string [1] + "'")
End IF
RETURN 1
end event

type tabpage_4 from u_ja021b_t4 within tab_subpage
integer x = 18
integer y = 112
integer width = 3049
integer height = 2288
string text = "주식확정배당(G20)"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   gs_customer_gr = dw_c.object.dddw [1]
   ts_find = "balh_co='" + tab_string [1] + "'"
   dw_pagelist.retrieve (gs_customer_gr, dw_c.object.ym [1], idt_workdate)
Else
   dw_pagelist.uf_find ("balh_co='" + tab_string [1] + "'")
End IF
RETURN 1
end event

type tabpage_5 from u_ja021b_t5 within tab_subpage
integer x = 18
integer y = 112
integer width = 3049
integer height = 2288
string text = "2차(주총)확정(G25)"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   gs_customer_gr = dw_c.object.dddw [1]
   ts_find = "balh_co='" + tab_string [1] + "'"
   dw_pagelist.retrieve (gs_customer_gr, dw_c.object.ym [1], idt_workdate)
Else
   dw_pagelist.uf_find ("balh_co='" + tab_string [1] + "'")
End IF
RETURN 1
end event

