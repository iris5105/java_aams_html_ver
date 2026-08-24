forward
global type w_ja010g from wt_list
end type
type cb_2 from pf_u_commandbutton within w_ja010g
end type
end forward

global type w_ja010g from wt_list
string is_find = "fund_cd=~'~'"
boolean ib_managedata = false
cb_2 cb_2
end type
global w_ja010g w_ja010g

event wue_lastopen;call super::wue_lastopen;DATETIME ldt

IF	gaa.corp_gr='2402'	Then
	SELECT JUNYONG_YMD
	  INTO :ldt
	  FROM SZX0AA aa
	 WHERE aa.corp_gr = :gaa.corp_gr;

	dw_c.object.ymd [1] = SQLCA.getitemdatetime (1)
Else
	dw_c.object.ymd [1] = idt_workdate
End IF

CHOOSE CASE gaa.corp_gr
	CASE '2402'
		dw_list.uf_dataobject ('d_ja010g1_2402', FALSE)
	CASE ELSE
		dw_list.uf_dataobject ('d_ja010g1_common', FALSE)
END CHOOSE
end event

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

on w_ja010g.create
int iCurrent
call super::create
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
end on

on w_ja010g.destroy
call super::destroy
destroy(this.cb_2)
end on

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja010g
end type

type ln_templeft from wt_list`ln_templeft within w_ja010g
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja010g
end type

type ln_temptop from wt_list`ln_temptop within w_ja010g
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja010g
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja010g
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja010g
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja010g
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja010g
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja010g
end type

type ln_tempright from wt_list`ln_tempright within w_ja010g
end type

type uo_navi from wt_list`uo_navi within w_ja010g
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja010g
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja010g
end type

type st_top_rect from wt_list`st_top_rect within w_ja010g
end type

type p_close from wt_list`p_close within w_ja010g
end type

type p_excel from wt_list`p_excel within w_ja010g
end type

type p_print from wt_list`p_print within w_ja010g
end type

type p_delete from wt_list`p_delete within w_ja010g
end type

type p_update from wt_list`p_update within w_ja010g
end type

type p_input from wt_list`p_input within w_ja010g
end type

type p_retrieve from wt_list`p_retrieve within w_ja010g
end type

type p_clear from wt_list`p_clear within w_ja010g
end type

type p_copy from wt_list`p_copy within w_ja010g
end type

type dw_c from wt_list`dw_c within w_ja010g
string tag = "                              주식 미수입금/미지급금은 LOAD순자산에 반영되어 있지 않으므로 조정"
string title = "점검일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;cb_2.Enabled = (Object.ymd [1] = idt_workdate)
RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_ja010g
end type

type st_count from wt_list`st_count within w_ja010g
end type

type dw_list from wt_list`dw_list within w_ja010g
string dataobject = "d_ja010g1_common"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tr_co_cd', gaa.corp_gr, '', 1, '')
end event

type cb_2 from pf_u_commandbutton within w_ja010g
integer x = 1102
integer y = 192
integer width = 457
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "차액반영"
end type

event clicked;LONG	ll, lCnt

lCnt = dw_List.rowcount ()

FOR ll = 1  TO  lCnt
   dw_List.object.conf_ymd [ll] = f_sysdate ('')
NEXT
Parent.TriggerEvent ('ue_wpage_Update')

f_messageBox ('INFO', '원장생성을 하시면 LOAD된 예수금으로 예수금을 반영합니다.')
end event

