forward
global type w_szx0ym from wt_vertdetail
end type
end forward

global type w_szx0ym from wt_vertdetail
boolean eb_direct_retrieve = true
end type
global w_szx0ym w_szx0ym

on w_szx0ym.create
int iCurrent
call super::create
end on

on w_szx0ym.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ()
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_szx0ym
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_szx0ym
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_szx0ym
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_szx0ym
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_szx0ym
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_szx0ym
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_szx0ym
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_szx0ym
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_szx0ym
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_szx0ym
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_szx0ym
end type

type uo_navi from wt_vertdetail`uo_navi within w_szx0ym
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_szx0ym
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_szx0ym
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_szx0ym
end type

type p_close from wt_vertdetail`p_close within w_szx0ym
end type

type p_excel from wt_vertdetail`p_excel within w_szx0ym
end type

type p_print from wt_vertdetail`p_print within w_szx0ym
end type

type p_delete from wt_vertdetail`p_delete within w_szx0ym
end type

type p_update from wt_vertdetail`p_update within w_szx0ym
end type

type p_input from wt_vertdetail`p_input within w_szx0ym
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_szx0ym
end type

type p_clear from wt_vertdetail`p_clear within w_szx0ym
end type

type p_copy from wt_vertdetail`p_copy within w_szx0ym
end type

type dw_c from wt_vertdetail`dw_c within w_szx0ym
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_vertdetail`btn_update within w_szx0ym
end type

type st_count from wt_vertdetail`st_count within w_szx0ym
end type

type dw_list from wt_vertdetail`dw_list within w_szx0ym
integer y = 156
integer height = 2608
string dataobject = "d_szx0ym_1"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'ymd_gb'
      LONG	lRow, lRowCount

      lRowCount = dw_detail.rowcount ()
      FOR  lRow = 1  TO  lRowCount
         dw_detail.object.ymd_gb [lRow] = data
      NEXT
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;IF AncestorReturnVALUE=1 THEN RETURN 1

uf_setcolumn ('corp_gr', '%')
uf_setcolumn ('gr_cd', 'HX')

POST SetColumn ('ymd_gb')

RETURN 0
end event

type dw_detail from wt_vertdetail`dw_detail within w_szx0ym
integer y = 156
integer height = 2608
string dataobject = "d_szx0ym_2"
end type

event dw_detail::ue_insertstart;call super::ue_insertstart;IF AncestorReturnVALUE=1 THEN RETURN 1

uf_SetColumn ('ymd_gb', dw_list.object.ymd_gb [iRow])

POST SetColumn ('ymd_id')

RETURN 0
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;f_visible (THIS, (dw_list.object.ymd_gb [iRow]='Y' OR dw_list.object.ymd_gb [iRow]='M'), 'ss_dae_cd')
f_visible (THIS, (dw_list.object.ymd_gb [iRow]='M'), 'srs_mm,call_mm,put_mm')
retrieve (dw_list.object.ymd_gb [iRow])
end event

type st_move from wt_vertdetail`st_move within w_szx0ym
integer y = 156
integer height = 2608
end type

