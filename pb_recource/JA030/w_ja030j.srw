forward
global type w_ja030j from wt_listdetail
end type
end forward

global type w_ja030j from wt_listdetail
boolean eb_direct_retrieve = true
boolean ib_managedata = false
end type
global w_ja030j w_ja030j

type variables

end variables

on w_ja030j.create
int iCurrent
call super::create
end on

on w_ja030j.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.fymd [1] = idt_workdate
dw_c.object.tymd [1] = idt_workdate
dw_detail.bringtotop = TRUE
end event

event wue_retrieve;STRING	ls_sql

CHOOSE CASE dw_c.object.gubun [1]
   CASE "1"
      ls_sql = dw_list.uf_sql_default ()
   CASE "3" // 채권속성별
      ls_sql = dw_list.uf_sql_default () + " and hj.cash_cd like '" + dw_c.object.cash_cd [1] + "' "
   CASE "5" // 종목별
      ls_sql = dw_list.uf_sql_default () + " and hj.jm_cd = '" + f_nvl (dw_c.object.hj_cd [1],'') + "' "
   CASE "6" // 펀드별
      ls_sql = dw_list.uf_sql_default () + " and ia.fund_cd = '" + f_nvl (dw_c.object.fund_cd [1],'') + "' "
END CHOOSE

dw_list.Modify ("DataWindow.Table.Select = ~" " + ls_sql + "~" ")
dw_list.retrieve (gaa.corp_gr, dw_c.object.fymd [1], dw_c.object.tymd [1])
end event

event resize;call super::resize;dw_List.Width = Width - 125 - dw_List.X
dw_List.Height = Height - dw_List.Y - 185

dw_detail.x = dw_list.x + dw_list.width - dw_detail.width - 50
dw_detail.y = dw_list.y + dw_list.height - dw_detail.height - 220
dw_detail.bringtotop = TRUE
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja030j
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja030j
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja030j
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja030j
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja030j
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja030j
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja030j
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja030j
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja030j
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja030j
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja030j
end type

type uo_navi from wt_listdetail`uo_navi within w_ja030j
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja030j
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja030j
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja030j
end type

type p_close from wt_listdetail`p_close within w_ja030j
end type

type p_excel from wt_listdetail`p_excel within w_ja030j
end type

type p_print from wt_listdetail`p_print within w_ja030j
end type

type p_delete from wt_listdetail`p_delete within w_ja030j
end type

type p_update from wt_listdetail`p_update within w_ja030j
end type

type p_input from wt_listdetail`p_input within w_ja030j
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja030j
end type

type p_clear from wt_listdetail`p_clear within w_ja030j
end type

type p_copy from wt_listdetail`p_copy within w_ja030j
end type

type dw_c from wt_listdetail`dw_c within w_ja030j
string dataobject = "d_ja030j"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'cash_cd', gaa.corp_gr, '%,전체,', 1, '')
F_DDDWCTL (THIS, 'type_gb', gaa.corp_gr, '%,전체,', 1, '')
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'hj_cd'
      rs_Where = "sanghw_ymd > '" + string (Object.fymd [1]) + "'"
   CASE 'fund_cd'
      rs_Where = "(haeji_ymd >= '" + string (Object.fymd [1]) + "' or haeji_ymd is null)"
      RETURN 2
END CHOOSE
RETURN 1
end event

event dw_c::ue_valid;call super::ue_valid;CHOOSE CASE Object.gubun [1]
   CASE '1','2','3'
      dw_list.uf_dataobject ('d_ja030j1', FALSE)
   CASE ELSE
      dw_list.uf_dataobject ('d_ja030j'+dw_c.object.gubun [1], FALSE)
END CHOOSE
RETURN TRUE
end event

type btn_update from wt_listdetail`btn_update within w_ja030j
end type

type st_count from wt_listdetail`st_count within w_ja030j
end type

type dw_list from wt_listdetail`dw_list within w_ja030j
integer height = 2416
string dataobject = "d_ja030j1"
boolean scaletobottom = true
end type

type dw_detail from wt_listdetail`dw_detail within w_ja030j
integer x = 3392
integer y = 1668
integer width = 1998
integer height = 988
boolean titlebar = true
string dataobject = "d_ja030jp"
boolean hscrollbar = false
boolean vscrollbar = false
boolean scaletoright = false
boolean scaletobottom = false
boolean ibsetlist4subbtn = false
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, string (dw_list.object.ymd [iRow],'yyyymmdd'), dw_list.object.fund_cd [iRow], dw_list.object.jm_cd [iRow])
end event

type st_move from wt_listdetail`st_move within w_ja030j
boolean visible = false
boolean enabled = false
end type

