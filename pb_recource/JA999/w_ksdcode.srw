forward
global type w_ksdcode from wt_vertdetail
end type
end forward

global type w_ksdcode from wt_vertdetail
boolean eb_direct_retrieve = true
end type
global w_ksdcode w_ksdcode

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ()
end event

on w_ksdcode.create
int iCurrent
call super::create
end on

on w_ksdcode.destroy
call super::destroy
end on

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ksdcode
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ksdcode
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ksdcode
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ksdcode
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ksdcode
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ksdcode
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ksdcode
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ksdcode
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ksdcode
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ksdcode
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ksdcode
end type

type uo_navi from wt_vertdetail`uo_navi within w_ksdcode
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ksdcode
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ksdcode
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ksdcode
end type

type p_close from wt_vertdetail`p_close within w_ksdcode
end type

type p_excel from wt_vertdetail`p_excel within w_ksdcode
end type

type p_print from wt_vertdetail`p_print within w_ksdcode
end type

type p_delete from wt_vertdetail`p_delete within w_ksdcode
end type

type p_update from wt_vertdetail`p_update within w_ksdcode
end type

type p_input from wt_vertdetail`p_input within w_ksdcode
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ksdcode
end type

type p_clear from wt_vertdetail`p_clear within w_ksdcode
end type

type p_copy from wt_vertdetail`p_copy within w_ksdcode
end type

type dw_c from wt_vertdetail`dw_c within w_ksdcode
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_vertdetail`btn_update within w_ksdcode
end type

type st_count from wt_vertdetail`st_count within w_ksdcode
end type

type dw_list from wt_vertdetail`dw_list within w_ksdcode
integer y = 156
integer height = 2608
string dataobject = "d_ksdcode_1"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow, lRowCount

CHOOSE CASE dwo.name
   CASE 'gr_cd'
      lRowCount = dw_Detail.rowcount ()
      FOR  lRow = 1  TO  lRowCount
         dw_detail.object.gr_cd [lRow] = data
      NEXT
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;IF AncestorReturnVALUE=1 THEN RETURN 1

uf_setColumn ('sebu_cd', '.' )

POST SetColumn ('gr_cd')

RETURN 0
end event

event dw_list::rowfocuschanging_return;call super::rowfocuschanging_return;IF AncestorReturnVALUE=1 THEN RETURN 1
IF Object.gr_cd [newrow]='K01'   Then
   dw_detail.is_resize_column = ''
   dw_detail.uf_dataobject ('d_ksdcode_k01', FALSE)
Else
   dw_detail.is_resize_column = 'sebu_cd_nm'
   dw_detail.uf_dataobject ('d_ksdcode_2', FALSE)
End IF
RETURN 0
end event

type dw_detail from wt_vertdetail`dw_detail within w_ksdcode
integer y = 156
integer height = 2608
string dataobject = "d_ksdcode_2"
string is_resize_column = "sebu_cd_nm"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.gr_cd [iRow])
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setColumn ('gr_cd', dw_List.object.gr_cd [iRow] )

POST SetColumn ('sebu_cd')

RETURN 0
end event

event dw_detail::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'grcd_f1', gaa.corp_gr, '', 1, '')
end event

type st_move from wt_vertdetail`st_move within w_ksdcode
integer y = 156
integer height = 2608
boolean leftmaxsizefixed = true
end type

