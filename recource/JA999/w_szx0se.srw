forward
global type w_szx0se from wt_list
end type
end forward

global type w_szx0se from wt_list
boolean eb_direct_retrieve = true
integer ii_dddw_width = 800
end type
global w_szx0se w_szx0se

on w_szx0se.create
int iCurrent
call super::create
end on

on w_szx0se.destroy
call super::destroy
end on

event open;call super::open;LONG	ll_size

dw_c.visible = gaa.admin
IF gaa.admin THEN ll_size = 0 ELSE ll_size = dw_list.y - dw_c.y
dw_list.y = dw_list.y - ll_size
dw_list.height = dw_list.height + ll_size
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = gaa.corp_gr
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
//IF NOT gaa.kfs THEN cb_1.POST EVENT Clicked ()
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (dw_c.object.dddw [1])
end event

type lb_dirlist from wt_list`lb_dirlist within w_szx0se
end type

type ln_templeft from wt_list`ln_templeft within w_szx0se
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_szx0se
end type

type ln_temptop from wt_list`ln_temptop within w_szx0se
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_szx0se
end type

type ln_tempstart from wt_list`ln_tempstart within w_szx0se
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_szx0se
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_szx0se
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_szx0se
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_szx0se
end type

type ln_tempright from wt_list`ln_tempright within w_szx0se
end type

type uo_navi from wt_list`uo_navi within w_szx0se
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_szx0se
end type

type st_windelaytime from wt_list`st_windelaytime within w_szx0se
end type

type st_top_rect from wt_list`st_top_rect within w_szx0se
end type

type p_close from wt_list`p_close within w_szx0se
end type

type p_excel from wt_list`p_excel within w_szx0se
end type

type p_print from wt_list`p_print within w_szx0se
end type

type p_delete from wt_list`p_delete within w_szx0se
end type

type p_update from wt_list`p_update within w_szx0se
end type

type p_input from wt_list`p_input within w_szx0se
end type

type p_retrieve from wt_list`p_retrieve within w_szx0se
end type

type p_clear from wt_list`p_clear within w_szx0se
end type

type p_copy from wt_list`p_copy within w_szx0se
end type

type dw_c from wt_list`dw_c within w_szx0se
string title = "자산운용(자문)사"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | corp_gr', gaa.corp_gr, '', 1, '')
end event

event dw_c::itemchanged;call super::itemchanged;F_DDDWCTL (dw_List, 'series_g1', gaa.corp_gr, '', 1, "corp_gr='" + data + "'")
end event

type btn_update from wt_list`btn_update within w_szx0se
end type

type st_count from wt_list`st_count within w_szx0se
end type

type dw_list from wt_list`dw_list within w_szx0se
string dataobject = "d_szx0se"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('corp_gr', dw_c.object.dddw [1])
uf_setColumn ('used', '1')
uf_setColumn ('magam_used', '0')
IF getrow ()>0 THEN uf_setColumn ('series_g1', Object.series_g1 [getrow ()])

POST SetColumn ('series_g2')

RETURN 0
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'series_g1'
      Object.series_gb [row] = data + Object.series_g2 [row]
   CASE 'series_g2'
      Object.series_gb [row] = Object.series_g1 [row] + data
END CHOOSE
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'series_g1', gaa.corp_gr, '', 1, "corp_gr='" + dw_c.object.dddw [1] + "'")
F_DDDWCTL (THIS, 'jy_fa_cd', gaa.corp_gr, '', 1, '')
f_dddwctl (THIS, 'bm_gr', gaa.corp_gr, '', 1, '')
f_dddwctl (THIS, 'gugan', '', ',,', 1, '')
f_dddwctl (THIS, 'ga', '', ',,', 1, '')
end event

event dw_list::updateend;call super::updateend;LONG	ll

STRING	ls_corp_gr, ls_old, ls_new

FOR  ll = 1  TO  rowcount ()
   IF GetItemStatus (ll, 'series_gb', Primary!)=DataModified!  Then
      ls_new = GetItemstring (ll, 'series_gb')
      ls_old = GetItemstring (ll, 'series_gb', Primary!, TRUE)

      ls_corp_gr = dw_c.object.dddw [1]

      UPDATE  szm0ia
         SET  series_gb = :ls_new
      WHERE   corp_gr   = :ls_corp_gr
        AND   series_gb = :ls_old;
	End IF
NEXT
end event

event dw_list::ue_protect;call super::ue_protect;f_setprotect (THIS, NOT gaa.aams, { 'jy_fa_cd' })
end event

