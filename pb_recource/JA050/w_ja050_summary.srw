forward
global type w_ja050_summary from w_response_s
end type
type cb_1 from pf_u_commandbutton within w_ja050_summary
end type
end forward

global type w_ja050_summary from w_response_s
integer width = 6235
integer height = 2408
string title = "결과요약"
boolean minbox = true
windowtype windowtype = popup!
boolean center = true
cb_1 cb_1
end type
global w_ja050_summary w_ja050_summary

type variables
str_parameter  sp
end variables

on w_ja050_summary.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_ja050_summary.destroy
call super::destroy
destroy(this.cb_1)
end on

event wue_postopen;call super::wue_postopen;sp = Message.PowerObjectParm
end event

event wue_lastopen;call super::wue_lastopen;dw_view.retrieve(sp.dt[1])
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_ja050_summary
end type

type ln_tempstart from w_response_s`ln_tempstart within w_ja050_summary
end type

type ln_templeft from w_response_s`ln_templeft within w_ja050_summary
end type

type ln_cond_start from w_response_s`ln_cond_start within w_ja050_summary
end type

type ln_tempright from w_response_s`ln_tempright within w_ja050_summary
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_ja050_summary
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_ja050_summary
end type

type dw_view from w_response_s`dw_view within w_ja050_summary
integer width = 6126
integer height = 2272
string dataobject = "d_ja050_s1"
boolean ibsetlist4subbtn = true
boolean eb_fund_default_change = true
boolean eb_range_delcopy = false
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'corp_gr', gaa.corp_gr, '', 1, '')
end event

type cb_1 from pf_u_commandbutton within w_ja050_summary
integer x = 5618
integer y = 24
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer weight = 400
string text = "인쇄"
boolean setbringtotop = true
end type

event clicked;call super::clicked;dw_view.event ue_print()
end event

