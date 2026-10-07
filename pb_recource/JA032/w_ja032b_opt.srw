forward
global type w_ja032b_opt from wt_listdetail
end type
type dw_fund from u_dw within w_ja032b_opt
end type
end forward

global type w_ja032b_opt from wt_listdetail
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "fund_cd=~'~'"
boolean ib_managedata = false
dw_fund dw_fund
end type
global w_ja032b_opt w_ja032b_opt

type variables
DATETIME	idt_f
end variables

on w_ja032b_opt.create
int iCurrent
call super::create
this.dw_fund=create dw_fund
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_fund
end on

on w_ja032b_opt.destroy
call super::destroy
destroy(this.dw_fund)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;idt_f = dw_c.object.ymd [1]

SELECT fymd
  INTO :idt_f
  FROM USPM_PORT t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.TYMD    = :idt_f
   AND ROWNUM = 1 ;

idt_f = SQLCA.GETITEMDATETIME (1)

is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_fund.retrieve (gaa.CORP_GR, dw_c.object.ymd [1])
end event

event ue_activate;call super::ue_activate;IF dw_fund.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja032b_opt
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja032b_opt
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja032b_opt
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja032b_opt
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja032b_opt
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja032b_opt
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja032b_opt
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja032b_opt
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja032b_opt
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja032b_opt
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja032b_opt
end type

type uo_navi from wt_listdetail`uo_navi within w_ja032b_opt
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja032b_opt
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja032b_opt
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja032b_opt
end type

type p_close from wt_listdetail`p_close within w_ja032b_opt
end type

type p_excel from wt_listdetail`p_excel within w_ja032b_opt
end type

type p_print from wt_listdetail`p_print within w_ja032b_opt
end type

type p_delete from wt_listdetail`p_delete within w_ja032b_opt
end type

type p_update from wt_listdetail`p_update within w_ja032b_opt
end type

type p_input from wt_listdetail`p_input within w_ja032b_opt
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja032b_opt
end type

type p_clear from wt_listdetail`p_clear within w_ja032b_opt
end type

type p_copy from wt_listdetail`p_copy within w_ja032b_opt
end type

type dw_c from wt_listdetail`dw_c within w_ja032b_opt
string title = "조회기준일"
string dataobject = "dc_ymd"
end type

type btn_update from wt_listdetail`btn_update within w_ja032b_opt
end type

type st_count from wt_listdetail`st_count within w_ja032b_opt
end type

type dw_list from wt_listdetail`dw_list within w_ja032b_opt
integer x = 1888
integer width = 3543
string dataobject = "d_ja032b"
end type

type dw_detail from wt_listdetail`dw_detail within w_ja032b_opt
string dataobject = "d_ja032b_opt"
string islist4subbtnauth = "0010001001"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;IF	POS (dw_list.object.yj_cd [iRow],':')=0	Then
	uf_dataobject ('d_ja032b_opt_krx', FALSE)
Else
	uf_dataobject ('d_ja032b_opt', FALSE)
End IF
retrieve (gaa.CORP_GR, dw_fund.object.fund_cd [dw_fund.getrow ()], dw_list.object.yj_cd [iRow], idt_f, dw_c.object.ymd [1])
end event

type st_move from wt_listdetail`st_move within w_ja032b_opt
string topdragobject = "dw_list;dw_fund"
end type

type dw_fund from u_dw within w_ja032b_opt
integer x = 55
integer y = 348
integer width = 1824
integer height = 1092
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_ja032n1"
end type

event retrieveend;call super::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;is_find = ''
dw_list.retrieve (gaa.CORP_GR, idt_f, dw_c.object.ymd [1], Object.fund_cd [currentrow])
RETURN 0
end event

