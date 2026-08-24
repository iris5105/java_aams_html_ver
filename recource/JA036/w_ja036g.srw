forward
global type w_ja036g from wt_listdetail
end type
end forward

global type w_ja036g from wt_listdetail
boolean eb_retrievewait = true
boolean ib_managedata = false
end type
global w_ja036g w_ja036g

event wue_lastopen;call super::wue_lastopen;dw_c.object.fymd [1] = f_first_ymd (Date (idt_workdate) )
dw_c.object.tymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.fymd [1], dw_c.object.tymd [1])
end event

on w_ja036g.create
int iCurrent
call super::create
end on

on w_ja036g.destroy
call super::destroy
end on

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja036g
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja036g
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja036g
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja036g
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja036g
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja036g
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja036g
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja036g
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja036g
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja036g
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja036g
end type

type uo_navi from wt_listdetail`uo_navi within w_ja036g
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja036g
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja036g
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja036g
end type

type p_close from wt_listdetail`p_close within w_ja036g
end type

type p_excel from wt_listdetail`p_excel within w_ja036g
end type

type p_print from wt_listdetail`p_print within w_ja036g
end type

type p_delete from wt_listdetail`p_delete within w_ja036g
end type

type p_update from wt_listdetail`p_update within w_ja036g
end type

type p_input from wt_listdetail`p_input within w_ja036g
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja036g
end type

type p_clear from wt_listdetail`p_clear within w_ja036g
end type

type p_copy from wt_listdetail`p_copy within w_ja036g
end type

type dw_c from wt_listdetail`dw_c within w_ja036g
string title = "영업일자구간"
string dataobject = "dc_ftymd"
end type

type btn_update from wt_listdetail`btn_update within w_ja036g
end type

type st_count from wt_listdetail`st_count within w_ja036g
end type

type dw_list from wt_listdetail`dw_list within w_ja036g
string dataobject = "d_ja036g1"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'jasan_gb', gaa.corp_gr, '', 51, "")
end event

type dw_detail from wt_listdetail`dw_detail within w_ja036g
string dataobject = "d_ja036g2"
boolean hsplitscroll = true
string islist4subbtnauth = "0010001001"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;IF dw_list.object.fund_currency [iRow]='KRW'   Then
   uf_dataobject ('d_ja036g2_krw', FALSE)
Else
   uf_dataobject ('d_ja036g2', FALSE)
End IF
MODIFY ("currency_t.text='" + dw_List.object.currency [iRow] + " 금 액'")
retrieve (gaa.corp_gr, dw_c.object.fymd [1], dw_c.object.tymd [1], dw_List.object.fund_cd [iRow], dw_List.object.jm_cd [iRow])
end event

type st_move from wt_listdetail`st_move within w_ja036g
end type

