forward
global type w_ja010m1 from wt_tabvert
end type
type tabpage_1 from u_ja010m1_t1 within tab_subpage
end type
type tabpage_1 from u_ja010m1_t1 within tab_subpage
end type
type tabpage_2 from u_ja010m1_t2 within tab_subpage
end type
type tabpage_2 from u_ja010m1_t2 within tab_subpage
end type
type tabpage_3 from u_ja010m1_t3 within tab_subpage
end type
type tabpage_3 from u_ja010m1_t3 within tab_subpage
end type
end forward

global type w_ja010m1 from wt_tabvert
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
end type
global w_ja010m1 w_ja010m1

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr)
end event

on w_ja010m1.create
int iCurrent
call super::create
end on

on w_ja010m1.destroy
call super::destroy
end on

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_tabvert`lb_dirlist within w_ja010m1
end type

type ln_templeft from wt_tabvert`ln_templeft within w_ja010m1
end type

type ln_tempbuttom from wt_tabvert`ln_tempbuttom within w_ja010m1
end type

type ln_temptop from wt_tabvert`ln_temptop within w_ja010m1
end type

type ln_tempbutton from wt_tabvert`ln_tempbutton within w_ja010m1
end type

type ln_tempstart from wt_tabvert`ln_tempstart within w_ja010m1
end type

type ln_cond1_yline from wt_tabvert`ln_cond1_yline within w_ja010m1
end type

type ln_dw1_yline from wt_tabvert`ln_dw1_yline within w_ja010m1
end type

type ln_cond2_yline from wt_tabvert`ln_cond2_yline within w_ja010m1
end type

type ln_dw2_yline from wt_tabvert`ln_dw2_yline within w_ja010m1
end type

type ln_tempright from wt_tabvert`ln_tempright within w_ja010m1
end type

type uo_navi from wt_tabvert`uo_navi within w_ja010m1
end type

type ln_temptop_shadow from wt_tabvert`ln_temptop_shadow within w_ja010m1
end type

type st_windelaytime from wt_tabvert`st_windelaytime within w_ja010m1
end type

type st_top_rect from wt_tabvert`st_top_rect within w_ja010m1
end type

type p_close from wt_tabvert`p_close within w_ja010m1
end type

type p_excel from wt_tabvert`p_excel within w_ja010m1
end type

type p_print from wt_tabvert`p_print within w_ja010m1
end type

type p_delete from wt_tabvert`p_delete within w_ja010m1
end type

type p_update from wt_tabvert`p_update within w_ja010m1
end type

type p_input from wt_tabvert`p_input within w_ja010m1
end type

type p_retrieve from wt_tabvert`p_retrieve within w_ja010m1
end type

type p_clear from wt_tabvert`p_clear within w_ja010m1
end type

type p_copy from wt_tabvert`p_copy within w_ja010m1
end type

type dw_c from wt_tabvert`dw_c within w_ja010m1
boolean visible = false
end type

type btn_update from wt_tabvert`btn_update within w_ja010m1
end type

type st_count from wt_tabvert`st_count within w_ja010m1
end type

type tab_subpage from wt_tabvert`tab_subpage within w_ja010m1
integer y = 156
integer height = 2608
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

type dw_list from wt_tabvert`dw_list within w_ja010m1
integer y = 156
integer height = 2608
string dataobject = "d_ja010m1"
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt

DEC	ldc

CHOOSE CASE dwo.name
   CASE 'iik_bunbae_aek'
      Object.tuja_suik_rt [row] = dec(data) / dec(Object.wonbon_aek [row])
      Object.tuja_suik_per [row] = dec(data) / dec(Object.wonbon_aek [row]) * 100

   CASE 'tuja_suik_per'
      Object.tuja_suk_rt [row] = dec(data) / 100

   CASE 'gyul_ymd'
      ldt = datetime(date(MID (data,1,10)))

      SELECT  ADD_MONTHS (:ldt, -12)
        INTO  :ldt
      FROM    dual;

      Object.bf_gyul_ymd [row] = ldt
END CHOOSE
end event

type uo_tab from wt_tabvert`uo_tab within w_ja010m1
end type

type st_tab_move from wt_tabvert`st_tab_move within w_ja010m1
integer y = 156
integer height = 2608
end type

type tabpage_1 from u_ja010m1_t1 within tab_subpage
integer x = 18
integer y = 112
integer width = 3049
integer height = 2480
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   td_gyul_ymd = dw_List.object.gyul_ymd [iRow]
   ts_fund_cd = dw_List.object.fund_cd [iRow]
   ole_rd.EVENT ue_retrieve (0)
End IF
RETURN 0
end event

type tabpage_2 from u_ja010m1_t2 within tab_subpage
integer x = 18
integer y = 112
integer width = 3049
integer height = 2480
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   td_gyul_ymd = dw_List.object.gyul_ymd [iRow]
   ts_fund_cd = dw_List.object.fund_cd [iRow]
   ole_rd.EVENT ue_retrieve (0)
End IF
RETURN 0
end event

type tabpage_3 from u_ja010m1_t3 within tab_subpage
integer x = 18
integer y = 112
integer width = 3049
integer height = 2480
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   td_gyul_ymd = dw_List.object.gyul_ymd [iRow]
   ts_fund_cd = dw_List.object.fund_cd [iRow]
   ole_rd.EVENT ue_retrieve (0)
End IF
RETURN 0
end event

